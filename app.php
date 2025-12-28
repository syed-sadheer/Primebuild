<?php
// Primebuild ERP - App Config

date_default_timezone_set("Asia/Dubai");

// Change this if your folder name is different
define("BASE_URL", "http://localhost/primebuild");
define("APP_NAME", "Primebuild ERP");

/*
  IMPORTANT:
  Do NOT ini_set session settings here, because session may already be started
  by some file (or by module pages). We set session cookie params in include/auth.php
  BEFORE session_start().
*/
