<?php
require_once __DIR__ . "/../include/auth.php";
require_login();
require_permission('customers.view');

header('Content-Type: application/json; charset=utf-8');

$term = trim($_GET['term'] ?? '');
$term = mb_substr($term, 0, 100);

$out = [];

if ($term === '') {
    echo json_encode($out);
    exit;
}

$sql = "SELECT id, customer_name, mobile
        FROM customers
        WHERE status=1 AND (customer_name LIKE CONCAT('%', ?, '%') OR mobile LIKE CONCAT('%', ?, '%'))
        ORDER BY customer_name ASC
        LIMIT 10";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $term, $term);
$stmt->execute();
$res = $stmt->get_result();

while ($r = $res->fetch_assoc()) {
    $out[] = [
        'id' => (int)$r['id'],
        'label' => $r['customer_name'] . " (" . $r['mobile'] . ")",
        'name' => $r['customer_name'],
        'mobile' => $r['mobile']
    ];
}

echo json_encode($out);
