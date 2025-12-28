<?php
require_once __DIR__ . "/../include/auth.php";
require_login();

require_once __DIR__ . "/../config/db.php";

header('Content-Type: application/json; charset=utf-8');

$supplier_id = (int)($_GET['supplier_id'] ?? 0);
if ($supplier_id <= 0) {
  echo json_encode(['ok'=>true, 'rows'=>[]]);
  exit;
}

$sql = "
  SELECT id, purchase_no, supplier_invoice_no, purchase_date
  FROM purchases
  WHERE supplier_id=?
  ORDER BY id DESC
  LIMIT 200
";
$st = $conn->prepare($sql);
$st->bind_param("i", $supplier_id);
$st->execute();
$rs = $st->get_result();

$rows = [];
while ($r = $rs->fetch_assoc()) {
  $rows[] = [
    'id' => (int)$r['id'],
    'purchase_no' => (string)($r['purchase_no'] ?? ''),
    'supplier_invoice_no' => (string)($r['supplier_invoice_no'] ?? ''),
    'purchase_date' => (string)($r['purchase_date'] ?? ''),
    'label' => trim(
      (string)($r['purchase_no'] ?? '') .
      " | " . (string)($r['supplier_invoice_no'] ?? '') .
      " | " . (string)($r['purchase_date'] ?? '')
    ),
  ];
}
$st->close();

echo json_encode(['ok'=>true, 'rows'=>$rows]);
