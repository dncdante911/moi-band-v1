/**
 * MASTER OF ILLUSION - EPIC PLAYER
 * Плеер для треков и видео с плейлистами
 * ИСПРАВЛЕННАЯ ВЕРСИЯ v2.1 - Фиксы багов
 */

class EpicPlayer {
    constructor(containerId = 'epic-player') {
        this.container = document.getElementById(containerId);
        this.queue = [];
        this.currentIndex = 0;
        this.isPlaying = false;
        this.currentMode = 'audio'; // audio, video, queue, lyrics
        this.repeatMode = 'none'; // none, one, all
        this.isShuffle = false;
        
        this.init();
    }
    
    init() {
        console.log('🎸 EpicPlayer инициализирован');
        this.setupEventListeners();
        this.loadPlaylist();
    }
    
    setupEventListeners() {
        // Кнопки управления
        const playBtn = this.container.querySelector('.play-btn');
        const prevBtn = this.container.querySelector('[data-action="prev"]');
        const nextBtn = this.container.querySelector('[data-action="next"]');
        const repeatBtn = this.container.querySelector('[data-action="repeat"]');
        const shuffleBtn = this.container.querySelector('[data-action="shuffle"]');
        
        if (playBtn) playBtn.addEventListener('click', () => this.togglePlay());
        if (prevBtn) prevBtn.addEventListener('click', () => this.prevTrack());
        if (nextBtn) nextBtn.addEventListener('click', () => this.nextTrack());
        if (repeatBtn) repeatBtn.addEventListener('click', () => this.toggleRepeat());
        if (shuffleBtn) shuffleBtn.addEventListener('click', () => this.toggleShuffle());
        
        // Режимы
        const modeButtons = this.container.querySelectorAll('.mode-btn');
        modeButtons.forEach(btn => {
            btn.addEventListener('click', (e) => this.switchMode(e.target.dataset.mode));
        });
        
        // Прогресс бар
        const progressBar = this.container.querySelector('.progress-bar');
        if (progressBar) {
            progressBar.addEventListener('click', (e) => this.seekTo(e));
        }
        
        // Очередь
        const queueItems = this.container.querySelectorAll('.queue-item');
        queueItems.forEach((item, index) => {
            item.addEventListener('click', () => this.playTrack(index));
        });
        
        // Медиа элементы
        const audio = this.container.querySelector('audio');
        const video = this.container.querySelector('video');
        
        if (audio) {
            audio.addEventListener('timeupdate', () => this.updateProgress());
            audio.addEventListener('ended', () => this.nextTrack());
            audio.addEventListener('loadedmetadata', () => this.updateDuration());
        }
        
        if (video) {
            video.addEventListener('timeupdate', () => this.updateProgress());
            video.addEventListener('ended', () => this.nextTrack());
            video.addEventListener('loadedmetadata', () => this.updateDuration());
        }
    }
    
