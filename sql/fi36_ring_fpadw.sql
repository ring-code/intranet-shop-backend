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
  `isadmin` BOOLEAN DEFAULT 0,
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

INSERT INTO `user` (email, password_hash, isadmin) 
VALUES ('admin@hardware-gmbh.de', '$2b$10$c4XMsRfttRpPaAvJ2F8cMOWBkxBvh.pcaD86Vr6XYY8PTHWJq30oe', 1);



INSERT INTO `product` VALUES
(1,'GIGABYTE B550M DS3H',
'Formfaktor: µATX | 
Sockel: AMD AM4 (PGA1331) | 
Chipsatz: AMD B550 | 
CPU-Kompatibilität: Athlon - Dali, Ryzen 3000, Ryzen 4000, Ryzen 4000G, Ryzen 5000G | 
RAM-Slots: 4x DDR4 DIMM, Dual Channel, UDIMM (Non-ECC), max. 128GB (UDIMM) | 
RAM-Taktfrequenz OC: max. DDR4-4733 | 
RAM-Taktfrequenz nativ: DDR4-2400/​DDR4-2666 (Athlon - Dali), DDR4-3200 (Ryzen 3000), DDR4-3200 (Ryzen 4000), DDR4-3200 (Ryzen 4000G), DDR4-3200 (Ryzen 5000G) | 
ECC-Unterstützung: ja | 
Anschlüsse extern: 1x HDMI 2.1 (iGPU), 1x DVI-D (iGPU), 4x USB-A 3.0 (5Gb/​s), 4x USB-A 2.0 (480Mb/​s), 1x RJ-45 1Gb LAN (Realtek RTL8118AS), 3x 3.5mm Klinke (Realtek ALC887), 1x PS/​2 Combo | 
PCIe-Slots: 1x PCIe 4.0 x16, 1x PCIe 3.0 x16 (x4), 1x PCIe 3.0 x1 | 
M.2-Slots: 1x M.2/​M-Key (PCIe 4.0 x4/​SATA, 22110/​2280/​2260/​2242), 1x M.2/​M-Key (PCIe 3.0 x2/​SATA, 2280/​2260/​2242) | 
Sonstige Schnittstellen: 4x SATA 6Gb/s (B550) | 
Anschlüsse intern - USB: 1x USB 3.0 Header 20-Pin (5Gb/​s, 2x USB 3.0), 1x USB 2.0 Header 9-Pin (480Mb/​s, 2x USB 2.0) | 
Anschlüsse intern - sonstige: 1x seriell-Header, 1x TPM-Header | 
Anschlüsse intern - Kühlung: 1x CPU-Lüfter 4-Pin, 2x Lüfter 4-Pin | 
Anschlüsse intern - Stromversorgung: 1x 24-Pin ATX, 1x 8-Pin EPS12V | 
Anschlüsse intern - Beleuchtung: 3x 4-Pin RGB (+12V/​G/​R/​B, max. 2A), 2x 3-Pin ARGB (+5V/​DATA/​GND, max. 5A) | 
Buttons/Switches: USB BIOS Flashback/​Q-Flash Plus (intern) | 
Audio: Realtek ALC887 | 
Grafik: iGPU | 
Wireless: N/​A | 
RAID-Level: 0/​1/​10 | 
VRM-Design: 5+3, 8 virtuelle CPU-Phasen (5+3), 8 reale CPU-Phasen (5+3) | 
MOSFETs VCORE: 5x 46A 4C10N/​10x 4C06N (High-/​Low-Side) | 
MOSFETs SOC/VCCGT: 3x 46A 4C10N/​4C06N (High-/​Low-Side) | 
PWM-Controller: RAA229004 (max. 8 Phasen) | 
Beleuchtung: N/​A | 
BIOS: 1x 32MB (256Mb) | 
Besonderheiten: Audio+solid capacitors',
59.99,
 'images/product-image-1.jpg'
 ),

