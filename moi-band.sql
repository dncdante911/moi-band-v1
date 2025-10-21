-- phpMyAdmin SQL Dump
-- version 5.2.1deb3
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Окт 21 2025 г., 12:59
-- Версия сервера: 10.11.13-MariaDB-0ubuntu0.24.04.1
-- Версия PHP: 8.3.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `moi-band`
--

-- --------------------------------------------------------

--
-- Структура таблицы `Albums`
--

CREATE TABLE `Albums` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `coverImagePath` varchar(255) NOT NULL,
  `releaseDate` date DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `Albums`
--

INSERT INTO `Albums` (`id`, `title`, `description`, `coverImagePath`, `releaseDate`, `createdAt`, `updatedAt`) VALUES
(3, 'Хроники забытых миров', '«Хроники забытых миров» — это музыкальное путешествие длиной в 12 треков через\r\nлегенды, которые мир забыл. От пробуждения древних стражей до триумфального\r\nрассвета новой эры — альбом проводит слушателя через эпические битвы, мифические\r\nвозрождения, трагические падения и лирические истории о любви и потере.', '/public/uploads/album_covers/68f4f7da160db.png', '2025-09-25', '2025-10-19 17:38:18', '2025-10-19 17:38:18'),
(4, 'Эхо миров', '', '/public/uploads/album_covers/68f521f7f26c8.webp', '2024-12-19', '2025-10-19 20:37:59', '2025-10-19 20:37:59'),
(5, 'Театр крови и костей (Live)', '', '/public/uploads/album_covers/68f5233f80410.png', '2025-06-27', '2025-10-19 20:43:27', '2025-10-19 20:43:27'),
(6, 'Нескоренна земля', '', '/public/uploads/album_covers/68f7301192cbb.jpg', '2024-12-30', '2025-10-21 10:02:41', '2025-10-21 10:02:41');

-- --------------------------------------------------------

--
-- Структура таблицы `ChatMessages`
--

CREATE TABLE `ChatMessages` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_edited` tinyint(1) DEFAULT 0,
  `is_deleted` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `Events`
--

CREATE TABLE `Events` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `event_type` enum('concert','release','announcement','stream') DEFAULT 'announcement',
  `event_date` datetime NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `ticket_url` varchar(500) DEFAULT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `Favorites`
--

CREATE TABLE `Favorites` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `track_id` int(11) NOT NULL,
  `addedAt` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `gallery`
--

CREATE TABLE `gallery` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `category` varchar(50) NOT NULL DEFAULT 'studio' COMMENT 'studio, concert, event, promo',
  `image_url` varchar(500) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `news`
--

CREATE TABLE `news` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `category` varchar(50) NOT NULL DEFAULT 'update' COMMENT 'release, event, update',
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `news`
--

INSERT INTO `news` (`id`, `title`, `content`, `category`, `image`, `created_at`, `updated_at`) VALUES
(1, 'test', 'test', 'event', '', '2025-10-20 20:28:03', '2025-10-20 20:28:03');

-- --------------------------------------------------------

--
-- Структура таблицы `PlayHistory`
--

CREATE TABLE `PlayHistory` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `track_id` int(11) NOT NULL,
  `playedAt` datetime DEFAULT current_timestamp(),
  `duration_played` int(11) DEFAULT NULL COMMENT 'Сколько секунд сыграло'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `Playlists`
--

CREATE TABLE `Playlists` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `coverImagePath` varchar(255) DEFAULT NULL,
  `isPublic` tinyint(1) DEFAULT 0,
  `createdAt` datetime DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `PlaylistTracks`
--

CREATE TABLE `PlaylistTracks` (
  `id` int(11) NOT NULL,
  `playlist_id` int(11) NOT NULL,
  `track_id` int(11) NOT NULL,
  `position` int(11) NOT NULL,
  `addedAt` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `PlayQueue`
--

CREATE TABLE `PlayQueue` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `current_track_id` int(11) DEFAULT NULL,
  `queue_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'JSON с идами треков в очереди' CHECK (json_valid(`queue_data`)),
  `currentTime` int(11) DEFAULT 0 COMMENT 'Текущая позиция в секундах',
  `isPlaying` tinyint(1) DEFAULT 0,
  `updatedAt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `Posts`
--

CREATE TABLE `Posts` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `imageUrl` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп данных таблицы `Posts`
--

INSERT INTO `Posts` (`id`, `title`, `content`, `imageUrl`, `createdAt`, `updatedAt`) VALUES
(3, 'тест', 'тест новостей, и смотр внешнего вида', NULL, '2025-10-18 20:06:52', '2025-10-18 20:06:52');

-- --------------------------------------------------------

--
-- Структура таблицы `Ratings`
--

CREATE TABLE `Ratings` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `track_id` int(11) DEFAULT NULL,
  `album_id` int(11) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `RoomMessages`
--

CREATE TABLE `RoomMessages` (
  `id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `is_edited` tinyint(1) DEFAULT 0,
  `is_deleted` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `Rooms`
