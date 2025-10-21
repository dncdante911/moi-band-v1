<?php 
/**
 * Файл: include_config/header.php
 * ИСПРАВЛЕННАЯ ВЕРСИЯ с мобильной поддержкой
 */

require_once __DIR__ . '/config.php'; 
?>
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= htmlspecialchars(SITE_NAME) ?></title>
    
    <!-- 🎸 ЗАГРУЗЧИК ТЕМ - ПОДКЛЮЧИТЬ ПЕРВЫМ В <head> -->
    <script src="/assets/js/theme-loader.js"></script>
    
    <!-- === БАЗОВЫЕ СТИЛИ === -->
    <link rel="stylesheet" href="/assets/css/main.css">
    
    <!-- === ОСТАЛЬНЫЕ СТИЛИ === -->
    <link rel="stylesheet" href="/assets/css/auth.css">
    <link rel="stylesheet" href="/assets/css/chat.css">
    <link rel="stylesheet" href="/assets/css/responsive.css">
    
    <!-- Шрифты Google -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel+Decorative:wght@700&family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    
    <!-- Particles.js -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/particles.js/2.0.0/particles.min.js"></script>
    
    <style>
        /* Быстрые исправления для всех устройств */
        * {
            box-sizing: border-box;
        }
        
        html, body {
            width: 100%;
            overflow-x: hidden;
        }
        
        /* Плавный скролл */
        html {
            scroll-behavior: smooth;
        }
    </style>
    
    <!-- 
  Файл: Добавить в include_config/header.php
  
  Вставить ДО закрытия </head> или в шапке сайта
  Это компонент переключателя тем
-->

<!-- === ПЕРЕКЛЮЧАТЕЛЬ ТЕМ === -->
<div class="theme-switcher-widget">
    <button class="theme-toggle-btn" id="theme-toggle" title="Переключить тему" aria-label="Меню тем">
        🎨 Тема
    </button>
    
    <!-- Выпадающее меню тем -->
    <div class="theme-menu" id="theme-menu">
        <div class="theme-menu-header">
            <h4>🎨 Выберите тему</h4>
            <button class="theme-menu-close" id="theme-menu-close" aria-label="Закрыть">×</button>
        </div>
        
        <div class="theme-options">
            <!-- Power Metal -->
            <label class="theme-option">
                <input type="radio" name="theme" value="power-metal" id="theme-switcher" class="theme-radio">
                <div class="theme-option-content">
                    <span class="theme-icon">⚔️</span>
                    <div class="theme-info">
                        <span class="theme-name">Power Metal</span>
                        <span class="theme-desc">Эпический дизайн</span>
                    </div>
                </div>
            </label>
            
            <!-- Gothic Metal -->
            <label class="theme-option">
                <input type="radio" name="theme" value="gothic-metal" class="theme-radio">
                <div class="theme-option-content">
                    <span class="theme-icon">🦇</span>
                    <div class="theme-info">
                        <span class="theme-name">Gothic Metal</span>
                        <span class="theme-desc">Мрачный стиль</span>
                    </div>
                </div>
            </label>
            
            <!-- Punk Rock -->
            <label class="theme-option">
                <input type="radio" name="theme" value="punk-rock" class="theme-radio">
                <div class="theme-option-content">
                    <span class="theme-icon">🤘</span>
                    <div class="theme-info">
                        <span class="theme-name">Punk Rock</span>
                        <span class="theme-desc">Энергичный стиль</span>
                    </div>
                </div>
            </label>
            
            <!-- Literary Dark -->
            <label class="theme-option">
                <input type="radio" name="theme" value="literary-dark" class="theme-radio">
                <div class="theme-option-content">
                    <span class="theme-icon">📚</span>
                    <div class="theme-info">
                        <span class="theme-name">Literary Dark</span>
                        <span class="theme-desc">Классический стиль</span>
                    </div>
                </div>
            </label>
        </div>
    </div>
</div>

<!-- === СТИЛИ ДЛЯ ПЕРЕКЛЮЧАТЕЛЯ === -->
<style>
/* Контейнер */
.theme-switcher-widget {
    position: fixed;
    bottom: 30px;
    right: 30px;
    z-index: 1000;
    font-family: 'Roboto', sans-serif;
}

/* Кнопка переключателя */
.theme-toggle-btn {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    border: 2px solid #FFD700;
    background: linear-gradient(135deg, rgba(15,15,25,0.9) 0%, rgba(20,20,35,0.9) 100%);
    color: #FFD700;
    font-size: 1.3rem;
    font-weight: bold;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s;
    box-shadow: 0 0 20px rgba(255,215,0,0.3);
}

.theme-toggle-btn:hover {
    background: linear-gradient(135deg, rgba(255,215,0,0.1) 0%, rgba(255,215,0,0.05) 100%);
    box-shadow: 0 0 40px rgba(255,215,0,0.6);
    transform: scale(1.1);
}

/* Меню тем */
.theme-menu {
    position: absolute;
    bottom: 80px;
    right: 0;
    background: rgba(10,10,15,0.98);
    border: 2px solid #FFD700;
    border-radius: 12px;
    padding: 15px;
    min-width: 280px;
    box-shadow: 0 10px 50px rgba(0,0,0,0.8);
    opacity: 0;
    visibility: hidden;
    transform: translateY(10px);
    transition: all 0.3s;
    backdrop-filter: blur(10px);
}

.theme-menu.active {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
}

/* Заголовок меню */
.theme-menu-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
    padding-bottom: 10px;
    border-bottom: 1px solid rgba(255,215,0,0.2);
}

