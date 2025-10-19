<?php
// Файл: pages/home.php - ПОЛНАЯ РАБОЧАЯ ВЕРСИЯ

require_once __DIR__ . '/../include_config/db_connect.php';

// Получаем 3 последние новости
$stmt_posts = $pdo->query('SELECT id, title, content, createdAt FROM Posts ORDER BY createdAt DESC LIMIT 3');
$posts = $stmt_posts->fetchAll();

// Получаем все альбомы, сортируя по дате релиза
$stmt_albums = $pdo->query('SELECT * FROM Albums ORDER BY releaseDate DESC');
$albums = $stmt_albums->fetchAll();
?>

<div class="hero-banner">
    <div class="hero-content">
        <h1>Хроники Забытых Миров</h1>
        <p>Новый альбом в стиле Power Metal уже здесь!</p>
        <a href="#albums" class="hero-button">Слушать</a>
    </div>
</div>

<div class="container page-content">
    <section class="news-section">
        <h2>Последние новости</h2>
        <div class="news-preview">
            <?php if (empty($posts)): ?>
                <p>Пока нет никаких новостей.</p>
            <?php else: ?>
                <?php foreach ($posts as $post): ?>
                    <article class="news-item">
                        <h3><?= htmlspecialchars($post['title']) ?></h3>
                        <p class="news-date"><?= date('d.m.Y', strtotime($post['createdAt'])) ?></p>
                        <p><?= htmlspecialchars(mb_substr($post['content'], 0, 150)) ?>...</p>
                        <a href="/pages/post.php?id=<?= (int)$post['id'] ?>" class="news-readmore">Читать далее...</a>
                    </article>
                <?php endforeach; ?>
            <?php endif; ?>
        </div>
    </section>

    <section id="albums" class="albums-section">
        <h2>Альбомы</h2>
        <div class="album-grid">
            <?php if (empty($albums)): ?>
                <p>Альбомов пока нет. Вы можете добавить их в админ-панели.</p>
            <?php else: ?>
                <?php foreach ($albums as $album): ?>
                    <a href="/pages/albums.php?id=<?= (int)$album['id'] ?>" class="album-card">
                        <img src="/<?= htmlspecialchars(ltrim($album['coverImagePath'], '/')) ?>" alt="Обложка <?= htmlspecialchars($album['title']) ?>">
                        <div class="album-title-overlay">
                            <h3><?= htmlspecialchars($album['title']) ?></h3>
                        </div>
                    </a>
                <?php endforeach; ?>
            <?php endif; ?>
        </div>
    </section>
</div>