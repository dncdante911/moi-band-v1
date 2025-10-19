/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.13-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: moi-band
-- ------------------------------------------------------
-- Server version	10.11.13-MariaDB-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Albums`
--

DROP TABLE IF EXISTS `Albums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Albums` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `coverImagePath` varchar(255) NOT NULL,
  `releaseDate` date DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Albums`
--

LOCK TABLES `Albums` WRITE;
/*!40000 ALTER TABLE `Albums` DISABLE KEYS */;
INSERT INTO `Albums` VALUES
(2,'Хроники забытых миров','«Хроники забытых миров» — это музыкальное путешествие длиной в 12 треков через\r\nлегенды, которые мир забыл. От пробуждения древних стражей до триумфального\r\nрассвета новой эры — альбом проводит слушателя через эпические битвы, мифические\r\nвозрождения, трагические падения и лирические истории о любви и потере.','/public/uploads/album_covers/68f4dc911d0b5.png','2025-08-25','2025-10-19 15:41:53','2025-10-19 15:41:53');
/*!40000 ALTER TABLE `Albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ChatMessages`
--

DROP TABLE IF EXISTS `ChatMessages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ChatMessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_edited` tinyint(1) DEFAULT 0,
  `is_deleted` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_created` (`created_at`),
  CONSTRAINT `ChatMessages_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ChatMessages`
--

LOCK TABLES `ChatMessages` WRITE;
/*!40000 ALTER TABLE `ChatMessages` DISABLE KEYS */;
/*!40000 ALTER TABLE `ChatMessages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Events`
--

DROP TABLE IF EXISTS `Events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `event_type` enum('concert','release','announcement','stream') DEFAULT 'announcement',
  `event_date` datetime NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `ticket_url` varchar(500) DEFAULT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_date` (`event_date`),
  KEY `idx_type` (`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Events`
--

LOCK TABLES `Events` WRITE;
/*!40000 ALTER TABLE `Events` DISABLE KEYS */;
/*!40000 ALTER TABLE `Events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Posts`
--

DROP TABLE IF EXISTS `Posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `imageUrl` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Posts`
--

LOCK TABLES `Posts` WRITE;
/*!40000 ALTER TABLE `Posts` DISABLE KEYS */;
INSERT INTO `Posts` VALUES
(3,'тест','тест новостей, и смотр внешнего вида',NULL,'2025-10-18 20:06:52','2025-10-18 20:06:52');
/*!40000 ALTER TABLE `Posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Ratings`
--

DROP TABLE IF EXISTS `Ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `track_id` int(11) DEFAULT NULL,
  `album_id` int(11) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_track` (`user_id`,`track_id`),
  UNIQUE KEY `unique_user_album` (`user_id`,`album_id`),
  KEY `track_id` (`track_id`),
  KEY `album_id` (`album_id`),
  CONSTRAINT `Ratings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Ratings_ibfk_2` FOREIGN KEY (`track_id`) REFERENCES `Track` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Ratings_ibfk_3` FOREIGN KEY (`album_id`) REFERENCES `Albums` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ratings`
--

LOCK TABLES `Ratings` WRITE;
/*!40000 ALTER TABLE `Ratings` DISABLE KEYS */;
/*!40000 ALTER TABLE `Ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RoomMessages`
--

DROP TABLE IF EXISTS `RoomMessages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `RoomMessages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `room_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `is_edited` tinyint(1) DEFAULT 0,
  `is_deleted` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_room` (`room_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_created` (`created_at`),
  CONSTRAINT `RoomMessages_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `Rooms` (`id`) ON DELETE CASCADE,
  CONSTRAINT `RoomMessages_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RoomMessages`
--

LOCK TABLES `RoomMessages` WRITE;
/*!40000 ALTER TABLE `RoomMessages` DISABLE KEYS */;
/*!40000 ALTER TABLE `RoomMessages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Rooms`
--

DROP TABLE IF EXISTS `Rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Rooms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `is_private` tinyint(1) DEFAULT 0,
  `created_by` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `created_by` (`created_by`),
  KEY `idx_slug` (`slug`),
  CONSTRAINT `Rooms_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `Users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Rooms`
--

LOCK TABLES `Rooms` WRITE;
/*!40000 ALTER TABLE `Rooms` DISABLE KEYS */;
INSERT INTO `Rooms` VALUES
(9,'General','general','🎸 Основной чат для всех фанов Power Metal','🎸',0,1,'2025-10-19 10:59:19'),
(10,'Gothic Lounge','gothic','🦇 Для поклонников Gothic Metal','🦇',0,1,'2025-10-19 10:59:19'),
(11,'Punk Garage','punk','🤘 Энергичный punk-rock уголок','🤘',0,1,'2025-10-19 10:59:19'),
(12,'News & Announcements','news','📢 Новости о группе и релизах','📢',0,1,'2025-10-19 10:59:19');
/*!40000 ALTER TABLE `Rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Track`
--

DROP TABLE IF EXISTS `Track`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Track` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `albumId` int(11) DEFAULT NULL,
  `coverImagePath` varchar(191) NOT NULL,
  `fullAudioPath` varchar(191) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `fossbillingProductId` int(11) DEFAULT NULL,
  `lyrics` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Track_albumId_fkey` (`albumId`),
  CONSTRAINT `Track_albumId_fkey` FOREIGN KEY (`albumId`) REFERENCES `Albums` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Track`
--

LOCK TABLES `Track` WRITE;
/*!40000 ALTER TABLE `Track` DISABLE KEYS */;
INSERT INTO `Track` VALUES
(21,'1. Последний из драконов',NULL,2,'/public/uploads/album_covers/68f4dc911d0b5.png','/public/uploads/full/68f4dcc320f34.wav','2025-10-19 15:42:43.135','2025-10-19 15:42:43',NULL,NULL),
(22,'2. Спящий Страж',NULL,2,'/public/uploads/album_covers/68f4dc911d0b5.png','/public/uploads/full/68f4dcc3321bc.mp3','2025-10-19 15:42:43.206','2025-10-19 15:42:43',NULL,NULL),
(23,'3. Стальной Легион',NULL,2,'/public/uploads/album_covers/68f4dc911d0b5.png','/public/uploads/full/68f4dcc344680.wav','2025-10-19 15:42:43.280','2025-10-19 15:42:43',NULL,NULL),
(24,'4. Феникс',NULL,2,'/public/uploads/album_covers/68f4dc911d0b5.png','/public/uploads/full/68f4dcc3595c5.wav','2025-10-19 15:42:43.366','2025-10-19 15:42:43',NULL,NULL),
(25,'5. Средиземье',NULL,2,'/public/uploads/album_covers/68f4dc911d0b5.png','/public/uploads/full/68f4dcc364ec0.wav','2025-10-19 15:42:43.414','2025-10-19 15:42:43',NULL,NULL);
/*!40000 ALTER TABLE `Track` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserPreferences`
--

DROP TABLE IF EXISTS `UserPreferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserPreferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `favorite_tracks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`favorite_tracks`)),
  `favorite_albums` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`favorite_albums`)),
  `notifications_enabled` tinyint(1) DEFAULT 1,
  `email_notifications` tinyint(1) DEFAULT 0,
  `theme` enum('dark','light','gothic','punk') DEFAULT 'dark',
  `language` varchar(5) DEFAULT 'ru',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `UserPreferences_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserPreferences`
--

LOCK TABLES `UserPreferences` WRITE;
/*!40000 ALTER TABLE `UserPreferences` DISABLE KEYS */;
INSERT INTO `UserPreferences` VALUES
(1,1,NULL,NULL,1,0,'dark','ru','2025-10-19 10:59:19','2025-10-19 10:59:19'),
(2,2,NULL,NULL,1,0,'dark','ru','2025-10-19 11:23:36','2025-10-19 11:25:56');
/*!40000 ALTER TABLE `UserPreferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
  `verification_expires` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_username` (`username`),
  KEY `idx_email` (`email`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES
(1,'admin','admin@lovix.top','$2y$12$t2X3dPjVV3u3i8V8xK2V0eZ2Z3Z3Z3Z3Z3Z3Z3Z3Z3Z3Z3Z3Z3Z3Z3Z3','Administrator',NULL,NULL,'online',NULL,'2025-10-19 10:59:19','2025-10-19 10:59:19',1,0,1,NULL,NULL),
(2,'dncdante','nfsdante@gmail.com','$argon2id$v=19$m=65536,t=4,p=1$Vk5DeW5sWGJnN3NLY2FwYQ$2t14wnpfvnikpVOKGWaH3LP3yJBOjUKgOTHbkgUnzJA','dncdante',NULL,NULL,'online',NULL,'2025-10-19 11:23:36','2025-10-19 11:23:36',0,0,0,'251fb5ec54910b63b1618003a7c0f03293c8f420c7d8efc5a4ec2a5a7ee102a9','2025-10-20 11:23:36');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-19 15:50:44
