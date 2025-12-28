<?php
require_once __DIR__ . "/../../../include/auth.php";
require_login();
require_permission('units.export');

$search = trim($_GET['q'] ?? '');
$search = mb_substr($search, 0, 100);

if ($search !== '') {
    $stmt = $conn->prepare("SELECT id, unit_name, status FROM units WHERE unit_name LIKE CONCAT('%', ?, '%') ORDER BY id DESC LIMIT 5000");
    $stmt->bind_param("s", $search);
} else {
    $stmt = $conn->prepare("SELECT id, unit_name, status FROM units ORDER BY id DESC LIMIT 5000");
}
$stmt->execute();
$res = $stmt->get_result();

$filename = "units_" . date("Ymd_His") . ".csv";

header('Content-Type: text/csv; charset=utf-8');
header('Content-Disposition: attachment; filename="'.$filename.'"');
header('Pragma: no-cache');
header('Expires: 0');

$out = fopen('php://output', 'w');
fwrite($out, "\xEF\xBB\xBF");

fputcsv($out, ['ID','Unit Name','Status']);

while ($row = $res->fetch_assoc()) {
    fputcsv($out, [
        $row['id'],
        $row['unit_name'],
        ((int)$row['status']===1)?'Active':'Inactive'
    ]);
}
fclose($out);
exit;