(2, 'MSI B550-A Pro',
'Formfaktor: ATX | 
Sockel: AMD AM4 (PGA1331) | 
Chipsatz: AMD B550 | 
CPU-Kompatibilität: Ryzen 3000, Ryzen 4000G, Ryzen 5000G | 
RAM-Slots: 4x DDR4 DIMM, Dual Channel, UDIMM (Non-ECC), max. 128GB (UDIMM) | 
RAM-Taktfrequenz OC: max. DDR4-4400 | 
RAM-Taktfrequenz nativ: DDR4-3200 (Ryzen 3000), DDR4-3200 (Ryzen 4000G), DDR4-3200 (Ryzen 5000G) | 
ECC-Unterstützung: nein | 
Anschlüsse extern: 1x HDMI 2.1 (iGPU), 1x DisplayPort 1.4 (iGPU), 1x USB-C 3.1 (10Gb/​s, B550), 1x USB-A 3.1 (10Gb/​s, B550), 2x USB-A 3.0 (5Gb/​s), 4x USB-A 2.0 (480Mb/​s), 1x RJ-45 1Gb LAN (Realtek RTL8111H), 6x 3.5mm Klinke (Realtek ALC892), 1x PS/​2 Combo | 
PCIe-Slots: 1x PCIe 4.0 x16, 1x PCIe 3.0 x16 (x4), 2x PCIe 3.0 x1 | 
M.2-Slots: 1x M.2/​M-Key (PCIe 4.0 x4/​SATA, 22110/​2280/​2260/​2242), 1x M.2/​M-Key (PCIe 3.0 x4, 2280/​2260/​2242) | 
Sonstige Schnittstellen: 6x SATA 6Gb/s (B550) | 
Anschlüsse intern - USB: 1x USB-C 3.0 Key-A Header (5Gb/​s), 1x USB 3.0 Header 20-Pin (5Gb/​s, 2x USB 3.0), 2x USB 2.0 Header 9-Pin (480Mb/​s, 4x USB 2.0) | 
Anschlüsse intern - sonstige: 1x TPM-Header, 1x Chassis Intrusion-Header | 
Anschlüsse intern - Kühlung: 1x CPU-Lüfter 4-Pin, 6x Lüfter 4-Pin, 1x Lüfter/​Pumpe 4-Pin | 
Anschlüsse intern - Stromversorgung: 1x 24-Pin ATX, 1x 8-Pin EPS12V | 
Anschlüsse intern - Beleuchtung: 1x 4-Pin RGB (+12V/​G/​R/​B, max. 3A), 2x 3-Pin ARGB (+5V/​DATA/​GND, max. 3A) | 
Buttons/Switches: USB BIOS Flashback (extern), LED-Switch (intern) | 
Audio: Realtek ALC892 | 
Grafik: iGPU | 
Wireless: N/​A | 
RAID-Level: 0/​1/​10 | 
VRM-Design: 10+2, 12 virtuelle CPU-Phasen (2x5+2), 7 reale CPU-Phasen (5+2) | 
MOSFETs VCORE: 10x 46A 4C029N/​4C024N (High-/​Low-Side) | 
MOSFETs SOC/VCCGT: 4x 46A 4C029N/​4C024N (High-/​Low-Side) | 
PWM-Controller: IR35201 (max. 8 Phasen) | 
Beleuchtung: N/​A | 
BIOS: 1x 32MB (256Mb) | 
Besonderheiten: Audio+solid capacitors, Diagnostic LED (LED-Indikatoren), White Build-kompatibel (PCB primär schwarz), 1x M.2-Passivkühler, unterstützt AMD 2-Way-CrossFireX (x16/​x4)',
79.99,
'images/product-image-2.jpg'),

