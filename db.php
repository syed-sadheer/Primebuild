<?php
// Primebuild ERP - Database Connection (MySQLi)

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

$db_host = "localhost";
$db_user = "root";
$db_pass = "";              // XAMPP default is empty
$db_name = "primebuild";

try {
    $conn = new mysqli($db_host, $db_user, $db_pass, $db_name);
    $conn->set_charset("utf8mb4");
} catch (Throwable $e) {
    http_response_code(500);
    die("Database connection failed. Check config/db.php settings.");
}
