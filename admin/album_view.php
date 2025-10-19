<?php
// Файл: admin/album_view.php

require_once '../include_config/config.php';
require_once '../include_config/db_connect.php';

if (!isset($_GET['id']) || !filter_var($_GET['id'], FILTER_VALIDATE_INT)) {
    header('Location: albums_list.php');
    exit;
}
$albumId = (int)$_GET['id'];

// 1. Получаем информацию о самом альбоме
$stmt_album = $pdo->prepare("SELECT * FROM Albums WHERE id = ?");
$stmt_album->execute([$albumId]);
$album = $stmt_album->fetch();
if (!$album) {
    header('Location: albums_list.php');
    exit;
}

// 2. Получаем все треки, которые относятся к этому альбому
$stmt_tracks = $pdo->prepare("SELECT * FROM Track WHERE albumId = ? ORDER BY id ASC");
$stmt_tracks->execute([$albumId]);
$tracks = $stmt_tracks->fetchAll();
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Обзор альбома: <?= htmlspecialchars($album['title']) ?></title>
    <link rel="stylesheet" href="../assets/css/admin_style.css">
    <style>
        .album-header { display: flex; align-items: flex-start; margin-bottom: 30px; }
        .album-cover { margin-right: 20px; }
        .album-cover img { border-radius: 4px; border: 1px solid #444; }
        .album-details h2 { margin-top: 0; }
        .album-actions a { margin-right: 15px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="breadcrumbs">
            <a href="albums_list.php">Управление альбомами</a> &raquo;
            <span>Обзор альбома</span>
        </div>
        
        <div class="album-header">
            <div class="album-cover">
                <img src="../<?= htmlspecialchars(ltrim($album['coverImagePath'], '/')) ?>" alt="Обложка" width="150">
            </div>
            <div class="album-details">
                <h1><?= htmlspecialchars($album['title']) ?></h1>
                <p><?= nl2br(htmlspecialchars($album['description'])) ?></p>
                <div class="album-actions action-links">
                    <a href="album_edit.php?id=<?= $albumId ?>">Редактировать инфо</a>
                    <a href="album_add_tracks.php?album_id=<?= $albumId ?>" class="add">Массово загрузить треки</a>
                </div>
            </div>
        </div>

        <h2>Треки в альбоме</h2>
        <table class="track-table">
            <thead>
                <tr>
                    <th>Название</th>
                    <th>Действия</th>
                </tr>
            </thead>
            <tbody>
                <?php if (empty($tracks)): ?>
                    <tr><td colspan="2">В этом альбоме пока нет треков.</td></tr>
                <?php else: ?>
                    <?php foreach ($tracks as $track): ?>
                        <tr>
                            <td><?= htmlspecialchars($track['title']) ?></td>
                            <td class="action-links">
                                <a href="edit_track.php?id=<?= (int)$track['id'] ?>&album_id=<?= $albumId ?>">Редактировать</a>
                                <a href="delete_track.php?id=<?= (int)$track['id'] ?>" class="delete" onclick="return confirm('Вы уверены?');">Удалить</a>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</body>
</html>