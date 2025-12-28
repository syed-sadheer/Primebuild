<?php
require_once __DIR__ . "/../../../include/auth.php";
require_login();
require_permission('units.add');

$unit_name = trim($_POST['unit_name'] ?? '');
$errors = [];

if (is_post()) {
    if ($unit_name === '') $errors[] = "Unit name is required.";

    if (!$errors) {
        $stmt = $conn->prepare("SELECT id FROM units WHERE LOWER(unit_name)=LOWER(?) LIMIT 1");
        $stmt->bind_param("s", $unit_name);
        $stmt->execute();
        if ($stmt->get_result()->fetch_assoc()) $errors[] = "This unit already exists.";
    }

    if (!$errors) {
        $stmt = $conn->prepare("INSERT INTO units (unit_name, status) VALUES (?, 1)");
        $stmt->bind_param("s", $unit_name);
        $stmt->execute();

        flash_set('success', 'Unit added successfully.');
        redirect(BASE_URL . "/modules/utilities/units/list.php");
    }
}

require_once __DIR__ . "/../../../include/header.php";
require_once __DIR__ . "/../../../include/sidebar.php";
?>
<div class="content">
  <div class="card center-card">
    <h2 style="margin:0;">Add Unit</h2>
    <div class="muted small">Utilities / Units</div>

    <?php if ($errors): ?>
      <div class="alert">
        <ul style="margin:0;padding-left:18px;">
          <?php foreach($errors as $e): ?><li><?= e($e) ?></li><?php endforeach; ?>
        </ul>
      </div>
    <?php endif; ?>

    <form method="post" class="form" style="margin-top:12px;">
      <label>Unit Name *</label>
      <input type="text" name="unit_name" value="<?= e($unit_name) ?>" required>

      <div style="display:flex;gap:10px;flex-wrap:wrap;margin-top:8px;">
        <button type="submit" class="btn">Save</button>
        <a class="btn btn-light" href="<?= e(BASE_URL) ?>/modules/utilities/units/list.php">Back</a>
      </div>
    </form>
  </div>
</div>
<?php require_once __DIR__ . "/../../../include/footer.php"; ?>
