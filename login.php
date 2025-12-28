<?php
require_once __DIR__ . "/include/auth.php";

if (is_logged_in()) {
    redirect(BASE_URL . "/index.php");
}

$error = null;

if (is_post()) {
    $username = trim($_POST['username'] ?? '');
    $password = (string)($_POST['password'] ?? '');

    if ($username === '' || $password === '') {
        $error = "Username and password are required.";
    } else {
        if (login_attempt($conn, $username, $password)) {
            redirect(BASE_URL . "/index.php");
        } else {
            $error = "Invalid login.";
        }
    }
}
?>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title><?= e(APP_NAME) ?> - Login</title>
  <link rel="stylesheet" href="<?= e(BASE_URL) ?>/assets/css/style.css">
</head>
<body>
  <div class="center-wrap">
    <div class="card">
      <h2 class="center"><?= e(APP_NAME) ?></h2>
      <p class="muted center">Login</p>

      <?php if ($error): ?>
        <div class="alert"><?= e($error) ?></div>
      <?php endif; ?>

      <form method="post" class="form">
        <label>Username</label>
        <input type="text" name="username" autocomplete="username" required>

        <label>Password</label>
        <input type="password" name="password" autocomplete="current-password" required>

        <button type="submit" class="btn">Login</button>

        <div class="muted small center" style="margin-top:10px;">
          Default: superadmin / Primebuild@123
        </div>
      </form>
    </div>
  </div>
</body>
</html>
