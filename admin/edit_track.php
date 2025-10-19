<?php
// Файл: admin/edit_track.php

require_once '../include_config/config.php';
require_once '../include_config/db_connect.php';

$stmt_albums = $pdo->query("SELECT id, title FROM Albums ORDER BY title ASC");
$albums = $stmt_albums->fetchAll();

// Проверяем, что ID трека передан и является числом
if (!isset($_GET['id']) || !filter_var($_GET['id'], FILTER_VALIDATE_INT)) {
if (isset($_GET['album_id'])) {
    header('Location: album_view.php?id=' . (int)$_GET['album_id']);
} else {
    header('Location: index.php'); // Иначе - на общий список треков
}
exit;
}
$trackId = (int)$_GET['id'];

// --- ОБРАБОТКА ОТПРАВЛЕННОЙ ФОРМЫ (POST-ЗАПРОС) ---
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Получаем и очищаем данные
    $title = trim($_POST['title'] ?? '');
    $description = trim($_POST['description'] ?? '');
    $errors = [];

    // Валидация
    if (empty($title)) $errors[] = 'Название не может быть пустым.';

    if (empty($errors)) {
        // Загружаем текущие данные трека, чтобы знать старые пути к файлам
        $stmt = $pdo->prepare("SELECT * FROM Track WHERE id = ?");
        $stmt->execute([$trackId]);
        $currentTrack = $stmt->fetch();

        // Функция для сохранения файла (та же, что и в add_track.php)
        function saveFile($file, $subfolder) {
            $uploadDir = '../public/uploads/' . $subfolder . '/';
            if (!is_dir($uploadDir)) mkdir($uploadDir, 0755, true);
            $fileExtension = pathinfo($file['name'], PATHINFO_EXTENSION);
            $fileName = uniqid() . '.' . $fileExtension;
            $uploadPath = $uploadDir . $fileName;
            if (move_uploaded_file($file['tmp_name'], $uploadPath)) {
                return '/public/uploads/' . $subfolder . '/' . $fileName;
            }
            return false;
        }

        // Обрабатываем файлы: если загружен новый файл, сохраняем его и удаляем старый
        $coverPath = $currentTrack['coverImagePath'];
        if (!empty($_FILES['cover']['name']) && $_FILES['cover']['error'] === UPLOAD_ERR_OK) {
            $newCoverPath = saveFile($_FILES['cover'], 'covers');
            if ($newCoverPath) {
                @unlink('..' . $coverPath); // Удаляем старый файл
                $coverPath = $newCoverPath; // Обновляем путь
            }
        }
               $fullTrackPath = $currentTrack['fullAudioPath'];
        if (!empty($_FILES['fullTrack']['name']) && $_FILES['fullTrack']['error'] === UPLOAD_ERR_OK) {
            $newFullTrackPath = saveFile($_FILES['fullTrack'], 'full');
            if ($newFullTrackPath) {
                @unlink('..' . $fullTrackPath);
                $fullTrackPath = $newFullTrackPath;
            }
        }

        // Обновляем запись в базе данных
$sql = "UPDATE Track SET 
    title = :title, 
    description = :description, 
    albumId = :albumId,
    coverImagePath = :coverImagePath, 
    fullAudioPath = :fullAudioPath 
WHERE id = :id";
        
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            ':title' => $title,
            ':description' => $description,
            ':albumId' => $albumId ?: null,
            ':coverImagePath' => $coverPath,
            ':fullAudioPath' => $fullTrackPath,
            ':id' => $trackId
        ]);

        header('Location: index.php');
        exit;
    }
}

// --- ЗАГРУЗКА ДАННЫХ ДЛЯ ОТОБРАЖЕНИЯ ФОРМЫ (GET-ЗАПРОС) ---
$stmt = $pdo->prepare("SELECT * FROM Track WHERE id = ?");
$stmt->execute([$trackId]);
$track = $stmt->fetch();

if (!$track) {
    // Если трек не найден, отправляем на главную
    header('Location: index.php');
    exit;
}
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Редактировать трек - <?= htmlspecialchars($track['title']) ?></title>
    <link rel="stylesheet" href="../assets/css/admin_style.css">
    <style>
        .form-container { max-width: 800px; } .form-group { margin-bottom: 20px; } .form-group label { display: block; margin-bottom: 5px; font-weight: bold; } .form-group input, .form-group textarea { width: 100%; padding: 10px; background-color: #4a5568; border: 1px solid #718096; color: #e2e8f0; border-radius: 5px; box-sizing: border-box; } .form-group input[type="file"] { padding: 5px; } .submit-button { padding: 12px 25px; background-color: #2b6cb0; color: #ffffff; border: none; border-radius: 5px; font-size: 1rem; cursor: pointer; } .errors { background-color: #c53030; color: #ffffff; padding: 15px; border-radius: 5px; margin-bottom: 20px; } .current-file { font-size: 0.9rem; color: #a0aec0; margin-top: 5px; }
    </style>
</head>
<body>
    <div class="container form-container">
        <h1>Редактировать трек: <?= htmlspecialchars($track['title']) ?></h1>

        <?php if (!empty($errors)): ?>
            <div class="errors">
                <strong>Ошибки:</strong>
                <ul><?php foreach ($errors as $error) echo "<li>" . htmlspecialchars($error) . "</li>"; ?></ul>
            </div>
        <?php endif; ?>
        
<div class="form-group">
    <label for="albumId">Альбом</label>
    <select id="albumId" name="albumId">
        <option value="">Без альбома</option>
        <?php foreach ($albums as $album): ?>
            <option value="<?= $album['id'] ?>" <?= ($track['albumId'] == $album['id']) ? 'selected' : '' ?>>
                <?= htmlspecialchars($album['title']) ?>
            </option>
        <?php endforeach; ?>
    </select>
</div>
        <form action="edit_track.php?id=<?= $trackId ?>" method="POST" enctype="multipart/form-data">
            <div class="form-group">
                <label for="title">Название трека</label>
                <input type="text" id="title" name="title" value="<?= htmlspecialchars($track['title']) ?>" required>
            </div>
            <div class="form-group">
                <label for="description">Описание / Текст</label>
                <textarea id="description" name="description" rows="5"><?= htmlspecialchars($track['description']) ?></textarea>
            </div>

            <div class="form-group">
                <label for="cover">Новая обложка (оставить пустым, чтобы не менять)</label>
                <input type="file" id="cover" name="cover" accept="image/jpeg, image/png">
                <div class="current-file">Текущий файл: <?= htmlspecialchars(basename($track['description'] ?? '')) ?></div>
            </div>

            <div class="form-group">
                <label for="fullTrack">Новый полный трек (оставить пустым, чтобы не менять)</label>
                <input type="file" id="fullTrack" name="fullTrack" accept=".mp3, .wav">
                <div class="current-file">Текущий файл: <?= htmlspecialchars(basename($track['description'] ?? '')) ?></div>
            </div>

            <button type="submit" class="submit-button">Сохранить изменения</button>
        </form>
    </div>
</body>
</html>