    async loadPlaylist(albumId = null, playlistId = null) {
        try {
            let url = '/api/player/queue.php?';
            
            if (albumId) {
                url += `album_id=${albumId}`;
            } else if (playlistId) {
                url += `playlist_id=${playlistId}`;
            } else {
                // Загружаем по умолчанию первый альбом
                url += 'album_id=1';
            }
            
            const response = await fetch(url);
            const data = await response.json();
            
            if (data.success) {
                this.queue = data.tracks;
                this.currentIndex = 0;
                this.isShuffle = false; // Сбросить перемешивание
                this.repeatMode = 'none'; // Сбросить повтор
                this.renderQueue();
                this.loadTrack(0);
                console.log('✅ Плейлист загружен:', this.queue.length, 'треков');
            }
        } catch (e) {
            console.error('❌ Ошибка загрузки плейлиста:', e);
        }
    }
    
loadTrack(index) {
    if (index < 0 || index >= this.queue.length) return;
    
    this.currentIndex = index;
    const track = this.queue[index];
    
    console.log('🎵 Загружаем трек:', track.title, '(ID:', track.id + ')');
    
    // Обновляем информацию
    this.updateTrackInfo(track);
    
    // ✅ ВАЖНО: Загружаем в соответствии с ТЕКУЩИМ РЕЖИМОМ
    if (this.currentMode === 'video' && track.videoPath) {
        console.log('📺 Загружаем ВИД ЕО для режима видео');
        this.loadVideo(track);
    } else {
        console.log('🔊 Загружаем АУДИО');
        this.loadAudio(track);
        
        // Если видео нет и мы в режиме видео - вернуться на аудио
        if (this.currentMode === 'video' && !track.videoPath) {
            console.warn('⚠️ Видео отсутствует, переключаемся на аудио');
            this.currentMode = 'audio';
            const display = this.container.querySelector('.player-display');
            if (display) display.style.display = 'block';
        }
    }
    
    // Загружаем текст
    this.loadLyrics(track.id);
    
    // Обновляем очередь
    this.updateQueueHighlight();
}
    
loadAudio(track) {
    const audio = this.container.querySelector('audio');
    if (audio && track.fullAudioPath) {
        const audioPath = track.fullAudioPath.startsWith('/') 
            ? track.fullAudioPath 
            : '/' + track.fullAudioPath;
        
        // ✅ Очистить и переустановить
        audio.src = '';
        audio.src = audioPath;
        audio.load();
        
        console.log('🔊 Аудио загружено:', audioPath);
        
        // Обработчик ошибок
        audio.onerror = function() {
            console.error('❌ Ошибка загрузки аудио:', audioPath);
        };
    }
}
    
loadVideo(track) {
    console.log('🎬 loadVideo() вызвана для трека:', track.title);
    
    const video = this.container.querySelector('video');
    const display = this.container.querySelector('.player-display');
    
    if (!video) {
        console.error('❌ Видео элемент не найден!');
        return;
    }
    
    if (!track.videoPath) {
        console.warn('⚠️ У трека нет videoPath:', track);
        return;
    }
    
    // Нормализация пути
    const videoPath = track.videoPath.startsWith('/') 
        ? track.videoPath 
        : '/' + track.videoPath;
    
    console.log('📺 Устанавливаем видео путь:', videoPath);
    
    // ✅ ВАЖНО: Очистить предыдущее видео
    video.src = '';
    
    // Устанавливаем новый источник
    video.src = videoPath;
    
    // Пытаемся загрузить
    video.load();
    
    // Показываем видео плеер
    if (display) {
        display.style.display = 'block';
        console.log('✅ Видео display показан');
    }
    
    // Обработчик ошибок видео
    video.onerror = function() {
        console.error('❌ Ошибка загрузки видео:', videoPath);
        console.error('CORS? Формат? Путь неверный?');
        alert('⚠️ Ошибка загрузки видео:\n' + videoPath);
    };
    
    // Обработчик успешной загрузки
    video.onloadstart = function() {
        console.log('📺 Видео начинает загружаться...');
    };
    
    video.oncanplay = function() {
        console.log('✅ Видео готово к воспроизведению');
    };
}
    
    async loadLyrics(trackId) {
        try {
            const response = await fetch(`/api/player/lyrics.php?track_id=${trackId}`);
            const data = await response.json();
            
            const lyricsContainer = this.container.querySelector('.lyrics-container');
            const lyricsText = this.container.querySelector('.lyrics-text');
            
            if (data.lyrics && data.lyrics.trim()) {
                lyricsText.textContent = data.lyrics;
                if (lyricsContainer) {
                    lyricsContainer.classList.remove('hidden');
                }
            } else {
                if (lyricsText) {
                    lyricsText.innerHTML = '<div class="no-lyrics">🎵 Текст песни отсутствует</div>';
                }
            }
        } catch (e) {
            console.error('Ошибка загрузки текста:', e);
        }
    }
    
    updateTrackInfo(track) {
        const title = this.container.querySelector('.track-title');
        const artist = this.container.querySelector('.track-artist');
        const album = this.container.querySelector('.track-album');
        
        if (title) title.textContent = track.title;
        if (artist) artist.textContent = 'Master of Illusion';
        if (album) album.textContent = track.albumTitle || 'Альбом';
        
        // Обновляем обложку
        const cover = this.container.querySelector('.player-cover img');
        if (cover) {
            const coverPath = track.coverImagePath.startsWith('/') 
                ? track.coverImagePath 
                : '/' + track.coverImagePath;
            cover.src = coverPath;
        }
    }
    
    renderQueue() {
        const queueList = this.container.querySelector('.queue-list');
        if (!queueList) return;
        
        queueList.innerHTML = this.queue.map((track, index) => `
            <li class="queue-item" data-index="${index}">
                <span class="queue-number">${index + 1}</span>
                <div class="queue-info">
                    <div class="queue-track-name">${this.escapeHtml(track.title)}</div>
                    <div class="queue-track-album">${this.escapeHtml(track.albumTitle || 'Альбом')}</div>
                </div>
                <span class="queue-duration">${this.formatTime(track.duration || 0)}</span>
            </li>
        `).join('');
        
        // Переназначаем события
        this.setupEventListeners();
    }
    
    updateQueueHighlight() {
        const items = this.container.querySelectorAll('.queue-item');
        items.forEach((item, index) => {
            if (index === this.currentIndex) {
                item.classList.add('active');
            } else {
                item.classList.remove('active');
            }
        });
    }
    