(3,
 'GIGABYTE B650 Eagle AX',
 'Formfaktor: ATX | 
Sockel: AMD AM5 (LGA1718) | 
Chipsatz: AMD B650 | 
CPU-Kompatibilität: Ryzen 7000, Ryzen 8000G, Ryzen 9000 | 
RAM-Slots: 4x DDR5 DIMM, Dual Channel, UDIMM (Non-ECC), max. 192GB (UDIMM) | 
RAM-Taktfrequenz OC: max. DDR5-7600 | 
RAM-Taktfrequenz nativ: DDR5-5200 (Ryzen 7000), DDR5-5200 (Ryzen 8000G), DDR5-5600 (Ryzen 9000) | 
ECC-Unterstützung: nein | 
Anschlüsse extern: 1x HDMI 2.1 (iGPU), 1x DisplayPort 1.4 (iGPU), 1x USB-C 3.0 (5Gb/​s), 2x USB-A 3.1 (10Gb/​s), 6x USB-A 2.0 (480Mb/​s), 1x RJ-45 1Gb LAN (Realtek), 3x 3.5mm Klinke (Realtek ALC897), 1x PS/​2 Combo, 2x Antennenanschluss RP-SMA | 
PCIe-Slots: 1x PCIe 4.0 x16, 3x PCIe 3.0 x16 (x1) | 
M.2-Slots: 1x M.2/​M-Key (PCIe 5.0 x4, 25110/​2580/​22110/​2280), 1x M.2/​M-Key (PCIe 4.0 x2, 22110/​2280), 1x M.2/​M-Key (PCIe 4.0 x4, 22110/​2280), 1x M.2/​E-Key (2230, belegt mit WiFi+BT-Modul) | 
Sonstige Schnittstellen: 4x SATA 6Gb/s (B650) | 
Anschlüsse intern - USB: 1x USB-C 3.0 Key-A Header (5Gb/​s), 1x USB 3.0 Header 20-Pin (5Gb/​s, 2x USB 3.0), 3x USB 2.0 Header 9-Pin (480Mb/​s, 6x USB 2.0) | 
Anschlüsse intern - sonstige: 1x seriell-Header, 1x TPM-Header | 
Anschlüsse intern - Kühlung: 1x CPU-Lüfter 4-Pin, 1x CPU-Lüfter/​Pumpe 4-Pin, 2x Lüfter 4-Pin, 1x Lüfter/​Pumpe 4-Pin | 
Anschlüsse intern - Stromversorgung: 1x 24-Pin ATX, 1x 8-Pin EPS12V | 
Anschlüsse intern - Beleuchtung: 3x 3-Pin ARGB (+5V/​DATA/​GND, max. 5A), 1x 4-Pin RGB (+12V/​G/​R/​B, max. 2A) | 
Buttons/Switches: USB BIOS Flashback/​Q-Flash Plus (intern) | 
Audio: Realtek ALC897 | 
Grafik: iGPU | 
Wireless: Wi-Fi 6E (WLAN 802.11a/​b/​g/​n/​ac/​ax, 2x2, Realtek RTL8852CE), Bluetooth 5.3 | 
RAID-Level: 0/​1/​10 | 
VRM-Design: 12+2, 14 virtuelle CPU-Phasen (2x6+2), 8 reale CPU-Phasen (6+2) | 
MOSFETs VCORE: 12x 46A 4C10N/​24x 4C06N (High-/​Low-Side) | 
MOSFETs SOC/VCCGT: 4x 46A 4C10N/​4C06N (High-/​Low-Side) | 
PWM-Controller: RT3678BE (max. 10 Phasen) | 
Beleuchtung: N/​A | 
BIOS: 1x 32MB (256Mb) | 
Besonderheiten: Audio+solid capacitors, Diagnostic LED (LED-Indikatoren), I/​O-Blende integriert, 1x M.2-Passivkühler',
74.99,
'images/product-image-3.jpg'),

(4,
 'MSI PRO B650-S WIFI',
  'Formfaktor: ATX | 
  Sockel: AMD AM5 (LGA1718) | 
  Chipsatz: AMD B650 | 
  CPU-Kompatibilität: Ryzen 7000, Ryzen 8000G, Ryzen 9000 | 
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
  99.99,
  'images/product-image-4.jpg'
),

