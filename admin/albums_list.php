<?php
// Файл: admin/albums_list.php

require_once '../include_config/config.php';
require_once '../include_config/db_connect.php';

$stmt = $pdo->query('SELECT * FROM Albums ORDER BY releaseDate DESC');
$albums = $stmt->fetchAll();
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Управление альбомами - Админ-панель</title>
    <link rel="stylesheet" href="../assets/css/admin_style.css">
</head>
<body>
    <div class="container">
        <h1>Панель управления</h1>

        <div class="admin-nav">
            <a href="index.php">Управление треками</a>
            <span class="admin-nav-separator">|</span>
            <a href="albums_list.php" class="active">Управление альбомами</a>
            <span class="admin-nav-separator">|</span>
            <a href="news_list.php">Управление новостями</a>
        </div>

        <a href="album_add.php" class="add-button">+ Добавить новый альбом</a>

        <table class="track-table">
            <thead>
                <tr>
                    <th>Обложка</th>
                    <th>Название альбома</th>
                    <th>Дата релиза</th>
                    <th>Действия</th>
                </tr>
            </thead>
            <tbody>
                <?php if (empty($albums)): ?>
                    <tr><td colspan="4">Альбомов пока нет.</td></tr>
                <?php else: ?>
                    <?php foreach ($albums as $album): ?>
                        <tr>
                            <td><img src="../<?= htmlspecialchars(ltrim($album['coverImagePath'], '/')) ?>" alt="Обложка" width="50"></td>
                            <td><?= htmlspecialchars($album['title']) ?></td>
                            <td><?= $album['releaseDate'] ? date('d.m.Y', strtotime($album['releaseDate'])) : 'Не указана' ?></td>
<td class="action-links">
    <a href="album_view.php?id=<?= (int)$album['id'] ?>">Посмотреть / Управлять</a>
    <a href="album_delete.php?id=<?= (int)$album['id'] ?>" class="delete" onclick="return confirm('Вы уверены?');">Удалить</a>
</td>
                        </tr>
                    <?php endforeach; ?>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</body>
</html>