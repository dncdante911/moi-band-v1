<?php
// Файл: db_connect.php

// Настройки для подключения к базе данных
$db_host = '127.0.0.1'; // или 'localhost'
$db_name = 'moi-band';
$db_user = 'moi-band';
$db_pass = '0607Dm$157'; // Твой пароль
$db_char = 'utf8mb4';

// Строка для подключения (DSN)
$dsn = "mysql:host=$db_host;dbname=$db_name;charset=$db_char";

// Опции для PDO для более безопасной и эффективной работы
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
    // Создаем объект PDO для подключения к базе данных
    $pdo = new PDO($dsn, $db_user, $db_pass, $options);
} catch (\PDOException $e) {
    // Если подключиться не удалось, выводим ошибку и прекращаем работу
    // В реальном проекте здесь лучше логировать ошибку, а не выводить на экран
    throw new \PDOException($e->getMessage(), (int)$e->getCode());
}