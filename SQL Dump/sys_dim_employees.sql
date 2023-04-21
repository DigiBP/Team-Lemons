-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: sys
-- ------------------------------------------------------
-- Server version	8.0.33

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `dim_employees`
--

DROP TABLE IF EXISTS `dim_employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_employees` (
  `Employee_ID` varchar(10) DEFAULT NULL,
  `First_Name` varchar(50) DEFAULT NULL,
  `Last_Name` varchar(50) DEFAULT NULL,
  `eMail` varchar(100) DEFAULT NULL,
  `ML` int DEFAULT NULL,
  `ORG_ID` int DEFAULT NULL,
  `Organizational_Unit` varchar(255) DEFAULT NULL,
  `DIR_ID` varchar(5) DEFAULT NULL,
  `Directory_Unit` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dim_employees`
--

LOCK TABLES `dim_employees` WRITE;
/*!40000 ALTER TABLE `dim_employees` DISABLE KEYS */;
INSERT INTO `dim_employees` VALUES ('SMRCS','Maximilian','Müller','maximilian.mueller@test.ch',4,1001,'Treasury','5','Finance'),('HGK01','Bukayo','Saka','bukayo.saka@test.ch',4,1002,'VZ Bern','4','Logistics'),('WIKAS','Roger','Federer','roger.federer@test.ch',3,1000,'IT Prozesse Warenwirtschaft','7','Digital & Customer'),('SCP41','Rafael','Nadal','rafael.nadal@test.ch',3,1000,'IT Prozesse Warenwirtschaft','7','Digital & Customer'),('AAAA1','Thomas','Müller','thomas.mueller@test.ch',2,1003,'Logistik VRE Bern','4','Logistics'),('AAAA2','Alexander','Frei','alexander.frei@test.ch',1,1002,'Logistik National','4','Logistics'),('AAAA3','Cedric','Itten','cedric.itten@test.ch',0,1001,'Finance','5','Finance'),('AAAA4','Taulant','Xhaka','taulant.xhaka@test.ch',2,1000,'IT','7','Digital & Customer'),('AAAA5','Lando','Norris','lando.norris@test.ch',0,1000,'Digital & Customer','7','Digital & Customer'),('AAAA6','Gabriel','Martinelli','gabriel.martinelli@test.ch',4,1000,'IT','7','Digital & Customer');
/*!40000 ALTER TABLE `dim_employees` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-04-20 18:25:02
