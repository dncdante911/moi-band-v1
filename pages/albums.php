<?php
// Файл: pages/album.php

$page_css = '/assets/css/album.css'; // Указываем, что у этой страницы есть свой CSS
require_once '../include_config/header.php';
require_once '../include_config/db_connect.php';

if (!isset($_GET['id']) || !filter_var($_GET['id'], FILTER_VALIDATE_INT)) {
    header('Location: /index.php'); exit;
}
$albumId = (int)$_GET['id'];

// 1. Получаем информацию о самом альбоме
$stmt_album = $pdo->prepare("SELECT * FROM Albums WHERE id = ?");
$stmt_album->execute([$albumId]);
$album = $stmt_album->fetch();
if (!$album) { header('Location: /index.php'); exit; }

// 2. Получаем все треки этого альбома
$stmt_tracks = $pdo->prepare("SELECT * FROM Track WHERE albumId = ? ORDER BY id ASC");
$stmt_tracks->execute([$albumId]);
$tracks = $stmt_tracks->fetchAll();
?>

<div class="container page-content">
    <div class="album-page-header">
        <div class="album-page-cover">
            <img src="/<?= htmlspecialchars(ltrim($album['coverImagePath'], '/')) ?>" alt="Обложка <?= htmlspecialchars($album['title']) ?>">
        </div>
        <div class="album-page-info">
            <h1><?= htmlspecialchars($album['title']) ?></h1>
            <p class="release-date">Дата релиза: <?= date('d.m.Y', strtotime($album['releaseDate'])) ?></p>
            <div class="album-description">
                <?= nl2br(htmlspecialchars($album['description'])) ?>
            </div>
        </div>
    </div>

    <div class="tracklist">
        <h2>Треклист</h2>
        <?php if (empty($tracks)): ?>
            <p>В этом альбоме пока нет треков.</p>
        <?php else: ?>
            <?php foreach ($tracks as $index => $track): ?>
                <div class="track-item">
                    <div class="track-number"><?= $index + 1 ?>.</div>
                    <div class="track-title"><?= htmlspecialchars($track['title']) ?></div>
                    <div class="track-player">
                        <audio controls controlsList="nodownload">
                            <source src="/<?= htmlspecialchars(ltrim($track['fullAudioPath'], '/')) ?>" type="audio/mpeg">
                        </audio>
                    </div>
                </div>
            <?php endforeach; ?>
        <?php endif; ?>
    </div>
</div>

<?php
require_once '../include_config/footer.php';
?>