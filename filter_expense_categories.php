<?php
require_once __DIR__ . "/../include/auth.php";
require_login();
require_permission('expense_categories.view');

header('Content-Type: application/json; charset=utf-8');

function pb_table_exists(mysqli $conn, string $table): bool {
    $t = $conn->real_escape_string($table);
    $res = $conn->query("SHOW TABLES LIKE '{$t}'");
    return $res && $res->num_rows > 0;
}
function pb_column_exists(mysqli $conn, string $table, string $column): bool {
    $t = $conn->real_escape_string($table);
    $c = $conn->real_escape_string($column);
    $res = $conn->query("SHOW COLUMNS FROM `{$t}` LIKE '{$c}'");
    return $res && $res->num_rows > 0;
}
function pb_pick_col(mysqli $conn, string $table, array $candidates, string $fallback): string {
    foreach ($candidates as $col) {
        if (pb_column_exists($conn, $table, $col)) return $col;
    }
    return $fallback;
}

if (!pb_table_exists($conn, 'expense_categories')) {
    echo json_encode(['count'=>0,'html'=>'<tr><td colspan="4" class="center muted">Table expense_categories not found.</td></tr>']);
    exit;
}

$nameCol = pb_pick_col($conn, 'expense_categories', ['category_name','expense_category_name','expense_category','name'], 'category_name');
$statusCol = pb_column_exists($conn,'expense_categories','status') ? 'status' : null;

$q = trim($_GET['q'] ?? '');
$q = mb_substr($q, 0, 100);

$where = "WHERE 1=1";
if ($q !== '') {
    $where .= " AND `$nameCol` LIKE CONCAT('%', ?, '%')";
}

$sql = "SELECT id, `$nameCol` AS name" . ($statusCol ? ", `$statusCol` AS status" : ", 1 AS status") . "
        FROM expense_categories
        $where
        ORDER BY id DESC
        LIMIT 500";

$stmt = $conn->prepare($sql);
if ($q !== '') $stmt->bind_param("s", $q);
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
    $html .= '<td>'.e($row['name']).'</td>';
    $html .= '<td>'.(((int)$row['status']===1)?'Active':'Inactive').'</td>';
    $html .= '<td>';
    $html .= '<a class="btn-sm" href="'.e(BASE_URL).'/modules/utilities/expense_categories/view.php?id='.$id.'">View</a> ';
    $html .= '<a class="btn-sm" href="'.e(BASE_URL).'/modules/utilities/expense_categories/edit.php?id='.$id.'">Edit</a> ';
    $html .= '<a class="btn-sm danger" onclick="return confirm(\'Delete this category?\')" href="'.e(BASE_URL).'/modules/utilities/expense_categories/delete.php?id='.$id.'">Delete</a>';
    $html .= '</td>';
    $html .= '</tr>';
}

if ($count === 0) {
    $html = '<tr><td colspan="4" class="center muted">No categories found.</td></tr>';
}

echo json_encode(['count'=>$count,'html'=>$html]);
