<?php
/**
 * Файл: api/player/queue.php
 * API для получения очереди треков
 */

header('Content-Type: application/json');

require_once '../../include_config/config.php';
require_once '../../include_config/db_connect.php';

$albumId = intval($_GET['album_id'] ?? 0);
$playlistId = intval($_GET['playlist_id'] ?? 0);

try {
    $tracks = [];
    
    if ($albumId) {
        // Получаем все треки альбома
        $stmt = $pdo->prepare("
            SELECT 
                t.id,
                t.title,
                t.description,
                t.albumId,
                t.coverImagePath,
                t.fullAudioPath,
                t.videoPath,
                t.lyricsPath,
                t.duration,
                a.title as albumTitle
            FROM Track t
            LEFT JOIN Albums a ON t.albumId = a.id
            WHERE t.albumId = ?
            ORDER BY t.id ASC
        ");
        $stmt->execute([$albumId]);
        $tracks = $stmt->fetchAll();
        
    } else if ($playlistId) {
        // Получаем треки из плейлиста
        $stmt = $pdo->prepare("
            SELECT 
                t.id,
                t.title,
                t.description,
                t.albumId,
                t.coverImagePath,
                t.fullAudioPath,
                t.videoPath,
                t.lyricsPath,
                t.duration,
                a.title as albumTitle
            FROM Track t
            LEFT JOIN Albums a ON t.albumId = a.id
            INNER JOIN PlaylistTracks pt ON t.id = pt.track_id
            WHERE pt.playlist_id = ?
            ORDER BY pt.position ASC
        ");
        $stmt->execute([$playlistId]);
        $tracks = $stmt->fetchAll();
    }
    
    echo json_encode([
        'success' => true,
        'tracks' => array_map(function($track) {
            return [
                'id' => (int)$track['id'],
                'title' => htmlspecialchars($track['title']),
                'description' => htmlspecialchars($track['description'] ?? ''),
                'albumTitle' => htmlspecialchars($track['albumTitle'] ?? 'Альбом'),
                'coverImagePath' => $track['coverImagePath'],
                'fullAudioPath' => $track['fullAudioPath'],
                'videoPath' => $track['videoPath'],
                'lyricsPath' => $track['lyricsPath'],
                'duration' => (int)($track['duration'] ?? 0)
            ];
        }, $tracks)
    ]);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}