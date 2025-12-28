<?php
require_once __DIR__ . "/../../../include/auth.php";
require_login();
require_permission('units.delete');

$id = (int)($_GET['id'] ?? 0);
if ($id <= 0) { flash_set('error','Invalid unit.'); redirect(BASE_URL."/modules/utilities/units/list.php"); }

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

if (pb_table_exists($conn,'items')) {
    if (pb_column_exists($conn,'items','unit_id')) {
        $stmt = $conn->prepare("SELECT 1 FROM items WHERE unit_id=? LIMIT 1");
        $stmt->bind_param("i",$id);
        $stmt->execute();
        if ($stmt->get_result()->fetch_assoc()) {
            flash_set('error', 'Cannot delete. Unit is used in items (unit_id).');
            redirect(BASE_URL . "/modules/utilities/units/list.php");
        }
    }
    if (pb_column_exists($conn,'items','base_unit_id')) {
        $stmt = $conn->prepare("SELECT 1 FROM items WHERE base_unit_id=? LIMIT 1");
        $stmt->bind_param("i",$id);
        $stmt->execute();
        if ($stmt->get_result()->fetch_assoc()) {
            flash_set('error', 'Cannot delete. Unit is used in items (base_unit_id).');
            redirect(BASE_URL . "/modules/utilities/units/list.php");
        }
    }
}

$stmt = $conn->prepare("DELETE FROM units WHERE id=?");
$stmt->bind_param("i",$id);
$stmt->execute();

flash_set('success','Unit deleted successfully.');
redirect(BASE_URL . "/modules/utilities/units/list.php");
