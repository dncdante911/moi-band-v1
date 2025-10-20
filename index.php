<?php
// Файл: index.php (в корне сайта)

$page_css = '/assets/css/main.css';
//$page_css = '/assets/css/responsive.css';
$page_css = '/assets/css/mobile-universal.css';
require_once 'include_config/header.php';
require_once 'pages/home.php';
require_once 'include_config/footer.php';