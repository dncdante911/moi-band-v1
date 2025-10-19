<?php
/**
 * Файл: include_config/footer.php
 * Закрывающая часть HTML и подключение скриптов
 */
?>

    </main>

    <!-- === ПОДВАЛ САЙТА === -->
    <footer class="site-footer">
        <div class="container">
            <p>&copy; 2024-2025 Master of Illusion. Все права защищены.</p>
            <p style="font-size: 0.9rem; color: #aaa;">
                Музыкальный проект, созданный с помощью AI | 
                <a href="/pages/about.php" style="color: #FFD700;">О проекте</a>
            </p>
        </div>
    </footer>

    <!-- === СКРИПТЫ === -->
    
    <!-- Particles.js инициализация -->
    <script src="/assets/js/main.js"></script>
    
    <!-- Мобильное меню -->
    <script src="/assets/js/mobile-menu.js"></script>
    
    <!-- Chat (если нужен) -->
    <?php if (isset($_SESSION['user_id'])): ?>
        <script src="/assets/js/chat.js"></script>
    <?php endif; ?>

</body>
</html>