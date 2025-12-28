<?php
session_start();

require_once "../../include/auth.php";
require_login();
require_permission('sales.view');

require_once "../../config/db.php";

function h($v){ return htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8'); }

$id = (int)($_GET['id'] ?? 0);
if ($id <= 0) die("Invalid document.");

function typeLabel($t){
  if ($t === 'quotation') return 'Quotation';
  if ($t === 'proforma') return 'Proforma Invoice';
  if ($t === 'tax_invoice') return 'Tax Invoice';
  return $t;
}

/* -----------------------------
   Company profile (optional)
----------------------------- */
$company = [
  'name' => 'Company Name',
  'address' => '',
  'phone' => '',
  'email' => '',
  'trn' => '',
  'logo' => '' // URL/path if you store it
];

try {
  // If table exists, read first row
  $chk = $conn->query("SHOW TABLES LIKE 'company_profile'");
  if ($chk && $chk->num_rows > 0) {
    $res = $conn->query("SELECT * FROM company_profile LIMIT 1");
    if ($res && ($r = $res->fetch_assoc())) {
      // Map common column names safely
      foreach (['company_name','name'] as $k) if (!empty($r[$k])) $company['name'] = $r[$k];
      foreach (['address','company_address'] as $k) if (!empty($r[$k])) $company['address'] = $r[$k];
      foreach (['phone','mobile','company_phone'] as $k) if (!empty($r[$k])) $company['phone'] = $r[$k];
      foreach (['email','company_email'] as $k) if (!empty($r[$k])) $company['email'] = $r[$k];
      foreach (['trn','vat_no','tax_no'] as $k) if (!empty($r[$k])) $company['trn'] = $r[$k];
      foreach (['logo','logo_path'] as $k) if (!empty($r[$k])) $company['logo'] = $r[$k];
    }
  }
} catch(Throwable $e) {
  // ignore, use defaults
}

/* -----------------------------
   Load master
----------------------------- */
$sql = "
  SELECT
    sd.*,
    c.customer_name, c.mobile, c.email, c.city, c.address,
    pm.method_name AS payment_method_name
  FROM sales_docs sd
  INNER JOIN customers c ON c.id = sd.customer_id
  LEFT JOIN payment_methods pm ON pm.id = sd.payment_method_id
  WHERE sd.id = ?
  LIMIT 1
";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $id);
$stmt->execute();
$doc = $stmt->get_result()->fetch_assoc();
$stmt->close();

if (!$doc) die("Document not found.");

/* -----------------------------
   Load items
----------------------------- */
$items = [];
$sqlI = "
  SELECT
    sdi.*,
    i.item_name
  FROM sales_doc_items sdi
  INNER JOIN items i ON i.id = sdi.item_id
  WHERE sdi.sales_doc_id = ?
  ORDER BY sdi.id ASC
";
$stmt = $conn->prepare($sqlI);
$stmt->bind_param("i", $id);
$stmt->execute();
$res = $stmt->get_result();
while ($r = $res->fetch_assoc()) $items[] = $r;
$stmt->close();

$title = typeLabel($doc['doc_type']);
$printedAt = date('Y-m-d H:i');

$vatYesNo = ((float)$doc['vat_amount'] > 0) ? 'Yes' : 'No';
$payMethod = $doc['payment_method_name'] ? $doc['payment_method_name'] : '-';
?>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title><?= h($title) ?> - <?= h($doc['doc_no']) ?></title>
  <style>
    /* A4 print standard */
    @page { size: A4; margin: 12mm; }
    body{ font-family: Arial, Helvetica, sans-serif; font-size: 12px; color:#111; margin:0; }
    .noprint{ display:flex; gap:8px; justify-content:flex-end; padding:10px 12mm; }
    .btn{ display:inline-block; padding:6px 10px; border:1px solid #cbd5e1; border-radius:6px; text-decoration:none; color:#111; background:#f8fafc; font-size:12px; }
    .btn.primary{ background:#111827; color:#fff; border-color:#111827; }
    .wrap{ padding:0 12mm 12mm; }

    /* Header standard: logo+company left, title/meta right */
    .hdr{ display:flex; justify-content:space-between; align-items:flex-start; gap:12px; }
    .hdr-left{ display:flex; gap:10px; align-items:flex-start; }
    .logo{ width:64px; height:64px; border:1px solid #e5e7eb; border-radius:8px; overflow:hidden; display:flex; align-items:center; justify-content:center; }
    .logo img{ max-width:100%; max-height:100%; display:block; }
    .cname{ font-size:16px; font-weight:800; margin:0 0 4px; }
    .cmeta{ line-height:1.45; color:#374151; }
    .hdr-right{ text-align:right; }
    .rtitle{ font-size:18px; font-weight:900; margin:0; }
    .rmeta{ margin-top:6px; line-height:1.5; color:#374151; }
    .hr{ border-top:2px solid #111827; margin:10px 0 10px; }

    .info-grid{ display:flex; gap:12px; flex-wrap:wrap; }
    .box{ border:1px solid #e5e7eb; border-radius:10px; padding:10px; flex:1; min-width:260px; }
    .row{ display:flex; justify-content:space-between; gap:10px; margin:4px 0; }
    .k{ color:#6b7280; }
    .v{ font-weight:700; }

    table{ width:100%; border-collapse:collapse; margin-top:10px; }
    th, td{ border:1px solid #e5e7eb; padding:6px 6px; }
    thead th{ background:#f3f4f6; font-weight:800; }
    .right{ text-align:right; }
    .center{ text-align:center; }

    .totals{ width:360px; max-width:100%; margin-left:auto; margin-top:10px; }
    .totals .row{ margin:6px 0; }
    .totals .grand{ font-size:14px; font-weight:900; }

    .notes{ margin-top:10px; border:1px solid #e5e7eb; border-radius:10px; padding:10px; }
    .sig{ display:flex; justify-content:space-between; gap:20px; margin-top:26px; }
    .sig .sbox{ flex:1; text-align:center; }
    .sig .line{ border-top:1px solid #111; margin:24px 20px 6px; }

    @media print {
      .noprint{ display:none !important; }
      .wrap{ padding:0; }
    }
  </style>
</head>
<body>

<div class="noprint">
  <a class="btn" href="view.php?id=<?= (int)$doc['id'] ?>">Back</a>
  <button class="btn primary" onclick="window.print()">Print</button>
</div>

<div class="wrap">

  <div class="hdr">
    <div class="hdr-left">
      <div class="logo">
        <?php if (!empty($company['logo'])): ?>
          <img src="<?= h($company['logo']) ?>" alt="Logo">
        <?php else: ?>
          <span style="color:#9ca3af;font-size:11px;">LOGO</span>
        <?php endif; ?>
      </div>
      <div>
        <div class="cname"><?= h($company['name']) ?></div>
        <div class="cmeta">
          <?php if ($company['address']): ?><?= nl2br(h($company['address'])) ?><br><?php endif; ?>
          <?php if ($company['phone']): ?>Phone: <?= h($company['phone']) ?><br><?php endif; ?>
          <?php if ($company['email']): ?>Email: <?= h($company['email']) ?><br><?php endif; ?>
          <?php if ($company['trn']): ?>TRN: <?= h($company['trn']) ?><br><?php endif; ?>
        </div>
      </div>
    </div>

    <div class="hdr-right">
      <div class="rtitle"><?= h($title) ?></div>
      <div class="rmeta">
        <div><b>Doc No:</b> <?= h($doc['doc_no']) ?></div>
        <div><b>Date:</b> <?= h($doc['doc_date']) ?></div>
        <div><b>Printed:</b> <?= h($printedAt) ?></div>
      </div>
    </div>
  </div>

  <div class="hr"></div>

  <div class="info-grid">
    <div class="box">
      <div style="font-weight:900;margin-bottom:6px;">Customer</div>
      <div class="row"><div class="k">Name</div><div class="v"><?= h($doc['customer_name']) ?></div></div>
      <div class="row"><div class="k">Mobile</div><div class="v"><?= h($doc['mobile'] ?? '') ?></div></div>
      <div class="row"><div class="k">Email</div><div class="v"><?= h($doc['email'] ?? '') ?></div></div>
      <div class="row"><div class="k">City</div><div class="v"><?= h($doc['city'] ?? '') ?></div></div>
      <div class="row"><div class="k">Address</div><div class="v"><?= h($doc['address'] ?? '') ?></div></div>
    </div>

    <div class="box">
      <div style="font-weight:900;margin-bottom:6px;">Document</div>
      <div class="row"><div class="k">Type</div><div class="v"><?= h($title) ?></div></div>
      <div class="row"><div class="k">Status</div><div class="v"><?= h($doc['status']) ?></div></div>
      <div class="row"><div class="k">Reserve Stock</div><div class="v"><?= ((int)$doc['reserve_stock'] === 1 ? 'Yes' : 'No') ?></div></div>
      <div class="row"><div class="k">VAT</div><div class="v"><?= h($vatYesNo) ?></div></div>
      <div class="row"><div class="k">VAT Rate</div><div class="v"><?= number_format((float)$doc['vat_rate'], 2) ?>%</div></div>
      <div class="row"><div class="k">Payment Method</div><div class="v"><?= h($payMethod) ?></div></div>
    </div>
  </div>

  <table>
    <thead>
      <tr>
        <th style="width:50px;">#</th>
        <th>Item</th>
        <th class="right" style="width:90px;">SQM</th>
        <th class="right" style="width:80px;">Boxes</th>
        <th class="right" style="width:80px;">PCS</th>
        <th class="right" style="width:110px;">Rate/SQM</th>
        <th class="right" style="width:110px;">Subtotal</th>
        <th class="right" style="width:90px;">VAT</th>
        <th class="right" style="width:110px;">Total</th>
      </tr>
    </thead>
    <tbody>
      <?php if (!$items): ?>
        <tr><td colspan="9" class="center" style="color:#6b7280;">No items.</td></tr>
      <?php else: ?>
        <?php foreach ($items as $i => $r): ?>
          <tr>
            <td class="center"><?= (int)($i+1) ?></td>
            <td><?= h($r['item_name']) ?></td>
            <td class="right"><?= number_format((float)$r['qty_sqm'], 4) ?></td>
            <td class="right"><?= number_format((float)$r['qty_boxes'], 0) ?></td>
            <td class="right"><?= number_format((float)$r['qty_pcs'], 0) ?></td>
            <td class="right"><?= number_format((float)$r['unit_price_sqm'], 4) ?></td>
            <td class="right"><?= number_format((float)$r['line_subtotal'], 2) ?></td>
            <td class="right"><?= number_format((float)$r['vat_amount'], 2) ?></td>
            <td class="right"><?= number_format((float)$r['line_total'], 2) ?></td>
          </tr>
        <?php endforeach; ?>
      <?php endif; ?>
    </tbody>
  </table>

  <div class="totals">
    <div class="row"><div class="k">Subtotal</div><div class="v"><?= number_format((float)$doc['subtotal'], 2) ?></div></div>
    <div class="row"><div class="k">Discount</div><div class="v"><?= number_format((float)$doc['discount'], 2) ?></div></div>
    <div class="row"><div class="k">VAT Amount</div><div class="v"><?= number_format((float)$doc['vat_amount'], 2) ?></div></div>
    <div class="row grand"><div class="k">Grand Total</div><div class="v"><?= number_format((float)$doc['total_amount'], 2) ?></div></div>
    <div class="row"><div class="k">Paid</div><div class="v"><?= number_format((float)$doc['paid_amount'], 2) ?></div></div>
    <div class="row"><div class="k">Balance</div><div class="v"><?= number_format((float)$doc['balance_amount'], 2) ?></div></div>
  </div>

  <?php if (!empty($doc['notes'])): ?>
    <div class="notes">
      <div style="font-weight:900;margin-bottom:6px;">Notes</div>
      <div style="white-space:pre-wrap;"><?= h($doc['notes']) ?></div>
    </div>
  <?php endif; ?>

  <div class="sig">
    <div class="sbox">
      <div class="line"></div>
      <div>Prepared By</div>
    </div>
    <div class="sbox">
      <div class="line"></div>
      <div>Approved By</div>
    </div>
    <div class="sbox">
      <div class="line"></div>
      <div>Customer Signature</div>
    </div>
  </div>

</div>

</body>
</html>
