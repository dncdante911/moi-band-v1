<?php
// Файл: admin/add_track.php - ПОЛНАЯ ВЕРСИЯ

require_once '../include_config/config.php';
require_once '../include_config/db_connect.php';

// Получаем список всех альбомов для выпадающего меню
$stmt_albums = $pdo->query("SELECT id, title FROM Albums ORDER BY title ASC");
$albums = $stmt_albums->fetchAll();

$errors = [];
// Переменные для сохранения введенных данных в случае ошибки
$title = '';
$description = '';
$price = '';
$albumId_selected = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $title = trim($_POST['title'] ?? '');
    $description = trim($_POST['description'] ?? '');
    $albumId = filter_var($_POST['albumId'], FILTER_VALIDATE_INT);
    $albumId_selected = $albumId; // Сохраняем выбор для формы

    if (empty($title)) $errors[] = 'Название трека обязательно для заполнения.';
    if (empty($_FILES['cover']['name']) || $_FILES['cover']['error'] !== UPLOAD_ERR_OK) $errors[] = 'Ошибка загрузки обложки.';
      if (empty($_FILES['fullTrack']['name']) || $_FILES['fullTrack']['error'] !== UPLOAD_ERR_OK) $errors[] = 'Ошибка загрузки полного трека.';

    if (empty($errors)) {
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

        $coverPath = saveFile($_FILES['cover'], 'covers');
        $fullTrackPath = saveFile($_FILES['fullTrack'], 'full');

        if ($coverPath && $snippetPath && $fullTrackPath) {
            $sql = "INSERT INTO Track (title, description, albumId, coverImagePath, fullAudioPath) 
                    VALUES (:title, :description, :albumId, :coverImagePath, :fullAudioPath)";
            $stmt = $pdo->prepare($sql);
            $stmt->execute([
                ':title' => $title,
                ':description' => $description,
                ':albumId' => $albumId ?: null,
                ':coverImagePath' => $coverPath,
                ':fullAudioPath' => $fullTrackPath
            ]);
            header('Location: index.php');
            exit;
        } else {
            $errors[] = 'Не удалось сохранить один из файлов.';
        }
    }
}
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Добавить трек - Админ-панель</title>
    <link rel="stylesheet" href="../assets/css/admin_style.css">
</head>
<body>
    <div class="container form-container">
        <div class="breadcrumbs">
            <a href="index.php">Управление треками</a> &raquo;
            <span>Добавить трек</span>
        </div>
        <h1>Добавить новый трек</h1>

        <?php if (!empty($errors)): ?>
            <div class="errors">
                <ul><?php foreach ($errors as $error) echo "<li>" . htmlspecialchars($error) . "</li>"; ?></ul>
            </div>
        <?php endif; ?>

        <form action="add_track.php" method="POST" enctype="multipart/form-data">
            <div class="form-group">
                <label for="albumId">Альбом (необязательно)</label>
                <select id="albumId" name="albumId">
                    <option value="">-- Без альбома --</option>
                    <?php foreach ($albums as $album): ?>
                        <option value="<?= $album['id'] ?>" <?= ($albumId_selected == $album['id']) ? 'selected' : '' ?>>
                            <?= htmlspecialchars($album['title']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div class="form-group">
                <label for="title">Название трека</label>
                <input type="text" id="title" name="title" value="<?= htmlspecialchars($title) ?>" required>
            </div>
            <div class="form-group">
                <label for="description">Описание / Текст</label>
                <textarea id="description" name="description" rows="5"><?= htmlspecialchars($description) ?></textarea>
            </div>

            <div class="form-group">
                <label for="cover">Файл обложки (JPG, PNG)</label>
                <input type="file" id="cover" name="cover" accept="image/jpeg, image/png" required>
            </div>

            <div class="form-group">
                <label for="fullTrack">Полный трек (MP3, WAV)</label>
                <input type="file" id="fullTrack" name="fullTrack" accept=".mp3, .wav" required>
            </div>
            <button type="submit" class="submit-button">Сохранить трек</button>
        </form>
    </div>
</body>
</html>