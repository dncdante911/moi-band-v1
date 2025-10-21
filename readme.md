# 🎸 Master of Illusion API Documentation

**Версия:** 1.0  
**URL:** `https://lovix.top/api/v1`  
**Формат:** JSON  
**Кодировка:** UTF-8

---

## 📁 Структура папок

```
/api/v1/
├── auth/
│   ├── login.php           - Вход пользователя
│   └── register.php        - Регистрация
├── albums/
│   ├── list.php            - Список альбомов
│   └── detail.php          - Детали альбома со треками
├── tracks/
│   ├── list.php            - Список треков альбома
│   ├── play.php            - Отметить прослушивание
│   └── search.php          - Поиск треков
├── news/
│   ├── list.php            - Список новостей
│   └── detail.php          - Деталь новости
├── gallery/
│   └── list.php            - Список фотографий
├── chat/
│   ├── rooms.php           - Список комнат чата
│   ├── messages.php        - Получить сообщения
│   └── send.php            - Отправить сообщение
└── user/
    └── profile.php         - Профиль пользователя
```

---

## 🔐 Авторизация

### JWT токены

Большинство endpoints требуют JWT токен в заголовке:

```
Authorization: Bearer <JWT_TOKEN>
```

**Время жизни токена:** 24 часа

---

## 📋 Стандартный формат ответа

### Успех (2xx)
```json
{
  "success": true,
  "code": 200,
  "message": "Success",
  "data": {...},
  "timestamp": "2025-10-21T15:30:45+00:00",
  "version": "1.0"
}
```

### Ошибка (4xx/5xx)
```json
{
  "success": false,
  "code": 400,
  "error": "Invalid request",
  "timestamp": "2025-10-21T15:30:45+00:00",
  "version": "1.0"
}
```

### Пагинированный ответ
```json
{
  "success": true,
  "data": [...],
  "pagination": {
    "total": 100,
    "page": 1,
    "per_page": 10,
    "total_pages": 10,
    "has_next": true,
    "has_prev": false
  }
}
```

---

## 🔑 Auth Endpoints

### POST /api/v1/auth/login
Вход пользователя

**Body:**
```json
{
  "username": "dncdante",
  "password": "password123"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "token_type": "Bearer",
    "expires_in": 86400,
    "user": {
      "id": 1,
      "username": "dncdante",
      "email": "user@email.com",
      "display_name": "dncdante",
      "avatar_path": null
    }
  }
}
```

---

### POST /api/v1/auth/register
Регистрация пользователя

**Body:**
```json
{
  "username": "newuser",
  "email": "new@email.com",
  "password": "SecurePass123",
  "password_confirm": "SecurePass123",
  "display_name": "New User"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "token_type": "Bearer",
    "expires_in": 86400,
    "user": {
      "id": 2,
      "username": "newuser",
      "email": "new@email.com",
      "display_name": "New User"
    }
  },
  "message": "Registration successful"
}
```

---

## 📀 Albums Endpoints

### GET /api/v1/albums/list.php
Получить список альбомов

**Parameters:**
- `page` (int, default: 1)
- `per_page` (int, default: 10, max: 100)

