<?php
/**
 * Файл: admin/edit_track.php
 * ИСПРАВЛЕННАЯ ВЕРСИЯ - редактирование трека с текстом и видео
 */

require_once '../include_config/config.php';
require_once '../include_config/db_connect.php';

// Получаем список альбомов
$stmt_albums = $pdo->query("SELECT id, title FROM Albums ORDER BY title ASC");
$albums = $stmt_albums->fetchAll();

// Проверяем ID трека
if (!isset($_GET['id']) || !filter_var($_GET['id'], FILTER_VALIDATE_INT)) {
    header('Location: index.php');
    exit;
}
$trackId = (int)$_GET['id'];

// === ОБРАБОТКА POST ЗАПРОСА ===
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $title = trim($_POST['title'] ?? '');
    $description = trim($_POST['description'] ?? '');
    $albumId = filter_var($_POST['albumId'] ?? '', FILTER_VALIDATE_INT);
    $lyrics = trim($_POST['lyrics'] ?? '');
    $errors = [];
    
    // Валидация
    if (empty($title)) {
        $errors[] = 'Название не может быть пустым';
    }
    
    if (empty($errors)) {
        try {
            // Получаем текущие данные
            $stmt = $pdo->prepare("SELECT * FROM Track WHERE id = ?");
            $stmt->execute([$trackId]);
            $currentTrack = $stmt->fetch();
            
            if (!$currentTrack) {
                $errors[] = 'Трек не найден';
            } else {
                // Функция для сохранения файла
                function saveFile($file, $subfolder) {
                    if (empty($file['name']) || $file['error'] !== UPLOAD_ERR_OK) {
                        return null;
                    }
                    
                    $uploadDir = '../public/uploads/' . $subfolder . '/';
                    if (!is_dir($uploadDir)) {
                        mkdir($uploadDir, 0755, true);
                    }
                    
                    $fileExtension = pathinfo($file['name'], PATHINFO_EXTENSION);
                    $fileName = uniqid() . '.' . $fileExtension;
                    $uploadPath = $uploadDir . $fileName;
                    
                    if (move_uploaded_file($file['tmp_name'], $uploadPath)) {
                        return '/public/uploads/' . $subfolder . '/' . $fileName;
                    }
                    return false;
                }
                
                // Обновляем файлы если загружены
                $coverPath = $currentTrack['coverImagePath'];
                if (!empty($_FILES['cover']['name'])) {
                    $newCoverPath = saveFile($_FILES['cover'], 'covers');
                    if ($newCoverPath) {
                        @unlink('..' . $coverPath);
                        $coverPath = $newCoverPath;
                    }
                }
                
                $fullTrackPath = $currentTrack['fullAudioPath'];
                if (!empty($_FILES['fullTrack']['name'])) {
                    $newFullTrackPath = saveFile($_FILES['fullTrack'], 'full');
                    if ($newFullTrackPath) {
                        @unlink('..' . $fullTrackPath);
                        $fullTrackPath = $newFullTrackPath;
                    }
                }
                
                $videoPath = $currentTrack['videoPath'];
                if (!empty($_FILES['video']['name'])) {
                    $newVideoPath = saveFile($_FILES['video'], 'videos');
                    if ($newVideoPath) {
                        if ($videoPath) @unlink('..' . $videoPath);
                        $videoPath = $newVideoPath;
                    }
                }
                
                // Обновляем основной трек
                $sql = "UPDATE Track SET 
                    title = :title, 
                    description = :description, 
                    albumId = :albumId,
                    coverImagePath = :coverImagePath, 
                    fullAudioPath = :fullAudioPath,
                    videoPath = :videoPath
                WHERE id = :id";
                
                $stmt = $pdo->prepare($sql);
                $result = $stmt->execute([
                    ':title' => $title,
                    ':description' => $description,
                    ':albumId' => $albumId ?: null,
                    ':coverImagePath' => $coverPath,
                    ':fullAudioPath' => $fullTrackPath,
                    ':videoPath' => $videoPath,
                    ':id' => $trackId
                ]);
                
                if (!$result) {
                    $errors[] = 'Ошибка при обновлении трека';
                } else {
                    // Сохраняем текст песни отдельно
                    if (!empty($lyrics)) {
                        $stmt = $pdo->prepare("
                            INSERT INTO SongLyrics (track_id, lyrics)
                            VALUES (:track_id, :lyrics)
                            ON DUPLICATE KEY UPDATE lyrics = VALUES(lyrics)
                        ");
                        $stmt->execute([
                            ':track_id' => $trackId,
                            ':lyrics' => $lyrics
                        ]);
                    }
                    
                    // Успешное обновление
                    header('Location: index.php?success=1');
                    exit;
                }
            }
        } catch (Exception $e) {
            $errors[] = 'Ошибка БД: ' . $e->getMessage();
        }
    }
}

