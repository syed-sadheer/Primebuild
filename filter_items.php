<?php
require_once __DIR__ . "/../include/auth.php";
require_login();
require_permission('items.view');

header('Content-Type: application/json; charset=utf-8');

$q = trim($_GET['q'] ?? '');
$q = mb_substr($q, 0, 100);

$where = "WHERE 1=1";
$params = [];
$types = "";

if ($q !== '') {
    $where .= " AND (
        i.item_name LIKE CONCAT('%', ?, '%')
        OR c.color_name LIKE CONCAT('%', ?, '%')
        OR s.size_name LIKE CONCAT('%', ?, '%')
        OR u.unit_name LIKE CONCAT('%', ?, '%')
    )";
    $types = "ssss";
    $params = [$q, $q, $q, $q];
}

$sql = "SELECT i.id, i.item_name,
               COALESCE(c.color_name,'') AS color_name,
               COALESCE(s.size_name,'')  AS size_name,
               COALESCE(u.unit_name,'')  AS unit_name,
               i.status, i.created_at
        FROM items i
        LEFT JOIN colors c ON c.id = i.color_id
        LEFT JOIN sizes  s ON s.id = i.size_id
        LEFT JOIN units  u ON u.id = i.unit_id
        $where
        ORDER BY i.id DESC
        LIMIT 500";

$stmt = $conn->prepare($sql);
if ($types !== "") $stmt->bind_param($types, ...$params);
$stmt->execute();
$res = $stmt->get_result();

$html = '';
$count = 0;
$i = 0;

while ($row = $res->fetch_assoc()) {
    $count++;
    $i++;
    $id = (int)$row['id'];

    $html .= '<tr>';
    $html .= '<td>' . $i . '</td>';
    $html .= '<td>' . e($row['item_name']) . '</td>';
    $html .= '<td>' . e($row['color_name']) . '</td>';
    $html .= '<td>' . e($row['size_name']) . '</td>';
    $html .= '<td>' . e($row['unit_name']) . '</td>';
    $html .= '<td>' . (((int)$row['status'] === 1) ? 'Active' : 'Inactive') . '</td>';
    $html .= '<td>' . e($row['created_at']) . '</td>';
    $html .= '<td>';
    $html .= '<a class="btn-sm" href="' . e(BASE_URL) . '/modules/items/view.php?id=' . $id . '">View</a> ';
    $html .= '<a class="btn-sm" href="' . e(BASE_URL) . '/modules/items/edit.php?id=' . $id . '">Edit</a> ';
    $html .= '<a class="btn-sm" target="_blank" href="' . e(BASE_URL) . '/modules/items/print.php?id=' . $id . '">Print</a> ';
    $html .= '<a class="btn-sm danger" onclick="return confirm(\'Delete this item?\')" href="' . e(BASE_URL) . '/modules/items/delete.php?id=' . $id . '">Delete</a>';
    $html .= '</td>';
    $html .= '</tr>';
}

if ($count === 0) {
    $html = '<tr><td colspan="8" class="center muted">No items found.</td></tr>';
}

echo json_encode(['count' => $count, 'html' => $html]);
