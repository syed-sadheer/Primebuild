<?php
session_start();

require_once "../../include/auth.php";
require_login();

require_once "../../config/db.php";

/* ---------------------------
   AJAX: load invoice items
---------------------------- */
if (isset($_GET['action']) && $_GET['action'] === 'load_items') {
    require_permission('sales_returns.add');

    $tax_invoice_id = (int)($_GET['tax_invoice_id'] ?? 0);
    if ($tax_invoice_id <= 0) {
        echo json_encode(['ok'=>false, 'error'=>'Invalid invoice']);
        exit;
    }

    $sql = "
      SELECT
        sdi.id,
        sdi.item_id,
        i.item_name,
        sdi.input_unit_id,
        ROUND(sdi.qty_sqm,4) AS qty_sqm,
        ROUND(sdi.unit_price_sqm,4) AS unit_price_sqm,
        ROUND(sdi.vat_rate,2) AS vat_rate
      FROM sales_doc_items sdi
      INNER JOIN items i ON i.id=sdi.item_id
      INNER JOIN sales_docs sd ON sd.id=sdi.sales_doc_id
      WHERE sdi.sales_doc_id = ?
        AND sd.doc_type='tax_invoice'
        AND sd.status='confirmed'
      ORDER BY sdi.id ASC
    ";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $tax_invoice_id);
    $stmt->execute();
    $res = $stmt->get_result();

    $items = [];
    while($row = $res->fetch_assoc()){
        $items[] = $row;
    }

    echo json_encode(['ok'=>true, 'items'=>$items]);
    exit;
}

/* ---------------------------
   Decide create vs update
---------------------------- */
$is_update = isset($_POST['return_id']) && (int)$_POST['return_id'] > 0;
if ($is_update) {
    require_permission('sales_returns.edit');
} else {
    require_permission('sales_returns.add');
}

$return_id      = (int)($_POST['return_id'] ?? 0);
$tax_invoice_id = (int)($_POST['tax_invoice_id'] ?? 0);
$return_date    = $_POST['return_date'] ?? '';
$refund_amount  = (float)($_POST['refund_amount'] ?? 0);
$notes          = trim($_POST['notes'] ?? '');

$sales_doc_item_ids = $_POST['sales_doc_item_id'] ?? [];
$item_ids           = $_POST['item_id'] ?? [];
$input_unit_ids      = $_POST['input_unit_id'] ?? [];
$qty_sqm_arr         = $_POST['qty_sqm'] ?? [];
$unit_price_sqm_arr  = $_POST['unit_price_sqm'] ?? [];
$vat_rate_arr        = $_POST['vat_rate'] ?? [];
$line_total_arr      = $_POST['line_total'] ?? [];

$errors = [];
$old = $_POST;

if ($tax_invoice_id <= 0) $errors[] = "Tax invoice is required.";
if (!$return_date) $errors[] = "Return date is required.";
if ($refund_amount < 0) $errors[] = "Refund amount cannot be negative.";
if (count($sales_doc_item_ids) === 0) $errors[] = "No invoice items loaded.";

if (!empty($errors)) {
    $_SESSION['sr_errors'] = $errors;
    $_SESSION['sr_old'] = $old;
    header("Location: " . ($is_update ? "edit.php?id=".(int)$return_id : "add.php"));
    exit;
}

