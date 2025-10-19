<?php
// Файл: pages/post.php - ОБНОВЛЕННАЯ ВЕРСИЯ

// Подключаем шапку и конфиги
$page_css = '/assets/css/post.css';
require_once '../include_config/header.php';
require_once '../include_config/db_connect.php';

// Проверяем, что ID новости передан и является числом
if (!isset($_GET['id']) || !filter_var($_GET['id'], FILTER_VALIDATE_INT)) {
    header('Location: /index.php');
    exit;
}
$postId = (int)$_GET['id'];

// Ищем новость в базе по ее ID
$stmt = $pdo->prepare("SELECT * FROM Posts WHERE id = ?");
$stmt->execute([$postId]);
$post = $stmt->fetch();

// Если новость с таким ID не найдена
if (!$post) {
    // Используем нашу общую структуру для страницы с ошибкой
    echo "<div class='container page-content'><section><h2>Ошибка 404</h2><p>Новость не найдена.</p></section></div>";
    require_once '../include_config/footer.php';
    exit;
}
?>

<div class="punk-banner">
  <h1 style="text-shadow: 3px 3px #FF00FF, -2px -2px #00FFFF;">RAW ENERGY</h1>
</div>

<div class="container page-content">
    <article class="full-post">
        <h1><?= htmlspecialchars($post['title']) ?></h1>
        
        <p class="post-date"><?= date('d F Y', strtotime($post['createdAt'])) ?></p>
        
        <?php if (!empty($post['imageUrl'])): ?>
            <img class="post-image" src="/<?= htmlspecialchars(ltrim($post['imageUrl'], '/')) ?>" alt="<?= htmlspecialchars($post['title']) ?>">
        <?php endif; ?>

        <div class="post-content">
            <?= nl2br(htmlspecialchars($post['content'])) ?>
        </div>

        <a href="/" class="back-link">&laquo; Вернуться на главную</a>
    </article>
</div>

<?php
// Подключаем подвал сайта
require_once '../include_config/footer.php';
?>