<?php
/**
 * Файл: pages/album.php
 * Страница отдельного альбома с треклистом
 */

$page_css = '/assets/css/album.css';
require_once __DIR__ . '/../include_config/db_connect.php';

// Проверяем параметр ID
if (!isset($_GET['id']) || !filter_var($_GET['id'], FILTER_VALIDATE_INT)) {
    header('Location: /pages/albums.php');
    exit;
}

$albumId = (int)$_GET['id'];

// Получаем информацию об альбоме
$stmt = $pdo->prepare("SELECT * FROM Albums WHERE id = ?");
$stmt->execute([$albumId]);
$album = $stmt->fetch();

if (!$album) {
    header('Location: /pages/albums.php');
    exit;
}

// Получаем все треки альбома
$stmt = $pdo->prepare("SELECT * FROM Track WHERE albumId = ? ORDER BY id ASC");
$stmt->execute([$albumId]);
$tracks = $stmt->fetchAll();

require_once __DIR__ . '/../include_config/header.php';
?>

<!-- === БАННЕР АЛЬБОМА === -->
<div class="album-page-banner">
    <div class="banner-overlay"></div>
    <div class="banner-glow"></div>
    
    <div class="banner-content">
        <h1 class="banner-title">💿 <?= htmlspecialchars($album['title']) ?></h1>
        <p class="banner-subtitle">
            <?php if ($album['releaseDate']): ?>
                📅 <?= date('Y', strtotime($album['releaseDate'])) ?>
            <?php endif; ?>
            • 🎵 <?= count($tracks) ?> треков
        </p>
    </div>
</div>

<div class="container page-content album-page">
    
    <!-- === ИНФОРМАЦИЯ АЛЬБОМА === -->
    <section class="album-header">
        <div class="album-cover">
            <img src="/<?= htmlspecialchars(ltrim($album['coverImagePath'], '/')) ?>" 
                 alt="<?= htmlspecialchars($album['title']) ?>"
                 class="album-cover-image">
        </div>
        
        <div class="album-info-section">
            <h2 class="album-title-main">
                <?= htmlspecialchars($album['title']) ?>
            </h2>
            
            <?php if ($album['releaseDate']): ?>
                <p class="album-release-date">
                    📅 Дата релиза: <?= date('d.m.Y', strtotime($album['releaseDate'])) ?>
                </p>
            <?php endif; ?>
            
            <div class="album-stats">
                <span class="stat">🎵 <?= count($tracks) ?> треков</span>
            </div>
            
            <?php if ($album['description']): ?>
                <div class="album-description">
                    <h3>Описание</h3>
                    <p><?= nl2br(htmlspecialchars($album['description'])) ?></p>
                </div>
            <?php endif; ?>
            
            <a href="/pages/albums.php" class="back-link">← Вернуться в каталог</a>
        </div>
    </section>
    
    <!-- === ТРЕКЛИСТ === -->
    <section class="album-tracklist">
        <h2 class="tracklist-title">📋 Треклист</h2>
        
        <?php if (empty($tracks)): ?>
            <div class="empty-tracklist">
                <p>🎵 В этом альбоме пока нет треков</p>
            </div>
        <?php else: ?>
            <div class="tracks-container">
                <?php foreach ($tracks as $index => $track): ?>
                    <div class="track-item">
                        <div class="track-number">
                            <?= sprintf('%02d', $index + 1) ?>
                        </div>
                        
                        <div class="track-cover">
                            <img src="/<?= htmlspecialchars(ltrim($track['coverImagePath'], '/')) ?>" 
                                 alt="<?= htmlspecialchars($track['title']) ?>"
                                 loading="lazy">
                        </div>
                        
                        <div class="track-info">
                            <h3 class="track-title">
                                <?= htmlspecialchars($track['title']) ?>
                            </h3>
                            <?php if ($track['description']): ?>
                                <p class="track-description">
                                    <?= htmlspecialchars(mb_substr($track['description'], 0, 100)) ?>
                                    <?php if (strlen($track['description']) > 100): ?>
                                        ...
                                    <?php endif; ?>
                                </p>
                            <?php endif; ?>
                        </div>
                        
                        <div class="track-player">
                            <audio controls controlsList="nodownload">
                                <source src="/<?= htmlspecialchars(ltrim($track['fullAudioPath'], '/')) ?>" 
                                        type="audio/mpeg">
                                Ваш браузер не поддерживает HTML5 аудио
                            </audio>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
        <?php endif; ?>
    </section>
    
    <!-- === КНОПКА НАЗАД === -->
    <div class="album-footer">
        <a href="/pages/albums.php" class="footer-link">← Вернуться в каталог альбомов</a>
    </div>
    
</div>

<?php require_once __DIR__ . '/../include_config/footer.php'; ?>