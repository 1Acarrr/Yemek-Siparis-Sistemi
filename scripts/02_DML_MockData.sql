-- ============================================================
-- VTYS-1 Dönem Projesi: Yemek Sipariş Sistemi
-- Dosya: 02_DML_MockData.sql
-- Açıklama: Test verileri — Kullanıcılar, Restoranlar, Ürünler
-- ============================================================

USE YemekSiparisDB;
GO

-- ============================================================
-- 1. KULLANICILAR (20 Müşteri + Sahipler + Kuryeler + Admin)
-- ============================================================
INSERT INTO Kullanicilar (Ad, Soyad, Eposta, Telefon, SifreHash, Rol, IsVerifiedNeedy) VALUES
-- Admin
('Kemal',   'Yurt',    'admin@yemeksiparis.com',  '5550000001', 'admin_hash',  'Admin',          0),
-- Restoran Sahipleri (5 kişi)
('Can',     'Ozdemir', 'can.oz@mail.com',          '5550000002', 'hash_can',   'RestoranSahibi', 0),
('Ece',     'Aydin',   'ece.aydin@mail.com',        '5550000003', 'hash_ece',   'RestoranSahibi', 0),
('Gizem',   'Bakir',   'gizem.b@mail.com',          '5550000004', 'hash_giz',   'RestoranSahibi', 0),
('Hakan',   'Sener',   'hakan.s@mail.com',          '5550000005', 'hash_hak',   'RestoranSahibi', 0),
('Merve',   'Guler',   'merve.g@mail.com',          '5550000006', 'hash_mer',   'RestoranSahibi', 0),
-- Kuryeler (3 kişi)
('Burak',   'Turan',   'burak.kurye@mail.com',      '5550000007', 'hash_bur',   'Kurye',          0),
('Deniz',   'Yalcin',  'deniz.kurye@mail.com',      '5550000008', 'hash_den',   'Kurye',          0),
('Umut',    'Koc',     'umut.kurye@mail.com',        '5550000009', 'hash_umt',   'Kurye',          0),
-- Müşteriler — Normal (11 kişi)
('Ahmet',   'Yilmaz',  'ahmet@mail.com',             '5550000010', 'hash_ahm',   'Musteri',        0),
('Selin',   'Yildiz',  'selin@mail.com',              '5550000011', 'hash_sel',   'Musteri',        0),
('Ali',     'Aras',    'ali.aras@mail.com',           '5550000012', 'hash_ali',   'Musteri',        0),
('Zeynep',  'Korkmaz', 'zeynep@mail.com',             '5550000013', 'hash_zey',   'Musteri',        0),
('Serkan',  'Dogan',   'serkan@mail.com',             '5550000014', 'hash_ser',   'Musteri',        0),
('Pelin',   'Seker',   'pelin@mail.com',              '5550000015', 'hash_pel',   'Musteri',        0),
('Mert',    'Celik',   'mert.celik@mail.com',         '5550000016', 'hash_mert',  'Musteri',        0),
('Buse',    'Kaplan',  'buse.k@mail.com',             '5550000017', 'hash_buse',  'Musteri',        0),
('Tolga',   'Arslan',  'tolga@mail.com',              '5550000018', 'hash_tolg',  'Musteri',        0),
('Irem',    'Polat',   'irem@mail.com',               '5550000019', 'hash_irem',  'Musteri',        0),
('Cagri',   'Sahin',   'cagri@mail.com',              '5550000020', 'hash_cag',   'Musteri',        0),
-- Müşteriler — İhtiyaç Sahibi (Admin onaylı, 4 kişi)
('Ayse',    'Demir',   'ayse.ihtiyac@mail.com',      '5550000021', 'hash_ays',   'Musteri',        1),
('Fatma',   'Celik',   'fatma.ihtiyac@mail.com',     '5550000022', 'hash_fat',   'Musteri',        1),
('Murat',   'Aksoy',   'murat.ihtiyac@mail.com',     '5550000023', 'hash_mur',   'Musteri',        1),
('Elif',    'Sari',    'elif.ihtiyac@mail.com',       '5550000024', 'hash_eli',   'Musteri',        1);
GO

