/* ========================================
   ФАЙЛ: assets/js/simple-theme-switcher.js
   КУДА: Замени свой старый файл на этот
   
   ОБНОВЛЕННАЯ ВЕРСИЯ - загружает фоны И CSS темы
   ✅ Фоны + цветовые стили вместе
   ✅ Меняет data-theme на body
   ✅ Загружает CSS файлы тем
   ======================================== */

(function() {
    'use strict';

    const STORAGE_KEY = 'site_bg_theme';
    
    // Темы с фонами И CSS файлами
    const BG_THEMES = {
        'default': {
            name: 'Default',
            icon: '🌙',
            bg: {
                color: '#0a0a0a',
                image: 'none'
            },
            css: null // Default без CSS темы
        },
        'power-metal': {
            name: 'Power Metal ⚔️',
            icon: '⚔️',
            bg: {
                color: '#0a0a0a',
                image: `
                    repeating-linear-gradient(90deg, transparent, transparent 2px, rgba(255, 215, 0, 0.03) 2px, rgba(255, 215, 0, 0.03) 4px),
                    radial-gradient(ellipse at 20% 50%, rgba(255, 165, 0, 0.15) 0%, transparent 50%),
                    radial-gradient(ellipse at 80% 80%, rgba(255, 215, 0, 0.1) 0%, transparent 50%),
                    linear-gradient(135deg, #0a0a0a 0%, #1a1410 50%, #0a0a0a 100%)
                `
            },
            css: '/assets/css/themes/power-metal/main.css',
            dataTheme: 'power-metal'
        },
        'gothic-metal': {
            name: 'Gothic Metal 🦇',
            icon: '🦇',
            bg: {
                color: '#0a0a0a',
                image: `
                    repeating-linear-gradient(0deg, transparent, transparent 3px, rgba(107, 44, 107, 0.05) 3px, rgba(107, 44, 107, 0.05) 6px),
                    repeating-linear-gradient(90deg, transparent, transparent 3px, rgba(217, 70, 239, 0.03) 3px, rgba(217, 70, 239, 0.03) 6px),
                    radial-gradient(ellipse 800px 400px at 10% 50%, rgba(217, 70, 239, 0.1) 0%, rgba(107, 44, 107, 0.05) 30%, transparent 70%),
                    radial-gradient(ellipse 600px 300px at 90% 30%, rgba(139, 0, 139, 0.08) 0%, transparent 60%),
                    linear-gradient(125deg, #0a0a0a 0%, #15091a 40%, #0a0a0a 100%)
                `
            },
            css: '/assets/css/themes/gothic-metal/main.css',
            dataTheme: 'gothic-metal'
        },
        'punk-rock': {
            name: 'Punk Rock 🤘',
            icon: '🤘',
            bg: {
                color: '#1a1a1a',
                image: `
                    repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(0, 255, 0, 0.04) 2px, rgba(0, 255, 0, 0.04) 4px),
                    repeating-linear-gradient(90deg, transparent, transparent 2px, rgba(255, 0, 255, 0.03) 2px, rgba(255, 0, 255, 0.03) 4px),
                    radial-gradient(ellipse 900px 450px at 15% 60%, rgba(0, 255, 0, 0.12) 0%, rgba(0, 255, 0, 0.05) 30%, transparent 70%),
                    radial-gradient(ellipse 800px 400px at 85% 40%, rgba(255, 0, 255, 0.1) 0%, transparent 60%),
                    radial-gradient(ellipse 600px 300px at 50% 90%, rgba(0, 255, 255, 0.08) 0%, transparent 50%),
                    linear-gradient(110deg, #1a1a1a 0%, #0d0d1a 50%, #1a1a1a 100%)
                `
            },
            css: '/assets/css/themes/punk-rock/main.css',
            dataTheme: 'punk-rock'
        },
        'literary-dark': {
            name: 'Literary Dark 📚',
            icon: '📚',
            bg: {
                color: '#1a1714',
                image: `
                    repeating-linear-gradient(90deg, transparent, transparent 1px, rgba(212, 165, 116, 0.02) 1px, rgba(212, 165, 116, 0.02) 2px),
                    repeating-linear-gradient(0deg, transparent, transparent 1px, rgba(139, 115, 85, 0.02) 1px, rgba(139, 115, 85, 0.02) 2px),
                    radial-gradient(ellipse 700px 400px at 15% 40%, rgba(212, 165, 116, 0.1) 0%, rgba(139, 115, 85, 0.05) 30%, transparent 70%),
                    radial-gradient(ellipse 600px 350px at 80% 60%, rgba(212, 165, 116, 0.08) 0%, transparent 60%),
                    linear-gradient(130deg, #1a1714 0%, #251f19 50%, #1a1714 100%)
                `
            },
            css: '/assets/css/themes/literary-dark/main.css',
            dataTheme: 'literary-dark'
        }
    };

    // Получить сохраненную тему
    function getSavedTheme() {
        return localStorage.getItem(STORAGE_KEY) || 'default';
    }

    // Загрузить CSS файл темы
    function loadThemeCSS(themeName) {
        const theme = BG_THEMES[themeName];
        if (!theme || !theme.css) {
            // Удаляем старый CSS если переходим на default
            const oldLink = document.querySelector('link[data-theme-css]');
            if (oldLink) oldLink.remove();
            return;
        }

        // Удаляем старый CSS если есть
        const oldLink = document.querySelector('link[data-theme-css]');
        if (oldLink) oldLink.remove();

        // Загружаем новый CSS
        const link = document.createElement('link');
        link.rel = 'stylesheet';
        link.href = theme.css;
        link.setAttribute('data-theme-css', 'true');
        document.head.appendChild(link);
    }

    // Применить тему (фон + стили)
    function applyBackground(themeName) {
        const theme = BG_THEMES[themeName];
        if (!theme) return;

        const body = document.body;
        
        // Применяем фон
        body.style.backgroundColor = theme.bg.color;
        body.style.backgroundImage = theme.bg.image;
        body.style.backgroundAttachment = 'fixed';
        body.style.backgroundSize = '100% 100%';
        body.style.backgroundPosition = '0 0';
        body.style.transition = 'background 0.5s ease';

        // Применяем data-theme для CSS стилей
        if (theme.dataTheme) {
            body.setAttribute('data-theme', theme.dataTheme);
            loadThemeCSS(themeName);
        } else {
            body.removeAttribute('data-theme');
            loadThemeCSS(themeName); // Удалит CSS если default
        }

        localStorage.setItem(STORAGE_KEY, themeName);
        console.log('Theme applied:', themeName);
    }

    // Создать кнопку и меню
    function createThemeSwitcher() {
        if (document.querySelector('.bg-theme-switcher')) return;

        // Контейнер
        const container = document.createElement('div');
        container.className = 'bg-theme-switcher';

        // Кнопка
        const button = document.createElement('button');
        button.className = 'bg-theme-btn';
        button.innerHTML = '🎨';
        button.title = 'Выбрать тему';

        // Меню
        const menu = document.createElement('div');
        menu.className = 'bg-theme-menu';

        let html = '';
        const currentTheme = getSavedTheme();
        
        for (const [key, theme] of Object.entries(BG_THEMES)) {
            const activeClass = key === currentTheme ? 'active' : '';
            html += `<button class="bg-menu-item ${activeClass}" data-theme="${key}" title="${theme.name}">${theme.icon} ${theme.name}</button>`;
        }
        
        menu.innerHTML = html;

        // Добавляем в контейнер
        container.appendChild(button);
        container.appendChild(menu);
        document.body.appendChild(container);

        // Стили
        addStyles();

        // Обработчики
        button.addEventListener('click', (e) => {
            e.stopPropagation();
            menu.classList.toggle('active');
        });

        menu.querySelectorAll('.bg-menu-item').forEach(item => {
            item.addEventListener('click', (e) => {
                e.stopPropagation();
                const themeName = item.dataset.theme;
                applyBackground(themeName);
                
                // Обновляем активный элемент
                menu.querySelectorAll('.bg-menu-item').forEach(i => i.classList.remove('active'));
                item.classList.add('active');
                
                // Закрываем меню
                menu.classList.remove('active');
            });
        });

        // Закрыть меню при клике снаружи
        document.addEventListener('click', () => {
            menu.classList.remove('active');
        });
    }

    // CSS для кнопки и меню
    function addStyles() {
        if (document.querySelector('style[data-bg-theme-switcher]')) return;

        const style = document.createElement('style');
        style.setAttribute('data-bg-theme-switcher', 'true');
        style.textContent = `
            .bg-theme-switcher {
                position: fixed;
                bottom: 20px;
                right: 20px;
                z-index: 9999;
            }

            .bg-theme-btn {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                border: none;
                background: rgba(0, 0, 0, 0.6);
                color: white;
                font-size: 1.5rem;
                cursor: pointer;
                transition: all 0.3s;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
                backdrop-filter: blur(5px);
            }

            .bg-theme-btn:hover {
                background: rgba(0, 0, 0, 0.8);
                transform: scale(1.1);
                box-shadow: 0 4px 20px rgba(255, 215, 0, 0.3);
            }

            .bg-theme-menu {
                position: absolute;
                bottom: 70px;
                right: 0;
                background: rgba(0, 0, 0, 0.9);
                border: 1px solid rgba(255, 215, 0, 0.3);
                border-radius: 8px;
                padding: 8px;
                display: none;
                flex-direction: column;
                gap: 4px;
                backdrop-filter: blur(10px);
                min-width: 180px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.7);
            }

            .bg-theme-menu.active {
                display: flex;
            }

            .bg-menu-item {
                padding: 10px 12px;
                background: transparent;
                border: 1px solid rgba(255, 215, 0, 0.2);
                color: #ccc;
                text-align: left;
                cursor: pointer;
                border-radius: 4px;
                transition: all 0.2s;
                font-size: 0.95rem;
            }

            .bg-menu-item:hover {
                background: rgba(255, 215, 0, 0.1);
                border-color: rgba(255, 215, 0, 0.5);
                color: #FFD700;
            }

            .bg-menu-item.active {
                background: rgba(255, 215, 0, 0.2);
                border-color: #FFD700;
                color: #FFD700;
                font-weight: bold;
            }

            @media (max-width: 768px) {
                .bg-theme-switcher {
                    bottom: 10px;
                    right: 10px;
                }

                .bg-theme-btn {
                    width: 45px;
                    height: 45px;
                    font-size: 1.2rem;
                }

                .bg-theme-menu {
                    bottom: 60px;
                }
            }
        `;
        document.head.appendChild(style);
    }

    // Инициализация
    function init() {
        // Применяем сохраненную тему
        applyBackground(getSavedTheme());
        
        // Создаем кнопку и меню
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', createThemeSwitcher);
        } else {
            createThemeSwitcher();
        }

        console.log('✅ Theme Switcher ready');
    }

    // Запуск
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();