<?php 
/**
 * Файл: include_config/header.php
 * ИСПРАВЛЕННАЯ ВЕРСИЯ - правильное подключение стилей
 */

require_once __DIR__ . '/config.php'; 
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= htmlspecialchars(SITE_NAME) ?></title>
    
    <!-- === ОСНОВНЫЕ СТИЛИ === -->
    <link rel="stylesheet" href="/assets/css/main.css">
    
    <!-- === EPIC THEME - НОВЫЙ БОЕВОЙ ДИЗАЙН === -->
    <link rel="stylesheet" href="/assets/css/header-epic.css">
    <link rel="stylesheet" href="/assets/css/albums-epic.css">
    <link rel="stylesheet" href="/assets/css/epic-home.css">
    
    <!-- === СТАРЫЕ СТИЛИ (базовые) === -->
    <link rel="stylesheet" href="/assets/css/auth.css">
    <link rel="stylesheet" href="/assets/css/chat.css">
    <link rel="stylesheet" href="/assets/css/about.css">
    <link rel="stylesheet" href="/assets/css/post.css">
    
    <!-- === АДАПТИВНЫЕ СТИЛИ === -->
    <link rel="stylesheet" href="/assets/css/responsive.css">
    
    <!-- === СТРАНИЦА-СПЕЦИФИЧНЫЕ СТИЛИ === -->
    <!-- Если на странице задан $page_css, подключаем его (он переопределит общие) -->
    <?php if (isset($page_css)): ?>
        <link rel="stylesheet" href="<?= htmlspecialchars($page_css) ?>">
    <?php endif; ?>
    
    <!-- === ШРИФТЫ GOOGLE === -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel+Decorative:wght@700&family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    
    <!-- === ВНЕШНИЕ БИБЛИОТЕКИ === -->
    <!-- Particles.js для анимированного фона (если используется) -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/particles.js/2.0.0/particles.min.js"></script>
</head>
<body>
    <!-- === ФОНОВЫЕ ЭЛЕМЕНТЫ === -->
    <div id="particles-js"></div>
    <video autoplay muted loop id="background-video">
        <source src="/assets/videos/background_video.mp4" type="video/mp4">
    </video>

    <!-- === ШАПКА САЙТА === -->
    <header class="site-header">
        <div class="container header-container">
            <div class="logo">
                <a href="/"><?= htmlspecialchars(SITE_NAME) ?></a>
            </div>
            
            <!-- Бургер меню для мобильных -->
            <button class="hamburger-menu" id="hamburger">☰</button>
            
            <!-- Навигация -->
            <nav class="main-nav" id="mainNav">
                <ul>
                    <li><a href="/">🏠 Главная</a></li>
                    <li><a href="/pages/albums.php">📀 Альбомы</a></li>
                    <li><a href="/pages/about.php">ℹ️ О проекте</a></li>
                    <li><a href="/pages/news.php">📰 Новости</a></li>
                    <li><a href="/pages/gallery.php">🖼️ Галерея</a></li>
                    <li><a href="/pages/contact.php">✉️ Контакты</a></li>
                    
                    <?php 
                    // Проверяем авторизацию
                    if (isset($_SESSION['user_id'])): 
                    ?>
                        <li><a href="/pages/chat.php">💬 Чат</a></li>
                        <li><a href="/pages/auth/profile.php">👤 Профиль</a></li>
                        <li><a href="/pages/auth/logout.php">🚪 Выход</a></li>
                    <?php else: ?>
                        <li><a href="/pages/auth/login.php">🔐 Вход</a></li>
                        <li><a href="/pages/auth/register.php">✍️ Регистрация</a></li>
                    <?php endif; ?>
                </ul>
            </nav>
        </div>
    </header>

    <!-- === ОСНОВНОЙ КОНТЕНТ === -->
    <main class="main-content">