    updateDuration() {
        const media = this.getCurrentMedia();
        if (media && media.duration) {
            const duration = Math.floor(media.duration);
            console.log('⏱️ Длительность:', this.formatTime(duration));
            
            // ФИХ #1: Сохранить длительность в локальное хранилище
            if (this.queue[this.currentIndex]) {
                this.queue[this.currentIndex].duration = duration;
                
                // Обновить в очереди на странице
                const queueItem = this.container.querySelector(`.queue-item[data-index="${this.currentIndex}"] .queue-duration`);
                if (queueItem) {
                    queueItem.textContent = this.formatTime(duration);
                }
            }
        }
    }
    
    togglePlay() {
        const media = this.getCurrentMedia();
        if (!media) return;
        
        if (this.isPlaying) {
            media.pause();
        } else {
            media.play();
        }
        
        this.isPlaying = !this.isPlaying;
        this.updatePlayButton();
    }
    
    playTrack(index) {
        if (index < 0 || index >= this.queue.length) return;
        this.loadTrack(index);
        this.togglePlay();
    }
    
    nextTrack() {
        console.log('➡️ Следующий трек (repeat:', this.repeatMode, ', shuffle:', this.isShuffle + ')');
        
        if (this.repeatMode === 'one') {
            // Повторить текущий трек
            this.loadTrack(this.currentIndex);
        } else if (this.isShuffle) {
            // Случайный трек
            this.currentIndex = Math.floor(Math.random() * this.queue.length);
            this.loadTrack(this.currentIndex);
        } else {
            // Следующий по порядку
            this.currentIndex++;
            if (this.currentIndex >= this.queue.length) {
                if (this.repeatMode === 'all') {
                    this.currentIndex = 0;
                } else {
                    // Стоп в конце плейлиста
                    this.currentIndex = this.queue.length - 1;
                    this.isPlaying = false;
                    this.updatePlayButton();
                    return;
                }
            }
            this.loadTrack(this.currentIndex);
        }
        
        if (this.isPlaying) {
            this.getCurrentMedia()?.play();
        }
    }
    
    prevTrack() {
        console.log('⬅️ Предыдущий трек');
        
        this.currentIndex--;
        if (this.currentIndex < 0) {
            this.currentIndex = this.queue.length - 1;
        }
        
        this.loadTrack(this.currentIndex);
        if (this.isPlaying) {
            this.getCurrentMedia()?.play();
        }
    }
    
    toggleRepeat() {
        const btn = this.container.querySelector('[data-action="repeat"]');
        const modes = ['none', 'all', 'one'];
        const currentIdx = modes.indexOf(this.repeatMode);
        this.repeatMode = modes[(currentIdx + 1) % modes.length];
        
        console.log('🔄 Режим повтора:', this.repeatMode);
        
        if (btn) {
            let icon = '🔁';
            let text = 'Нет повтора';
            
            if (this.repeatMode === 'all') {
                icon = '🔁';
                text = 'Повтор всех';
            } else if (this.repeatMode === 'one') {
                icon = '🔂';
                text = 'Повтор одного';
            }
            
            btn.textContent = icon;
            btn.title = text;
            btn.classList.toggle('active', this.repeatMode !== 'none');
        }
    }
    