--

CREATE TABLE `Rooms` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `is_private` tinyint(1) DEFAULT 0,
  `created_by` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `Rooms`
--

INSERT INTO `Rooms` (`id`, `name`, `slug`, `description`, `icon`, `is_private`, `created_by`, `created_at`) VALUES
(9, 'General', 'general', '🎸 Основной чат для всех фанов Power Metal', '🎸', 0, 1, '2025-10-19 10:59:19'),
(10, 'Gothic Lounge', 'gothic', '🦇 Для поклонников Gothic Metal', '🦇', 0, 1, '2025-10-19 10:59:19'),
(11, 'Punk Garage', 'punk', '🤘 Энергичный punk-rock уголок', '🤘', 0, 1, '2025-10-19 10:59:19'),
(12, 'News & Announcements', 'news', '📢 Новости о группе и релизах', '📢', 0, 1, '2025-10-19 10:59:19');

-- --------------------------------------------------------

--
-- Структура таблицы `SongLyrics`
--

CREATE TABLE `SongLyrics` (
  `id` int(11) NOT NULL,
  `track_id` int(11) NOT NULL,
  `lyrics` longtext DEFAULT NULL,
  `createdAt` datetime DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `SongLyrics`
--

INSERT INTO `SongLyrics` (`id`, `track_id`, `lyrics`, `createdAt`, `updatedAt`) VALUES
(2, 38, '[Verse 1]\r\nВ далёких горах, где туман\r\nСкрывает древние руины\r\nСпит последний великан\r\nДракон забытой долины.\r\nВека прошли с тех пор\r\nКогда он правил небесами.\r\nТеперь лишь старый фольклор\r\nХранит память о деяньях.\r\n\r\nНо пламя в сердце не погасло,\r\nХоть мир забыл о чудесах.\r\nПришло время сбросить маски,\r\nИ вновь расправить два крыла!\r\n\r\n[Chorus]\r\nПоследний из драконов\r\nВосстанет из пепла.\r\nПройдёт сквозь все миры\r\nЛюдских забытых снов.\r\nОгненным дыханием,\r\nНебо озарит.\r\nИ древним заклинанием\r\nМир преобразит!\r\n\r\n[Verse 2]\r\nРыцари давно забыли,\r\nКак сражаться с ним.\r\nМечи от ржи затупились,\r\nВ век новых технологий.\r\nНо есть среди людей один,\r\nКто верит в старые сказанья.\r\nОн знает - мифов властелин\r\nВернётся для воздаянья.\r\n\r\nВедь пламя в сердце не погасло,\r\nХоть мир забыл о чудесах.\r\nПришло время сбросить маски,\r\nИ вновь расправить два крыла!\r\n\r\n[Chorus]\r\nПоследний из драконов\r\nВосстанет из пепла.\r\nПройдёт сквозь все миры\r\nЛюдских забытых снов.\r\nОгненным дыханием,\r\nНебо озарит.\r\nИ древним заклинанием\r\nМир преобразит!\r\n\r\n[Bridge]\r\nПроснись, великий дракон!\r\nТвой час настал опять\r\nРазрушь обмана закон\r\nИ магию верни назад!\r\n\r\n[Chorus]\r\nПоследний из драконов\r\nВосстал из глубины.\r\nСломал людские троны\r\nИ рушит их умы.\r\nЗолотым сияньем\r\nМир теперь объят.\r\nНовым мирозданьем\r\nПравит древний ритуал!', '2025-10-19 17:40:46', '2025-10-19 17:40:46');

-- --------------------------------------------------------

--
-- Структура таблицы `Track`
--

CREATE TABLE `Track` (
  `id` int(11) NOT NULL,
  `title` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `albumId` int(11) DEFAULT NULL,
  `coverImagePath` varchar(191) NOT NULL,
  `fullAudioPath` varchar(191) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `fossbillingProductId` int(11) DEFAULT NULL,
  `lyrics` text DEFAULT NULL,
  `lyricsPath` varchar(255) DEFAULT NULL,
  `videoPath` varchar(255) DEFAULT NULL,
  `videoCoverPath` varchar(255) DEFAULT NULL,
  `duration` int(11) DEFAULT 0 COMMENT 'Длительность в секундах',
  `views` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `Track`
--

INSERT INTO `Track` (`id`, `title`, `description`, `albumId`, `coverImagePath`, `fullAudioPath`, `createdAt`, `updatedAt`, `fossbillingProductId`, `lyrics`, `lyricsPath`, `videoPath`, `videoCoverPath`, `duration`, `views`) VALUES
(38, '1. Последний из драконов', '<br />\r\n<b>Deprecated</b>:  htmlspecialchars(): Passing null to parameter #1 ($string) of type string is deprecated in <b>/var/www/www-root/data/www/lovix.top/admin/edit_track.php</b> on line <b>279</b><br />', 3, '/public/uploads/album_covers/68f4f7da160db.png', '/public/uploads/full/68f4f84a937a2.wav', '2025-10-19 17:40:10.604', '2025-10-19 20:16:13', NULL, NULL, NULL, '/public/uploads/videos/68f51cdce1ecb.mp4', NULL, 307, 0),
(39, '2. Спящий Страж', NULL, 3, '/public/uploads/album_covers/68f4f7da160db.png', '/public/uploads/full/68f4f84a97462.mp3', '2025-10-19 17:40:10.619', '2025-10-19 17:40:10', NULL, NULL, NULL, NULL, NULL, 0, 0),
(40, '3. Стальной Легион', NULL, 3, '/public/uploads/album_covers/68f4f7da160db.png', '/public/uploads/full/68f4f84a994f4.wav', '2025-10-19 17:40:10.636', '2025-10-19 17:40:10', NULL, NULL, NULL, NULL, NULL, 0, 0),
(41, '4. Феникс', NULL, 3, '/public/uploads/album_covers/68f4f7da160db.png', '/public/uploads/full/68f4f84a9d600.wav', '2025-10-19 17:40:10.644', '2025-10-19 17:40:10', NULL, NULL, NULL, NULL, NULL, 0, 0),
(42, '5. Средиземье', NULL, 3, '/public/uploads/album_covers/68f4f7da160db.png', '/public/uploads/full/68f4f84a9f684.wav', '2025-10-19 17:40:10.653', '2025-10-19 17:40:10', NULL, NULL, NULL, NULL, NULL, 0, 0),
(43, '6. Прощальный взгляд', NULL, 3, '/public/uploads/album_covers/68f4f7da160db.png', '/public/uploads/full/68f4f84aa1726.wav', '2025-10-19 17:40:10.661', '2025-10-19 17:40:10', NULL, NULL, NULL, NULL, NULL, 0, 0),
(44, '7. Восхождение', NULL, 3, '/public/uploads/album_covers/68f4f7da160db.png', '/public/uploads/full/68f4f84aa37ba.wav', '2025-10-19 17:40:10.670', '2025-10-19 17:40:10', NULL, NULL, NULL, NULL, NULL, 0, 0),
(45, '8. изгнанник мира', NULL, 3, '/public/uploads/album_covers/68f4f7da160db.png', '/public/uploads/full/68f4f84aa583e.wav', '2025-10-19 17:40:10.678', '2025-10-19 17:40:10', NULL, NULL, NULL, NULL, NULL, 0, 0),
(46, '9. Ледяной трон', NULL, 3, '/public/uploads/album_covers/68f4f7da160db.png', '/public/uploads/full/68f4f84aa78c4.wav', '2025-10-19 17:40:10.686', '2025-10-19 17:40:10', NULL, NULL, NULL, NULL, NULL, 0, 0),
(47, '10. Цена Любви', NULL, 3, '/public/uploads/album_covers/68f4f7da160db.png', '/public/uploads/full/68f4f84aa9956.wav', '2025-10-19 17:40:10.695', '2025-10-19 17:40:10', NULL, NULL, NULL, NULL, NULL, 0, 0),
(48, '11. Последний рассвет', NULL, 3, '/public/uploads/album_covers/68f4f7da160db.png', '/public/uploads/full/68f4f84aab9eb.wav', '2025-10-19 17:40:10.703', '2025-10-19 17:40:10', NULL, NULL, NULL, NULL, NULL, 0, 0),
(49, '12. Симфония вечности', NULL, 3, '/public/uploads/album_covers/68f4f7da160db.png', '/public/uploads/full/68f4f84aada42.wav', '2025-10-19 17:40:10.711', '2025-10-19 17:40:10', NULL, NULL, NULL, NULL, NULL, 0, 0),
(50, '1 .Шаги на воде', NULL, 4, '/public/uploads/album_covers/68f521f7f26c8.webp', '/public/uploads/full/68f522237d8e1.mp3', '2025-10-19 20:38:43.514', '2025-10-19 20:38:43', NULL, NULL, NULL, NULL, NULL, 0, 0),
(51, '2. Бал Вечной Тьмы', NULL, 4, '/public/uploads/album_covers/68f521f7f26c8.webp', '/public/uploads/full/68f52223823d9.mp3', '2025-10-19 20:38:43.541', '2025-10-19 20:38:43', NULL, NULL, NULL, NULL, NULL, 0, 0),
(52, '3. Шёпот во тьме', NULL, 4, '/public/uploads/album_covers/68f521f7f26c8.webp', '/public/uploads/full/68f52223864e9.mp3', '2025-10-19 20:38:43.550', '2025-10-19 20:38:43', NULL, NULL, NULL, NULL, NULL, 0, 0),
(53, '4. Сияние в бездне', NULL, 4, '/public/uploads/album_covers/68f521f7f26c8.webp', '/public/uploads/full/68f522238856e.mp3', '2025-10-19 20:38:43.558', '2025-10-19 20:38:43', NULL, NULL, NULL, NULL, NULL, 0, 0),
(54, '5. Последний рассвет', NULL, 4, '/public/uploads/album_covers/68f521f7f26c8.webp', '/public/uploads/full/68f522238a5f9.mp3', '2025-10-19 20:38:43.567', '2025-10-19 20:38:43', NULL, NULL, NULL, NULL, NULL, 0, 0),
(55, '6. Ворон', NULL, 4, '/public/uploads/album_covers/68f521f7f26c8.webp', '/public/uploads/full/68f522238c654.mp3', '2025-10-19 20:38:43.575', '2025-10-19 20:38:43', NULL, NULL, NULL, NULL, NULL, 0, 0),
(56, '7. Аннабель Ли', NULL, 4, '/public/uploads/album_covers/68f521f7f26c8.webp', '/public/uploads/full/68f522238e717.mp3', '2025-10-19 20:38:43.583', '2025-10-19 20:38:43', NULL, NULL, NULL, NULL, NULL, 0, 0),
(57, '8. Мой создатель. История Франкенштейна', NULL, 4, '/public/uploads/album_covers/68f521f7f26c8.webp', '/public/uploads/full/68f5222390796.mp3', '2025-10-19 20:38:43.592', '2025-10-19 20:38:43', NULL, NULL, NULL, NULL, NULL, 0, 0),
(58, '9. Печать Мефистофеля', NULL, 4, '/public/uploads/album_covers/68f521f7f26c8.webp', '/public/uploads/full/68f522239280d.mp3', '2025-10-19 20:38:43.600', '2025-10-19 20:38:43', NULL, NULL, NULL, NULL, NULL, 0, 0),
(59, '10. Маска и тень', NULL, 4, '/public/uploads/album_covers/68f521f7f26c8.webp', '/public/uploads/full/68f52223948a7.mp3', '2025-10-19 20:38:43.608', '2025-10-19 20:38:43', NULL, NULL, NULL, NULL, NULL, 0, 0),
(60, '11. Phantom of the Opera (бонус)', NULL, 4, '/public/uploads/album_covers/68f521f7f26c8.webp', '/public/uploads/full/68f5222396936.mp3', '2025-10-19 20:38:43.617', '2025-10-19 20:38:43', NULL, NULL, NULL, NULL, NULL, 0, 0),
(61, '1. Скелет под чердаком', NULL, 5, '/public/uploads/album_covers/68f5233f80410.png', '/public/uploads/full/68f523c9489c2.wav', '2025-10-19 20:45:45.297', '2025-10-19 20:45:45', NULL, NULL, NULL, NULL, NULL, 0, 0),
(62, '2. анархист-революционер', NULL, 5, '/public/uploads/album_covers/68f5233f80410.png', '/public/uploads/full/68f523c952c7b.wav', '2025-10-19 20:45:45.339', '2025-10-19 20:45:45', NULL, NULL, NULL, NULL, NULL, 0, 0),
(63, '3. Грим под гробовой свет', NULL, 5, '/public/uploads/album_covers/68f5233f80410.png', '/public/uploads/full/68f523c95f679.wav', '2025-10-19 20:45:45.391', '2025-10-19 20:45:45', NULL, NULL, NULL, NULL, NULL, 0, 0),
(64, '4. Баллада о рубщике голов', NULL, 5, '/public/uploads/album_covers/68f5233f80410.png', '/public/uploads/full/68f523c96b73d.wav', '2025-10-19 20:45:45.441', '2025-10-19 20:45:45', NULL, NULL, NULL, NULL, NULL, 0, 0),
(65, '5. Дом, что смотрит в след', NULL, 5, '/public/uploads/album_covers/68f5233f80410.png', '/public/uploads/full/68f523c977cef.wav', '2025-10-19 20:45:45.571', '2025-10-19 20:45:45', NULL, NULL, NULL, NULL, NULL, 0, 0),
(66, '6. Гробовщик с гармошкой', NULL, 5, '/public/uploads/album_covers/68f5233f80410.png', '/public/uploads/full/68f523c998736.wav', '2025-10-19 20:45:45.625', '2025-10-19 20:45:45', NULL, NULL, NULL, NULL, NULL, 0, 0),
(67, '7. Кукловод', NULL, 5, '/public/uploads/album_covers/68f5233f80410.png', '/public/uploads/full/68f523c9a8d1b.wav', '2025-10-19 20:45:45.692', '2025-10-19 20:45:45', NULL, NULL, NULL, NULL, NULL, 0, 0),
(68, '8. Зеркало без отражения', NULL, 5, '/public/uploads/album_covers/68f5233f80410.png', '/public/uploads/full/68f523c9b4d65.wav', '2025-10-19 20:45:45.741', '2025-10-19 20:45:45', NULL, NULL, NULL, NULL, NULL, 0, 0),
(69, '9. Письмо из ниоткуда', NULL, 5, '/public/uploads/album_covers/68f5233f80410.png', '/public/uploads/full/68f523c9c51bc.wav', '2025-10-19 20:45:45.808', '2025-10-19 20:45:45', NULL, NULL, NULL, NULL, NULL, 0, 0),
(70, '10. Охотник За Душами', NULL, 5, '/public/uploads/album_covers/68f5233f80410.png', '/public/uploads/full/68f523c9cfb3d.mp3', '2025-10-19 20:45:45.851', '2025-10-19 20:45:45', NULL, NULL, NULL, NULL, NULL, 0, 0),
(71, '11. Сон в лапах медведя', NULL, 5, '/public/uploads/album_covers/68f5233f80410.png', '/public/uploads/full/68f523c9d7ec7.wav', '2025-10-19 20:45:45.885', '2025-10-19 20:45:45', NULL, NULL, NULL, NULL, NULL, 0, 0),
(72, '12. Полярный адмирал', NULL, 5, '/public/uploads/album_covers/68f5233f80410.png', '/public/uploads/full/68f523c9e2fa8.wav', '2025-10-19 20:45:45.930', '2025-10-19 20:45:45', NULL, NULL, NULL, NULL, NULL, 0, 0),
(73, '13. Театр крови', NULL, 5, '/public/uploads/album_covers/68f5233f80410.png', '/public/uploads/full/68f523c9ec766.wav', '2025-10-19 20:45:45.970', '2025-10-19 20:45:45', NULL, NULL, NULL, NULL, NULL, 0, 0),
(74, '14. Торговец теней', NULL, 5, '/public/uploads/album_covers/68f5233f80410.png', '/public/uploads/full/68f523ca00bdc.wav', '2025-10-19 20:45:46.003', '2025-10-19 20:45:46', NULL, NULL, NULL, NULL, NULL, 0, 0),
(75, '15. У тётки Агаты', NULL, 5, '/public/uploads/album_covers/68f5233f80410.png', '/public/uploads/full/68f523ca03ccc.wav', '2025-10-19 20:45:46.016', '2025-10-19 20:45:46', NULL, NULL, NULL, NULL, NULL, 0, 0),
(76, '16. Хозяйка часов', NULL, 5, '/public/uploads/album_covers/68f5233f80410.png', '/public/uploads/full/68f523ca05d3d.wav', '2025-10-19 20:45:46.024', '2025-10-19 20:45:46', NULL, NULL, NULL, NULL, NULL, 0, 0),
(77, '17. Театр живых - поппури', NULL, 5, '/public/uploads/album_covers/68f5233f80410.png', '/public/uploads/full/68f523ca112eb.wav', '2025-10-19 20:45:46.071', '2025-10-19 20:45:46', NULL, NULL, NULL, NULL, NULL, 0, 0),
(78, '1. Крила свободи', NULL, 6, '/public/uploads/album_covers/68f7301192cbb.jpg', '/public/uploads/full/68f7303e57aeb.mp3', '2025-10-21 10:03:26.359', '2025-10-21 10:03:26', NULL, NULL, NULL, NULL, NULL, 0, 0),
(79, '2. Вогонь у венах', NULL, 6, '/public/uploads/album_covers/68f7301192cbb.jpg', '/public/uploads/full/68f7303e65931.mp3', '2025-10-21 10:03:26.421', '2025-10-21 10:03:26', NULL, NULL, NULL, NULL, NULL, 0, 0),
(80, '3. Відлуння серця', NULL, 6, '/public/uploads/album_covers/68f7301192cbb.jpg', '/public/uploads/full/68f7303eaff92.mp3', '2025-10-21 10:03:26.721', '2025-10-21 10:03:26', NULL, NULL, NULL, NULL, NULL, 0, 0),
(81, '4. Крила вогню', NULL, 6, '/public/uploads/album_covers/68f7301192cbb.jpg', '/public/uploads/full/68f7303ec2b31.mp3', '2025-10-21 10:03:26.798', '2025-10-21 10:03:26', NULL, NULL, NULL, NULL, NULL, 0, 0),
(82, '5. Крізь відстань', NULL, 6, '/public/uploads/album_covers/68f7301192cbb.jpg', '/public/uploads/full/68f7303ecd89c.mp3', '2025-10-21 10:03:26.842', '2025-10-21 10:03:26', NULL, NULL, NULL, NULL, NULL, 0, 0),
(83, '6. Повна тиша', NULL, 6, '/public/uploads/album_covers/68f7301192cbb.jpg', '/public/uploads/full/68f7303ed5bfc.mp3', '2025-10-21 10:03:26.876', '2025-10-21 10:03:26', NULL, NULL, NULL, NULL, NULL, 0, 0),
(84, '7. Тінь між зорями', NULL, 6, '/public/uploads/album_covers/68f7301192cbb.jpg', '/public/uploads/full/68f7303edc479.mp3', '2025-10-21 10:03:26.910', '2025-10-21 10:03:26', NULL, NULL, NULL, NULL, NULL, 0, 0),
(85, '8. Нескорена земля', NULL, 6, '/public/uploads/album_covers/68f7301192cbb.jpg', '/public/uploads/full/68f7303ee05a7.mp3', '2025-10-21 10:03:26.919', '2025-10-21 10:03:26', NULL, NULL, NULL, NULL, NULL, 0, 0),
(86, '9. Світло в темряві', NULL, 6, '/public/uploads/album_covers/68f7301192cbb.jpg', '/public/uploads/full/68f7303ee261b.mp3', '2025-10-21 10:03:26.927', '2025-10-21 10:03:26', NULL, NULL, NULL, NULL, NULL, 0, 0),
(87, '10. Сила в серці', NULL, 6, '/public/uploads/album_covers/68f7301192cbb.jpg', '/public/uploads/full/68f7303ee676c.mp3', '2025-10-21 10:03:26.944', '2025-10-21 10:03:26', NULL, NULL, NULL, NULL, NULL, 0, 0),
(88, '11. Чорний попіл', NULL, 6, '/public/uploads/album_covers/68f7301192cbb.jpg', '/public/uploads/full/68f7303ee87d6.mp3', '2025-10-21 10:03:26.952', '2025-10-21 10:03:26', NULL, NULL, NULL, NULL, NULL, 0, 0),
(89, '12. Янголи', NULL, 6, '/public/uploads/album_covers/68f7301192cbb.jpg', '/public/uploads/full/68f7303eea86e.mp3', '2025-10-21 10:03:26.961', '2025-10-21 10:03:26', NULL, NULL, NULL, NULL, NULL, 0, 0),
(90, '13. Чорний попіл (бонус, женский вокал)', NULL, 6, '/public/uploads/album_covers/68f7301192cbb.jpg', '/public/uploads/full/68f7303eec8e1.mp3', '2025-10-21 10:03:26.969', '2025-10-21 10:03:26', NULL, NULL, NULL, NULL, NULL, 0, 0),
(91, '14. Phantom of the Opera (бонус)', NULL, 6, '/public/uploads/album_covers/68f7301192cbb.jpg', '/public/uploads/full/68f7303eee97f.mp3', '2025-10-21 10:03:26.977', '2025-10-21 10:03:26', NULL, NULL, NULL, NULL, NULL, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `TrackLikes`
--

CREATE TABLE `TrackLikes` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `track_id` int(11) NOT NULL,
  `createdAt` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `UserDeviceTokens`
--

CREATE TABLE `UserDeviceTokens` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `device_token` varchar(500) NOT NULL,
  `device_type` enum('android','ios') NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `UserPreferences`
--

CREATE TABLE `UserPreferences` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `favorite_tracks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`favorite_tracks`)),
  `favorite_albums` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`favorite_albums`)),
  `notifications_enabled` tinyint(1) DEFAULT 1,
  `email_notifications` tinyint(1) DEFAULT 0,
  `theme` enum('dark','light','gothic','punk') DEFAULT 'dark',
  `language` varchar(5) DEFAULT 'ru',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `UserPreferences`
--

INSERT INTO `UserPreferences` (`id`, `user_id`, `favorite_tracks`, `favorite_albums`, `notifications_enabled`, `email_notifications`, `theme`, `language`, `created_at`, `updated_at`) VALUES
(1, 1, NULL, NULL, 1, 0, 'dark', 'ru', '2025-10-19 10:59:19', '2025-10-19 10:59:19'),
(2, 2, NULL, NULL, 1, 0, 'dark', 'ru', '2025-10-19 11:23:36', '2025-10-19 11:25:56'),
(3, 3, NULL, NULL, 1, 0, 'dark', 'ru', '2025-10-21 09:52:48', '2025-10-21 09:52:48');

-- --------------------------------------------------------

--
-- Структура таблицы `Users`
--

CREATE TABLE `Users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `display_name` varchar(150) DEFAULT NULL,
  `avatar_path` varchar(255) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `status` enum('online','away','offline') DEFAULT 'offline',
  `last_seen` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_verified` tinyint(1) DEFAULT 0,
  `is_banned` tinyint(1) DEFAULT 0,
  `is_admin` tinyint(1) DEFAULT 0,
  `verification_token` varchar(255) DEFAULT NULL,
  `verification_expires` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `Users`
--

INSERT INTO `Users` (`id`, `username`, `email`, `password_hash`, `display_name`, `avatar_path`, `bio`, `status`, `last_seen`, `created_at`, `updated_at`, `is_verified`, `is_banned`, `is_admin`, `verification_token`, `verification_expires`) VALUES
(1, 'admin', 'admin@lovix.top', '$2y$12$t2X3dPjVV3u3i8V8xK2V0eZ2Z3Z3Z3Z3Z3Z3Z3Z3Z3Z3Z3Z3Z3Z3Z3Z3', 'Administrator', NULL, NULL, 'online', NULL, '2025-10-19 10:59:19', '2025-10-19 10:59:19', 1, 0, 1, NULL, NULL),
(2, 'dncdante', 'nfsdante@gmail.com', '$argon2id$v=19$m=65536,t=4,p=1$Vk5DeW5sWGJnN3NLY2FwYQ$2t14wnpfvnikpVOKGWaH3LP3yJBOjUKgOTHbkgUnzJA', 'dncdante', NULL, NULL, 'online', NULL, '2025-10-19 11:23:36', '2025-10-19 11:23:36', 0, 0, 0, '251fb5ec54910b63b1618003a7c0f03293c8f420c7d8efc5a4ec2a5a7ee102a9', '2025-10-20 11:23:36'),
(3, 'hwwliegxzd', 'hiwuiwyj@testform.xyz', '$argon2id$v=19$m=65536,t=4,p=1$Z1VOanJNV0ZpbXEzLzdwNw$80yi4ypEULrkH6m3MssOCmAxApznl2mW7jv45M2UlA4', 'yshuljwpvr', NULL, NULL, 'online', NULL, '2025-10-21 09:52:48', '2025-10-21 09:52:48', 0, 0, 0, '90692cf9a510e1c64f2cab67af9cafe85536197a1ae94f8ce6c6618d228e76df', '2025-10-22 09:52:48');

-- --------------------------------------------------------

--
-- Структура таблицы `VideoClips`
--

CREATE TABLE `VideoClips` (
  `id` int(11) NOT NULL,
  `track_id` int(11) NOT NULL,
  `videoPath` varchar(255) NOT NULL,
  `coverImagePath` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `duration` int(11) DEFAULT NULL COMMENT 'Длительность видео в секундах',
  `views` int(11) DEFAULT 0,
  `createdAt` datetime DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `Albums`
--
ALTER TABLE `Albums`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `ChatMessages`
--
ALTER TABLE `ChatMessages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_created` (`created_at`);

--
-- Индексы таблицы `Events`
--
ALTER TABLE `Events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_date` (`event_date`),
  ADD KEY `idx_type` (`event_type`);

--
-- Индексы таблицы `Favorites`
--
ALTER TABLE `Favorites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_favorite` (`user_id`,`track_id`),
  ADD KEY `track_id` (`track_id`),
  ADD KEY `idx_user` (`user_id`);

--
-- Индексы таблицы `gallery`
--
ALTER TABLE `gallery`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_created` (`created_at`),
  ADD KEY `idx_gallery_category` (`category`);

--
-- Индексы таблицы `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_category` (`category`),
  ADD KEY `idx_created` (`created_at`),
  ADD KEY `idx_news_category` (`category`);

--
-- Индексы таблицы `PlayHistory`
--
ALTER TABLE `PlayHistory`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_track` (`track_id`),
  ADD KEY `idx_played_at` (`playedAt`),
  ADD KEY `idx_play_history_user` (`user_id`);

--
-- Индексы таблицы `Playlists`
--
ALTER TABLE `Playlists`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_public` (`isPublic`);

--
-- Индексы таблицы `PlaylistTracks`
--
ALTER TABLE `PlaylistTracks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_playlist_track` (`playlist_id`,`track_id`),
  ADD KEY `track_id` (`track_id`),
  ADD KEY `idx_playlist` (`playlist_id`);

--
-- Индексы таблицы `PlayQueue`
--
ALTER TABLE `PlayQueue`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD KEY `current_track_id` (`current_track_id`);

--
-- Индексы таблицы `Posts`
--
ALTER TABLE `Posts`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `Ratings`
--
ALTER TABLE `Ratings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_track` (`user_id`,`track_id`),
  ADD UNIQUE KEY `unique_user_album` (`user_id`,`album_id`),
  ADD KEY `track_id` (`track_id`),
  ADD KEY `album_id` (`album_id`);

--
-- Индексы таблицы `RoomMessages`
--
ALTER TABLE `RoomMessages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_room` (`room_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_created` (`created_at`),
  ADD KEY `idx_room_messages_room` (`room_id`);

--
-- Индексы таблицы `Rooms`
--
ALTER TABLE `Rooms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `idx_slug` (`slug`);

--
-- Индексы таблицы `SongLyrics`
--
ALTER TABLE `SongLyrics`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `track_id` (`track_id`);

--
-- Индексы таблицы `Track`
--
ALTER TABLE `Track`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Track_albumId_fkey` (`albumId`),
  ADD KEY `idx_track_album` (`albumId`);

--
-- Индексы таблицы `TrackLikes`
--
ALTER TABLE `TrackLikes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_track` (`user_id`,`track_id`),
  ADD KEY `track_id` (`track_id`),
  ADD KEY `idx_user` (`user_id`);

--
-- Индексы таблицы `UserDeviceTokens`
--
ALTER TABLE `UserDeviceTokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `UserPreferences`
--
ALTER TABLE `UserPreferences`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Индексы таблицы `Users`
--
ALTER TABLE `Users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_status` (`status`);

--
-- Индексы таблицы `VideoClips`
--
ALTER TABLE `VideoClips`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_track` (`track_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `Albums`
--
ALTER TABLE `Albums`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `ChatMessages`
--
ALTER TABLE `ChatMessages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `Events`
--
ALTER TABLE `Events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `Favorites`
--
ALTER TABLE `Favorites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `gallery`
--
ALTER TABLE `gallery`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `news`
--
ALTER TABLE `news`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `PlayHistory`
--
ALTER TABLE `PlayHistory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `Playlists`
--
ALTER TABLE `Playlists`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `PlaylistTracks`
--
ALTER TABLE `PlaylistTracks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `PlayQueue`
--
ALTER TABLE `PlayQueue`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `Posts`
--
ALTER TABLE `Posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `Ratings`
--
ALTER TABLE `Ratings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `RoomMessages`
--
ALTER TABLE `RoomMessages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `Rooms`
--
ALTER TABLE `Rooms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT для таблицы `SongLyrics`
--
ALTER TABLE `SongLyrics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `Track`
--
ALTER TABLE `Track`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92;

--
-- AUTO_INCREMENT для таблицы `TrackLikes`
--
ALTER TABLE `TrackLikes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `UserDeviceTokens`
--
ALTER TABLE `UserDeviceTokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `UserPreferences`
--
ALTER TABLE `UserPreferences`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `Users`
--
ALTER TABLE `Users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `VideoClips`
--
ALTER TABLE `VideoClips`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `ChatMessages`
--
ALTER TABLE `ChatMessages`
  ADD CONSTRAINT `ChatMessages_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `Favorites`
--
ALTER TABLE `Favorites`
  ADD CONSTRAINT `Favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `Favorites_ibfk_2` FOREIGN KEY (`track_id`) REFERENCES `Track` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `PlayHistory`
--
ALTER TABLE `PlayHistory`
  ADD CONSTRAINT `PlayHistory_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `PlayHistory_ibfk_2` FOREIGN KEY (`track_id`) REFERENCES `Track` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `Playlists`
--
ALTER TABLE `Playlists`
  ADD CONSTRAINT `Playlists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `PlaylistTracks`
--
ALTER TABLE `PlaylistTracks`
  ADD CONSTRAINT `PlaylistTracks_ibfk_1` FOREIGN KEY (`playlist_id`) REFERENCES `Playlists` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `PlaylistTracks_ibfk_2` FOREIGN KEY (`track_id`) REFERENCES `Track` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `PlayQueue`
--
ALTER TABLE `PlayQueue`
  ADD CONSTRAINT `PlayQueue_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `PlayQueue_ibfk_2` FOREIGN KEY (`current_track_id`) REFERENCES `Track` (`id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `Ratings`
--
ALTER TABLE `Ratings`
  ADD CONSTRAINT `Ratings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `Ratings_ibfk_2` FOREIGN KEY (`track_id`) REFERENCES `Track` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `Ratings_ibfk_3` FOREIGN KEY (`album_id`) REFERENCES `Albums` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `RoomMessages`
--
ALTER TABLE `RoomMessages`
  ADD CONSTRAINT `RoomMessages_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `Rooms` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `RoomMessages_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `Rooms`
--
ALTER TABLE `Rooms`
  ADD CONSTRAINT `Rooms_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `Users` (`id`);

--
-- Ограничения внешнего ключа таблицы `SongLyrics`
--
ALTER TABLE `SongLyrics`
  ADD CONSTRAINT `SongLyrics_ibfk_1` FOREIGN KEY (`track_id`) REFERENCES `Track` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `Track`
--
ALTER TABLE `Track`
  ADD CONSTRAINT `Track_albumId_fkey` FOREIGN KEY (`albumId`) REFERENCES `Albums` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `TrackLikes`
--
ALTER TABLE `TrackLikes`
  ADD CONSTRAINT `TrackLikes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `TrackLikes_ibfk_2` FOREIGN KEY (`track_id`) REFERENCES `Track` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `UserDeviceTokens`
--
ALTER TABLE `UserDeviceTokens`
  ADD CONSTRAINT `UserDeviceTokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `UserPreferences`
--
ALTER TABLE `UserPreferences`
  ADD CONSTRAINT `UserPreferences_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `VideoClips`
--
ALTER TABLE `VideoClips`
  ADD CONSTRAINT `VideoClips_ibfk_1` FOREIGN KEY (`track_id`) REFERENCES `Track` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
