/*!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.6.18-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: fi36_ring_fpadw
-- ------------------------------------------------------
-- Server version	10.6.18-MariaDB-0ubuntu0.22.04.1

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
-- Current Database: `fi36_ring_fpadw`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `fi36_ring_fpadw` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `fi36_ring_fpadw`;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `order_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `total_amount` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `order_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_item` (
  `order_item_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) GENERATED ALWAYS AS (`quantity` * `price`) STORED,
  PRIMARY KEY (`order_item_id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_item_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_item_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `price` decimal(10,2) NOT NULL CHECK (`price` > 0),
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  UNIQUE KEY `title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'GIGABYTE B550M DS3H','Formfaktor: µATX | \nSockel: AMD AM4 (PGA1331) | \nChipsatz: AMD B550 | \nCPU-Kompatibilität: Athlon - Dali, Ryzen 3000, Ryzen 4000, Ryzen 4000G, Ryzen 5000G | \nRAM-Slots: 4x DDR4 DIMM, Dual Channel, UDIMM (Non-ECC), max. 128GB (UDIMM) | \nRAM-Taktfrequenz OC: max. DDR4-4733 | \nRAM-Taktfrequenz nativ: DDR4-2400/​DDR4-2666 (Athlon - Dali), DDR4-3200 (Ryzen 3000), DDR4-3200 (Ryzen 4000), DDR4-3200 (Ryzen 4000G), DDR4-3200 (Ryzen 5000G) | \nECC-Unterstützung: ja | \nAnschlüsse extern: 1x HDMI 2.1 (iGPU), 1x DVI-D (iGPU), 4x USB-A 3.0 (5Gb/​s), 4x USB-A 2.0 (480Mb/​s), 1x RJ-45 1Gb LAN (Realtek RTL8118AS), 3x 3.5mm Klinke (Realtek ALC887), 1x PS/​2 Combo | \nPCIe-Slots: 1x PCIe 4.0 x16, 1x PCIe 3.0 x16 (x4), 1x PCIe 3.0 x1 | \nM.2-Slots: 1x M.2/​M-Key (PCIe 4.0 x4/​SATA, 22110/​2280/​2260/​2242), 1x M.2/​M-Key (PCIe 3.0 x2/​SATA, 2280/​2260/​2242) | \nSonstige Schnittstellen: 4x SATA 6Gb/s (B550) | \nAnschlüsse intern - USB: 1x USB 3.0 Header 20-Pin (5Gb/​s, 2x USB 3.0), 1x USB 2.0 Header 9-Pin (480Mb/​s, 2x USB 2.0) | \nAnschlüsse intern - sonstige: 1x seriell-Header, 1x TPM-Header | \nAnschlüsse intern - Kühlung: 1x CPU-Lüfter 4-Pin, 2x Lüfter 4-Pin | \nAnschlüsse intern - Stromversorgung: 1x 24-Pin ATX, 1x 8-Pin EPS12V | \nAnschlüsse intern - Beleuchtung: 3x 4-Pin RGB (+12V/​G/​R/​B, max. 2A), 2x 3-Pin ARGB (+5V/​DATA/​GND, max. 5A) | \nButtons/Switches: USB BIOS Flashback/​Q-Flash Plus (intern) | \nAudio: Realtek ALC887 | \nGrafik: iGPU | \nWireless: N/​A | \nRAID-Level: 0/​1/​10 | \nVRM-Design: 5+3, 8 virtuelle CPU-Phasen (5+3), 8 reale CPU-Phasen (5+3) | \nMOSFETs VCORE: 5x 46A 4C10N/​10x 4C06N (High-/​Low-Side) | \nMOSFETs SOC/VCCGT: 3x 46A 4C10N/​4C06N (High-/​Low-Side) | \nPWM-Controller: RAA229004 (max. 8 Phasen) | \nBeleuchtung: N/​A | \nBIOS: 1x 32MB (256Mb) | \nBesonderheiten: Audio+solid capacitors',59.99,'images/product-image-1.jpg'),(2,'MSI B550-A Pro','Formfaktor: ATX | \nSockel: AMD AM4 (PGA1331) | \nChipsatz: AMD B550 | \nCPU-Kompatibilität: Ryzen 3000, Ryzen 4000G, Ryzen 5000G | \nRAM-Slots: 4x DDR4 DIMM, Dual Channel, UDIMM (Non-ECC), max. 128GB (UDIMM) | \nRAM-Taktfrequenz OC: max. DDR4-4400 | \nRAM-Taktfrequenz nativ: DDR4-3200 (Ryzen 3000), DDR4-3200 (Ryzen 4000G), DDR4-3200 (Ryzen 5000G) | \nECC-Unterstützung: nein | \nAnschlüsse extern: 1x HDMI 2.1 (iGPU), 1x DisplayPort 1.4 (iGPU), 1x USB-C 3.1 (10Gb/​s, B550), 1x USB-A 3.1 (10Gb/​s, B550), 2x USB-A 3.0 (5Gb/​s), 4x USB-A 2.0 (480Mb/​s), 1x RJ-45 1Gb LAN (Realtek RTL8111H), 6x 3.5mm Klinke (Realtek ALC892), 1x PS/​2 Combo | \nPCIe-Slots: 1x PCIe 4.0 x16, 1x PCIe 3.0 x16 (x4), 2x PCIe 3.0 x1 | \nM.2-Slots: 1x M.2/​M-Key (PCIe 4.0 x4/​SATA, 22110/​2280/​2260/​2242), 1x M.2/​M-Key (PCIe 3.0 x4, 2280/​2260/​2242) | \nSonstige Schnittstellen: 6x SATA 6Gb/s (B550) | \nAnschlüsse intern - USB: 1x USB-C 3.0 Key-A Header (5Gb/​s), 1x USB 3.0 Header 20-Pin (5Gb/​s, 2x USB 3.0), 2x USB 2.0 Header 9-Pin (480Mb/​s, 4x USB 2.0) | \nAnschlüsse intern - sonstige: 1x TPM-Header, 1x Chassis Intrusion-Header | \nAnschlüsse intern - Kühlung: 1x CPU-Lüfter 4-Pin, 6x Lüfter 4-Pin, 1x Lüfter/​Pumpe 4-Pin | \nAnschlüsse intern - Stromversorgung: 1x 24-Pin ATX, 1x 8-Pin EPS12V | \nAnschlüsse intern - Beleuchtung: 1x 4-Pin RGB (+12V/​G/​R/​B, max. 3A), 2x 3-Pin ARGB (+5V/​DATA/​GND, max. 3A) | \nButtons/Switches: USB BIOS Flashback (extern), LED-Switch (intern) | \nAudio: Realtek ALC892 | \nGrafik: iGPU | \nWireless: N/​A | \nRAID-Level: 0/​1/​10 | \nVRM-Design: 10+2, 12 virtuelle CPU-Phasen (2x5+2), 7 reale CPU-Phasen (5+2) | \nMOSFETs VCORE: 10x 46A 4C029N/​4C024N (High-/​Low-Side) | \nMOSFETs SOC/VCCGT: 4x 46A 4C029N/​4C024N (High-/​Low-Side) | \nPWM-Controller: IR35201 (max. 8 Phasen) | \nBeleuchtung: N/​A | \nBIOS: 1x 32MB (256Mb) | \nBesonderheiten: Audio+solid capacitors, Diagnostic LED (LED-Indikatoren), White Build-kompatibel (PCB primär schwarz), 1x M.2-Passivkühler, unterstützt AMD 2-Way-CrossFireX (x16/​x4)',79.99,'images/product-image-2.jpg'),(3,'GIGABYTE B650 Eagle AX','Formfaktor: ATX | \nSockel: AMD AM5 (LGA1718) | \nChipsatz: AMD B650 | \nCPU-Kompatibilität: Ryzen 7000, Ryzen 8000G, Ryzen 9000 | \nRAM-Slots: 4x DDR5 DIMM, Dual Channel, UDIMM (Non-ECC), max. 192GB (UDIMM) | \nRAM-Taktfrequenz OC: max. DDR5-7600 | \nRAM-Taktfrequenz nativ: DDR5-5200 (Ryzen 7000), DDR5-5200 (Ryzen 8000G), DDR5-5600 (Ryzen 9000) | \nECC-Unterstützung: nein | \nAnschlüsse extern: 1x HDMI 2.1 (iGPU), 1x DisplayPort 1.4 (iGPU), 1x USB-C 3.0 (5Gb/​s), 2x USB-A 3.1 (10Gb/​s), 6x USB-A 2.0 (480Mb/​s), 1x RJ-45 1Gb LAN (Realtek), 3x 3.5mm Klinke (Realtek ALC897), 1x PS/​2 Combo, 2x Antennenanschluss RP-SMA | \nPCIe-Slots: 1x PCIe 4.0 x16, 3x PCIe 3.0 x16 (x1) | \nM.2-Slots: 1x M.2/​M-Key (PCIe 5.0 x4, 25110/​2580/​22110/​2280), 1x M.2/​M-Key (PCIe 4.0 x2, 22110/​2280), 1x M.2/​M-Key (PCIe 4.0 x4, 22110/​2280), 1x M.2/​E-Key (2230, belegt mit WiFi+BT-Modul) | \nSonstige Schnittstellen: 4x SATA 6Gb/s (B650) | \nAnschlüsse intern - USB: 1x USB-C 3.0 Key-A Header (5Gb/​s), 1x USB 3.0 Header 20-Pin (5Gb/​s, 2x USB 3.0), 3x USB 2.0 Header 9-Pin (480Mb/​s, 6x USB 2.0) | \nAnschlüsse intern - sonstige: 1x seriell-Header, 1x TPM-Header | \nAnschlüsse intern - Kühlung: 1x CPU-Lüfter 4-Pin, 1x CPU-Lüfter/​Pumpe 4-Pin, 2x Lüfter 4-Pin, 1x Lüfter/​Pumpe 4-Pin | \nAnschlüsse intern - Stromversorgung: 1x 24-Pin ATX, 1x 8-Pin EPS12V | \nAnschlüsse intern - Beleuchtung: 3x 3-Pin ARGB (+5V/​DATA/​GND, max. 5A), 1x 4-Pin RGB (+12V/​G/​R/​B, max. 2A) | \nButtons/Switches: USB BIOS Flashback/​Q-Flash Plus (intern) | \nAudio: Realtek ALC897 | \nGrafik: iGPU | \nWireless: Wi-Fi 6E (WLAN 802.11a/​b/​g/​n/​ac/​ax, 2x2, Realtek RTL8852CE), Bluetooth 5.3 | \nRAID-Level: 0/​1/​10 | \nVRM-Design: 12+2, 14 virtuelle CPU-Phasen (2x6+2), 8 reale CPU-Phasen (6+2) | \nMOSFETs VCORE: 12x 46A 4C10N/​24x 4C06N (High-/​Low-Side) | \nMOSFETs SOC/VCCGT: 4x 46A 4C10N/​4C06N (High-/​Low-Side) | \nPWM-Controller: RT3678BE (max. 10 Phasen) | \nBeleuchtung: N/​A | \nBIOS: 1x 32MB (256Mb) | \nBesonderheiten: Audio+solid capacitors, Diagnostic LED (LED-Indikatoren), I/​O-Blende integriert, 1x M.2-Passivkühler',74.99,'images/product-image-3.jpg'),(4,'MSI PRO B650-S WIFI','Formfaktor: ATX | \n  Sockel: AMD AM5 (LGA1718) | \n  Chipsatz: AMD B650 | \n  CPU-Kompatibilität: Ryzen 7000, Ryzen 8000G, Ryzen 9000 | \n  RAM-Slots: 4x DDR5 DIMM, Dual Channel, UDIMM (Non-ECC), max. 256GB (UDIMM) | \n  RAM-Taktfrequenz OC: max. DDR5-7200 | \n  RAM-Taktfrequenz nativ: DDR5-5200 (Ryzen 7000), DDR5-5200 (Ryzen 8000G), DDR5-5600 (Ryzen 9000) | \n  ECC-Unterstützung: nein | \n  Anschlüsse extern: 1x HDMI 2.1 (iGPU), 1x DisplayPort 1.4 (iGPU), 1x USB-C 3.2 (20Gb/​s), 3x USB-A 3.1 (10Gb/​s), 4x USB-A 3.0 (5Gb/​s), 1x RJ-45 2.5Gb LAN (Realtek RTL8125BG), 6x 3.5mm Klinke (Realtek ALC897), 2x Antennenanschluss RP-SMA | \n  PCIe-Slots: 2x PCIe 4.0 x16 (1x x16, 1x x4), 1x PCIe 3.0 x1 | \n  M.2-Slots: 1x M.2/​M-Key (PCIe 4.0 x4, 22110/​2280), 1x M.2/​M-Key (PCIe 4.0 x4, 2280/​2260), 1x M.2/​E-Key (2230, belegt mit WiFi+BT-Modul) | \n  Sonstige Schnittstellen: 4x SATA 6Gb/s (B650) | \n  Anschlüsse intern - USB: 1x USB-C 3.1 Key-A Header (10Gb/​s), 1x USB 3.0 Header 20-Pin (5Gb/​s, 2x USB 3.0), 2x USB 2.0 Header 9-Pin (480Mb/​s, 4x USB 2.0) | \n  Anschlüsse intern - sonstige: 1x seriell-Header, 1x TPM-Header, 1x Chassis Intrusion-Header, 1x MSI Tuning Controller Header (JDASH) | \n  Anschlüsse intern - Kühlung: 1x CPU-Lüfter 4-Pin, 4x Lüfter 4-Pin, 1x Pumpe 4-Pin | \n  Anschlüsse intern - Stromversorgung: 1x 24-Pin ATX, 2x 8-Pin EPS12V | \n  Anschlüsse intern - Beleuchtung: 2x 4-Pin RGB (+12V/​G/​R/​B, max. 3A), 2x 3-Pin ARGB (+5V/​DATA/​GND, max. 3A, JARGB_V2) | \n  Buttons/Switches: USB BIOS Flashback (extern) | \n  Audio: Realtek ALC897 | \n  Grafik: iGPU | \n  Wireless: Wi-Fi 6E (WLAN 802.11a/​b/​g/​n/​ac/​ax, 2x2), Bluetooth 5.3 | \n  RAID-Level: 0/​1/​10 | \n  VRM-Design: 12+2+1, 14 virtuelle CPU-Phasen (2x6+2), 8 reale CPU-Phasen (6+2) | \n  MOSFETs VCORE: 12x 55A SM4337/​SM4503 (High-/​Low-Side) | \n  MOSFETs SOC/VCCGT: 4x 55A SM4337/​SM4503 (High-/​Low-Side) | \n  MOSFETs VDD_MISC/VCCSA/VCCAUX: 1x 30A MxL7630S (DrMOS) | \n  PWM-Controller: MP2857 (max. 12 Phasen) | \n  Beleuchtung: N/​A | \n  BIOS: 1x 32MB (256Mb) | \n  Besonderheiten: Audio+solid capacitors, Diagnostic LED (LED-Indikatoren), 1x M.2-Passivkühler',99.99,'images/product-image-4.jpg'),(5,'ASRock WRX90 WS EVO','Formfaktor: E-ATX (SSI EEB) | \nSockel: AMD sTR5 (LGA4844) | \nChipsatz: AMD WRX90 | \nCPU-Kompatibilität: Ryzen Threadripper PRO 7000 | \nRAM-Slots: 8x DDR5 DIMM, 8 Channel, RDIMM, max. 2TB (RDIMM), 2TB (RDIMM-3DS) | \nRAM-Taktfrequenz OC: max. DDR5-7600 | \nRAM-Taktfrequenz nativ: DDR5-5200 (Ryzen Threadripper PRO 7000) | \nECC-Unterstützung: ja | \nAnschlüsse extern: 1x DisplayPort 1.1a (AST2600), 2x USB4 (40Gb/​s, ASMedia ASM4242), 4x USB-A 3.1 (10Gb/​s), 2x USB-A 3.0 (5Gb/​s), 2x RJ-45 10Gb LAN (Intel X710-AT2), 1x Toslink S/​PDIF Out (Realtek ALC1220), 2x 3.5mm Klinke (Realtek ALC1220), 1x Management-Port (RJ-45) | \nPCIe-Slots: 7x PCIe 5.0 x16 (6x x16, 1x x8) | \nM.2-Slots: 1x M.2/​M-Key (PCIe 5.0 x4, 22110/​2280/​2260) | \nSonstige Schnittstellen: 2x MCIO SFF-TA-1016 4i (PCIe 5.0 x4), 1x Slim SAS SFF-8654 4i (PCIe 4.0 x4/​SATA), 4x SATA 6Gb/s (via Slim SAS SFF-8654 4i) | \nAnschlüsse intern - USB: 1x USB-C 3.2 Key-A Header (20Gb/​s), 1x USB 3.0 Header 20-Pin (5Gb/​s, 2x USB 3.0), 2x USB 2.0 Header 9-Pin (480Mb/​s, 4x USB 2.0) | \nAnschlüsse intern - sonstige: 1x seriell-Header, 1x BMC-Header, 1x IPMB-Header, 1x SMBus-Header, 1x VGA-Header, 1x Speaker-Header, 2x SGPIO, 1x NMI-Header | \nAnschlüsse intern - Kühlung: 1x CPU-Lüfter 4-Pin, 1x CPU-Lüfter/​Pumpe 4-Pin, 3x Lüfter/​Pumpe 4-Pin, 2x Thermal-Sensor | \nAnschlüsse intern - Stromversorgung: 1x 24-Pin ATX, 2x 8-Pin EPS12V, 2x 6-Pin PCIe, 2x 6-Pin PCIe (Ausgang) | \nAnschlüsse intern - Beleuchtung: 2x 3-Pin ARGB (+5V/​DATA/​GND, max. 3A) | \nButtons/Switches: Clear-CMOS-Button (intern), Power-Button (intern), Retry-Button (intern) | \nAudio: Realtek ALC1220 | \nGrafik: ASPEED AST2600 - Onboard | \nWireless: N/​A | \nRAID-Level: 0/​1/​10 | \nVRM-Design: 18+3+3, 21 virtuelle CPU-Phasen (18+3), 21 reale CPU-Phasen (18+3) | \nMOSFETs VCORE: 18x 110A | \nMOSFETs SOC/VCCGT: 3x 110A | \nMOSFETs VDD_MISC/VCCSA/VCCAUX: 3x 110A | \nBeleuchtung: N/​A | \nBIOS: 1x 32MB (256Mb) | \nBesonderheiten: Audio+solid capacitors, Diagnostic LED (Segmentanzeige), VRM-Lüfter, 2x M.2-Passivkühler',849.99,'images/product-image-5.jpg'),(6,'AMD Ryzen 9 7950X, 16C/32T, 4.50-5.70GHz, boxed ohne Kühler','Kerne: 16 (16C) |\nThreads: 32 |\nTurbotakt: 5.70GHz |\nBasistakt: 4.50GHz |\nTDP: 170W |\nGrafik: ja (AMD Radeon Graphics) |\nSockel: AMD AM5 (LGA1718) |\nChipsatz-Eignung: A620, B650, B650E, B840, B850, X670, X670E, X870, X870E (modellabhängig: PRO 600, PRO 665, X600) |\nCodename: Raphael |\nArchitektur: Zen 4 |\nFertigung: TSMC 5nm (CPU), TSMC 6nm (I/O) |\nL2-Cache: 16MB (16x 1MB) |\nL3-Cache: 64MB (2x 32MB) |\nSpeichercontroller: Dual Channel DDR5, max. 192GB (UEFI AGESA Basis 1.0.0.7 oder höher) |\nSpeicherkompatibilität: max. DDR5-5200 (PC5-41600, 83.2GB/s) |\nSpeicherkompatibilität erweitert (DIMM): DDR5-5200 (1DPC/1R), DDR5-5200 (1DPC/2R), DDR5-3600 (2DPC/1R), DDR5-3600 (2DPC/2R) |\nECC-Unterstützung: ja |\nSMT: ja |\nFernwartung: nein |\nFreier Multiplikator: ja |\nCPU-Funktionen: AES-NI, AMD-V, AVX, AVX-512, AVX2, FMA3, MMX(+), SHA, SSE, SSE2, SSE3, SSE4.1, SSE4.2, SSE4a, x86-64 |\nSystemeignung: 1 Sockel (1S) |\nPCIe-Lanes: 28x PCIe 5.0 (verfügbar: 24) |\nChipsatz-Interface: PCIe 4.0 x4 |\niGPU-Modell: AMD Radeon Graphics |\niGPU-Takt: 0.40–2.20GHz |\niGPU-Einheiten: 2CU/128SP |\niGPU-Architektur: RDNA 2, Codename \"Raphael\" |\niGPU-Interface: DP 2.0, HDMI 2.1 |\niGPU-Funktionen: 4x Display Support, AMD Eyefinity, AMD FreeSync 2, AV1 decode, H.265 encode/decode, VP9 decode, DirectX 12.1, OpenGL 4.5, Vulkan 1.0 |\niGPU-Rechenleistung: 0.56 TFLOPS (FP32) |\nLieferumfang: ohne CPU-Kühler |\nEinführung: 2022/Q3 (27.9.2022) |\nSegment: Desktop (Mainstream) |\nStepping: RPL-B2 |\nTemperatur max.: 95°C (Tjmax) |',439.99,'images/product-image-6.jpg'),(7,'AMD Ryzen 9 9950X, 16C/32T, 4.30-5.70GHz, boxed ohne Kühler','Kerne: 16 (16C) |\nThreads: 32 |\nTurbotakt: 5.70GHz |\nBasistakt: 4.30GHz |\nTDP: 170W |\nGrafik: ja (AMD Radeon Graphics) |\nSockel: AMD AM5 (LGA1718) |\nChipsatz-Eignung: A620, B650, B650E, B840, B850, X670, X670E, X870, X870E (modellabhängig: PRO 600, PRO 665, X600) |\nCodename: Granite Ridge |\nArchitektur: Zen 5 |\nFertigung: TSMC 4nm (CPU), TSMC 6nm (I/O) |\nL2-Cache: 16MB (16x 1MB) |\nL3-Cache: 64MB (2x 32MB) |\nSpeichercontroller: Dual Channel DDR5, max. 192GB |\nSpeicherkompatibilität: max. DDR5-5600 (PC5-44800, 89.6GB/s) |\nSpeicherkompatibilität erweitert (DIMM): DDR5-5600 (1DPC/1R), DDR5-5600 (1DPC/2R), DDR5-3600 (2DPC/1R), DDR5-3600 (2DPC/2R) |\nECC-Unterstützung: ja |\nSMT: ja |\nFernwartung: nein |\nFreier Multiplikator: ja |\nCPU-Funktionen: AES-NI, AMD-V, AVX, AVX-512, AVX2, FMA3, MMX(+), SHA, SSE, SSE2, SSE3, SSE4.1, SSE4.2, SSE4a, x86-64 |\nSystemeignung: 1 Sockel (1S) |\nPCIe-Lanes: 28x PCIe 5.0 (verfügbar: 24) |\nChipsatz-Interface: PCIe 4.0 x4 |\niGPU-Modell: AMD Radeon Graphics |\niGPU-Takt: 2.20GHz |\niGPU-Einheiten: 2CU/128SP |\niGPU-Architektur: RDNA 2, Codename \"Granite Ridge\" |\niGPU-Interface: DP 2.0, HDMI 2.1 |\niGPU-Funktionen: 4x Display Support, AMD Eyefinity, AMD FreeSync 2, AV1 decode, H.265 encode/decode, VP9 decode, DirectX 12.1, OpenGL 4.5, Vulkan 1.0 |\niGPU-Rechenleistung: 0.56 TFLOPS (FP32) |\nLieferumfang: ohne CPU-Kühler |\nEinführung: 2024/Q3 |\nSegment: Desktop (Mainstream) |\nStepping: GNR-B0 |\nTemperatur max.: 95°C (Tjmax) |',649.99,'images/product-image-7.jpg'),(8,'AMD Ryzen 5 8600G, 6C/12T, 4.30-5.00GHz, boxed','Kerne: 6 (6C) |\nThreads: 12 |\nTurbotakt: 5.00GHz |\nBasistakt: 4.30GHz |\nTDP: 65W, 45W cTDP-down |\nGrafik: ja (AMD Radeon 760M) |\nSockel: AMD AM5 (LGA1718) |\nChipsatz-Eignung: A620, B650, B650E, B840, B850, X670, X670E, X870, X870E (modellabhängig: PRO 600, PRO 665, X600) |\nCodename: Phoenix |\nArchitektur: Zen 4 |\nFertigung: TSMC 4nm |\nL2-Cache: 6MB (6x 1MB) |\nL3-Cache: 16MB |\nSpeichercontroller: Dual Channel DDR5, max. 256GB |\nSpeicherkompatibilität: max. DDR5-5200 (PC5-41600, 83.2GB/s) |\nSpeicherkompatibilität erweitert (DIMM): DDR5-5200 (1DPC/1R), DDR5-5200 (1DPC/2R), DDR5-3600 (2DPC/1R), DDR5-3600 (2DPC/2R) |\nECC-Unterstützung: nein |\nSMT: ja |\nFernwartung: nein |\nFreier Multiplikator: ja |\nCPU-Funktionen: AES-NI, AMD-V, AVX, AVX-512, AVX2, FMA3, MMX(+), SHA, SSE, SSE2, SSE3, SSE4.1, SSE4.2, SSE4a, x86-64 |\nSystemeignung: 1 Sockel (1S) |\nPCIe-Lanes: 20x PCIe 4.0 (verfügbar: 16) |\niGPU-Modell: AMD Radeon 760M |\niGPU-Takt: 2.80GHz |\niGPU-Einheiten: 8CU/512SP |\niGPU-Architektur: RDNA 3, Codename \"Phoenix\" |\niGPU-Interface: DP 2.1, HDMI 2.1 |\niGPU-Funktionen: 4x Display Support, AMD Eyefinity, AMD FreeSync 2, AV1 encode/decode, H.265 encode/decode, VP9 decode, DirectX 12.1, OpenGL 4.5, Vulkan 1.0 |\niGPU-Rechenleistung: 2.87 TFLOPS (FP32) |\nNPU-Rechenleistung: 16 TOPS (AMD Ryzen AI) |\nLieferumfang: mit CPU-Kühler (AMD Wraith Stealth, BxHxT: 102x54x114mm) |\nEinführung: 2024/Q1 (8.1.2024) |\nSegment: Desktop (Mainstream) |\nStepping: PHX-A1 |\nTemperatur max.: 95°C (Tjmax) |',139.99,'images/product-image-8.jpg'),(9,'AMD Ryzen 7 9800X3D, 8C/16T, 4.70-5.20GHz, boxed ohne Kühler','Kerne: 8 (8C) |\nThreads: 16 |\nTurbotakt: 5.20GHz |\nBasistakt: 4.70GHz |\nTDP: 120W |\nGrafik: ja (AMD Radeon Graphics) |\nSockel: AMD AM5 (LGA1718) |\nChipsatz-Eignung: A620, B650, B650E, B840, B850, X670, X670E, X870, X870E (modellabhängig: PRO 600, PRO 665, X600) |\nCodename: Granite Ridge |\nArchitektur: Zen 5 |\nFertigung: TSMC 4nm (CPU), TSMC 6nm (I/O) |\nL2-Cache: 8MB (8x 1MB) |\nL3-Cache: 96MB (32MB + 64MB 3D-Cache) |\nSpeichercontroller: Dual Channel DDR5, max. 192GB |\nSpeicherkompatibilität: max. DDR5-5600 (PC5-44800, 89.6GB/s) |\nSpeicherkompatibilität erweitert (DIMM): DDR5-5600 (1DPC/1R), DDR5-5600 (1DPC/2R), DDR5-3600 (2DPC/1R), DDR5-3600 (2DPC/2R) |\nECC-Unterstützung: ja |\nSMT: ja |\nFernwartung: nein |\nFreier Multiplikator: ja |\nCPU-Funktionen: AES-NI, AMD-V, AVX, AVX-512, AVX2, FMA3, MMX(+), SHA, SSE, SSE2, SSE3, SSE4.1, SSE4.2, SSE4a, x86-64 |\nSystemeignung: 1 Sockel (1S) |\nPCIe-Lanes: 28x PCIe 5.0 (verfügbar: 24) |\nChipsatz-Interface: PCIe 4.0 x4 |\niGPU-Modell: AMD Radeon Graphics |\niGPU-Takt: 2.20GHz |\niGPU-Einheiten: 2CU/128SP |\niGPU-Architektur: RDNA 2, Codename \"Granite Ridge\" |\niGPU-Interface: DP 2.0, HDMI 2.1 |\niGPU-Funktionen: 4x Display Support, AMD Eyefinity, AMD FreeSync 2, AV1 decode, H.265 encode/decode, VP9 decode, DirectX 12.1, OpenGL 4.5, Vulkan 1.0 |\niGPU-Rechenleistung: 0.56 TFLOPS (FP32) |\nLieferumfang: ohne CPU-Kühler |\nEinführung: 2024/Q4 (7.11.2024) |\nSegment: Desktop (Mainstream) |\nStepping: GNR-B0 |\nTemperatur max.: 95°C (Tjmax) |',699.99,'images/product-image-9.jpg'),(10,'AMD Ryzen 5 9600X, 6C/12T, 3.90-5.40GHz, boxed ohne Kühler','Kerne: 6 (6C) |\nThreads: 12 |\nTurbotakt: 5.40GHz |\nBasistakt: 3.90GHz |\nTDP: 65W |\nGrafik: ja (AMD Radeon Graphics) |\nSockel: AMD AM5 (LGA1718) |\nChipsatz-Eignung: A620, B650, B650E, B840, B850, X670, X670E, X870, X870E (modellabhängig: PRO 600, PRO 665, X600) |\nCodename: Granite Ridge |\nArchitektur: Zen 5 |\nFertigung: TSMC 4nm (CPU), TSMC 6nm (I/O) |\nL2-Cache: 6MB (6x 1MB) |\nL3-Cache: 32MB |\nSpeichercontroller: Dual Channel DDR5, max. 192GB |\nSpeicherkompatibilität: max. DDR5-5600 (PC5-44800, 89.6GB/s) |\nSpeicherkompatibilität erweitert (DIMM): DDR5-5600 (1DPC/1R), DDR5-5600 (1DPC/2R), DDR5-3600 (2DPC/1R), DDR5-3600 (2DPC/2R) |\nECC-Unterstützung: ja |\nSMT: ja |\nFernwartung: nein |\nFreier Multiplikator: ja |\nCPU-Funktionen: AES-NI, AMD-V, AVX, AVX-512, AVX2, FMA3, MMX(+), SHA, SSE, SSE2, SSE3, SSE4.1, SSE4.2, SSE4a, x86-64 |\nSystemeignung: 1 Sockel (1S) |\nPCIe-Lanes: 28x PCIe 5.0 (verfügbar: 24) |\nChipsatz-Interface: PCIe 4.0 x4 |\niGPU-Modell: AMD Radeon Graphics |\niGPU-Takt: 2.20GHz |\niGPU-Einheiten: 2CU/128SP |\niGPU-Architektur: RDNA 2, Codename \"Granite Ridge\" |\niGPU-Interface: DP 2.0, HDMI 2.1 |\niGPU-Funktionen: 4x Display Support, AMD Eyefinity, AMD FreeSync 2, AV1 decode, H.265 encode/decode, VP9 decode, DirectX 12.1, OpenGL 4.5, Vulkan 1.0 |\niGPU-Rechenleistung: 0.56 TFLOPS (FP32) |\nLieferumfang: ohne CPU-Kühler |\nEinführung: 2024/Q3 |\nSegment: Desktop (Mainstream) |\nStepping: GNR-B0 |\nTemperatur max.: 95°C (Tjmax) |',209.99,'images/product-image-10.jpg');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `isadmin` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin@hardware-gmbh.de','$2b$10$fNPxKRIPcuVpHP/juyHVEeEJVGdbb4eF9g3AXfWhpUiF2IOo0lM6q',1,'2024-11-29 19:40:47');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-29 20:57:29
