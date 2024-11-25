CREATE DATABASE IF NOT EXISTS fi36_ring_fpadw;

USE fi36_ring_fpadw;

CREATE TABLE IF NOT EXISTS product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) UNIQUE NOT NULL,
    description TEXT NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    image_url VARCHAR(255) DEFAULT NULL
);


CREATE TABLE IF NOT EXISTS `user` (
  `user_id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `email` VARCHAR(255) UNIQUE NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT current_timestamp()
);

CREATE TABLE IF NOT EXISTS `order` (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  total_amount DECIMAL(10, 2),
  FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS order_item (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) AS (quantity * price) STORED,
    FOREIGN KEY (order_id) REFERENCES `order`(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE
);


INSERT INTO `product` VALUES
(1,'Beispielprodukt','Dies ist ein Beispielprodukt.',19.99, 'images/product-image-1.jpg'),
(2, 'DasBesteVomBesten','Lorem ipsum dolor sit, amet consectetur adipisicing elit. Sit, eligendi. Sed et commodi cupiditate itaque sit vero, consequuntur quasi, soluta ratione, animi nobis at quae labore necessitatibus error porro excepturi!',44.44, 'images/product-image-2.jpg'),
(3, 'Apierzeugungshelferlein','Lorem ipsum dolor sit, amet consectetur adipisicing elit. Sit, eligendi. Sed et commodi cupiditate itaque sit vero, consequuntur quasi, soluta ratione, animi nobis at quae labore necessitatibus error porro excepturi!',23.28, 'images/product-image-3.jpg'),
(4, 'MSI PRO B650-S WIFI',
  'Formfaktor: ATX | 
  Sockel: AMD AM5 (LGA1718) | 
  Chipsatz: AMD B650 | 
  CPU-Kompatibilität: Ryzen 7000, Ryzen 8000G, Ryzen 9000, CPU-Kompatibilitätsliste | 
  RAM-Slots: 4x DDR5 DIMM, Dual Channel, UDIMM (Non-ECC), max. 256GB (UDIMM) | 
  RAM-Taktfrequenz OC: max. DDR5-7200 | 
  RAM-Taktfrequenz nativ: DDR5-5200 (Ryzen 7000), DDR5-5200 (Ryzen 8000G), DDR5-5600 (Ryzen 9000) | 
  ECC-Unterstützung: nein | 
  Anschlüsse extern: 1x HDMI 2.1 (iGPU), 1x DisplayPort 1.4 (iGPU), 1x USB-C 3.2 (20Gb/​s), 3x USB-A 3.1 (10Gb/​s), 4x USB-A 3.0 (5Gb/​s), 1x RJ-45 2.5Gb LAN (Realtek RTL8125BG), 6x 3.5mm Klinke (Realtek ALC897), 2x Antennenanschluss RP-SMA | 
  PCIe-Slots: 2x PCIe 4.0 x16 (1x x16, 1x x4), 1x PCIe 3.0 x1 | 
  M.2-Slots: 1x M.2/​M-Key (PCIe 4.0 x4, 22110/​2280), 1x M.2/​M-Key (PCIe 4.0 x4, 2280/​2260), 1x M.2/​E-Key (2230, belegt mit WiFi+BT-Modul) | 
  Sonstige Schnittstellen: 4x SATA 6Gb/s (B650) | 
  Anschlüsse intern - USB: 1x USB-C 3.1 Key-A Header (10Gb/​s), 1x USB 3.0 Header 20-Pin (5Gb/​s, 2x USB 3.0), 2x USB 2.0 Header 9-Pin (480Mb/​s, 4x USB 2.0) | 
  Anschlüsse intern - sonstige: 1x seriell-Header, 1x TPM-Header, 1x Chassis Intrusion-Header, 1x MSI Tuning Controller Header (JDASH) | 
  Anschlüsse intern - Kühlung: 1x CPU-Lüfter 4-Pin, 4x Lüfter 4-Pin, 1x Pumpe 4-Pin | 
  Anschlüsse intern - Stromversorgung: 1x 24-Pin ATX, 2x 8-Pin EPS12V | 
  Anschlüsse intern - Beleuchtung: 2x 4-Pin RGB (+12V/​G/​R/​B, max. 3A), 2x 3-Pin ARGB (+5V/​DATA/​GND, max. 3A, JARGB_V2) | 
  Buttons/Switches: USB BIOS Flashback (extern) | 
  Audio: Realtek ALC897 | 
  Grafik: iGPU | 
  Wireless: Wi-Fi 6E (WLAN 802.11a/​b/​g/​n/​ac/​ax, 2x2), Bluetooth 5.3 | 
  RAID-Level: 0/​1/​10 | 
  VRM-Design: 12+2+1, 14 virtuelle CPU-Phasen (2x6+2), 8 reale CPU-Phasen (6+2) | 
  MOSFETs VCORE: 12x 55A SM4337/​SM4503 (High-/​Low-Side) | 
  MOSFETs SOC/VCCGT: 4x 55A SM4337/​SM4503 (High-/​Low-Side) | 
  MOSFETs VDD_MISC/VCCSA/VCCAUX: 1x 30A MxL7630S (DrMOS) | 
  PWM-Controller: MP2857 (max. 12 Phasen) | 
  Beleuchtung: N/​A | 
  BIOS: 1x 32MB (256Mb) | 
  Besonderheiten: Audio+solid capacitors, Diagnostic LED (LED-Indikatoren), 1x M.2-Passivkühler',
  100,
  'images/product-image-4.jpg'
  
);