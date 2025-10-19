<?php require_once 'config.php'; ?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= htmlspecialchars(SITE_NAME) ?></title>
    <link rel="stylesheet" href="/assets/css/index.css">
</head>
<body>
    <div id="particles-js"></div> 
    <video autoplay muted loop id="background-video">
        <source src="/assets/videos/background_video.mp4" type="video/mp4">
    </video>

    <header class="site-header">
        <div class="container header-container">
            <div class="logo">
                <a href="/"><?= htmlspecialchars(SITE_NAME) ?></a>
            </div>
            <nav class="main-nav">
                <ul>
                    <li><a href="/">Музыка</a></li>
                    <li><a href="/pages/about.php">О группе</a></li>
                    <li><a href="/pages/news.php">Новости</a></li>
                    <li><a href="/pages/gallery.php">Галерея</a></li>
                    <li><a href="/pages/contact.php">Контакты</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <main>