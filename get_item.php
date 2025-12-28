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

$id = (int)($_GET['id'] ?? 0);
if ($id <= 0) { echo json_encode(['ok'=>false]); exit; }

$itemNameCol = pb_pick_col($conn,'items',['item_name','name']);
$unitCol     = pb_pick_col($conn,'items',['unit_id','base_unit_id']);
if (!$itemNameCol) { echo json_encode(['ok'=>false]); exit; }

$unitJoin = $unitCol ? "LEFT JOIN units u ON u.id = i.`$unitCol`" : "";
$unitSel  = $unitCol ? "COALESCE(u.unit_name,'') AS unit_name, i.`$unitCol` AS unit_id" : "'' AS unit_name, 0 AS unit_id";

$sql = "SELECT i.id,
               i.`$itemNameCol` AS item_name,
               COALESCE(c.color_name,'') AS color_name,
               COALESCE(s.size_name,'')  AS size_name,
               $unitSel
        FROM items i
        LEFT JOIN colors c ON c.id=i.color_id
        LEFT JOIN sizes  s ON s.id=i.size_id
        $unitJoin
        WHERE i.id=? LIMIT 1";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i",$id);
$stmt->execute();
$row = $stmt->get_result()->fetch_assoc();

if (!$row) { echo json_encode(['ok'=>false]); exit; }

echo json_encode([
  'ok'=>true,
  'id'=>(int)$row['id'],
  'item_name'=>$row['item_name'],
  'color_name'=>$row['color_name'],
  'size_name'=>$row['size_name'],
  'unit_id'=>(int)($row['unit_id'] ?? 0),
  'unit_name'=>$row['unit_name'],
]);
