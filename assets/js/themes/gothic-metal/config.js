/* ========================================
   ФАЙЛ: assets/js/themes/gothic-metal/config.js
   
   КОНФИГУРАЦИЯ ТЕМЫ GOTHIC METAL
   ======================================== */

const GOTHIC_METAL_CONFIG = {
    name: 'Gothic Metal',
    icon: '🦇',
    id: 'gothic-metal',
    
    // Цвета
    colors: {
        primary: '#D946EF',
        secondary: '#6B2C6B',
        accent: '#B088D9',
        textLight: '#d8d8d8',
        textDark: '#a0a0a0',
        bgPrimary: '#0a0a0a',
        bgSecondary: 'rgba(25, 10, 30, 0.9)',
        border: '#D946EF'
    },
    
    // Пути
    paths: {
        css: '/assets/css/themes/gothic-metal/main.css'
    },
    
    // Описание
    description: 'Мрак, мистика и готические узоры',
    
    // Элементы для стилизации
    elements: {
        headings: ['h1', 'h2', 'h3'],
        buttons: ['button', '.btn', '.hero-button'],
        cards: ['.card', '.page-content', '.genre-card'],
        links: ['a']
    }
};

export default GOTHIC_METAL_CONFIG;