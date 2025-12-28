<?php
require_once __DIR__ . "/include/auth.php";
require_login();
require_permission('dashboard.view');

require_once __DIR__ . "/include/header.php";
require_once __DIR__ . "/include/sidebar.php";
?>
<div class="content">
  <div class="card center-card">
    <h2>Dashboard</h2>
    <p class="muted">Auth + permissions are working. Next: Customers module (CRUD + auto-suggest + print).</p>
  </div>
</div>
<?php require_once __DIR__ . "/include/footer.php"; ?>
