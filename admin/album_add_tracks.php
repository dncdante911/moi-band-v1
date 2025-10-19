<?php
// Файл: admin/album_add_tracks.php - ФИНАЛЬНАЯ ВЕРСИЯ

require_once '../include_config/config.php';
require_once '../include_config/db_connect.php';

// Проверяем, что ID альбома передан
if (!isset($_GET['album_id']) || !filter_var($_GET['album_id'], FILTER_VALIDATE_INT)) {
    header('Location: albums_list.php');
    exit;
}
$albumId = (int)$_GET['album_id'];

// ИЗМЕНЕНИЕ: Получаем не только название, но и ПУТЬ К ОБЛОЖКЕ альбома
$stmt = $pdo->prepare("SELECT title, coverImagePath FROM Albums WHERE id = ?");
$stmt->execute([$albumId]);
$album = $stmt->fetch();
if (!$album) {
    header('Location: albums_list.php');
    exit;
}
// Сохраняем путь к обложке в переменную
$albumCoverPath = $album['coverImagePath'];

// Обрабатываем отправку формы
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_FILES['tracks'])) {
        $uploadDirFull = '../public/uploads/full/';
        if (!is_dir($uploadDirFull)) mkdir($uploadDirFull, 0755, true);

        // Убираем лишние поля из запроса
        $sql = "INSERT INTO Track (title, albumId, coverImagePath, fullAudioPath) 
                VALUES (:title, :albumId, :coverImagePath, :fullAudioPath)";
        $stmt = $pdo->prepare($sql);

        // Перебираем каждый загруженный файл
        foreach ($_FILES['tracks']['name'] as $key => $name) {
            if ($_FILES['tracks']['error'][$key] === UPLOAD_ERR_OK) {
                
                $tmp_name = $_FILES['tracks']['tmp_name'][$key];
                $fileExtension = pathinfo($name, PATHINFO_EXTENSION);
                $fileName = uniqid() . '.' . $fileExtension;
                $uploadPath = $uploadDirFull . $fileName;

                if (move_uploaded_file($tmp_name, $uploadPath)) {
                    $trackTitle = pathinfo($name, PATHINFO_FILENAME);
                    
                    $stmt->execute([
                        ':title' => $trackTitle,
                        ':albumId' => $albumId,
                        // ИЗМЕНЕНИЕ: Используем настоящую обложку альбома
                        ':coverImagePath' => $albumCoverPath, 
                        ':fullAudioPath' => '/public/uploads/full/' . $fileName
                    ]);
                }
            }
        }
        // После загрузки всех треков, перенаправляем на страницу просмотра альбома
        header('Location: album_view.php?id=' . $albumId);
        exit;
    }
}
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Добавить треки в альбом - Админ-панель</title>
    <link rel="stylesheet" href="../assets/css/admin_style.css">
</head>
<body>
    <div class="container form-container">
        <div class="breadcrumbs">
            <a href="albums_list.php">Управление альбомами</a> &raquo;
            <a href="album_view.php?id=<?= $albumId ?>"><?= htmlspecialchars($album['title']) ?></a> &raquo;
            <span>Массовая загрузка треков</span>
        </div>

        <h1>Добавить треки в альбом: "<?= htmlspecialchars($album['title']) ?>"</h1>
        <p>Вы можете выбрать несколько файлов одновременно, зажав клавишу Ctrl (или Cmd на Mac) при выборе.</p>

        <form action="album_add_tracks.php?album_id=<?= $albumId ?>" method="POST" enctype="multipart/form-data">
            <div class="form-group">
                <label for="tracks">Выберите файлы треков (MP3, WAV)</label>
                <input type="file" id="tracks" name="tracks[]" accept=".mp3, .wav" required multiple>
            </div>
            <button type="submit" class="submit-button">Загрузить треки</button>
        </form>
    </div>
</body>
</html>