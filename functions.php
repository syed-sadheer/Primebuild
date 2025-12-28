<?php

function e($str): string {
    return htmlspecialchars((string)$str, ENT_QUOTES, 'UTF-8');
}

function redirect(string $url): void {
    header("Location: " . $url);
    exit;
}

function flash_set(string $key, string $msg): void {
    $_SESSION['flash'][$key] = $msg;
}

function flash_get(string $key): ?string {
    if (!isset($_SESSION['flash'][$key])) return null;
    $v = $_SESSION['flash'][$key];
    unset($_SESSION['flash'][$key]);
    return $v;
}

function is_post(): bool {
    return ($_SERVER['REQUEST_METHOD'] ?? '') === 'POST';
}

/* Super admin hidden rule helper:
   - Use this in user list queries later:
     WHERE is_super_admin=0  (unless current user is super admin)
*/
function should_hide_superadmin(): bool {
    return empty($_SESSION['user']['is_super_admin']);
}
