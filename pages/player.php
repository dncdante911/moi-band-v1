<?php
/**
 * Компонент: Epic Player
 * Используйте этот код на странице альбома или плейлиста
 * 
 * Поместите в pages/albums.php или создайте pages/player.php
 */
?>

<div id="epic-player" class="epic-player">
    
    <!-- === ЭКРАН ПЛЕЕРА === -->
    <div class="player-display">
        <!-- Аудио плеер (скрыт) -->
        <audio controls style="display: none;"></audio>
        
        <!-- Видео плеер (скрыт по умолчанию) -->
        <video style="display: none;" controls></video>
        
        <!-- Обложка альбома -->
        <div class="player-cover">
            <img src="/assets/images/placeholder.png" alt="Обложка">
            <div class="player-overlay">
                <div class="play-big">▶</div>
            </div>
        </div>
    </div>
    
    <!-- === ИНФОРМАЦИЯ О ТРЕКЕ === -->
    <div class="player-info">
        <h2 class="track-title">Название трека</h2>
        <p class="track-artist">Master of Illusion</p>
        <p class="track-album">Альбом</p>
    </div>
    
    <!-- === ПРОГРЕСС БАР === -->
    <div class="progress-container">
        <span class="time">0:00</span>
        <div class="progress-bar">
            <div class="progress-fill"></div>
            <div class="progress-handle"></div>
        </div>
        <span class="time">0:00</span>
    </div>
    
    <!-- === КНОПКИ УПРАВЛЕНИЯ === -->
    <div class="player-controls">
        <button class="control-btn" data-action="shuffle" title="Перемешивание">🔀</button>
        <button class="control-btn" data-action="prev" title="Предыдущий">⏮</button>
        <button class="control-btn play-btn" title="Проиграть">▶</button>
        <button class="control-btn" data-action="next" title="Следующий">⏭</button>
        <button class="control-btn" data-action="repeat" title="Повтор">🔁</button>
    </div>
    
    <!-- === РЕЖИМЫ === -->
    <div class="player-modes">
        <button class="mode-btn active" data-mode="audio" title="Аудио">🎵 Аудио</button>
        <button class="mode-btn" data-mode="video" title="Видео">🎬 Видео</button>
        <button class="mode-btn" data-mode="queue" title="Очередь">📋 Очередь</button>
        <button class="mode-btn" data-mode="lyrics" title="Текст">📝 Текст</button>
    </div>
    
    <!-- === СПИСОК ТРЕКОВ (ОЧЕРЕДЬ) === -->
    <div class="queue-container" style="display: none;">
        <div class="queue-title">📋 Очередь воспроизведения</div>
        <ul class="queue-list">
            <!-- Заполняется JavaScript -->
        </ul>
    </div>
    
    <!-- === ТЕКСТ ПЕСНИ (LYRICS) === -->
    <div class="lyrics-container" style="display: none;">
        <div class="lyrics-text">
            <!-- Заполняется JavaScript -->
        </div>
    </div>
    
</div>

<!-- Подключаем стили и скрипты -->
<link rel="stylesheet" href="/assets/css/epic-player.css">
<script src="/assets/js/epic-player.js"></script>

<!-- Пример использования в JavaScript -->
<script>
    // После загрузки страницы
    document.addEventListener('DOMContentLoaded', () => {
        // Загружаем плейлист альбома
        const albumId = new URLSearchParams(window.location.search).get('id');
        if (window.epicPlayer && albumId) {
            window.epicPlayer.loadPlaylist(albumId);
        }
    });
    
    // Пример создания плейлиста
    async function createMyPlaylist() {
        const playlistId = await window.epicPlayer.createPlaylist(
            'Мой плейлист',
            'Описание моего плейлиста'
        );
        console.log('Плейлист создан:', playlistId);
    }
    
    // Пример добавления трека
    async function addTrackToPlaylist(trackId, playlistId) {
        const success = await window.epicPlayer.addToPlaylist(trackId, playlistId);
        if (success) {
            alert('✅ Трек добавлен!');
        }
    }
</script>