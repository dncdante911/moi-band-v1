<?php
// Файл: config.php

// Включаем отображение всех ошибок для удобной отладки
// На рабочем сайте это нужно будет отключить
ini_set('display_errors', 1);
error_reporting(E_ALL);

// Настройки для FOSSBilling API
define('FOSSBILLING_API_URL', 'https://bill.sthost.pro');
define('FOSSBILLING_API_TOKEN', 'YPo9tN0V8Ih0pdHDAKJfBuyNA08CnaHN');

// Другие настройки сайта
define('SITE_NAME', 'Master of illusion');