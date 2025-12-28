<?php
require_once __DIR__ . "/../../../include/auth.php";
require_login();
require_permission('units.view');

$id = (int)($_GET['id'] ?? 0);
if ($id <= 0) { flash_set('error','Invalid unit.'); redirect(BASE_URL."/modules/utilities/units/list.php"); }

$stmt = $conn->prepare("SELECT * FROM units WHERE id=? LIMIT 1");
$stmt->bind_param("i",$id);
$stmt->execute();
$unit = $stmt->get_result()->fetch_assoc();
if (!$unit) { flash_set('error','Unit not found.'); redirect(BASE_URL."/modules/utilities/units/list.php"); }

require_once __DIR__ . "/../../../include/header.php";
require_once __DIR__ . "/../../../include/sidebar.php";
?>
<div class="content">
  <div class="card center-card">
    <div style="display:flex;justify-content:space-between;gap:10px;flex-wrap:wrap;align-items:center;">
      <div>
        <h2 style="margin:0;">Unit Details</h2>
        <div class="muted small">ID: <?= (int)$unit['id'] ?></div>
      </div>
      <div style="display:flex;gap:8px;flex-wrap:wrap;">
        <a class="btn btn-secondary" href="<?= e(BASE_URL) ?>/modules/utilities/units/edit.php?id=<?= (int)$unit['id'] ?>">Edit</a>
        <a class="btn btn-light" href="<?= e(BASE_URL) ?>/modules/utilities/units/list.php">Back</a>
      </div>
    </div>

    <div style="margin-top:12px;">
      <table class="table">
        <tr><th style="width:220px;">Unit Name</th><td><?= e($unit['unit_name']) ?></td></tr>
        <tr><th>Status</th><td><?= ((int)$unit['status']===1)?'Active':'Inactive' ?></td></tr>
      </table>
    </div>
  </div>
</div>
<?php require_once __DIR__ . "/../../../include/footer.php"; ?>
