<?php
require_once __DIR__ . "/auth.php";
$u = current_user();
?>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title><?= e(APP_NAME) ?></title>
  <link rel="stylesheet" href="<?= e(BASE_URL) ?>/assets/css/style.css">
  <script src="<?= e(BASE_URL) ?>/assets/js/app.js"></script>
</head>
<body>
  <div class="topbar">
    <div class="topbar-left"></div>
    <div class="topbar-center"><?= e(APP_NAME) ?></div>
    <div class="topbar-right">
      <span class="muted"><?= e($u['full_name'] ?: $u['username']) ?></span>
      <a class="link" href="<?= e(BASE_URL) ?>/logout.php">Logout</a>
    </div>
  </div>

  <div class="layout">