.theme-menu-header h4 {
    margin: 0;
    color: #FFD700;
    font-size: 1rem;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.theme-menu-close {
    background: none;
    border: none;
    color: #FFD700;
    font-size: 1.5rem;
    cursor: pointer;
    transition: all 0.2s;
}

.theme-menu-close:hover {
    color: #FFE135;
    transform: scale(1.2);
}

/* Опции тем */
.theme-options {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.theme-option {
    display: flex;
    align-items: center;
    padding: 12px;
    background: rgba(255,215,0,0.05);
    border: 1px solid rgba(255,215,0,0.2);
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.3s;
}

.theme-option:hover {
    background: rgba(255,215,0,0.15);
    border-color: #FFD700;
}

.theme-radio {
    display: none;
}

.theme-radio:checked + .theme-option-content {
    color: #FFE135;
}

.theme-option-content {
    display: flex;
    align-items: center;
    gap: 12px;
    color: #ddd;
    transition: all 0.3s;
    width: 100%;
}

.theme-icon {
    font-size: 1.5rem;
    min-width: 30px;
    text-align: center;
}

.theme-info {
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.theme-name {
    font-weight: bold;
    font-size: 0.95rem;
}

.theme-desc {
    font-size: 0.8rem;
    color: #999;
}

/* Адаптивность */
@media (max-width: 768px) {
    .theme-switcher-widget {
        bottom: 20px;
        right: 20px;
    }
    
    .theme-toggle-btn {
        width: 50px;
        height: 50px;
        font-size: 1.1rem;
    }
    
    .theme-menu {
        min-width: 250px;
        bottom: 70px;
    }
}

@media (max-width: 480px) {
    .theme-switcher-widget {
        bottom: 15px;
        right: 15px;
    }
    
    .theme-toggle-btn {
        width: 45px;
        height: 45px;
        font-size: 1rem;
    }
    
    .theme-menu {
        min-width: 220px;
        bottom: 60px;
        right: -10px;
    }
}
</style>

<!-- === СКРИПТ ДЛЯ ПЕРЕКЛЮЧАТЕЛЯ === -->
<script>
document.addEventListener('DOMContentLoaded', () => {
    const toggleBtn = document.getElementById('theme-toggle');
    const menu = document.getElementById('theme-menu');
    const closeBtn = document.getElementById('theme-menu-close');
    const themeRadios = document.querySelectorAll('.theme-radio');
    
    // Открыть/закрыть меню
    if (toggleBtn) {
        toggleBtn.addEventListener('click', () => {
            menu.classList.toggle('active');
        });
    }
    
    // Закрыть меню по кнопке
    if (closeBtn) {
        closeBtn.addEventListener('click', () => {
            menu.classList.remove('active');
        });
    }
    
    // Изменение темы
    themeRadios.forEach(radio => {
        radio.addEventListener('change', (e) => {
            if (window.themeManager) {
                window.themeManager.setTheme(e.target.value);
                
                // Закрыть меню после выбора
                setTimeout(() => {
                    menu.classList.remove('active');
                }, 300);
            }
        });
    });
    
    // Закрыть меню при клике вне его
    document.addEventListener('click', (e) => {
        if (!e.target.closest('.theme-switcher-widget')) {
            menu.classList.remove('active');
        }
    });
    
    // Обновляем селектор при смене темы через другие способы
    window.addEventListener('themeChanged', (e) => {
        const radio = document.querySelector(`input[value="${e.detail.theme}"]`);
        if (radio) {
            radio.checked = true;
        }
    });
});
</script>
    
</head>
<body>
    <!-- === ФОНОВЫЕ ЭЛЕМЕНТЫ === -->
    <div id="particles-js"></div>
    <video autoplay muted loop id="background-video" style="display: none;">
        <source src="/assets/videos/background_video.mp4" type="video/mp4">
    </video>

    <!-- === ШАПКА САЙТА === -->
    <header class="site-header">
        <div class="container header-container">
            <div class="logo">
                <a href="/"><?= htmlspecialchars(SITE_NAME) ?></a>
            </div>
            
            <!-- Бургер меню для мобильных -->
            <button class="hamburger-menu" id="hamburger" aria-label="Открыть меню" aria-expanded="false">☰</button>
            
            <!-- Навигация -->
            <nav class="main-nav" id="mainNav" aria-label="Главная навигация">
                <ul>
                    <li><a href="/">🏠 Главная</a></li>
                    <li><a href="/pages/albums.php">📀 Альбомы</a></li>
                    <li><a href="/pages/about.php">ℹ️ О проекте</a></li>
                    <li><a href="/pages/news.php">📰 Новости</a></li>
                    <li><a href="/pages/gallery.php">🖼️ Галерея</a></li>
                    <li><a href="/pages/contact.php">✉️ Контакты</a></li>
                    
                    <?php 
                    // Проверяем авторизацию
                    if (isset($_SESSION['user_id'])): 
                    ?>
                        <li><a href="/pages/chat.php">💬 Чат</a></li>
                        <li><a href="/pages/auth/profile.php">👤 Профиль</a></li>
                        <li><a href="/pages/auth/logout.php">🚪 Выход</a></li>
                    <?php else: ?>
                        <li><a href="/pages/auth/login.php">🔐 Вход</a></li>
                        <li><a href="/pages/auth/register.php">✍️ Регистрация</a></li>
                    <?php endif; ?>
                </ul>
            </nav>
        </div>
    </header>
<script src="/assets/js/themes/theme-manager.js"></script>
    <!-- === ОСНОВНОЙ КОНТЕНТ === -->
    <main class="main-content">