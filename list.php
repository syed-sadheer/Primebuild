<?php
require_once __DIR__ . "/../../../include/auth.php";
require_login();
require_permission('units.view');

require_once __DIR__ . "/../../../include/header.php";
require_once __DIR__ . "/../../../include/sidebar.php";

$search = trim($_GET['q'] ?? '');
$search = mb_substr($search, 0, 100);

if ($search !== '') {
    $stmt = $conn->prepare("SELECT id, unit_name, status FROM units WHERE unit_name LIKE CONCAT('%', ?, '%') ORDER BY id DESC LIMIT 500");
    $stmt->bind_param("s", $search);
} else {
    $stmt = $conn->prepare("SELECT id, unit_name, status FROM units ORDER BY id DESC LIMIT 500");
}
$stmt->execute();
$res = $stmt->get_result();

$success = flash_get('success');
$error   = flash_get('error');
?>
<div class="content">
  <div class="card center-card">

    <div style="display:flex;justify-content:space-between;align-items:center;gap:10px;flex-wrap:wrap;">
      <div>
        <h2 style="margin:0;">Units</h2>
        <div class="muted small">Utilities / Units</div>
        <div class="muted small">Results: <span id="resultCount"><?= (int)$res->num_rows ?></span></div>
      </div>

      <div style="display:flex;gap:8px;align-items:center;flex-wrap:wrap;">
        <a class="btn btn-light" title="Export to Excel"
           href="<?= e(BASE_URL) ?>/modules/utilities/units/export_excel.php?q=<?= urlencode($search) ?>">⤓ Excel</a>

        <a class="btn btn-secondary" href="<?= e(BASE_URL) ?>/modules/utilities/units/add.php">+ Add Unit</a>
      </div>
    </div>

    <?php if ($success): ?><div class="alert success"><?= e($success) ?></div><?php endif; ?>
    <?php if ($error): ?><div class="alert"><?= e($error) ?></div><?php endif; ?>

    <form id="searchForm" method="get" style="margin-top:12px;display:flex;gap:8px;flex-wrap:wrap;">
      <input
        type="text"
        id="q"
        name="q"
        value="<?= e($search) ?>"
        placeholder="Type to filter unit name"
        style="flex:1;min-width:240px;"
        autocomplete="off"
      >
      <a class="btn btn-light" href="<?= e(BASE_URL) ?>/modules/utilities/units/list.php">Reset</a>
    </form>

    <div style="overflow:auto;margin-top:12px;">
      <table class="table">
        <thead>
          <tr>
            <th style="width:60px;">#</th>
            <th>Unit Name</th>
            <th style="width:120px;">Status</th>
            <th style="width:220px;">Action</th>
          </tr>
        </thead>

        <tbody id="unitsBody">
          <?php $i=0; while($row = $res->fetch_assoc()): $i++; ?>
            <tr>
              <td><?= $i ?></td>
              <td><?= e($row['unit_name']) ?></td>
              <td><?= ((int)$row['status']===1)?'Active':'Inactive' ?></td>
              <td>
                <a class="btn-sm" href="<?= e(BASE_URL) ?>/modules/utilities/units/view.php?id=<?= (int)$row['id'] ?>">View</a>
                <a class="btn-sm" href="<?= e(BASE_URL) ?>/modules/utilities/units/edit.php?id=<?= (int)$row['id'] ?>">Edit</a>
                <a class="btn-sm danger" onclick="return confirm('Delete this unit?')" href="<?= e(BASE_URL) ?>/modules/utilities/units/delete.php?id=<?= (int)$row['id'] ?>">Delete</a>
              </td>
            </tr>
          <?php endwhile; ?>
          <?php if ($i===0): ?>
            <tr><td colspan="4" class="center muted">No units found.</td></tr>
          <?php endif; ?>
        </tbody>
      </table>
    </div>

  </div>
</div>

<script>
(function () {
  const inp = document.getElementById('q');
  const body = document.getElementById('unitsBody');
  const countEl = document.getElementById('resultCount');
  if (!inp || !body) return;

  let controller = null;

  const run = pbDebounce(async () => {
    const q = (inp.value || '').trim();

    if (controller) controller.abort();
    controller = new AbortController();

    try {
      const url = "<?= e(BASE_URL) ?>/ajax/filter_units.php?q=" + encodeURIComponent(q);
      const res = await fetch(url, { credentials: "same-origin", signal: controller.signal });
      const data = await res.json();
      body.innerHTML = data.html || '';
      if (countEl) countEl.textContent = (data.count ?? 0);
    } catch (e) {
      if (e.name !== 'AbortError') {}
    }
  }, 200);

  inp.addEventListener('input', run);
})();
</script>

<?php require_once __DIR__ . "/../../../include/footer.php"; ?>
