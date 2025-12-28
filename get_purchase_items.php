<?php
require_once __DIR__ . "/../include/auth.php";
require_login();

require_once __DIR__ . "/../config/db.php";

header('Content-Type: application/json; charset=utf-8');

$purchase_id = (int)($_GET['purchase_id'] ?? 0);
if ($purchase_id <= 0) {
  echo json_encode(['ok'=>false, 'msg'=>'Invalid purchase_id']);
  exit;
}

/*
  Returns items ONLY for selected purchase_id, and computes available qty:
  available = purchased - already_returned (non-cancelled returns)
*/
$sql = "
SELECT
  pi.id AS purchase_item_id,
  pi.purchase_id,
  pi.item_id,
  COALESCE(i.item_name,'') AS item_name,
  COALESCE(c.color_name,'') AS color_name,
  COALESCE(sz.size_name,'') AS size_name,
  COALESCE(u.unit_name,'') AS unit_name,

  pi.qty_pallets,
  pi.boxes_per_pallet,
  pi.sqm_per_box,
  pi.qty_boxes,
  pi.qty_sqm,
  pi.unit_cost_sqm,
  pi.line_total,

  COALESCE(rr.ret_pallets,0) AS ret_pallets,
  COALESCE(rr.ret_boxes,0)   AS ret_boxes,
  COALESCE(rr.ret_sqm,0)     AS ret_sqm,

  GREATEST(pi.qty_pallets - COALESCE(rr.ret_pallets,0), 0) AS av_pallets,
  GREATEST(pi.qty_boxes   - COALESCE(rr.ret_boxes,0),   0) AS av_boxes,
  GREATEST(pi.qty_sqm     - COALESCE(rr.ret_sqm,0),     0) AS av_sqm

FROM purchase_items pi
LEFT JOIN items i  ON i.id = pi.item_id
LEFT JOIN colors c ON c.id = i.color_id
LEFT JOIN sizes  sz ON sz.id = i.size_id
LEFT JOIN units  u ON u.id = pi.input_unit_id

LEFT JOIN (
  SELECT
    pri.purchase_item_id,
    SUM(pri.qty_pallets) AS ret_pallets,
    SUM(pri.qty_boxes)   AS ret_boxes,
    SUM(pri.qty_sqm)     AS ret_sqm
  FROM purchase_return_items pri
  INNER JOIN purchase_returns pr ON pr.id = pri.return_id
  WHERE pr.purchase_id = ?
    AND pr.status <> 'cancelled'
  GROUP BY pri.purchase_item_id
) rr ON rr.purchase_item_id = pi.id

WHERE pi.purchase_id = ?
ORDER BY pi.id ASC
";

$st = $conn->prepare($sql);
$st->bind_param("ii", $purchase_id, $purchase_id);
$st->execute();
$rs = $st->get_result();

$items = [];
while ($r = $rs->fetch_assoc()) {
  $items[] = [
    'purchase_item_id' => (int)$r['purchase_item_id'],
    'item_id' => (int)$r['item_id'],
    'item_name' => (string)$r['item_name'],
    'color_name' => (string)$r['color_name'],
    'size_name' => (string)$r['size_name'],
    'unit_name' => (string)$r['unit_name'],

    'qty_pallets' => (float)$r['qty_pallets'],
    'boxes_per_pallet' => (float)$r['boxes_per_pallet'],
    'sqm_per_box' => (float)$r['sqm_per_box'],
    'qty_boxes' => (float)$r['qty_boxes'],
    'qty_sqm' => (float)$r['qty_sqm'],
    'unit_cost_sqm' => (float)$r['unit_cost_sqm'],

    'ret_pallets' => (float)$r['ret_pallets'],
    'ret_boxes' => (float)$r['ret_boxes'],
    'ret_sqm' => (float)$r['ret_sqm'],

    'av_pallets' => (float)$r['av_pallets'],
    'av_boxes' => (float)$r['av_boxes'],
    'av_sqm' => (float)$r['av_sqm'],
  ];
}
$st->close();

echo json_encode(['ok'=>true, 'items'=>$items]);
