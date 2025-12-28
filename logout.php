<?php
require_once __DIR__ . "/include/auth.php";
do_logout();
redirect(BASE_URL . "/login.php");