-- ============================================================
-- 2. ADRESLER
-- ============================================================
INSERT INTO Adresler (KullaniciID, AdresBasligi, AdresTarifi, Ilce, Sehir) VALUES
(10, 'Ev',       'Cumhuriyet Mah. Lale Sok. No:5 D:3',     'Besiktas',  'Istanbul'),
(10, 'İş',       'Maslak Plaza B Blok Kat:4',              'Sariyer',   'Istanbul'),
(11, 'Ev',       'Bagdat Cad. No:120 D:7',                 'Kadikoy',   'Istanbul'),
(12, 'Ev',       'Ataturk Bulv. No:45',                    'Sisli',     'Istanbul'),
(13, 'Ev',       'Fatih Cad. No:30 D:2',                   'Fatih',     'Istanbul'),
(14, 'Ev',       'Bagcilar Mah. No:12',                    'Bagcilar',  'Istanbul'),
(15, 'Ev',       'Uskudar Meydani No:7',                   'Uskudar',   'Istanbul'),
(16, 'Ev',       'Pendik Sahil Sitesi A:3',                'Pendik',    'Istanbul'),
(17, 'Ev',       'Kartal Cad. No:55 D:1',                  'Kartal',    'Istanbul'),
(18, 'Ev',       'Maltepe Bulv. No:99',                    'Maltepe',   'Istanbul'),
(19, 'Ev',       'Avcilar Merkez No:8',                    'Avcilar',   'Istanbul'),
(20, 'Ev',       'Beylikduzu Yolu No:3',                   'Beylikduzu','Istanbul'),
(21, 'Ev',       'Zeytinburnu Mah. No:22',                 'Zeytinburnu','Istanbul'),
(22, 'Ev',       'Bayrampasa Cad. No:16',                  'Bayrampasa','Istanbul'),
(23, 'Ev',       'Gaziosmanpasa Mah. No:5',                'GOP',       'Istanbul'),
(24, 'Ev',       'Sultangazi Cad. No:11',                  'Sultangazi','Istanbul');
GO

-- ============================================================
-- 3. KURYELER
-- ============================================================
INSERT INTO Kuryeler (KuryeID, AracTipi, PlakaNo, IsAvailable) VALUES
(7, 'Motosiklet', '34 ABC 001', 1),
(8, 'Bisiklet',   NULL,         1),
(9, 'Motosiklet', '34 XYZ 002', 1);
GO

-- ============================================================
-- 4. RESTORANLAR (5 Adet)
-- ============================================================
INSERT INTO Restoranlar (SahipID, Ad, Adres, Telefon, AcilisYili) VALUES
(2, 'Burger Sarayi',    'Besiktas, Istanbul',    '2120000001', 2018),
(3, 'Lezzet Kebap',     'Kadikoy, Istanbul',     '2160000002', 2015),
(4, 'Pizza Dunyasi',    'Sisli, Istanbul',       '2120000003', 2019),
(5, 'Ev Yemekleri Evi', 'Fatih, Istanbul',       '2120000004', 2012),
(6, 'Tatli Koseresi',   'Uskudar, Istanbul',     '2160000005', 2020);
GO

-- ============================================================
-- 5. KATEGORİLER
-- ============================================================
INSERT INTO MenuKategorileri (KategoriAdi) VALUES
('Burger'), ('Kebap'), ('Pizza'), ('Ev Yemegi'), ('Tatli'), ('Icecek'), ('Salata');
GO

