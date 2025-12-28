<?php
require_once __DIR__ . "/../../include/auth.php";
require_login();
require_permission('suppliers.print');

$id = (int)($_GET['id'] ?? 0);
if ($id <= 0) die("Invalid");

$stmt = $conn->prepare("SELECT * FROM suppliers WHERE id=? LIMIT 1");
$stmt->bind_param("i",$id);
$stmt->execute();
$s = $stmt->get_result()->fetch_assoc();
if (!$s) die("Not found");

$cp = $conn->query("SELECT company_name, phone, email, address, vat_trn FROM company_profile WHERE id=1")->fetch_assoc();
?>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Print Supplier</title>
  <style>
    body{font-family:Arial;margin:20px;color:#111}
    .row{display:flex;justify-content:space-between;gap:20px}
    .box{border:1px solid #ddd;padding:12px;border-radius:8px}
    h2,h3{margin:0 0 8px 0}
    table{width:100%;border-collapse:collapse}
    td,th{padding:8px;border:1px solid #ddd;text-align:left}
    .muted{color:#666;font-size:12px}
    @media print { .noprint{display:none} }
  </style>
</head>
<body>
  <div class="noprint" style="margin-bottom:10px;">
    <button onclick="window.print()">Print</button>
  </div>

  <div class="row">
    <div class="box" style="flex:1;">
      <h3><?= e($cp['company_name'] ?? 'Primebuild') ?></h3>
      <div class="muted">
        <?= e($cp['address'] ?? '') ?><br>
        Phone: <?= e($cp['phone'] ?? '') ?> |
        Email: <?= e($cp['email'] ?? '') ?><br>
        VAT TRN: <?= e($cp['vat_trn'] ?? '') ?>
      </div>
    </div>
    <div class="box" style="width:280px;">
      <h3>Supplier</h3>
      <div class="muted">Printed: <?= date('Y-m-d H:i') ?></div>
      <div><b>ID:</b> <?= (int)$s['id'] ?></div>
    </div>
  </div>

  <div class="box" style="margin-top:12px;">
    <h2>Supplier Details</h2>
    <table>
      <tr><th style="width:240px;">Supplier Name</th><td><?= e($s['supplier_name']) ?></td></tr>
      <tr><th>Mobile</th><td><?= e($s['mobile']) ?></td></tr>
      <tr><th>Email</th><td><?= e($s['email']) ?></td></tr>
      <tr><th>City</th><td><?= e($s['city']) ?></td></tr>
      <tr><th>Opening Balance</th><td><?= number_format((float)$s['opening_balance'], 2) ?></td></tr>
      <tr><th>Current Balance</th><td><?= number_format((float)$s['current_balance'], 2) ?></td></tr>
      <tr><th>Address</th><td><?= e($s['address']) ?></td></tr>
      <tr><th>Status</th><td><?= ((int)$s['status']===1)?'Active':'Inactive' ?></td></tr>
    </table>
  </div>
</body>
</html>