// === ЗАГРУЗКА ДАННЫХ ТРЕКА ===
$stmt = $pdo->prepare("SELECT t.*, sl.lyrics FROM Track t 
                       LEFT JOIN SongLyrics sl ON t.id = sl.track_id 
                       WHERE t.id = ?");
$stmt->execute([$trackId]);
$track = $stmt->fetch();

if (!$track) {
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
        .form-container { max-width: 900px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: bold; color: #FFD700; }
        .form-group input, .form-group textarea, .form-group select { 
            width: 100%; 
            padding: 10px; 
            background-color: #111; 
            border: 1px solid #FFD700; 
            color: #e0e0e0; 
            border-radius: 4px; 
            box-sizing: border-box;
            font-family: inherit;
        }
        .form-group textarea { resize: vertical; min-height: 100px; }
        .form-group input[type="file"] { padding: 5px; border: 2px dashed #FFD700; }
        .submit-button { 
            padding: 12px 30px; 
            background-color: #2b6cb0; 
            color: #fff; 
            border: none; 
            border-radius: 4px; 
            font-size: 1rem; 
            cursor: pointer;
            font-weight: bold;
        }
        .submit-button:hover { background-color: #3182ce; }
        .errors { 
            background-color: #c53030; 
            color: #fff; 
            padding: 15px; 
            border-radius: 4px; 
            margin-bottom: 20px;
        }
        .error-item { margin: 5px 0; }
        .current-file { 
            font-size: 0.85rem; 
            color: #a0aec0; 
            margin-top: 8px;
            padding: 10px;
            background: rgba(255,215,0,0.1);
            border-left: 3px solid #FFD700;
        }
        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            border-bottom: 2px solid #FFD700;
        }
        .tab-btn {
            padding: 10px 20px;
            background: transparent;
            border: none;
            color: #aaa;
            cursor: pointer;
            font-weight: bold;
            border-bottom: 3px solid transparent;
            transition: all 0.3s;
        }
        .tab-btn.active {
            color: #FFD700;
            border-bottom-color: #FFD700;
        }
        .tab-content { display: none; }
        .tab-content.active { display: block; }
    </style>
</head>
<body>
    <div class="container form-container">
        <div class="breadcrumbs">
            <a href="index.php">Управление треками</a> &raquo;
            <span>Редактировать трек</span>
        </div>
        
        <h1>✏️ Редактировать трек: <?= htmlspecialchars($track['title']) ?></h1>
        
        <?php if (!empty($errors)): ?>
            <div class="errors">
                <strong>❌ Ошибки:</strong>
                <?php foreach ($errors as $error): ?>
                    <div class="error-item">• <?= htmlspecialchars($error) ?></div>
                <?php endforeach; ?>
            </div>
        <?php endif; ?>
        
        <!-- Табы -->
        <div class="tabs">
            <button class="tab-btn active" onclick="showTab('basic')">📝 Основное</button>
            <button class="tab-btn" onclick="showTab('files')">📁 Файлы</button>
            <button class="tab-btn" onclick="showTab('lyrics')">📄 Текст</button>
            <button class="tab-btn" onclick="showTab('video')">🎬 Видео</button>
        </div>
        
        <form action="edit_track.php?id=<?= $trackId ?>" method="POST" enctype="multipart/form-data">
            
            <!-- ТАБ 1: Основное -->
            <div id="basic" class="tab-content active">
                <div class="form-group">
                    <label for="albumId">Альбом</label>
                    <select id="albumId" name="albumId">
                        <option value="">-- Без альбома --</option>
                        <?php foreach ($albums as $album): ?>
                            <option value="<?= $album['id'] ?>" 
                                <?= ($track['albumId'] == $album['id']) ? 'selected' : '' ?>>
                                <?= htmlspecialchars($album['title']) ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="title">Название трека *</label>
                    <input type="text" id="title" name="title" 
                        value="<?= htmlspecialchars($track['title']) ?>" required>
                </div>
                
                <div class="form-group">
                    <label for="description">Описание / Краткая информация</label>
                    <textarea id="description" name="description" rows="4">
<?= htmlspecialchars($track['description']) ?></textarea>
                </div>
            </div>
            
            <!-- ТАБ 2: Файлы (обложка и аудио) -->
            <div id="files" class="tab-content">
                <div class="form-group">
                    <label for="cover">Обложка трека (JPG, PNG)</label>
                    <input type="file" id="cover" name="cover" accept="image/jpeg, image/png">
                    <div class="current-file">
                        📷 Текущая обложка: 
                        <img src="/<?= htmlspecialchars(ltrim($track['coverImagePath'], '/')) ?>" 
                            alt="Обложка" style="max-width: 100px; margin-top: 5px;">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="fullTrack">Аудиофайл трека (MP3, WAV)</label>
                    <input type="file" id="fullTrack" name="fullTrack" accept=".mp3, .wav">
                    <div class="current-file">
                        🎵 Текущий файл: <?= htmlspecialchars(basename($track['fullAudioPath'])) ?>
                    </div>
                </div>
            </div>
            
            <!-- ТАБ 3: Текст песни -->
            <div id="lyrics" class="tab-content">
                <div class="form-group">
                    <label for="lyrics">Текст песни</label>
                    <textarea id="lyrics" name="lyrics" rows="15" 
                        placeholder="Введите текст песни построчно...">
<?= htmlspecialchars($track['lyrics'] ?? '') ?></textarea>
                    <div class="current-file" style="margin-top: 15px;">
                        💡 Совет: Каждая строка на новой строке. 
                        Опционально добавьте время синхронизации: [00:12.00]Текст
                    </div>
                </div>
            </div>
            
            <!-- ТАБ 4: Видео -->
            <div id="video" class="tab-content">
                <div class="form-group">
                    <label for="video">Видеоклип (MP4, WebM)</label>
                    <input type="file" id="video" name="video" accept=".mp4, .webm">
                    <div class="current-file">
                        🎬 <?php if ($track['videoPath']): ?>
                            Текущее видео: <?= htmlspecialchars(basename($track['videoPath'])) ?>
                        <?php else: ?>
                            ❌ Видео не загружено
                        <?php endif; ?>
                    </div>
                </div>
                
                <div class="current-file" style="margin-top: 15px; background: rgba(100,200,255,0.1); border-left-color: #4169E1;">
                    📝 Для чего: 
                    <ul style="margin: 10px 0 0 20px; color: #a0aec0;">
                        <li>🎵 Клипы (музыкальные видео)</li>
                        <li>🎤 Минусовки для караоке</li>
                        <li>🎬 Концертные записи</li>
                    </ul>
                </div>
            </div>
            
            <button type="submit" class="submit-button">💾 Сохранить изменения</button>
        </form>
    </div>
    
    <script>
    function showTab(tabName) {
        // Скрыть все табы
        const contents = document.querySelectorAll('.tab-content');
        contents.forEach(c => c.classList.remove('active'));
        
        // Убрать активность с кнопок
        const buttons = document.querySelectorAll('.tab-btn');
        buttons.forEach(b => b.classList.remove('active'));
        
        // Показать нужный таб
        document.getElementById(tabName).classList.add('active');
        event.target.classList.add('active');
    }
    </script>
</body>
</html>