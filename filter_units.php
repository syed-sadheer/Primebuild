<?php
require_once __DIR__ . "/../include/auth.php";
require_login();
require_permission('units.view');

header('Content-Type: application/json; charset=utf-8');

$q = trim($_GET['q'] ?? '');
$q = mb_substr($q, 0, 100);

$where = "WHERE 1=1";
if ($q !== '') {
    $where .= " AND unit_name LIKE CONCAT('%', ?, '%')";
}

$sql = "SELECT id, unit_name, status
        FROM units
        $where
        ORDER BY id DESC
        LIMIT 500";

$stmt = $conn->prepare($sql);
if ($q !== '') {
    $stmt->bind_param("s", $q);
}
$stmt->execute();
$res = $stmt->get_result();

$html = '';
$count = 0;
$i = 0;

while ($row = $res->fetch_assoc()) {
    $count++; $i++;
    $id = (int)$row['id'];

    $html .= '<tr>';
    $html .= '<td>'.$i.'</td>';
    $html .= '<td>'.e($row['unit_name']).'</td>';
    $html .= '<td>'.(((int)$row['status']===1)?'Active':'Inactive').'</td>';
    $html .= '<td>';
    $html .= '<a class="btn-sm" href="'.e(BASE_URL).'/modules/utilities/units/view.php?id='.$id.'">View</a> ';
    $html .= '<a class="btn-sm" href="'.e(BASE_URL).'/modules/utilities/units/edit.php?id='.$id.'">Edit</a> ';
    $html .= '<a class="btn-sm danger" onclick="return confirm(\'Delete this unit?\')" href="'.e(BASE_URL).'/modules/utilities/units/delete.php?id='.$id.'">Delete</a>';
    $html .= '</td>';
    $html .= '</tr>';
}

if ($count === 0) {
    $html = '<tr><td colspan="4" class="center muted">No units found.</td></tr>';
}

echo json_encode(['count'=>$count,'html'=>$html]);