-- ============================================================
-- 6. ÜRÜNLER (50 Adet — her restorana 10'ar ürün)
-- ============================================================

-- Burger Sarayi (RestoranID: 1)
INSERT INTO Urunler (RestoranID, KategoriID, UrunAdi, Aciklama, Fiyat, HazirlamaSuresi) VALUES
(1,1,'Klasik Burger','150gr dana köfte, marul, domates, turşu',180.00,15),
(1,1,'Cheeseburger','Cheddar peyniri, özel sos, kornişon',210.00,15),
(1,1,'Tavuk Burger','Çıtır tavuk göğsü, coleslaw',160.00,12),
(1,1,'Double Burger','300gr double köfte, çift peynir',320.00,20),
(1,1,'Veggie Burger','Sebze köftesi, avokado, humus',190.00,15),
(1,1,'BBQ Burger','Barbekü soslu, soğan halkası',250.00,18),
(1,1,'Mantarli Burger','Karamelize soğan ve mantar',230.00,17),
(1,6,'Kola 330ml','Soğuk servis',45.00,2),
(1,6,'Ayran 300ml','Doğal yayık ayran',30.00,2),
(1,5,'Sufle','Sıcak çikolatalı sufle',120.00,10);

-- Lezzet Kebap (RestoranID: 2)
INSERT INTO Urunler (RestoranID, KategoriID, UrunAdi, Aciklama, Fiyat, HazirlamaSuresi) VALUES
(2,2,'Adana Kebap','Acılı zırh kıyması, mangal ateşinde',280.00,20),
(2,2,'Urfa Kebap','Acısız zırh kıyması',280.00,20),
(2,2,'Kuzu Şiş','Kuzu buttan lokum et',350.00,25),
(2,2,'Lahmacun','Çıtır hamur, bol malzeme',85.00,12),
(2,2,'Beyti Sarma','Özel soslu dana kebap',320.00,22),
(2,2,'Ali Nazik','Patlıcan beğendili kuzu kebap',340.00,25),
(2,2,'Karisik Izgara','Her çeşit et tabağı',550.00,30),
(2,6,'Şalgam Suyu','Acılı/Acısız seçeneği',35.00,2),
(2,6,'Ayran','Bol köpüklü yayık ayran',35.00,2),
(2,5,'Künefe','Antep fıstıklı, sıcak servis',150.00,15);

-- Pizza Dunyasi (RestoranID: 3)
INSERT INTO Urunler (RestoranID, KategoriID, UrunAdi, Aciklama, Fiyat, HazirlamaSuresi) VALUES
(3,3,'Margarita','Mozzarella, domates sos, fesleğen',220.00,20),
(3,3,'Karışık Pizza','Sucuk, sosis, mantar, mısır, biber',290.00,22),
(3,3,'Pepperoni Pizza','Bol bol pepperoni, mozzarella',310.00,22),
(3,3,'Dört Peynirli Pizza','Mozzarella, Parmesan, Rokfor, Cheddar',330.00,22),
(3,3,'Sebzeli Pizza','Mevsim sebzeleri, pesto sos',250.00,20),
(3,3,'BBQ Tavuklu Pizza','Barbekü soslu ızgara tavuk',280.00,22),
(3,3,'Akdeniz Pizzası','Zeytin, beyaz peynir, roka',260.00,20),
(3,6,'Ice Tea','Şeftali veya Limon seçeneği',45.00,2),
(3,6,'Sprite 330ml','Soğuk gazlı içecek',45.00,2),
(3,5,'Tiramisu','Klasik İtalyan tatlısı',140.00,5);

-- Ev Yemekleri Evi (RestoranID: 4)
INSERT INTO Urunler (RestoranID, KategoriID, UrunAdi, Aciklama, Fiyat, HazirlamaSuresi) VALUES
(4,4,'Kuru Fasulye','İspir fasulyesi, pilav ile',160.00,5),
(4,4,'Pilav','Tereyağlı baldo pirinç',80.00,5),
(4,4,'Karnıyarık','Patlıcan ve kıyma dolması',190.00,5),
(4,4,'İzmir Köfte','Sebzeli ve salçalı fırın köftesi',210.00,10),
(4,4,'Tas Kebabı','Dana etli, sebzeli',250.00,8),
(4,4,'Mercimek Çorbası','Tereyağlı soslu',75.00,5),
(4,4,'Musakka','Patlıcanlı kıymalı fırın yemeği',185.00,8),
(4,7,'Mevsim Salatası','Taze sebzeler, zeytinyağı',90.00,5),
(4,6,'Limonata','Ev yapımı taze limonata',70.00,3),
(4,5,'Sütlaç','Fırında pişirilmiş sütlaç',100.00,5);

-- Tatli Koseresi (RestoranID: 5)
INSERT INTO Urunler (RestoranID, KategoriID, UrunAdi, Aciklama, Fiyat, HazirlamaSuresi) VALUES
(5,5,'Fıstıklı Baklava','4 dilim, Antep fıstığı',220.00,5),
(5,5,'Sütlü Nuriye','Hafif sütlü baklava',180.00,5),
(5,5,'Kazandibi','Yanıklı, geleneksel lezzet',120.00,5),
(5,5,'Profiterol','Bol çikolata soslu',140.00,5),
(5,5,'Magnolia','Mevsim meyveleri ile',130.00,5),
(5,5,'Trileçe','Karamelli üç sütlü',120.00,5),
(5,5,'Mozaik Pasta','Cevizli, çikolatalı',110.00,5),
(5,5,'Muhallebi','Gülsuylu, geleneksel',95.00,5),
(5,6,'Türk Kahvesi','Geleneksel pişirme',65.00,8),
(5,6,'Sahlep','Tarçınlı, sıcak servis',90.00,5);
GO
