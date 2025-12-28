<?php
require_once __DIR__ . "/../include/auth.php";
require_login();

header('Content-Type: application/json; charset=utf-8');

function pb_column_exists(mysqli $conn, string $table, string $col): bool {
  $t = $conn->real_escape_string($table);
  $c = $conn->real_escape_string($col);
  $r = $conn->query("SHOW COLUMNS FROM `{$t}` LIKE '{$c}'");
  return $r && $r->num_rows > 0;
}
function pb_pick_col(mysqli $conn, string $table, array $cands): string {
  foreach ($cands as $c) if (pb_column_exists($conn,$table,$c)) return $c;
  return '';
}

$q = trim($_GET['q'] ?? '');
$q = mb_substr($q, 0, 80);
if ($q === '') { echo json_encode([]); exit; }

$itemNameCol = pb_pick_col($conn,'items',['item_name','name']);
$unitCol     = pb_pick_col($conn,'items',['unit_id','base_unit_id']);
$hasStatus   = pb_column_exists($conn,'items','status');

if (!$itemNameCol) { echo json_encode([]); exit; }

$unitJoin = $unitCol ? "LEFT JOIN units u ON u.id = i.`$unitCol`" : "";
$unitSel  = $unitCol ? "COALESCE(u.unit_name,'') AS unit_name" : "'' AS unit_name";

$where = "WHERE i.`$itemNameCol` LIKE CONCAT('%', ?, '%')";
if ($hasStatus) $where .= " AND i.status=1";

$sql = "SELECT i.id,
               i.`$itemNameCol` AS item_name,
               COALESCE(c.color_name,'') AS color_name,
               COALESCE(s.size_name,'')  AS size_name,
               $unitSel
        FROM items i
        LEFT JOIN colors c ON c.id=i.color_id
        LEFT JOIN sizes  s ON s.id=i.size_id
        $unitJoin
        $where
        ORDER BY i.`$itemNameCol` ASC
        LIMIT 20";

$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $q);
$stmt->execute();
$res = $stmt->get_result();

$out = [];
while ($r = $res->fetch_assoc()) {
  $label = trim($r['item_name']);
  $meta = trim(($r['color_name'] ?? '').' '.($r['size_name'] ?? '').' '.($r['unit_name'] ?? ''));
  if ($meta !== '') $label .= " - ".$meta;
  $out[] = ['id'=>(int)$r['id'], 'label'=>$label];
}
echo json_encode($out);
