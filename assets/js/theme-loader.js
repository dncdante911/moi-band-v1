/**
 * Файл: assets/js/theme-loader.js
 * Загрузчик и менеджер тем для Master of Illusion
 * 
 * ГЛАВНЫЙ ФАЙЛ СИСТЕМЫ ТЕМ
 * Подключить в header.php ДО всех других CSS/JS файлов
 */

class ThemeManager {
    constructor() {
        this.storageKey = 'master_of_illusion_theme';
        this.themeDir = '/assets/css/themes';
        this.defaultTheme = 'power-metal';
        
        // Доступные темы
        this.availableThemes = {
            'power-metal': {
                name: '⚔️ Power Metal',
                description: 'Эпический, героический дизайн',
                color: '#FFD700'
            },
            'gothic-metal': {
                name: '🦇 Gothic Metal',
                description: 'Мрачный, готический стиль',
                color: '#9D00FF'
            },
            'punk-rock': {
                name: '🤘 Punk Rock',
                description: 'Энергичный, бунтарский дизайн',
                color: '#FF00FF'
            },
            'literary-dark': {
                name: '📚 Literary Dark',
                description: 'Классический, литературный стиль',
                color: '#8B6914'
            }
        };
        
        this.init();
    }
    
    /**
     * Инициализация системы тем
     */
    init() {
        console.log('%c🎨 Theme Manager инициализация...', 'color: #FFD700; font-weight: bold;');
        
        // 1. Загружаем сохранённую тему
        const savedTheme = this.loadSavedTheme();
        
        // 2. Применяем тему
        this.setTheme(savedTheme);
        
        // 3. Создаём переключатель тем (если пользователь авторизован)
        this.initThemeSwitcher();
        
        // 4. Синхронизируем с БД если пользователь авторизован
        this.syncThemeWithDB();
        
        console.log('✅ Theme Manager готов! Текущая тема:', savedTheme);
    }
    
    /**
     * Загрузить сохранённую тему
     */
    loadSavedTheme() {
        // 1. Проверяем LocalStorage
        const stored = localStorage.getItem(this.storageKey);
        
        if (stored) {
            try {
                const themeData = JSON.parse(stored);
                if (this.availableThemes[themeData.name]) {
                    return themeData.name;
                }
            } catch (e) {
                console.warn('⚠️ Ошибка парсинга сохранённой темы:', e);
            }
        }
        
        // 2. Проверяем cookie (для не авторизованных)
        const themeCookie = this.getCookie('theme');
        if (themeCookie && this.availableThemes[themeCookie]) {
            return themeCookie;
        }
        
        // 3. Используем тему по умолчанию
        return this.defaultTheme;
    }
    
    /**
     * Установить тему
     */
    setTheme(themeName) {
        if (!this.availableThemes[themeName]) {
            console.error('❌ Тема не найдена:', themeName);
            themeName = this.defaultTheme;
        }
        
        console.log('🎨 Применяю тему:', themeName);
        
        // Удалить старые CSS
        document.querySelectorAll('link[data-theme-css]').forEach(el => {
            el.remove();
        });
        
        // Загрузить новый CSS
        const cssPath = `${this.themeDir}/${themeName}/main.css`;
        const link = document.createElement('link');
        link.rel = 'stylesheet';
        link.href = cssPath;
        link.setAttribute('data-theme-css', 'true');
        link.onload = () => {
            console.log('✅ CSS темы загружен:', themeName);
            this.applyThemeToDOM(themeName);
        };
        link.onerror = () => {
            console.error('❌ Не удалось загрузить CSS:', cssPath);
        };
        
        document.head.appendChild(link);
        
        // Сохраняем выбор
        this.saveTheme(themeName);
        
        // Уведомляем об изменении
        window.dispatchEvent(new CustomEvent('themeChanged', {
            detail: { theme: themeName }
        }));
    }
    
    /**
     * Применить тему к DOM элементам
     */
    applyThemeToDOM(themeName) {
        // Обновляем атрибут body
        document.documentElement.setAttribute('data-theme', themeName);
        document.body.setAttribute('data-theme', themeName);
        
        // Обновляем meta theme-color
        const metaThemeColor = document.querySelector('meta[name="theme-color"]');
        if (metaThemeColor) {
            const themeColor = this.availableThemes[themeName].color;
            metaThemeColor.setAttribute('content', themeColor);
        }
        
        // Обновляем переключатель (если существует)
        const switcher = document.getElementById('theme-switcher');
        if (switcher) {
            switcher.value = themeName;
        }
    }
    
    /**
     * Сохранить тему в LocalStorage и Cookie
     */
    saveTheme(themeName) {
        // LocalStorage
        try {
            const themeData = {
                name: themeName,
                savedAt: Date.now(),
                syncedToDB: false
            };
            localStorage.setItem(this.storageKey, JSON.stringify(themeData));
        } catch (e) {
            console.warn('⚠️ Не удалось сохранить в LocalStorage:', e);
        }
        
        // Cookie (на 1 год)
        this.setCookie('theme', themeName, 365);
        
        console.log('💾 Тема сохранена:', themeName);
    }
    
    /**
     * Синхронизировать тему с БД (для авторизованных)
     */
    syncThemeWithDB() {
        // Проверяем, авторизован ли пользователь
        const isLoggedIn = document.querySelector('meta[name="user-logged-in"]')?.content === 'true';
        
        if (!isLoggedIn) {
            console.log('ℹ️ Пользователь не авторизован, БД синхронизация пропущена');
            return;
        }
        
        const currentTheme = this.loadSavedTheme();
        
        // Отправляем текущую тему на сервер
        fetch('/api/user/update-theme.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ theme: currentTheme })
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    console.log('✅ Тема синхронизирована с БД');
                }
            })
            .catch(err => console.warn('⚠️ Ошибка синхронизации:', err));
    }
    
    /**
     * Инициализировать переключатель тем
     */
    initThemeSwitcher() {
        const switcher = document.getElementById('theme-switcher');
        if (!switcher) return;
        
        // Установить текущую тему
        switcher.value = this.loadSavedTheme();
        
        // Слушаем изменения
        switcher.addEventListener('change', (e) => {
            this.setTheme(e.target.value);
        });
        
        console.log('✅ Переключатель тем инициализирован');
    }
    
    /**
     * Получить cookie
     */
    getCookie(name) {
        const nameEQ = name + '=';
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            let cookie = cookies[i].trim();
            if (cookie.indexOf(nameEQ) === 0) {
                return cookie.substring(nameEQ.length);
            }
        }
        return null;
    }
    
    /**
     * Установить cookie
     */
    setCookie(name, value, days) {
        let expires = '';
        if (days) {
            const date = new Date();
            date.setTime(date.getTime() + days * 24 * 60 * 60 * 1000);
            expires = '; expires=' + date.toUTCString();
        }
        document.cookie = name + '=' + value + expires + '; path=/; SameSite=Lax';
    }
    
    /**
     * Получить все доступные темы (для API)
     */
    getAvailableThemes() {
        return this.availableThemes;
    }
    
    /**
     * Получить текущую тему
     */
    getCurrentTheme() {
        return this.loadSavedTheme();
    }
}

/**
 * ИНИЦИАЛИЗАЦИЯ
 * Запускаем ДО загрузки всего остального контента
 */
const themeManager = new ThemeManager();

// Экспортируем для использования в других скриптах
window.themeManager = themeManager;

console.log('✅ Theme Loader загружен успешно');