(5, 
'ASRock WRX90 WS EVO',
'Formfaktor: E-ATX (SSI EEB) | 
Sockel: AMD sTR5 (LGA4844) | 
Chipsatz: AMD WRX90 | 
CPU-Kompatibilität: Ryzen Threadripper PRO 7000 | 
RAM-Slots: 8x DDR5 DIMM, 8 Channel, RDIMM, max. 2TB (RDIMM), 2TB (RDIMM-3DS) | 
RAM-Taktfrequenz OC: max. DDR5-7600 | 
RAM-Taktfrequenz nativ: DDR5-5200 (Ryzen Threadripper PRO 7000) | 
ECC-Unterstützung: ja | 
Anschlüsse extern: 1x DisplayPort 1.1a (AST2600), 2x USB4 (40Gb/​s, ASMedia ASM4242), 4x USB-A 3.1 (10Gb/​s), 2x USB-A 3.0 (5Gb/​s), 2x RJ-45 10Gb LAN (Intel X710-AT2), 1x Toslink S/​PDIF Out (Realtek ALC1220), 2x 3.5mm Klinke (Realtek ALC1220), 1x Management-Port (RJ-45) | 
PCIe-Slots: 7x PCIe 5.0 x16 (6x x16, 1x x8) | 
M.2-Slots: 1x M.2/​M-Key (PCIe 5.0 x4, 22110/​2280/​2260) | 
Sonstige Schnittstellen: 2x MCIO SFF-TA-1016 4i (PCIe 5.0 x4), 1x Slim SAS SFF-8654 4i (PCIe 4.0 x4/​SATA), 4x SATA 6Gb/s (via Slim SAS SFF-8654 4i) | 
Anschlüsse intern - USB: 1x USB-C 3.2 Key-A Header (20Gb/​s), 1x USB 3.0 Header 20-Pin (5Gb/​s, 2x USB 3.0), 2x USB 2.0 Header 9-Pin (480Mb/​s, 4x USB 2.0) | 
Anschlüsse intern - sonstige: 1x seriell-Header, 1x BMC-Header, 1x IPMB-Header, 1x SMBus-Header, 1x VGA-Header, 1x Speaker-Header, 2x SGPIO, 1x NMI-Header | 
Anschlüsse intern - Kühlung: 1x CPU-Lüfter 4-Pin, 1x CPU-Lüfter/​Pumpe 4-Pin, 3x Lüfter/​Pumpe 4-Pin, 2x Thermal-Sensor | 
Anschlüsse intern - Stromversorgung: 1x 24-Pin ATX, 2x 8-Pin EPS12V, 2x 6-Pin PCIe, 2x 6-Pin PCIe (Ausgang) | 
Anschlüsse intern - Beleuchtung: 2x 3-Pin ARGB (+5V/​DATA/​GND, max. 3A) | 
Buttons/Switches: Clear-CMOS-Button (intern), Power-Button (intern), Retry-Button (intern) | 
Audio: Realtek ALC1220 | 
Grafik: ASPEED AST2600 - Onboard | 
Wireless: N/​A | 
RAID-Level: 0/​1/​10 | 
VRM-Design: 18+3+3, 21 virtuelle CPU-Phasen (18+3), 21 reale CPU-Phasen (18+3) | 
MOSFETs VCORE: 18x 110A | 
MOSFETs SOC/VCCGT: 3x 110A | 
MOSFETs VDD_MISC/VCCSA/VCCAUX: 3x 110A | 
Beleuchtung: N/​A | 
BIOS: 1x 32MB (256Mb) | 
Besonderheiten: Audio+solid capacitors, Diagnostic LED (Segmentanzeige), VRM-Lüfter, 2x M.2-Passivkühler',
849.99,
'images/product-image-5.jpg'
),

