<?php
// Primebuild ERP - Auth + Permission Helpers

require_once __DIR__ . "/../config/app.php";
require_once __DIR__ . "/../config/db.php";

if (session_status() === PHP_SESSION_NONE) {
    $cookieParams = session_get_cookie_params();
    session_set_cookie_params([
        'lifetime' => 0,
        'path' => $cookieParams['path'] ?? '/',
        'domain' => $cookieParams['domain'] ?? '',
        'secure' => false,       // set true when HTTPS
        'httponly' => true,
        'samesite' => 'Lax'
    ]);
    session_start();
}

require_once __DIR__ . "/functions.php";

function current_user(): ?array {
    return $_SESSION['user'] ?? null;
}

function is_logged_in(): bool {
    return !empty($_SESSION['user']['id']);
}

function is_super_admin(): bool {
    return !empty($_SESSION['user']['is_super_admin']);
}

function require_login(): void {
    if (!is_logged_in()) {
        redirect(BASE_URL . "/login.php");
    }
}

function load_user_permissions(mysqli $conn, int $user_id): array {
    $sql = "
        SELECT DISTINCT p.code
        FROM user_roles ur
        INNER JOIN role_permissions rp ON rp.role_id = ur.role_id
        INNER JOIN permissions p ON p.id = rp.permission_id
        WHERE ur.user_id = ?
    ";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $res = $stmt->get_result();
    $perms = [];
    while ($row = $res->fetch_assoc()) {
        $perms[] = $row['code'];
    }
    return $perms;
}

function require_permission(string $permission_code): void {
    if (is_super_admin()) return;

    $perms = $_SESSION['user']['permissions'] ?? [];
    if (!in_array($permission_code, $perms, true)) {
        http_response_code(403);
        echo "<h3 style='font-family:Arial'>403 - Access Denied</h3>";
        echo "<p style='font-family:Arial'>Missing permission: <b>" . e($permission_code) . "</b></p>";
        exit;
    }
}

function login_attempt(mysqli $conn, string $username, string $password): bool {
    $sql = "SELECT id, username, password_hash, full_name, status, is_super_admin
            FROM users
            WHERE username = ?
            LIMIT 1";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $u = $stmt->get_result()->fetch_assoc();

    if (!$u) return false;
    if ((int)$u['status'] !== 1) return false;

    if (!password_verify($password, $u['password_hash'])) {
        return false;
    }

    session_regenerate_id(true);

    $_SESSION['user'] = [
        'id' => (int)$u['id'],
        'username' => $u['username'],
        'full_name' => $u['full_name'] ?? '',
        'is_super_admin' => (int)$u['is_super_admin'] === 1 ? 1 : 0,
        'permissions' => []
    ];

    // Load permissions (super admin bypasses checks, but still load for completeness)
    $_SESSION['user']['permissions'] = load_user_permissions($conn, (int)$u['id']);

    return true;
}

function do_logout(): void {
    $_SESSION = [];
    if (ini_get("session.use_cookies")) {
        $params = session_get_cookie_params();
        setcookie(session_name(), '', time() - 42000,
            $params["path"], $params["domain"], $params["secure"], $params["httponly"]
        );
    }
    session_destroy();
}