/* Validate invoice header */
$stmt = $conn->prepare("
  SELECT sd.id, sd.customer_id
  FROM sales_docs sd
  WHERE sd.id=? AND sd.doc_type='tax_invoice' AND sd.status='confirmed'
");
$stmt->bind_param("i", $tax_invoice_id);
$stmt->execute();
$inv = $stmt->get_result()->fetch_assoc();

if (!$inv) {
    $_SESSION['sr_errors'] = ["Invalid or unconfirmed tax invoice."];
    $_SESSION['sr_old'] = $old;
    header("Location: " . ($is_update ? "edit.php?id=".(int)$return_id : "add.php"));
    exit;
}

$customer_id = (int)$inv['customer_id'];

/* Build return lines */
$lines = [];
$total_amount = 0.0;
$subtotal = 0.0;
$vat_amount = 0.0;

for ($i=0; $i<count($sales_doc_item_ids); $i++) {
    $sales_doc_item_id = (int)$sales_doc_item_ids[$i];
    $item_id           = (int)$item_ids[$i];
    $input_unit_id      = (int)$input_unit_ids[$i];
    $qty_sqm            = (float)$qty_sqm_arr[$i];
    $unit_price_sqm     = (float)$unit_price_sqm_arr[$i];
    $vat_rate           = (float)$vat_rate_arr[$i];

    if ($qty_sqm <= 0) continue;

    // validate sold qty
    $stmt = $conn->prepare("
      SELECT qty_sqm
      FROM sales_doc_items
      WHERE id=? AND sales_doc_id=? AND item_id=?
    ");
    $stmt->bind_param("iii", $sales_doc_item_id, $tax_invoice_id, $item_id);
    $stmt->execute();
    $r = $stmt->get_result()->fetch_assoc();

    if (!$r) {
        $errors[] = "Invalid invoice item line (ID: {$sales_doc_item_id}).";
        continue;
    }

    $sold_qty_sqm = (float)$r['qty_sqm'];
    if ($qty_sqm > $sold_qty_sqm + 0.00001) {
        $errors[] = "Return qty exceeds sold qty for invoice line ID {$sales_doc_item_id}.";
        continue;
    }

    $line_total = $qty_sqm * $unit_price_sqm;
    $base = ($vat_rate > 0) ? ($line_total / (1 + ($vat_rate/100))) : $line_total;
    $line_vat = $line_total - $base;

    $total_amount += $line_total;
    $subtotal     += $base;
    $vat_amount   += $line_vat;

    $lines[] = [
        'sales_doc_item_id' => $sales_doc_item_id,
        'item_id' => $item_id,
        'input_unit_id' => $input_unit_id,
        'qty_input' => $qty_sqm, // storing same for now
        'qty_sqm' => $qty_sqm,
        'qty_boxes' => 0,
        'qty_pallets' => 0,
        'qty_pcs' => 0,
        'unit_price_sqm' => $unit_price_sqm,
        'line_total' => $line_total,
    ];
}

if (!empty($errors)) {
    $_SESSION['sr_errors'] = $errors;
    $_SESSION['sr_old'] = $old;
    header("Location: " . ($is_update ? "edit.php?id=".(int)$return_id : "add.php"));
    exit;
}

if ($refund_amount > $total_amount + 0.01) {
    $_SESSION['sr_errors'] = ["Refund amount cannot exceed return total."];
    $_SESSION['sr_old'] = $old;
    header("Location: " . ($is_update ? "edit.php?id=".(int)$return_id : "add.php"));
    exit;
}

if (count($lines) === 0) {
    $_SESSION['sr_errors'] = ["Enter return quantity for at least one item."];
    $_SESSION['sr_old'] = $old;
    header("Location: " . ($is_update ? "edit.php?id=".(int)$return_id : "add.php"));
    exit;
}

$conn->begin_transaction();

try {

    // On update: reverse old impact and delete old details
    if ($is_update) {
        // load old header
        $stmt = $conn->prepare("SELECT * FROM sales_returns WHERE id=?");
        $stmt->bind_param("i", $return_id);
        $stmt->execute();
        $oldSr = $stmt->get_result()->fetch_assoc();
        if (!$oldSr) throw new Exception("Return not found.");

        // reverse customer balance: add back (old_total - old_refund)
        $old_net = (float)$oldSr['total_amount'] - (float)$oldSr['refund_amount'];
        $stmt = $conn->prepare("UPDATE customers SET current_balance = current_balance + ? WHERE id=?");
        $stmt->bind_param("di", $old_net, $oldSr['customer_id']);
        $stmt->execute();

        // delete stock ledger rows
        $ref_type = 'sales_return';
        $stmt = $conn->prepare("DELETE FROM stock_ledger WHERE ref_type=? AND ref_id=?");
        $stmt->bind_param("si", $ref_type, $return_id);
        $stmt->execute();

        // delete items
        $stmt = $conn->prepare("DELETE FROM sales_return_items WHERE return_id=?");
        $stmt->bind_param("i", $return_id);
        $stmt->execute();

        // update master
        $stmt = $conn->prepare("
          UPDATE sales_returns
          SET tax_invoice_id=?, customer_id=?, return_date=?, subtotal=?, vat_amount=?, total_amount=?, refund_amount=?, notes=?, status='posted'
          WHERE id=?
        ");
        $stmt->bind_param(
            "iisddddsi",
            $tax_invoice_id,
            $customer_id,
            $return_date,
            $subtotal,
            $vat_amount,
            $total_amount,
            $refund_amount,
            $notes,
            $return_id
        );

        $stmt->execute();

    } else {
        // CREATE: generate return_no from sequences
        $seq_key = 'sales_return';
        $stmt = $conn->prepare("SELECT prefix, next_number, pad_length FROM sequences WHERE seq_key=? FOR UPDATE");
        $stmt->bind_param("s", $seq_key);
        $stmt->execute();
        $seq = $stmt->get_result()->fetch_assoc();
        if (!$seq) throw new Exception("Missing sequences row for seq_key='sales_return'.");

        $prefix = $seq['prefix'];
        $next   = (int)$seq['next_number'];
        $pad    = (int)$seq['pad_length'];

        $return_no = $prefix . str_pad((string)$next, $pad, "0", STR_PAD_LEFT);

        $stmt = $conn->prepare("UPDATE sequences SET next_number = next_number + 1 WHERE seq_key=?");
        $stmt->bind_param("s", $seq_key);
        $stmt->execute();

        $created_by = $_SESSION['user']['id'] ?? null;

        $stmt = $conn->prepare("
          INSERT INTO sales_returns
          (return_no, tax_invoice_id, customer_id, return_date, subtotal, vat_amount, total_amount, refund_amount, notes, status, created_by)
          VALUES (?,?,?,?,?,?,?,?,?,'posted',?)
        ");
        $stmt->bind_param(
            "siisddddsi",
            $return_no,
            $tax_invoice_id,
            $customer_id,
            $return_date,
            $subtotal,
            $vat_amount,
            $total_amount,
            $refund_amount,
            $notes,
            $created_by
        );

        $stmt->execute();
        $return_id = (int)$conn->insert_id;
    }

    // Insert items
    $stmtItem = $conn->prepare("
      INSERT INTO sales_return_items
      (return_id, sales_doc_item_id, item_id, input_unit_id, qty_input, qty_sqm, qty_boxes, qty_pallets, qty_pcs, unit_price_sqm, line_total)
      VALUES (?,?,?,?,?,?,?,?,?,?,?)
    ");
    // 4 ints + 7 doubles = "iiiidddddddd"
    $stmtStock = $conn->prepare("
      INSERT INTO stock_ledger
      (tx_date, item_id, ref_type, ref_id, direction, qty_sqm, qty_boxes, qty_pallets, qty_pcs, unit_cost_sqm, note)
      VALUES (?,?,?,?, 'in', ?,?,?,?, 0, ?)
    ");

    foreach ($lines as $ln) {
        // 4 ints + 7 doubles = 11 params
            $stmtItem->bind_param(
                "iiiiddddddd",
                $return_id,
                $ln['sales_doc_item_id'],
                $ln['item_id'],
                $ln['input_unit_id'],
                $ln['qty_input'],
                $ln['qty_sqm'],
                $ln['qty_boxes'],
                $ln['qty_pallets'],
                $ln['qty_pcs'],
                $ln['unit_price_sqm'],
                $ln['line_total']
            );

        $stmtItem->execute();

        $ref_type = 'sales_return';
        $note = "Sales return ID {$return_id} against tax invoice {$tax_invoice_id}";

        $stmtStock->bind_param(
            "sisidddds",
            $return_date,
            $ln['item_id'],
            $ref_type,
            $return_id,
            $ln['qty_sqm'],
            $ln['qty_boxes'],
            $ln['qty_pallets'],
            $ln['qty_pcs'],
            $note
        );
        $stmtStock->execute();
    }

    // Apply new customer balance: decrease by (total - refund)
    $net = $total_amount - $refund_amount;
    $stmt = $conn->prepare("UPDATE customers SET current_balance = current_balance - ? WHERE id=?");
    $stmt->bind_param("di", $net, $customer_id);
    $stmt->execute();

    $conn->commit();

    header("Location: view.php?id=" . (int)$return_id);
    exit;

} catch (Exception $ex) {
    $conn->rollback();
    $_SESSION['sr_errors'] = ["Save failed: " . $ex->getMessage()];
    $_SESSION['sr_old'] = $old;
    header("Location: " . ($is_update ? "edit.php?id=".(int)$return_id : "add.php"));
    exit;
}