**Example:**
```
GET /api/v1/albums/list.php?page=1&per_page=10
```

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "Хроники забытых миров",
      "description": "...",
      "coverImagePath": "/public/uploads/...",
      "releaseDate": "2025-09-25",
      "track_count": 12,
      "createdAt": "2025-10-19T17:38:18..."
    }
  ],
  "pagination": {
    "total": 3,
    "page": 1,
    "per_page": 10,
    "total_pages": 1,
    "has_next": false,
    "has_prev": false
  }
}
```

---

### GET /api/v1/albums/detail.php
Получить альбом со всеми треками

**Parameters:**
- `id` (int, required) - ID альбома

**Example:**
```
GET /api/v1/albums/detail.php?id=1
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "Хроники забытых миров",
    "description": "...",
    "coverImagePath": "/public/uploads/...",
    "releaseDate": "2025-09-25",
    "track_count": 12,
    "total_duration": 3684,
    "total_duration_formatted": "01:01:24",
    "tracks": [
      {
        "id": 38,
        "title": "1. Последний из драконов",
        "cover_image": "/public/uploads/...",
        "audio_url": "/public/uploads/full/...",
        "duration": 307,
        "views": 0,
        "created_at": "2025-10-19"
      }
    ]
  }
}
```

---

## 🎵 Tracks Endpoints

### GET /api/v1/tracks/list.php
Получить список треков альбома

**Parameters:**
- `album_id` (int, required) - ID альбома
- `page` (int, default: 1)
- `per_page` (int, default: 20, max: 100)

**Example:**
```
GET /api/v1/tracks/list.php?album_id=1&page=1&per_page=20
```

---

### POST /api/v1/tracks/play.php
Отметить прослушивание трека (требует JWT)

**Body:**
```json
{
  "track_id": 38
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": 38,
    "title": "1. Последний из драконов",
    "audio_url": "/public/uploads/full/...",
    "duration": 307,
    "duration_formatted": "05:07",
    "views": 1,
    "played_by_user": true
  },
  "message": "Track play recorded"
}
```

---

### GET /api/v1/tracks/search.php
Поиск треков

**Parameters:**
- `q` (string, required, 2-100 chars) - Поисковый запрос
- `page` (int, default: 1)
- `per_page` (int, default: 20, max: 100)

**Example:**
```
GET /api/v1/tracks/search.php?q=драконов&page=1&per_page=20
```

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": 38,
      "title": "1. Последний из драконов",
      "audio_url": "/public/uploads/full/...",
      "duration": 307,
      "duration_formatted": "05:07",
      "views": 0,
      "album": {
        "id": 1,
        "title": "Хроники забытых миров"
      }
    }
  ],
  "pagination": {
    "total": 1,
    "page": 1,
    "per_page": 20,
    "total_pages": 1,
    "has_next": false,
    "has_prev": false
  }
}
```

---

## 📰 News Endpoints

### GET /api/v1/news/list.php
Получить список новостей

**Parameters:**
- `page` (int, default: 1)
- `per_page` (int, default: 10, max: 100)
- `category` (string, optional) - release, event, update

**Example:**
```
GET /api/v1/news/list.php?page=1&per_page=10&category=release
```

---

### GET /api/v1/news/detail.php
Получить деталь новости

**Parameters:**
- `id` (int, required) - ID новости

**Example:**
```
GET /api/v1/news/detail.php?id=1
```

---

## 🖼️ Gallery Endpoint

### GET /api/v1/gallery/list.php
Получить список фотографий

**Parameters:**
- `page` (int, default: 1)
- `per_page` (int, default: 12, max: 100)
- `category` (string, optional) - studio, concert, event, promo

**Example:**
```
GET /api/v1/gallery/list.php?page=1&per_page=12&category=studio
```

---

## 💬 Chat Endpoints

### GET /api/v1/chat/rooms.php
Получить список комнат чата (требует JWT)

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
```

**Example:**
```
GET /api/v1/chat/rooms.php
```

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": 9,
      "name": "General",
      "slug": "general",
      "description": "🎸 Основной чат",
      "icon": "🎸",
      "is_private": false,
      "messages_count": 284,
      "last_message": {
        "text": "Слушаю новый альбом!",
        "username": "dncdante",
        "created_at": "2025-10-21 15:30:45"
      }
    }
  ]
}
```

---

### GET /api/v1/chat/messages.php
Получить сообщения комнаты (требует JWT)

**Parameters:**
- `room_id` (int, required)
- `limit` (int, default: 50, max: 100)
- `offset` (int, default: 0)

**Example:**
```
GET /api/v1/chat/messages.php?room_id=9&limit=50&offset=0
Authorization: Bearer <JWT_TOKEN>
```

---

### POST /api/v1/chat/send.php
Отправить сообщение в чат (требует JWT)

**Body:**
```json
{
  "room_id": 9,
  "message": "Привет, ребята!"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "id": 285,
    "message": "Привет, ребята!",
    "username": "dncdante",
    "created_at": "2025-10-21 15:35:22",
    "timestamp": "15:35"
  },
  "message": "Message sent successfully"
}
```

