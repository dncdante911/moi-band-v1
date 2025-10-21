<?php
/**
 * Файл: api/v1/albums/detail.php
 * API Endpoint для получения деталей альбома со всеми треками
 * GET /api/v1/albums/detail.php?id=1
 */

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require_once '../../../include_config/config.php';
require_once '../../../include_config/db_connect.php';
require_once '../../../include_config/APIResponse.php';
require_once '../../../include_config/APILogger.php';

$logger = new APILogger();

try {
    // === ПРОВЕРКА МЕТОДА ===
    if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
        $logger->logError('/api/v1/albums/detail', 'Method not allowed', 405);
        APIResponse::methodNotAllowed(['GET']);
    }
    
    // === ПОЛУЧИТЬ ID АЛЬБОМА ===
    $album_id = intval($_GET['id'] ?? 0);
    
    $logger->logRequest('/api/v1/albums/detail', 'GET', null, ['album_id' => $album_id]);
    
    if ($album_id < 1) {
        $logger->logValidationError('/api/v1/albums/detail', ['Invalid album ID']);
        APIResponse::validationError(['id' => 'Invalid album ID']);
    }
    
    // === ПОЛУЧИТЬ АЛЬБОМ ===
    $stmt = $pdo->prepare("
        SELECT 
            id,
            title,
            description,
            coverImagePath,
            releaseDate,
            createdAt,
            updatedAt
        FROM Albums
        WHERE id = ?
    ");
    
    $stmt->execute([$album_id]);
    $album = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$album) {
        $logger->logError('/api/v1/albums/detail', 'Album not found', 404, null, ['album_id' => $album_id]);
        APIResponse::notFound('Album not found');
    }
    
    // === ПОЛУЧИТЬ ТРЕКИ ===
    $stmt = $pdo->prepare("
        SELECT 
            id,
            title,
            description,
            coverImagePath,
            fullAudioPath,
            duration,
            views,
            createdAt,
            updatedAt
        FROM Track
        WHERE albumId = ?
        ORDER BY id ASC
    ");
    
    $stmt->execute([$album_id]);
    $tracks = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // === ФОРМАТИРОВАНИЕ ===
    $album['id'] = (int)$album['id'];
    $album['releaseDate'] = $album['releaseDate'] ? substr($album['releaseDate'], 0, 10) : null;
    $album['track_count'] = count($tracks);
    
    $formatted_tracks = [];
    foreach ($tracks as $track) {
        $formatted_tracks[] = [
            'id' => (int)$track['id'],
            'title' => $track['title'],
            'description' => $track['description'],
            'cover_image' => $track['coverImagePath'],
            'audio_url' => $track['fullAudioPath'],
            'duration' => (int)$track['duration'],
            'views' => (int)$track['views'],
            'created_at' => substr($track['createdAt'], 0, 10)
        ];
    }
    
    $album['tracks'] = $formatted_tracks;
    
    // === РАСЧЁТ ОБЩЕЙ ПРОДОЛЖИТЕЛЬНОСТИ ===
    $total_duration = array_sum(array_column($tracks, 'duration'));
    $album['total_duration'] = (int)$total_duration;
    $album['total_duration_formatted'] = $this->formatDuration($total_duration);
    
    $logger->logResponse('/api/v1/albums/detail', 200, null);
    APIResponse::success($album, 200);
    
} catch (PDOException $e) {
    $logger->logException('/api/v1/albums/detail', $e);
    APIResponse::serverError('Database error', 'DB_ERROR');
    
} catch (Exception $e) {
    $logger->logException('/api/v1/albums/detail', $e);
    APIResponse::serverError($e->getMessage(), 'UNKNOWN_ERROR');
}

/**
 * Форматировать длительность из секунд в MM:SS или HH:MM:SS
 */
function formatDuration($seconds) {
    $seconds = (int)$seconds;
    
    if ($seconds < 3600) {
        $minutes = floor($seconds / 60);
        $secs = $seconds % 60;
        return sprintf('%02d:%02d', $minutes, $secs);
    }
    
    $hours = floor($seconds / 3600);
    $minutes = floor(($seconds % 3600) / 60);
    $secs = $seconds % 60;
    return sprintf('%02d:%02d:%02d', $hours, $minutes, $secs);
}