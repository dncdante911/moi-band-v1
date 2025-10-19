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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Albums`
--

LOCK TABLES `Albums` WRITE;
/*!40000 ALTER TABLE `Albums` DISABLE KEYS */;
INSERT INTO `Albums` VALUES
(1,'Хроники забытых миров','«Хроники забытых миров» — это музыкальное путешествие длиной в 12 треков через\r\nлегенды, которые мир забыл. От пробуждения древних стражей до триумфального\r\nрассвета новой эры — альбом проводит слушателя через эпические битвы, мифические\r\nвозрождения, трагические падения и лирические истории о любви и потере.','/public/uploads/album_covers/68f3d246e9687.png','2025-09-25','2025-10-18 20:45:42','2025-10-18 20:45:42');
/*!40000 ALTER TABLE `Albums` ENABLE KEYS */;
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
  PRIMARY KEY (`id`),
  KEY `Track_albumId_fkey` (`albumId`),
  CONSTRAINT `Track_albumId_fkey` FOREIGN KEY (`albumId`) REFERENCES `Albums` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Track`
--

LOCK TABLES `Track` WRITE;
/*!40000 ALTER TABLE `Track` DISABLE KEYS */;
INSERT INTO `Track` VALUES
(16,'Последний из драконов','[Verse 1]\r\nВ далёких горах, где туман\r\nСкрывает древние руины\r\nСпит последний великан\r\nДракон забытой долины.\r\nВека прошли с тех пор\r\nКогда он правил небесами.\r\nТеперь лишь старый фольклор\r\nХранит память о деяньях.\r\n\r\nНо пламя в сердце не погасло,\r\nХоть мир забыл о чудесах.\r\nПришло время сбросить маски,\r\nИ вновь расправить два крыла!\r\n\r\n[Chorus]\r\nПоследний из драконов\r\nВосстанет из пепла.\r\nПройдёт сквозь все миры\r\nЛюдских забытых снов.\r\nОгненным дыханием,\r\nНебо озарит.\r\nИ древним заклинанием\r\nМир преобразит!\r\n\r\n[Verse 2]\r\nРыцари давно забыли,\r\nКак сражаться с ним.\r\nМечи от ржи затупились,\r\nВ век новых технологий.\r\nНо есть среди людей один,\r\nКто верит в старые сказанья.\r\nОн знает - мифов властелин\r\nВернётся для воздаянья.\r\n\r\nВедь пламя в сердце не погасло,\r\nХоть мир забыл о чудесах.\r\nПришло время сбросить маски,\r\nИ вновь расправить два крыла!\r\n\r\n[Chorus]\r\nПоследний из драконов\r\nВосстанет из пепла.\r\nПройдёт сквозь все миры\r\nЛюдских забытых снов.\r\nОгненным дыханием,\r\nНебо озарит.\r\nИ древним заклинанием\r\nМир преобразит!\r\n\r\n[Bridge]\r\nПроснись, великий дракон!\r\nТвой час настал опять\r\nРазрушь обмана закон\r\nИ магию верни назад!\r\n\r\n[Chorus]\r\nПоследний из драконов\r\nВосстал из глубины.\r\nСломал людские троны\r\nИ рушит их умы.\r\nЗолотым сияньем\r\nМир теперь объят.\r\nНовым мирозданьем\r\nПравит древний ритуал!',1,'/public/uploads/album_covers/68f3d246e9687.png','/public/uploads/full/68f3dc7daa613.wav','2025-10-18 21:29:17.698','2025-10-18 21:56:54',NULL),
(17,'Спящий Страж','<br />\r\n<b>Deprecated</b>:  htmlspecialchars(): Passing null to parameter #1 ($string) of type string is deprecated in <b>/var/www/www-root/data/www/lovix.top/admin/edit_track.php</b> on line <b>140</b><br />',1,'/public/uploads/album_covers/68f3d246e9687.png','/public/uploads/full/68f3dc7daebc0.mp3','2025-10-18 21:29:17.715','2025-10-18 21:57:05',NULL),
(18,'Стальной Легион','<br />\r\n<b>Deprecated</b>:  htmlspecialchars(): Passing null to parameter #1 ($string) of type string is deprecated in <b>/var/www/www-root/data/www/lovix.top/admin/edit_track.php</b> on line <b>140</b><br />',1,'/public/uploads/album_covers/68f3d246e9687.png','/public/uploads/full/68f3dc7db2ce2.wav','2025-10-18 21:29:17.732','2025-10-18 21:57:10',NULL),
(19,'Феникс','<br />\r\n<b>Deprecated</b>:  htmlspecialchars(): Passing null to parameter #1 ($string) of type string is deprecated in <b>/var/www/www-root/data/www/lovix.top/admin/edit_track.php</b> on line <b>140</b><br />',1,'/public/uploads/album_covers/68f3d246e9687.png','/public/uploads/full/68f3e2e3360d5.wav','2025-10-18 21:56:35.221','2025-10-18 21:57:14',NULL),
(20,'Средиземье','<br />\r\n<b>Deprecated</b>:  htmlspecialchars(): Passing null to parameter #1 ($string) of type string is deprecated in <b>/var/www/www-root/data/www/lovix.top/admin/edit_track.php</b> on line <b>140</b><br />',1,'/public/uploads/album_covers/68f3d246e9687.png','/public/uploads/full/68f3e2e33ffcd.wav','2025-10-18 21:56:35.262','2025-10-18 21:57:17',NULL);
/*!40000 ALTER TABLE `Track` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-19 10:04:17
