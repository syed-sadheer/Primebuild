<?php
require_once __DIR__ . "/../../../include/auth.php";
require_login();
require_permission('units.edit');

$id = (int)($_GET['id'] ?? 0);
if ($id <= 0) { flash_set('error','Invalid unit.'); redirect(BASE_URL."/modules/utilities/units/list.php"); }

$stmt = $conn->prepare("SELECT * FROM units WHERE id=? LIMIT 1");
$stmt->bind_param("i",$id);
$stmt->execute();
$unit = $stmt->get_result()->fetch_assoc();
if (!$unit) { flash_set('error','Unit not found.'); redirect(BASE_URL."/modules/utilities/units/list.php"); }

$errors = [];

if (is_post()) {
    $unit_name = trim($_POST['unit_name'] ?? '');
    $status = (int)($_POST['status'] ?? 1);

    if ($unit_name === '') $errors[] = "Unit name is required.";

    if (!$errors) {
        $stmt = $conn->prepare("SELECT id FROM units WHERE LOWER(unit_name)=LOWER(?) AND id<>? LIMIT 1");
        $stmt->bind_param("si", $unit_name, $id);
        $stmt->execute();
        if ($stmt->get_result()->fetch_assoc()) $errors[] = "This unit already exists.";
    }

    if (!$errors) {
        $stmt = $conn->prepare("UPDATE units SET unit_name=?, status=? WHERE id=?");
        $stmt->bind_param("sii", $unit_name, $status, $id);
        $stmt->execute();

        flash_set('success', 'Unit updated successfully.');
        redirect(BASE_URL . "/modules/utilities/units/list.php");
    }
}

require_once __DIR__ . "/../../../include/header.php";
require_once __DIR__ . "/../../../include/sidebar.php";

$val_name = $_POST['unit_name'] ?? $unit['unit_name'];
$val_status = (int)($_POST['status'] ?? $unit['status']);
?>
<div class="content">
  <div class="card center-card">
    <h2 style="margin:0;">Edit Unit</h2>
    <div class="muted small">ID: <?= (int)$unit['id'] ?></div>

    <?php if ($errors): ?>
      <div class="alert">
        <ul style="margin:0;padding-left:18px;">
          <?php foreach($errors as $e): ?><li><?= e($e) ?></li><?php endforeach; ?>
        </ul>
      </div>
    <?php endif; ?>

    <form method="post" class="form" style="margin-top:12px;">
      <label>Unit Name *</label>
      <input type="text" name="unit_name" value="<?= e($val_name) ?>" required>

      <label>Status</label>
      <select name="status">
        <option value="1" <?= $val_status===1?'selected':'' ?>>Active</option>
        <option value="0" <?= $val_status===0?'selected':'' ?>>Inactive</option>
      </select>

      <div style="display:flex;gap:10px;flex-wrap:wrap;margin-top:8px;">
        <button type="submit" class="btn">Update</button>
        <a class="btn btn-light" href="<?= e(BASE_URL) ?>/modules/utilities/units/list.php">Back</a>
      </div>
    </form>
  </div>
</div>
<?php require_once __DIR__ . "/../../../include/footer.php"; ?>
