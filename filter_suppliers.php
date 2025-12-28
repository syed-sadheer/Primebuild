<?php
require_once __DIR__ . "/../include/auth.php";
require_login();
require_permission('suppliers.view');

header('Content-Type: application/json; charset=utf-8');

$q = trim($_GET['q'] ?? '');
$q = mb_substr($q, 0, 100);

$where = "WHERE 1=1";
$params = [];
$types = "";

if ($q !== '') {
    $where .= " AND (
        supplier_name LIKE CONCAT('%', ?, '%')
        OR mobile LIKE CONCAT('%', ?, '%')
        OR email LIKE CONCAT('%', ?, '%')
        OR city LIKE CONCAT('%', ?, '%')
    )";
    $types = "ssss";
    $params = [$q, $q, $q, $q];
}

$sql = "SELECT id, supplier_name, mobile, email, city, opening_balance, current_balance, status
        FROM suppliers
        $where
        ORDER BY id DESC
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
    $html .= '<td>' . e($row['supplier_name']) . '</td>';
    $html .= '<td>' . e($row['mobile']) . '</td>';
    $html .= '<td>' . e($row['email']) . '</td>';
    $html .= '<td>' . e($row['city']) . '</td>';
    $html .= '<td class="right">' . number_format((float)$row['opening_balance'], 2) . '</td>';
    $html .= '<td class="right">' . number_format((float)$row['current_balance'], 2) . '</td>';
    $html .= '<td>' . (((int)$row['status'] === 1) ? 'Active' : 'Inactive') . '</td>';
    $html .= '<td>';
    $html .= '<a class="btn-sm" href="' . e(BASE_URL) . '/modules/suppliers/view.php?id=' . $id . '">View</a> ';
    $html .= '<a class="btn-sm" href="' . e(BASE_URL) . '/modules/suppliers/edit.php?id=' . $id . '">Edit</a> ';
    $html .= '<a class="btn-sm" target="_blank" href="' . e(BASE_URL) . '/modules/suppliers/print.php?id=' . $id . '">Print</a> ';
    $html .= '<a class="btn-sm danger" onclick="return confirm(\'Delete this supplier?\')" href="' . e(BASE_URL) . '/modules/suppliers/delete.php?id=' . $id . '">Delete</a>';
    $html .= '</td>';
    $html .= '</tr>';
}

if ($count === 0) {
    $html = '<tr><td colspan="9" class="center muted">No suppliers found.</td></tr>';
}

echo json_encode(['count' => $count, 'html' => $html]);
