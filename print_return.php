<?php
session_start();

require_once "../../include/auth.php";
require_login();
require_permission('sales_returns.view');

require_once "../../config/db.php";

$id   = (int)($_GET['id'] ?? 0);
$type = strtolower(trim($_GET['type'] ?? 'a4')); // a4 | thermal

if ($id <= 0) exit("Invalid ID");

/* ----------------------------
   Helpers
---------------------------- */
function h($s){ return htmlspecialchars((string)$s, ENT_QUOTES, 'UTF-8'); }
function nf2($n){ return number_format((float)$n, 2); }
function nf4($n){ return number_format((float)$n, 4); }

/* ----------------------------
   Load header
---------------------------- */
$stmt = $conn->prepare("
  SELECT
    sr.*,
    sd.doc_no AS invoice_no,
    sd.doc_date AS invoice_date,
    c.customer_name,
    c.mobile,
    c.email,
    c.city,
    c.address
  FROM sales_returns sr
  INNER JOIN sales_docs sd ON sd.id=sr.tax_invoice_id
  INNER JOIN customers c ON c.id=sr.customer_id
  WHERE sr.id=?
  LIMIT 1
");
$stmt->bind_param("i", $id);
$stmt->execute();
$sr = $stmt->get_result()->fetch_assoc();
$stmt->close();

if (!$sr) exit("Not found");

/* ----------------------------
   Load items
---------------------------- */
$items = [];
$stmt = $conn->prepare("
  SELECT sri.*, i.item_name
  FROM sales_return_items sri
  INNER JOIN items i ON i.id=sri.item_id
  WHERE sri.return_id=?
  ORDER BY sri.id ASC
");
$stmt->bind_param("i", $id);
$stmt->execute();
$res = $stmt->get_result();
while($row = $res->fetch_assoc()) $items[] = $row;
$stmt->close();

/* ----------------------------
   Company profile (best effort)
---------------------------- */
$cp = [];
$q = $conn->query("SELECT * FROM company_profile LIMIT 1");
if ($q) $cp = $q->fetch_assoc() ?: [];

/* ----------------------------
   Standard Print Header V1 mapping (left company, right report/meta)
   Uses company_profile fields if present; safe fallback.
---------------------------- */
$company_name = $cp['company_name'] ?? $cp['name'] ?? 'Company';
$company_addr = $cp['address'] ?? '';
$company_phone= $cp['phone'] ?? $cp['mobile'] ?? '';
$company_email= $cp['email'] ?? '';
$company_trn  = $cp['trn'] ?? $cp['vat_no'] ?? $cp['tax_no'] ?? '';
$company_logo = $cp['logo'] ?? $cp['logo_path'] ?? '';

$report_title = "Sales Return";
$printed_on   = date('Y-m-d H:i');

/* ----------------------------
   Thermal sizing
---------------------------- */
$is_thermal = ($type === 'thermal');
?>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Sales Return Print</title>
  <style>
    *{ box-sizing:border-box; }
    body{
      font-family: Arial, sans-serif;
      color:#000;
      margin:0;
      padding:<?= $is_thermal ? "6px" : "16px" ?>;
      font-size:<?= $is_thermal ? "11px" : "12px" ?>;
    }

    /* Page width */
    .page{
      width:<?= $is_thermal ? "80mm" : "100%" ?>;
      margin:0 auto;
    }

    /* Standard header layout */
    .print-header{
      display:flex;
      justify-content:space-between;
      gap:12px;
      margin-bottom:10px;
    }
    .ph-left, .ph-right{
      border:1px solid #000;
      padding:8px;
      width:<?= $is_thermal ? "100%" : "49%" ?>;
    }
    <?php if ($is_thermal): ?>
    .print-header{ flex-direction:column; }
    <?php endif; ?>

    .company-name{
      font-size:<?= $is_thermal ? "13px" : "14px" ?>;
      font-weight:700;
      margin-bottom:4px;
    }
    .muted{ color:#111; }

    .report-title{
      font-size:<?= $is_thermal ? "13px" : "14px" ?>;
      font-weight:700;
      margin-bottom:6px;
    }
    .meta-row{ margin:2px 0; }

    .box{
      border:1px solid #000;
      padding:8px;
      margin-bottom:10px;
    }

    table{
      width:100%;
      border-collapse:collapse;
      margin-top:8px;
    }
    th, td{
      border:1px solid #000;
      padding:<?= $is_thermal ? "5px" : "6px" ?>;
      vertical-align:top;
    }
    th{
      background:#f2f2f2;
      font-weight:700;
      white-space:nowrap;
    }
    .right{ text-align:right; }
    .center{ text-align:center; }

    .totals{
      width:<?= $is_thermal ? "100%" : "40%" ?>;
      margin-left:auto;
      margin-top:10px;
      border:1px solid #000;
      padding:8px;
    }
    .tot-row{
      display:flex;
      justify-content:space-between;
      gap:10px;
      margin:3px 0;
    }
    .tot-row b{ font-weight:700; }

    .notes{
      margin-top:10px;
    }

    @media print{
      body{ padding:0; }
      .page{ width:<?= $is_thermal ? "80mm" : "100%" ?>; }
    }
  </style>
</head>
<body onload="window.print()">
  <div class="page">

    <!-- Print Header Standard V1 -->
    <div class="print-header">
      <div class="ph-left">
        <?php if (!empty($company_logo) && file_exists($_SERVER['DOCUMENT_ROOT'] . "/" . ltrim($company_logo, "/"))): ?>
          <div style="margin-bottom:6px;">
            <img src="<?= h($company_logo) ?>" alt="Logo" style="max-height:55px; max-width:220px;">
          </div>
        <?php endif; ?>

        <div class="company-name"><?= h($company_name) ?></div>
        <?php if ($company_addr !== ''): ?><div><?= h($company_addr) ?></div><?php endif; ?>
        <?php if ($company_phone !== '' || $company_email !== ''): ?>
          <div>
            <?= $company_phone !== '' ? h($company_phone) : '' ?>
            <?= ($company_phone !== '' && $company_email !== '') ? " | " : "" ?>
            <?= $company_email !== '' ? h($company_email) : '' ?>
          </div>
        <?php endif; ?>
        <?php if ($company_trn !== ''): ?><div>TRN: <?= h($company_trn) ?></div><?php endif; ?>
      </div>

      <div class="ph-right">
        <div class="report-title"><?= h($report_title) ?></div>
        <div class="meta-row">Return No: <b><?= h($sr['return_no']) ?></b></div>
        <div class="meta-row">Return Date: <b><?= h($sr['return_date']) ?></b></div>
        <div class="meta-row">Tax Invoice: <b><?= h($sr['invoice_no']) ?></b></div>
        <div class="meta-row">Printed: <b><?= h($printed_on) ?></b></div>
      </div>
    </div>

    <!-- Customer box -->
    <div class="box">
      <div><b>Customer:</b> <?= h($sr['customer_name']) ?></div>
      <?php if (!empty($sr['mobile'])): ?><div><b>Mobile:</b> <?= h($sr['mobile']) ?></div><?php endif; ?>
      <?php if (!empty($sr['email'])): ?><div><b>Email:</b> <?= h($sr['email']) ?></div><?php endif; ?>
      <?php if (!empty($sr['city'])): ?><div><b>City:</b> <?= h($sr['city']) ?></div><?php endif; ?>
      <?php if (!empty($sr['address'])): ?><div><b>Address:</b> <?= h($sr['address']) ?></div><?php endif; ?>
    </div>

    <!-- Items -->
    <table>
      <thead>
        <tr>
          <th style="width:5%;">#</th>
          <th>Item</th>
          <th class="right" style="width:18%;">Return SQM</th>
          <th class="right" style="width:18%;">Unit Price (SQM)</th>
          <th class="right" style="width:18%;">Line Total</th>
        </tr>
      </thead>
      <tbody>
        <?php if (empty($items)): ?>
          <tr><td colspan="5" class="center">No items found.</td></tr>
        <?php else: ?>
          <?php $i=1; foreach($items as $it): ?>
            <tr>
              <td class="center"><?= $i++ ?></td>
              <td><?= h($it['item_name']) ?></td>
              <td class="right"><?= nf4($it['qty_sqm']) ?></td>
              <td class="right"><?= nf4($it['unit_price_sqm']) ?></td>
              <td class="right"><?= nf2($it['line_total']) ?></td>
            </tr>
          <?php endforeach; ?>
        <?php endif; ?>
      </tbody>
    </table>

    <!-- Totals -->
    <div class="totals">
      <div class="tot-row"><span>Subtotal</span><b><?= nf2($sr['subtotal']) ?></b></div>
      <div class="tot-row"><span>VAT Amount</span><b><?= nf2($sr['vat_amount']) ?></b></div>
      <div class="tot-row"><span>Total Amount</span><b><?= nf2($sr['total_amount']) ?></b></div>
      <div class="tot-row"><span>Refund Amount</span><b><?= nf2($sr['refund_amount']) ?></b></div>
      <div class="tot-row"><span>Balance To Customer</span><b><?= nf2((float)$sr['total_amount'] - (float)$sr['refund_amount']) ?></b></div>
    </div>

    <?php if (!empty($sr['notes'])): ?>
      <div class="box notes">
        <b>Notes:</b><br>
        <?= nl2br(h($sr['notes'])) ?>
      </div>
    <?php endif; ?>

  </div>
</body>
</html>
