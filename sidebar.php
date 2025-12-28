<?php
// Sidebar with Utilities submenu (active-open)

$currentPath = parse_url($_SERVER['REQUEST_URI'] ?? '', PHP_URL_PATH);

// Active/Open flags
$utilOpen     = (strpos($currentPath, '/modules/utilities/') !== false);
$colorsActive = (strpos($currentPath, '/modules/utilities/colors/') !== false);

// (Future) flags for other utilities pages
$sizesActive  = (strpos($currentPath, '/modules/utilities/sizes/') !== false);
$unitsActive  = (strpos($currentPath, '/modules/utilities/units/') !== false);
?>
<div class="sidebar">
  <a class="navitem" href="<?= e(BASE_URL) ?>/index.php">Dashboard</a>

  <div class="navtitle">Masters</div>
  <a class="navitem" href="<?= e(BASE_URL) ?>/modules/customers/list.php">Customers</a>
  <a class="navitem" href="<?= e(BASE_URL) ?>/modules/suppliers/list.php">Suppliers</a>
  <a class="navitem" href="<?= e(BASE_URL) ?>/modules/items/list.php">Items</a>

  <!-- Utilities Parent (toggle) -->
  <a class="navitem" href="#"
     id="utilToggle"
     style="display:flex;justify-content:space-between;align-items:center;">
     <span>Utilities</span>
     <span><?= $utilOpen ? '▾' : '▸' ?></span>
  </a>

  <!-- Utilities Submenu -->
  <div id="utilSubmenu" style="margin-left:10px;<?= $utilOpen ? '' : 'display:none;' ?>">
    <a class="navitem <?= $colorsActive ? 'active' : '' ?>"
       href="<?= e(BASE_URL) ?>/modules/utilities/colors/list.php">Colors</a>

    <!-- placeholders for next utilities modules -->
    <a class="navitem <?= $sizesActive ? 'active' : '' ?>"
       href="<?= e(BASE_URL) ?>/modules/utilities/sizes/list.php">Sizes</a>

    <a class="navitem <?= $unitsActive ? 'active' : '' ?>"
       href="<?= e(BASE_URL) ?>/modules/utilities/units/list.php">Units</a>
       <a class="navitem" href="<?= e(BASE_URL) ?>/modules/utilities/payment_methods/list.php">Payment Methods</a>
      <a class="navitem" href="<?= e(BASE_URL) ?>/modules/utilities/expense_categories/list.php">Expense Categories</a>

  </div>

  <div class="navtitle">Transactions</div>
  <a class="navitem" href="<?= e(BASE_URL) ?>/modules/purchases/list.php">Purchases</a>
  <a class="navitem" href="<?= e(BASE_URL) ?>/modules/purchase_returns/list.php">Purchase Returns</a>
  <a class="navitem" href="<?= e(BASE_URL) ?>/modules/sales/list.php">Sales</a>
  <a class="navitem" href="<?= e(BASE_URL) ?>/modules/sales_returns/list.php">Sales Returns</a>
  <a class="navitem" href="<?= e(BASE_URL) ?>/modules/deliveries/list.php">Deliveries</a>

  <div class="navtitle">Accounts</div>
  <a class="navitem" href="<?= e(BASE_URL) ?>/modules/payments/customer_payment_list.php">Payments</a>
  <a class="navitem" href="<?= e(BASE_URL) ?>/modules/expenses/list.php">Expenses</a>
  <a class="navitem" href="<?= e(BASE_URL) ?>/modules/stock/summary.php">Stock</a>

  <div class="navtitle">Reports</div>
  <a class="navitem" href="<?= e(BASE_URL) ?>/modules/reports/sales_report.php">Reports</a>

  <div class="navtitle">Settings</div>
  <a class="navitem" href="<?= e(BASE_URL) ?>/modules/settings/company_profile.php">Company Profile</a>
  <a class="navitem" href="<?= e(BASE_URL) ?>/modules/rbac/users_list.php">Users & Roles</a>
</div>

<script>
(function () {
  var t = document.getElementById('utilToggle');
  var sub = document.getElementById('utilSubmenu');
  if (!t || !sub) return;

  t.addEventListener('click', function (e) {
    e.preventDefault();
    sub.style.display = (sub.style.display === 'none' || sub.style.display === '') ? 'block' : 'none';
  });
})();
</script>