(6,
'AMD Ryzen 9 7950X, 16C/32T, 4.50-5.70GHz, boxed ohne Kühler',
'Kerne: 16 (16C) |
Threads: 32 |
Turbotakt: 5.70GHz |
Basistakt: 4.50GHz |
TDP: 170W |
Grafik: ja (AMD Radeon Graphics) |
Sockel: AMD AM5 (LGA1718) |
Chipsatz-Eignung: A620, B650, B650E, B840, B850, X670, X670E, X870, X870E (modellabhängig: PRO 600, PRO 665, X600) |
Codename: Raphael |
Architektur: Zen 4 |
Fertigung: TSMC 5nm (CPU), TSMC 6nm (I/O) |
L2-Cache: 16MB (16x 1MB) |
L3-Cache: 64MB (2x 32MB) |
Speichercontroller: Dual Channel DDR5, max. 192GB (UEFI AGESA Basis 1.0.0.7 oder höher) |
Speicherkompatibilität: max. DDR5-5200 (PC5-41600, 83.2GB/s) |
Speicherkompatibilität erweitert (DIMM): DDR5-5200 (1DPC/1R), DDR5-5200 (1DPC/2R), DDR5-3600 (2DPC/1R), DDR5-3600 (2DPC/2R) |
ECC-Unterstützung: ja |
SMT: ja |
Fernwartung: nein |
Freier Multiplikator: ja |
CPU-Funktionen: AES-NI, AMD-V, AVX, AVX-512, AVX2, FMA3, MMX(+), SHA, SSE, SSE2, SSE3, SSE4.1, SSE4.2, SSE4a, x86-64 |
Systemeignung: 1 Sockel (1S) |
PCIe-Lanes: 28x PCIe 5.0 (verfügbar: 24) |
Chipsatz-Interface: PCIe 4.0 x4 |
iGPU-Modell: AMD Radeon Graphics |
iGPU-Takt: 0.40–2.20GHz |
iGPU-Einheiten: 2CU/128SP |
iGPU-Architektur: RDNA 2, Codename "Raphael" |
iGPU-Interface: DP 2.0, HDMI 2.1 |
iGPU-Funktionen: 4x Display Support, AMD Eyefinity, AMD FreeSync 2, AV1 decode, H.265 encode/decode, VP9 decode, DirectX 12.1, OpenGL 4.5, Vulkan 1.0 |
iGPU-Rechenleistung: 0.56 TFLOPS (FP32) |
Lieferumfang: ohne CPU-Kühler |
Einführung: 2022/Q3 (27.9.2022) |
Segment: Desktop (Mainstream) |
Stepping: RPL-B2 |
Temperatur max.: 95°C (Tjmax) |',
439.99,
'images/product-image-6.jpg'
),

(7,
'AMD Ryzen 9 9950X, 16C/32T, 4.30-5.70GHz, boxed ohne Kühler',
'Kerne: 16 (16C) |
Threads: 32 |
Turbotakt: 5.70GHz |
Basistakt: 4.30GHz |
TDP: 170W |
Grafik: ja (AMD Radeon Graphics) |
Sockel: AMD AM5 (LGA1718) |
Chipsatz-Eignung: A620, B650, B650E, B840, B850, X670, X670E, X870, X870E (modellabhängig: PRO 600, PRO 665, X600) |
Codename: Granite Ridge |
Architektur: Zen 5 |
Fertigung: TSMC 4nm (CPU), TSMC 6nm (I/O) |
L2-Cache: 16MB (16x 1MB) |
L3-Cache: 64MB (2x 32MB) |
Speichercontroller: Dual Channel DDR5, max. 192GB |
Speicherkompatibilität: max. DDR5-5600 (PC5-44800, 89.6GB/s) |
Speicherkompatibilität erweitert (DIMM): DDR5-5600 (1DPC/1R), DDR5-5600 (1DPC/2R), DDR5-3600 (2DPC/1R), DDR5-3600 (2DPC/2R) |
ECC-Unterstützung: ja |
SMT: ja |
Fernwartung: nein |
Freier Multiplikator: ja |
CPU-Funktionen: AES-NI, AMD-V, AVX, AVX-512, AVX2, FMA3, MMX(+), SHA, SSE, SSE2, SSE3, SSE4.1, SSE4.2, SSE4a, x86-64 |
Systemeignung: 1 Sockel (1S) |
PCIe-Lanes: 28x PCIe 5.0 (verfügbar: 24) |
Chipsatz-Interface: PCIe 4.0 x4 |
iGPU-Modell: AMD Radeon Graphics |
iGPU-Takt: 2.20GHz |
iGPU-Einheiten: 2CU/128SP |
iGPU-Architektur: RDNA 2, Codename "Granite Ridge" |
iGPU-Interface: DP 2.0, HDMI 2.1 |
iGPU-Funktionen: 4x Display Support, AMD Eyefinity, AMD FreeSync 2, AV1 decode, H.265 encode/decode, VP9 decode, DirectX 12.1, OpenGL 4.5, Vulkan 1.0 |
iGPU-Rechenleistung: 0.56 TFLOPS (FP32) |
Lieferumfang: ohne CPU-Kühler |
Einführung: 2024/Q3 |
Segment: Desktop (Mainstream) |
Stepping: GNR-B0 |
Temperatur max.: 95°C (Tjmax) |',
649.99,
'images/product-image-7.jpg'
),