---

## 👤 User Endpoint

### GET /api/v1/user/profile.php
Получить профиль пользователя (требует JWT)

**Headers:**
```
Authorization: Bearer <JWT_TOKEN>
```

**Example:**
```
GET /api/v1/user/profile.php
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "username": "dncdante",
    "email": "user@email.com",
    "display_name": "dncdante",
    "bio": "Power Metal фан",
    "status": "online",
    "theme": "dark",
    "notifications_enabled": true,
    "statistics": {
      "plays": 42,
      "room_messages": 128,
      "favorites": 5
    }
  }
}
```

---

### PUT /api/v1/user/profile.php
Обновить профиль пользователя (требует JWT)

**Body:**
```json
{
  "display_name": "Новое имя",
  "bio": "Новая биография",
  "theme": "gothic",
  "notifications_enabled": true
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "display_name": "Новое имя",
    "bio": "Новая биография",
    "theme": "gothic"
  },
  "message": "Profile updated successfully"
}
```

---

## 🔧 Вспомогательные классы

**Папка:** `/include_config/`

1. **JWTHandler.php** - Управление JWT токенами
   - `generateToken($user_id, $username, $email)` - Создать токен
   - `verifyToken($token)` - Проверить токен
   - `getTokenFromHeaders()` - Получить токен из заголовков

2. **APIResponse.php** - Стандартные API ответы
   - `success($data, $code, $message)`
   - `error($error, $code, $details)`
   - `unauthorized($message)`
   - `validationError($errors)`
   - `paginated($data, $total, $page, $per_page)`

3. **APILogger.php** - Логирование всех запросов и ошибок
   - `logRequest($endpoint, $method, $user_id, $data)`
   - `logResponse($endpoint, $code, $user_id, $response_time)`
   - `logError($endpoint, $error, $code, $user_id, $context)`
   - `logException($endpoint, $exception, $user_id)`

**Логи находятся в:** `/var/log/master-of-illusion/api_YYYY-MM-DD.log`

---

## ⚠️ Коды ошибок

| Код | Описание |
|-----|---------|
| 200 | OK - Успешный запрос |
| 201 | Created - Ресурс создан |
| 400 | Bad Request - Неверный запрос |
| 401 | Unauthorized - Требуется авторизация |
| 403 | Forbidden - Доступ запрещен |
| 404 | Not Found - Ресурс не найден |
| 405 | Method Not Allowed - Метод не допущен |
| 422 | Validation Failed - Ошибки валидации |
| 429 | Too Many Requests - Превышен rate limit |
| 500 | Internal Server Error - Ошибка сервера |

---

## 🚀 Примеры использования (cURL)

### Регистрация
```bash
curl -X POST https://lovix.top/api/v1/auth/register.php \
  -H "Content-Type: application/json" \
  -d '{
    "username": "newuser",
    "email": "new@email.com",
    "password": "SecurePass123",
    "password_confirm": "SecurePass123",
    "display_name": "New User"
  }'
```

### Вход
```bash
curl -X POST https://lovix.top/api/v1/auth/login.php \
  -H "Content-Type: application/json" \
  -d '{
    "username": "dncdante",
    "password": "password123"
  }'
```

### Получить альбомы
```bash
curl -X GET "https://lovix.top/api/v1/albums/list.php?page=1&per_page=10"
```

### Получить профиль (с авторизацией)
```bash
curl -X GET https://lovix.top/api/v1/user/profile.php \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### Поиск треков
```bash
curl -X GET "https://lovix.top/api/v1/tracks/search.php?q=драконов&page=1"
```

### Отправить сообщение в чат
```bash
curl -X POST https://lovix.top/api/v1/chat/send.php \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -d '{
    "room_id": 9,
    "message": "Привет, ребята!"
  }'
```

---

## 📞 CORS

API поддерживает CORS для всех доменов. В production ограничить на:
```
Access-Control-Allow-Origin: https://moi-band.com.ua
```

---

**Версия документации:** 1.0  
**Последнее обновление:** 21.10.2025