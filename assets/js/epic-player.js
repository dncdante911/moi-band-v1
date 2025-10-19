/**
 * MASTER OF ILLUSION - EPIC PLAYER
 * Плеер для треков и видео с плейлистами
 */

class EpicPlayer {
    constructor(containerId = 'epic-player') {
        this.container = document.getElementById(containerId);
        this.queue = [];
        this.currentIndex = 0;
        this.isPlaying = false;
        this.currentMode = 'album'; // album, video, lyrics
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
        }
        
        if (video) {
            video.addEventListener('timeupdate', () => this.updateProgress());
            video.addEventListener('ended', () => this.nextTrack());
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
                this.renderQueue();
                this.loadTrack(0);
            }
        } catch (e) {
            console.error('❌ Ошибка загрузки плейлиста:', e);
        }
    }
    
    loadTrack(index) {
        if (index < 0 || index >= this.queue.length) return;
        
        this.currentIndex = index;
        const track = this.queue[index];
        
        // Обновляем информацию
        this.updateTrackInfo(track);
        
        // Загружаем медиа в зависимости от режима
        if (this.currentMode === 'video' && track.videoPath) {
            this.loadVideo(track);
        } else {
            this.loadAudio(track);
        }
        
        // Загружаем текст
        this.loadLyrics(track.id);
        
        // Обновляем очередь
        this.updateQueueHighlight();
    }
    
    loadAudio(track) {
        const audio = this.container.querySelector('audio');
        if (audio && track.fullAudioPath) {
            audio.src = track.fullAudioPath;
            audio.load();
        }
    }
    
    loadVideo(track) {
        const video = this.container.querySelector('video');
        if (video && track.videoPath) {
            video.src = track.videoPath;
            video.load();
        }
    }
    
    async loadLyrics(trackId) {
        try {
            const response = await fetch(`/api/player/lyrics.php?track_id=${trackId}`);
            const data = await response.json();
            
            const lyricsContainer = this.container.querySelector('.lyrics-container');
            const lyricsText = this.container.querySelector('.lyrics-text');
            
            if (data.lyrics) {
                lyricsText.textContent = data.lyrics;
                lyricsContainer.classList.remove('hidden');
            } else {
                lyricsText.innerHTML = '<div class="no-lyrics">🎵 Текст песни отсутствует</div>';
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
        if (cover) cover.src = '/' + track.coverImagePath.replace(/^\//, '');
    }
    
    renderQueue() {
        const queueList = this.container.querySelector('.queue-list');
        if (!queueList) return;
        
        queueList.innerHTML = this.queue.map((track, index) => `
            <li class="queue-item" data-index="${index}">
                <span class="queue-number">${index + 1}</span>
                <div class="queue-info">
                    <div class="queue-track-name">${track.title}</div>
                    <div class="queue-track-album">${track.albumTitle || 'Альбом'}</div>
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
        this.loadTrack(index);
        this.togglePlay();
    }
    
    nextTrack() {
        if (this.repeatMode === 'one') {
            this.currentIndex = this.currentIndex;
        } else if (this.isShuffle) {
            this.currentIndex = Math.floor(Math.random() * this.queue.length);
        } else {
            this.currentIndex++;
            if (this.currentIndex >= this.queue.length) {
                this.currentIndex = 0;
            }
        }
        
        this.loadTrack(this.currentIndex);
        if (this.isPlaying) {
            this.getCurrentMedia()?.play();
        }
    }
    
    prevTrack() {
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
        
        if (btn) {
            btn.textContent = this.repeatMode === 'none' ? '🔁' : 
                            this.repeatMode === 'all' ? '🔁' : '🔂';
            btn.classList.toggle('active', this.repeatMode !== 'none');
        }
    }
    
    toggleShuffle() {
        this.isShuffle = !this.isShuffle;
        const btn = this.container.querySelector('[data-action="shuffle"]');
        if (btn) {
            btn.classList.toggle('active', this.isShuffle);
        }
    }
    
    switchMode(mode) {
        this.currentMode = mode;
        
        // Обновляем активную кнопку
        const buttons = this.container.querySelectorAll('.mode-btn');
        buttons.forEach(btn => {
            if (btn.dataset.mode === mode) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });
        
        // Показываем/скрываем элементы
        const display = this.container.querySelector('.player-display');
        const queue = this.container.querySelector('.queue-container');
        const lyrics = this.container.querySelector('.lyrics-container');
        
        if (display) display.style.display = 'none';
        if (queue) queue.style.display = 'none';
        if (lyrics) lyrics.style.display = 'none';
        
        if (mode === 'audio') {
            if (display) display.style.display = 'block';
        } else if (mode === 'video') {
            if (display) display.style.display = 'block';
            this.loadTrack(this.currentIndex);
        } else if (mode === 'queue') {
            if (queue) queue.style.display = 'block';
        } else if (mode === 'lyrics') {
            if (lyrics) lyrics.style.display = 'block';
        }
    }
    
    seekTo(e) {
        const progressBar = this.container.querySelector('.progress-bar');
        const media = this.getCurrentMedia();
        
        if (!progressBar || !media) return;
        
        const rect = progressBar.getBoundingClientRect();
        const percent = (e.clientX - rect.left) / rect.width;
        media.currentTime = percent * media.duration;
    }
    
    updateProgress() {
        const media = this.getCurrentMedia();
        if (!media) return;
        
        const percent = (media.currentTime / media.duration) * 100;
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
    
    // API методы для добавления треков
    async addToPlaylist(trackId, playlistId) {
        try {
            const response = await fetch('/api/player/add-to-playlist.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ track_id: trackId, playlist_id: playlistId })
            });
            
            const data = await response.json();
            console.log(data.success ? '✅ Добавлено' : '❌ Ошибка');
            return data.success;
        } catch (e) {
            console.error('Ошибка:', e);
            return false;
        }
    }
    
    async createPlaylist(title, description) {
        try {
            const response = await fetch('/api/player/create-playlist.php', {
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
        console.log('🎸 Epic Player готов!');
    }
});