(8,
'AMD Ryzen 5 8600G, 6C/12T, 4.30-5.00GHz, boxed',
'Kerne: 6 (6C) |
Threads: 12 |
Turbotakt: 5.00GHz |
Basistakt: 4.30GHz |
TDP: 65W, 45W cTDP-down |
Grafik: ja (AMD Radeon 760M) |
Sockel: AMD AM5 (LGA1718) |
Chipsatz-Eignung: A620, B650, B650E, B840, B850, X670, X670E, X870, X870E (modellabhängig: PRO 600, PRO 665, X600) |
Codename: Phoenix |
Architektur: Zen 4 |
Fertigung: TSMC 4nm |
L2-Cache: 6MB (6x 1MB) |
L3-Cache: 16MB |
Speichercontroller: Dual Channel DDR5, max. 256GB |
Speicherkompatibilität: max. DDR5-5200 (PC5-41600, 83.2GB/s) |
Speicherkompatibilität erweitert (DIMM): DDR5-5200 (1DPC/1R), DDR5-5200 (1DPC/2R), DDR5-3600 (2DPC/1R), DDR5-3600 (2DPC/2R) |
ECC-Unterstützung: nein |
SMT: ja |
Fernwartung: nein |
Freier Multiplikator: ja |
CPU-Funktionen: AES-NI, AMD-V, AVX, AVX-512, AVX2, FMA3, MMX(+), SHA, SSE, SSE2, SSE3, SSE4.1, SSE4.2, SSE4a, x86-64 |
Systemeignung: 1 Sockel (1S) |
PCIe-Lanes: 20x PCIe 4.0 (verfügbar: 16) |
iGPU-Modell: AMD Radeon 760M |
iGPU-Takt: 2.80GHz |
iGPU-Einheiten: 8CU/512SP |
iGPU-Architektur: RDNA 3, Codename "Phoenix" |
iGPU-Interface: DP 2.1, HDMI 2.1 |
iGPU-Funktionen: 4x Display Support, AMD Eyefinity, AMD FreeSync 2, AV1 encode/decode, H.265 encode/decode, VP9 decode, DirectX 12.1, OpenGL 4.5, Vulkan 1.0 |
iGPU-Rechenleistung: 2.87 TFLOPS (FP32) |
NPU-Rechenleistung: 16 TOPS (AMD Ryzen AI) |
Lieferumfang: mit CPU-Kühler (AMD Wraith Stealth, BxHxT: 102x54x114mm) |
Einführung: 2024/Q1 (8.1.2024) |
Segment: Desktop (Mainstream) |
Stepping: PHX-A1 |
Temperatur max.: 95°C (Tjmax) |',
139.99,
'images/product-image-8.jpg'
),

