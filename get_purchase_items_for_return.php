<?php
require_once __DIR__ . "/../include/auth.php";
require_login();
require_permission('purchase_returns.add');

require_once __DIR__ . "/../config/db.php";

header('Content-Type: application/json; charset=utf-8');

$purchase_id = (int)($_GET['purchase_id'] ?? 0);
if ($purchase_id <= 0) { echo json_encode(['ok'=>false,'items'=>[]]); exit; }

$sql = "
  SELECT
    pi.id AS purchase_item_id,
    pi.item_id,
    COALESCE(i.item_name,'') AS item_name,
    COALESCE(c.color_name,'') AS color_name,
    COALESCE(sz.size_name,'') AS size_name,
    COALESCE(u.unit_name,'') AS unit_name,

    COALESCE(pi.qty_pallets,0) AS buy_pallets,
    COALESCE(pi.qty_boxes,0)   AS buy_boxes,
    COALESCE(pi.qty_sqm,0)     AS buy_sqm,

    COALESCE(pi.boxes_per_pallet,0) AS boxes_per_pallet,
    COALESCE(pi.sqm_per_box,0)      AS sqm_per_box,
    COALESCE(pi.unit_cost_sqm, pi.unit_cost_input, 0) AS cost_per_sqm,

    COALESCE(rtn.ret_pallets,0) AS ret_pallets,
    COALESCE(rtn.ret_boxes,0)   AS ret_boxes,
    COALESCE(rtn.ret_sqm,0)     AS ret_sqm

  FROM purchase_items pi
  LEFT JOIN items i ON i.id = pi.item_id
  LEFT JOIN colors c ON c.id = i.color_id
  LEFT JOIN sizes  sz ON sz.id = i.size_id
  LEFT JOIN units  u ON u.id = pi.input_unit_id

  LEFT JOIN (
    SELECT
      pri.purchase_item_id,
      SUM(COALESCE(pri.qty_pallets,0)) AS ret_pallets,
      SUM(COALESCE(pri.qty_boxes,0))   AS ret_boxes,
      SUM(COALESCE(pri.qty_sqm,0))     AS ret_sqm
    FROM purchase_return_items pri
    INNER JOIN purchase_returns pr ON pr.id = pri.return_id
    WHERE pr.purchase_id = ?
    GROUP BY pri.purchase_item_id
  ) rtn ON rtn.purchase_item_id = pi.id

  WHERE pi.purchase_id = ?
  ORDER BY pi.id ASC
";

$st = $conn->prepare($sql);
$st->bind_param("ii", $purchase_id, $purchase_id);
$st->execute();
$rs = $st->get_result();

$items = [];
while($r = $rs->fetch_assoc()){
  $buy_sqm = (float)$r['buy_sqm'];
  $ret_sqm = (float)$r['ret_sqm'];
  $avail_sqm = max(0.0, $buy_sqm - $ret_sqm);

  $buy_boxes = (float)$r['buy_boxes'];
  $ret_boxes = (float)$r['ret_boxes'];
  $avail_boxes = max(0.0, $buy_boxes - $ret_boxes);

  $buy_pallets = (float)$r['buy_pallets'];
  $ret_pallets = (float)$r['ret_pallets'];
  $avail_pallets = max(0.0, $buy_pallets - $ret_pallets);

  $items[] = [
    'purchase_item_id' => (int)$r['purchase_item_id'],
    'item_id'          => (int)$r['item_id'],
    'item_name'        => (string)$r['item_name'],
    'color_name'       => (string)$r['color_name'],
    'size_name'        => (string)$r['size_name'],
    'unit_name'        => (string)$r['unit_name'],

    'boxes_per_pallet' => (float)$r['boxes_per_pallet'],
    'sqm_per_box'      => (float)$r['sqm_per_box'],
    'cost_per_sqm'     => (float)$r['cost_per_sqm'],

    'buy_pallets'      => (float)$r['buy_pallets'],
    'buy_boxes'        => (float)$r['buy_boxes'],
    'buy_sqm'          => (float)$r['buy_sqm'],

    'ret_pallets'      => (float)$r['ret_pallets'],
    'ret_boxes'        => (float)$r['ret_boxes'],
    'ret_sqm'          => (float)$r['ret_sqm'],

    'avail_pallets'    => $avail_pallets,
    'avail_boxes'      => $avail_boxes,
    'avail_sqm'        => $avail_sqm,
  ];
}
$st->close();

echo json_encode(['ok'=>true,'items'=>$items]);
