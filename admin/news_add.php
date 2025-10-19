<?php
// Файл: admin/news_add.php

require_once '../include_config/config.php';
require_once '../include_config/db_connect.php';

$errors = [];
$title = '';
$content = '';

// Обрабатываем отправку формы
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $title = trim($_POST['title'] ?? '');
    $content = trim($_POST['content'] ?? '');
    $imageUrl = null;

    // Валидация
    if (empty($title)) {
        $errors[] = 'Заголовок не может быть пустым.';
    }
    if (empty($content)) {
        $errors[] = 'Текст новости не может быть пустым.';
    }

    // Обработка загрузки изображения, если оно есть
    if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
        $uploadDir = '../public/uploads/posts/';
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0755, true);
        }
        $fileExtension = pathinfo($_FILES['image']['name'], PATHINFO_EXTENSION);
        $fileName = uniqid() . '.' . $fileExtension;
        $uploadPath = $uploadDir . $fileName;

        if (move_uploaded_file($_FILES['image']['tmp_name'], $uploadPath)) {
            $imageUrl = '/public/uploads/posts/' . $fileName;
        } else {
            $errors[] = 'Не удалось загрузить изображение.';
        }
    }

    // Если ошибок нет, сохраняем в базу
    if (empty($errors)) {
        $sql = "INSERT INTO Posts (title, content, imageUrl) VALUES (:title, :content, :imageUrl)";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            ':title' => $title,
            ':content' => $content,
            ':imageUrl' => $imageUrl
        ]);

        header('Location: news_list.php');
        exit;
    }
}
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Добавить новость - Админ-панель</title>
    <link rel="stylesheet" href="../assets/css/admin_style.css">
    <style>
        /* Стили для формы (аналогично форме треков) */
        .form-container { max-width: 800px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input, .form-group textarea {
            width: 100%;
            padding: 10px;
            background-color: #4a5568;
            border: 1px solid #718096;
            color: #e2e8f0;
            border-radius: 5px;
            box-sizing: border-box;
        }
        .form-group input[type="file"] { padding: 5px; }
        .submit-button {
            padding: 12px 25px;
            background-color: #2b6cb0;
            color: #ffffff;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .submit-button:hover { background-color: #3182ce; }
        .errors {
            background-color: #c53030;
            color: #ffffff;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container form-container">
        <div class="breadcrumbs">
            <a href="index.php">Управление треками</a> &raquo;
            <a href="news_list.php">Управление новостями</a> &raquo;
            <span>Добавить новость</span>
        </div>

        <h1>Добавить новую новость</h1>

        <?php if (!empty($errors)): ?>
            <div class="errors">
                <strong>Обнаружены ошибки:</strong>
                <ul>
                    <?php foreach ($errors as $error): ?>
                        <li><?= htmlspecialchars($error) ?></li>
                    <?php endforeach; ?>
                </ul>
            </div>
        <?php endif; ?>

        <form action="news_add.php" method="POST" enctype="multipart/form-data">
            <div class="form-group">
                <label for="title">Заголовок новости</label>
                <input type="text" id="title" name="title" value="<?= htmlspecialchars($title) ?>" required>
            </div>
            <div class="form-group">
                <label for="content">Текст новости</label>
                <textarea id="content" name="content" rows="10" required><?= htmlspecialchars($content) ?></textarea>
            </div>
            <div class="form-group">
                <label for="image">Изображение (необязательно)</label>
                <input type="file" id="image" name="image" accept="image/jpeg, image/png, image/gif">
            </div>
            <button type="submit" class="submit-button">Опубликовать новость</button>
        </form>
    </div>
</body>
</html>