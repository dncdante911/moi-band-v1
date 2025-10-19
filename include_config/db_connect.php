<?php
/**
 * Файл: include_config/db_connect.php
 * 
 * ВАЖНО: Этот файл использует ПРЯМЫЕ настройки без .env
 * После первого запуска перенесите данные в .env файл
 */

// === НАСТРОЙКИ БД ===
$db_host = '127.0.0.1';
$db_name = 'moi-band';
$db_user = 'moi-band';
$db_pass = '0607Dm$157';
$db_charset = 'utf8mb4';

// === СОЗДАНИЕ DSN ===
$dsn = "mysql:host=$db_host;dbname=$db_name;charset=$db_charset";

// === ОПЦИИ PDO ===
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

// === ПОДКЛЮЧЕНИЕ К БД ===
try {
    $pdo = new PDO($dsn, $db_user, $db_pass, $options);
    
    // Проверка подключения
    $pdo->query('SELECT 1');
    
} catch (\PDOException $e) {
    // В режиме разработки показываем ошибку
    http_response_code(500);
    echo '<!DOCTYPE html>
    <html lang="ru">
    <head>
        <meta charset="UTF-8">
        <title>❌ Ошибка подключения к БД</title>
        <style>
            body { 
                font-family: Arial, sans-serif; 
                background: #1a1a1a; 
                color: #e0e0e0; 
                padding: 20px;
            }
            .error-container {
                max-width: 800px;
                margin: 0 auto;
                background: #2a2a2a;
                border: 2px solid #8B0000;
                border-radius: 8px;
                padding: 30px;
            }
            h1 { color: #ff6666; margin-top: 0; }
            .error-details { 
                background: #111; 
                border: 1px solid #8B0000;
                border-radius: 4px;
                padding: 15px;
                margin: 20px 0;
                font-family: monospace;
                color: #ff9999;
                word-break: break-all;
            }
            .checklist { 
                background: rgba(65,105,225,0.1);
                border-left: 3px solid #4169E1;
                padding: 15px;
                margin: 20px 0;
            }
            .checklist li { margin: 8px 0; }
            .checklist strong { color: #FFD700; }
        </style>
    </head>
    <body>
        <div class="error-container">
            <h1>❌ Ошибка подключения к базе данных</h1>
            
            <div class="error-details">
                ' . htmlspecialchars($e->getMessage()) . '
            </div>
            
            <div class="checklist">
                <strong>🔍 Проверьте:</strong>
                <ul>
                    <li>✓ MySQL сервер запущен?</li>
                    <li>✓ Хост правильный: <code>127.0.0.1</code></li>
                    <li>✓ БД создана: <code>moi-band</code></li>
                    <li>✓ Пользователь: <code>moi-band</code></li>
                    <li>✓ Пароль правильный: <code>0607Dm$157</code></li>
                    <li>✓ Брандмауэр не блокирует порт 3306?</li>
                </ul>
            </div>
            
            <p style="color: #aaa; font-size: 0.9rem;">
                Если вы на Production - включите режим production в config.php и скройте эти ошибки от пользователей.
            </p>
        </div>
    </body>
    </html>';
    exit;
}