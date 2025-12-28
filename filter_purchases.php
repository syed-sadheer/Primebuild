<?php
require_once __DIR__ . "/../include/auth.php";
require_login();
require_permission('purchases.view');

header('Content-Type: application/json; charset=utf-8');

function pb_table_exists(mysqli $conn, string $table): bool {
  $t = $conn->real_escape_string($table);
  $r = $conn->query("SHOW TABLES LIKE '{$t}'");
  return $r && $r->num_rows > 0;
}
function pb_column_exists(mysqli $conn, string $table, string $col): bool {
  $t = $conn->real_escape_string($table);
  $c = $conn->real_escape_string($col);
  $r = $conn->query("SHOW COLUMNS FROM `{$t}` LIKE '{$c}'");
  return $r && $r->num_rows > 0;
}
function pb_pick_col(mysqli $conn, string $table, array $cands, string $fallback): string {
  foreach ($cands as $c) if (pb_column_exists($conn,$table,$c)) return $c;
  return $fallback;
}

if (!pb_table_exists($conn,'purchases')) {
  echo json_encode(['count'=>0,'html'=>'<tr><td colspan="9" class="center muted">Table purchases not found.</td></tr>']);
  exit;
}

$dateCol   = pb_pick_col($conn,'purchases',['purchase_date','date','created_at'],'purchase_date');
$invCol    = pb_pick_col($conn,'purchases',['invoice_no','supplier_invoice_no','invoice_number'],'invoice_no');
$totalCol  = pb_pick_col($conn,'purchases',['total_amount','grand_total','total'],'total_amount');
$paidCol   = pb_pick_col($conn,'purchases',['paid_amount','paid'],'paid_amount');
$suppIdCol = pb_pick_col($conn,'purchases',['supplier_id'],'supplier_id');

$q = trim($_GET['q'] ?? '');
$q = mb_substr($q, 0, 100);

$where = "WHERE 1=1";
$types = "";
$params = [];

if ($q !== '') {
  $where .= " AND (p.`$invCol` LIKE CONCAT('%', ?, '%')
              OR s.supplier_name LIKE CONCAT('%', ?, '%'))";
  $types = "ss";
  $params = [$q,$q];
}

$sql = "SELECT p.id,
               p.`$dateCol`  AS pdate,
               p.`$invCol`   AS invoice_no,
               p.`$totalCol` AS total_amount,
               p.`$paidCol`  AS paid_amount,
               s.supplier_name
        FROM purchases p
        LEFT JOIN suppliers s ON s.id = p.`$suppIdCol`
        $where
        ORDER BY p.id DESC
        LIMIT 500";

$stmt = $conn->prepare($sql);
if ($types !== "") $stmt->bind_param($types, ...$params);
$stmt->execute();
$res = $stmt->get_result();

$html = '';
$count = 0; $i=0;

while ($row = $res->fetch_assoc()) {
  $count++; $i++;
  $id = (int)$row['id'];
  $total = (float)($row['total_amount'] ?? 0);
  $paid  = (float)($row['paid_amount'] ?? 0);
  $due   = $total - $paid;

  $html .= '<tr>';
  $html .= '<td>'.$i.'</td>';
  $html .= '<td>'.e($row['pdate']).'</td>';
  $html .= '<td>'.e($row['supplier_name']).'</td>';
  $html .= '<td>'.e($row['invoice_no']).'</td>';
  $html .= '<td class="right">'.number_format($total,2).'</td>';
  $html .= '<td class="right">'.number_format($paid,2).'</td>';
  $html .= '<td class="right">'.number_format($due,2).'</td>';
  $html .= '<td>';
  $html .= '<a class="btn-sm" href="'.e(BASE_URL).'/modules/purchases/view.php?id='.$id.'">View</a> ';
  $html .= '<a class="btn-sm" href="'.e(BASE_URL).'/modules/purchases/edit.php?id='.$id.'">Edit</a> ';
  $html .= '<a class="btn-sm danger" onclick="return confirm(\'Delete this purchase?\')" href="'.e(BASE_URL).'/modules/purchases/delete.php?id='.$id.'">Delete</a>';
  $html .= '</td>';
  $html .= '</tr>';
}

if ($count === 0) {
  $html = '<tr><td colspan="8" class="center muted">No purchases found.</td></tr>';
}

echo json_encode(['count'=>$count,'html'=>$html]);