(9,
'AMD Ryzen 7 9800X3D, 8C/16T, 4.70-5.20GHz, boxed ohne Kühler',
'Kerne: 8 (8C) |
Threads: 16 |
Turbotakt: 5.20GHz |
Basistakt: 4.70GHz |
TDP: 120W |
Grafik: ja (AMD Radeon Graphics) |
Sockel: AMD AM5 (LGA1718) |
Chipsatz-Eignung: A620, B650, B650E, B840, B850, X670, X670E, X870, X870E (modellabhängig: PRO 600, PRO 665, X600) |
Codename: Granite Ridge |
Architektur: Zen 5 |
Fertigung: TSMC 4nm (CPU), TSMC 6nm (I/O) |
L2-Cache: 8MB (8x 1MB) |
L3-Cache: 96MB (32MB + 64MB 3D-Cache) |
Speichercontroller: Dual Channel DDR5, max. 192GB |
Speicherkompatibilität: max. DDR5-5600 (PC5-44800, 89.6GB/s) |
Speicherkompatibilität erweitert (DIMM): DDR5-5600 (1DPC/1R), DDR5-5600 (1DPC/2R), DDR5-3600 (2DPC/1R), DDR5-3600 (2DPC/2R) |
ECC-Unterstützung: ja |
SMT: ja |
Fernwartung: nein |
Freier Multiplikator: ja |
CPU-Funktionen: AES-NI, AMD-V, AVX, AVX-512, AVX2, FMA3, MMX(+), SHA, SSE, SSE2, SSE3, SSE4.1, SSE4.2, SSE4a, x86-64 |
Systemeignung: 1 Sockel (1S) |
PCIe-Lanes: 28x PCIe 5.0 (verfügbar: 24) |
Chipsatz-Interface: PCIe 4.0 x4 |
iGPU-Modell: AMD Radeon Graphics |
iGPU-Takt: 2.20GHz |
iGPU-Einheiten: 2CU/128SP |
iGPU-Architektur: RDNA 2, Codename "Granite Ridge" |
iGPU-Interface: DP 2.0, HDMI 2.1 |
iGPU-Funktionen: 4x Display Support, AMD Eyefinity, AMD FreeSync 2, AV1 decode, H.265 encode/decode, VP9 decode, DirectX 12.1, OpenGL 4.5, Vulkan 1.0 |
iGPU-Rechenleistung: 0.56 TFLOPS (FP32) |
Lieferumfang: ohne CPU-Kühler |
Einführung: 2024/Q4 (7.11.2024) |
Segment: Desktop (Mainstream) |
Stepping: GNR-B0 |
Temperatur max.: 95°C (Tjmax) |',
699.99,
'images/product-image-9.jpg'),

(10,
'AMD Ryzen 5 9600X, 6C/12T, 3.90-5.40GHz, boxed ohne Kühler',
'Kerne: 6 (6C) |
Threads: 12 |
Turbotakt: 5.40GHz |
Basistakt: 3.90GHz |
TDP: 65W |
Grafik: ja (AMD Radeon Graphics) |
Sockel: AMD AM5 (LGA1718) |
Chipsatz-Eignung: A620, B650, B650E, B840, B850, X670, X670E, X870, X870E (modellabhängig: PRO 600, PRO 665, X600) |
Codename: Granite Ridge |
Architektur: Zen 5 |
Fertigung: TSMC 4nm (CPU), TSMC 6nm (I/O) |
L2-Cache: 6MB (6x 1MB) |
L3-Cache: 32MB |
Speichercontroller: Dual Channel DDR5, max. 192GB |
Speicherkompatibilität: max. DDR5-5600 (PC5-44800, 89.6GB/s) |
Speicherkompatibilität erweitert (DIMM): DDR5-5600 (1DPC/1R), DDR5-5600 (1DPC/2R), DDR5-3600 (2DPC/1R), DDR5-3600 (2DPC/2R) |
ECC-Unterstützung: ja |
SMT: ja |
Fernwartung: nein |
Freier Multiplikator: ja |
CPU-Funktionen: AES-NI, AMD-V, AVX, AVX-512, AVX2, FMA3, MMX(+), SHA, SSE, SSE2, SSE3, SSE4.1, SSE4.2, SSE4a, x86-64 |
Systemeignung: 1 Sockel (1S) |
PCIe-Lanes: 28x PCIe 5.0 (verfügbar: 24) |
Chipsatz-Interface: PCIe 4.0 x4 |
iGPU-Modell: AMD Radeon Graphics |
iGPU-Takt: 2.20GHz |
iGPU-Einheiten: 2CU/128SP |
iGPU-Architektur: RDNA 2, Codename "Granite Ridge" |
iGPU-Interface: DP 2.0, HDMI 2.1 |
iGPU-Funktionen: 4x Display Support, AMD Eyefinity, AMD FreeSync 2, AV1 decode, H.265 encode/decode, VP9 decode, DirectX 12.1, OpenGL 4.5, Vulkan 1.0 |
iGPU-Rechenleistung: 0.56 TFLOPS (FP32) |
Lieferumfang: ohne CPU-Kühler |
Einführung: 2024/Q3 |
Segment: Desktop (Mainstream) |
Stepping: GNR-B0 |
Temperatur max.: 95°C (Tjmax) |',
209.99,
'images/product-image-10.jpg'
)


;