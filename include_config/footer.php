<?php 
/**
 * ФАЙЛ: include_config/footer.php
 * АВАРИЙНАЯ ВЕРСИЯ - просто закрытие тегов
 * БЕЗ системы тем
 */
?>
    </main>

    <!-- === ПОДВАЛ САЙТА === -->
    <footer class="site-footer">
        <div class="container">
            <p>&copy; 2024 <strong><?= htmlspecialchars(SITE_NAME) ?></strong> — Музыкальный проект</p>
            <p>
                <a href="/pages/contact.php">Контакты</a> • 
                <a href="mailto:<?= htmlspecialchars(SITE_EMAIL) ?>">Email</a>
            </p>
        </div>
    </footer>

    <!-- === ОСТАЛЬНЫЕ СКРИПТЫ === -->
    <script>
    // Обработка бургер-меню
    document.addEventListener('DOMContentLoaded', function() {
        const hamburger = document.getElementById('hamburger');
        const mainNav = document.getElementById('mainNav');
        
        if (hamburger && mainNav) {
            hamburger.addEventListener('click', function() {
                mainNav.classList.toggle('active');
                this.setAttribute('aria-expanded', mainNav.classList.contains('active'));
            });
            
            // Закрыть меню при клике на ссылку
            const navLinks = mainNav.querySelectorAll('a');
            navLinks.forEach(link => {
                link.addEventListener('click', function() {
                    mainNav.classList.remove('active');
                    hamburger.setAttribute('aria-expanded', 'false');
                });
            });
        }
    });
    </script>
    <script src="/assets/js/theme-manager-pro.js"></script>
    
</body>
</html>