<?php
// Файл: admin/news_list.php
require_once '../include_config/config.php';
require_once '../include_config/db_connect.php';
$stmt = $pdo->query('SELECT id, title, createdAt FROM Posts ORDER BY createdAt DESC');
$posts = $stmt->fetchAll();
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Управление новостями - Админ-панель</title>
    <link rel="stylesheet" href="../assets/css/admin_style.css">
</head>
<body>
    <div class="container">
        <h1>Панель управления</h1>

<div class="admin-nav">
    <a href="index.php">Управление треками</a>
    <span class="admin-nav-separator">|</span>
    <a href="albums_list.php">Управление альбомами</a>
    <span class="admin-nav-separator">|</span>
    <a href="news_list.php" class="active">Управление новостями</a>
</div>

        <a href="news_add.php" class="add-button">+ Добавить новость</a>

        <table class="track-table">
            <thead>
                <tr>
                    <th>Заголовок</th>
                    <th>Дата создания</th>
                    <th>Действия</th>
                </tr>
            </thead>
            <tbody>
                <?php if (empty($posts)): ?>
                    <tr><td colspan="3">Новостей пока нет.</td></tr>
                <?php else: ?>
                    <?php foreach ($posts as $post): ?>
                        <tr>
                            <td><?= htmlspecialchars($post['title']) ?></td>
                            <td><?= date('d.m.Y H:i', strtotime($post['createdAt'])) ?></td>
                            <td class="action-links">
                                <a href="news_edit.php?id=<?= (int)$post['id'] ?>">Редактировать</a>
                                <a href="news_delete.php?id=<?= (int)$post['id'] ?>" class="delete" onclick="return confirm('Вы уверены?');">Удалить</a>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
</body>
</html>