    toggleShuffle() {
        this.isShuffle = !this.isShuffle;
        const btn = this.container.querySelector('[data-action="shuffle"]');
        
        console.log('🔀 Перемешивание:', this.isShuffle ? 'ВКЛ' : 'ВЫКЛ');
        
        if (btn) {
            btn.classList.toggle('active', this.isShuffle);
            btn.title = this.isShuffle ? 'Случайный порядок' : 'Последовательный порядок';
        }
    }
    
switchMode(mode) {
    console.log('📺 Переключение режима:', mode);
    this.currentMode = mode;
    
    const display = this.container.querySelector('.player-display');
    const queue = this.container.querySelector('.queue-container');
    const lyrics = this.container.querySelector('.lyrics-container');
    const audio = this.container.querySelector('audio');
    const video = this.container.querySelector('video');
    
    // Обновляем активную кнопку
    const buttons = this.container.querySelectorAll('.mode-btn');
    buttons.forEach(btn => {
        if (btn.dataset.mode === mode) {
            btn.classList.add('active');
        } else {
            btn.classList.remove('active');
        }
    });
    
    // Скрыть всё
    if (display) display.style.display = 'none';
    if (queue) queue.style.display = 'none';
    if (lyrics) lyrics.style.display = 'none';
    
    // ✅ ВАЖНО: Остановить видео/аудио перед переключением
    if (audio) audio.pause();
    if (video) video.pause();
    
    // Показать нужное
    if (mode === 'audio') {
        console.log('🎵 Режим: АУДИО');
        if (display) display.style.display = 'block';
        
        // ✅ Убедиться что аудио установлен
        const track = this.queue[this.currentIndex];
        if (track && audio) {
            const audioPath = track.fullAudioPath.startsWith('/') 
                ? track.fullAudioPath 
                : '/' + track.fullAudioPath;
            
            if (audio.src !== audioPath) {
                console.log('🔊 Переустанавливаем аудио:', audioPath);
                audio.src = audioPath;
                audio.load();
            }
        }
    } 
    else if (mode === 'video') {
        console.log('🎬 Режим: ВИДЕО');
        if (display) display.style.display = 'block';
        
        // ✅ Загрузить видео
        const track = this.queue[this.currentIndex];
        if (track && track.videoPath) {
            this.loadVideo(track);
        } else {
            console.warn('⚠️ Видео не доступно для этого трека');
            alert('⚠️ У этого трека нет видео');
            this.currentMode = 'audio';
            document.querySelector('.mode-btn[data-mode="audio"]').classList.add('active');
            buttons.forEach(b => {
                if (b.dataset.mode === 'audio') b.classList.add('active');
                else b.classList.remove('active');
            });
            if (display) display.style.display = 'block';
        }
    } 
    else if (mode === 'queue') {
        console.log('📋 Режим: ОЧЕРЕДЬ');
        if (queue) queue.style.display = 'block';
    } 
    else if (mode === 'lyrics') {
        console.log('📝 Режим: ТЕКСТ');
        if (lyrics) lyrics.style.display = 'block';
    }
}
    
    seekTo(e) {
        const progressBar = this.container.querySelector('.progress-bar');
        const media = this.getCurrentMedia();
        
        if (!progressBar || !media || !media.duration) return;
        
        const rect = progressBar.getBoundingClientRect();
        const percent = (e.clientX - rect.left) / rect.width;
        media.currentTime = percent * media.duration;
    }
    
    updateProgress() {
        const media = this.getCurrentMedia();
        if (!media) return;
        
        const percent = media.duration ? (media.currentTime / media.duration) * 100 : 0;
        const fill = this.container.querySelector('.progress-fill');
        const handle = this.container.querySelector('.progress-handle');
        const currentTime = this.container.querySelector('.time:first-child');
        const duration = this.container.querySelector('.time:last-child');
        
        if (fill) fill.style.width = percent + '%';
        if (handle) handle.style.left = percent + '%';
        if (currentTime) currentTime.textContent = this.formatTime(media.currentTime);
        if (duration) duration.textContent = this.formatTime(media.duration);
    }
    
    updatePlayButton() {
        const btn = this.container.querySelector('.play-btn');
        if (btn) {
            btn.textContent = this.isPlaying ? '⏸' : '▶';
            btn.title = this.isPlaying ? 'Пауза' : 'Воспроизвести';
        }
    }
    
    getCurrentMedia() {
        if (this.currentMode === 'video') {
            return this.container.querySelector('video');
        } else {
            return this.container.querySelector('audio');
        }
    }
    
    formatTime(seconds) {
        if (!seconds || isNaN(seconds)) return '0:00';
        
        const mins = Math.floor(seconds / 60);
        const secs = Math.floor(seconds % 60);
        return `${mins}:${secs.toString().padStart(2, '0')}`;
    }
    
    escapeHtml(text) {
        const map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        return text.replace(/[&<>"']/g, m => map[m]);
    }
    
    // API методы для добавления треков
    async addToPlaylist(trackId, playlistId) {
        try {
            const response = await fetch('/api/player/add-to-playlist.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ track_id: trackId, playlist_id: playlistId })
            });
            
            const data = await response.json();
            console.log(data.success ? '✅ Добавлено в плейлист' : '❌ Ошибка добавления');
            return data.success;
        } catch (e) {
            console.error('Ошибка:', e);
            return false;
        }
    }
    
    async createPlaylist(title, description) {
        try {
            const response = await fetch('/api/player/playlists.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ title, description })
            });
            
            const data = await response.json();
            return data.playlist_id;
        } catch (e) {
            console.error('Ошибка создания плейлиста:', e);
            return null;
        }
    }
}

// Инициализация при загрузке страницы
document.addEventListener('DOMContentLoaded', () => {
    const playerElement = document.getElementById('epic-player');
    if (playerElement) {
        window.epicPlayer = new EpicPlayer('epic-player');
        console.log('🎸 Epic Player v2.1 готов!');
    }
});