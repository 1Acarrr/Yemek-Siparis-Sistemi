-- ============================================================
-- VTYS-1 Dönem Projesi: Yemek Sipariş Sistemi
-- Dosya: 03_DML_Siparisler.sql
-- Açıklama: Siparişler (100 hareket), Bağışlar, Ödemeler, Yorumlar
-- ============================================================

USE YemekSiparisDB;
GO

-- ============================================================
-- 1. BAĞIŞLAR (Havuzu dolduralım — Triggerlar henüz yok,
--    manuel olarak havuz bakiyesini de güncelleyeceğiz)
-- ============================================================
INSERT INTO Bagislar (KullaniciID, Miktar, BagisNotu) VALUES
(10, 500.00,  'Hayırlı olsun'),
(11, 1000.00, 'İhtiyaç sahiplerine'),
(NULL, 250.00, NULL),           -- Anonim bağış
(12, 750.00,  'Hayırlı olsun'),
(13, 100.00,  NULL),
(NULL, 2000.00, NULL),          -- Büyük anonim bağış
(14, 300.00,  'Az da olsa'),
(15, 150.00,  NULL),
(16, 200.00,  'Geçmiş olsun'),
(NULL, 500.00, NULL);           -- Anonim
GO

-- Havuz bakiyesini başlangıçta manuel güncelle (Trigger Commit #6'da eklenecek)
UPDATE AskidaYemekHavuzu
SET ToplamBakiye = 5750.00,
    ToplamBagis  = 10,
    SonGuncelleme = GETDATE()
WHERE HavuzID = 1;
GO

-- ============================================================
-- 2. SİPARİŞLER (100 Hareket)
-- Normal siparişler + Askıda Yemek siparişleri
-- ============================================================

-- Normal teslim edilmiş siparişler (70 adet)
INSERT INTO Siparisler (MusteriID, RestoranID, KuryeID, TeslimatAdresID, ToplamTutar, Durum, TeslimTarihi) VALUES
(10,1,7,1,  225.00,'Teslim Edildi', DATEADD(day,-30,GETDATE())),
(11,2,8,3,  365.00,'Teslim Edildi', DATEADD(day,-29,GETDATE())),
(12,3,9,4,  290.00,'Teslim Edildi', DATEADD(day,-28,GETDATE())),
(13,4,7,5,  235.00,'Teslim Edildi', DATEADD(day,-27,GETDATE())),
(14,5,8,6,  340.00,'Teslim Edildi', DATEADD(day,-26,GETDATE())),
(15,1,9,7,  390.00,'Teslim Edildi', DATEADD(day,-25,GETDATE())),
(16,2,7,8,  280.00,'Teslim Edildi', DATEADD(day,-24,GETDATE())),
(17,3,8,9,  550.00,'Teslim Edildi', DATEADD(day,-23,GETDATE())),
(18,4,9,10, 160.00,'Teslim Edildi', DATEADD(day,-22,GETDATE())),
(19,5,7,11, 220.00,'Teslim Edildi', DATEADD(day,-21,GETDATE())),
(20,1,8,12, 430.00,'Teslim Edildi', DATEADD(day,-20,GETDATE())),
(10,2,9,1,  630.00,'Teslim Edildi', DATEADD(day,-19,GETDATE())),
(11,3,7,3,  260.00,'Teslim Edildi', DATEADD(day,-18,GETDATE())),
(12,4,8,4,  190.00,'Teslim Edildi', DATEADD(day,-17,GETDATE())),
(13,5,9,5,  350.00,'Teslim Edildi', DATEADD(day,-16,GETDATE())),
(14,1,7,6,  210.00,'Teslim Edildi', DATEADD(day,-15,GETDATE())),
(15,2,8,7,  560.00,'Teslim Edildi', DATEADD(day,-14,GETDATE())),
(16,3,9,8,  310.00,'Teslim Edildi', DATEADD(day,-13,GETDATE())),
(17,4,7,9,  185.00,'Teslim Edildi', DATEADD(day,-12,GETDATE())),
(18,5,8,10, 450.00,'Teslim Edildi', DATEADD(day,-11,GETDATE())),
(19,1,9,11, 180.00,'Teslim Edildi', DATEADD(day,-10,GETDATE())),
(20,2,7,12, 315.00,'Teslim Edildi', DATEADD(day,-9, GETDATE())),
(10,3,8,1,  260.00,'Teslim Edildi', DATEADD(day,-8, GETDATE())),
(11,4,9,3,  240.00,'Teslim Edildi', DATEADD(day,-7, GETDATE())),
(12,5,7,4,  265.00,'Teslim Edildi', DATEADD(day,-6, GETDATE())),
(13,1,8,5,  500.00,'Teslim Edildi', DATEADD(day,-5, GETDATE())),
(14,2,9,6,  280.00,'Teslim Edildi', DATEADD(day,-4, GETDATE())),
(15,3,7,7,  330.00,'Teslim Edildi', DATEADD(day,-3, GETDATE())),
(16,4,8,8,  205.00,'Teslim Edildi', DATEADD(day,-2, GETDATE())),
(17,5,9,9,  120.00,'Teslim Edildi', DATEADD(day,-1, GETDATE())),
-- Devam...
(10,1,7,1,  390.00,'Teslim Edildi', DATEADD(day,-29,GETDATE())),
(11,2,8,3,  245.00,'Teslim Edildi', DATEADD(day,-28,GETDATE())),
(12,3,9,4,  310.00,'Teslim Edildi', DATEADD(day,-27,GETDATE())),
(13,4,7,5,  155.00,'Teslim Edildi', DATEADD(day,-26,GETDATE())),
(14,5,8,6,  440.00,'Teslim Edildi', DATEADD(day,-25,GETDATE())),
(15,1,9,7,  270.00,'Teslim Edildi', DATEADD(day,-24,GETDATE())),
(16,2,7,8,  580.00,'Teslim Edildi', DATEADD(day,-23,GETDATE())),
(17,3,8,9,  200.00,'Teslim Edildi', DATEADD(day,-22,GETDATE())),
(18,4,9,10, 175.00,'Teslim Edildi', DATEADD(day,-21,GETDATE())),
(19,5,7,11, 300.00,'Teslim Edildi', DATEADD(day,-20,GETDATE())),
(20,1,8,12, 215.00,'Teslim Edildi', DATEADD(day,-19,GETDATE())),
(10,2,9,1,  345.00,'Teslim Edildi', DATEADD(day,-18,GETDATE())),
(11,3,7,3,  420.00,'Teslim Edildi', DATEADD(day,-17,GETDATE())),
(12,4,8,4,  160.00,'Teslim Edildi', DATEADD(day,-16,GETDATE())),
(13,5,9,5,  230.00,'Teslim Edildi', DATEADD(day,-15,GETDATE())),
(14,1,7,6,  480.00,'Teslim Edildi', DATEADD(day,-14,GETDATE())),
(15,2,8,7,  355.00,'Teslim Edildi', DATEADD(day,-13,GETDATE())),
(16,3,9,8,  290.00,'Teslim Edildi', DATEADD(day,-12,GETDATE())),
(17,4,7,9,  210.00,'Teslim Edildi', DATEADD(day,-11,GETDATE())),
(18,5,8,10, 135.00,'Teslim Edildi', DATEADD(day,-10,GETDATE())),
(19,1,9,11, 410.00,'Teslim Edildi', DATEADD(day,-9, GETDATE())),
(20,2,7,12, 275.00,'Teslim Edildi', DATEADD(day,-8, GETDATE())),
(10,3,8,1,  320.00,'Teslim Edildi', DATEADD(day,-7, GETDATE())),
(11,4,9,3,  185.00,'Teslim Edildi', DATEADD(day,-6, GETDATE())),
(12,5,7,4,  240.00,'Teslim Edildi', DATEADD(day,-5, GETDATE())),
(13,1,8,5,  360.00,'Teslim Edildi', DATEADD(day,-4, GETDATE())),
(14,2,9,6,  430.00,'Teslim Edildi', DATEADD(day,-3, GETDATE())),
(15,3,7,7,  195.00,'Teslim Edildi', DATEADD(day,-2, GETDATE())),
(16,4,8,8,  265.00,'Teslim Edildi', DATEADD(day,-1, GETDATE())),
(17,5,9,9,  110.00,'Teslim Edildi', DATEADD(day,-1, GETDATE())),
-- Ek siparişler farklı müşterilerden
(18,1,7,10, 230.00,'Teslim Edildi', DATEADD(day,-15,GETDATE())),
(19,2,8,11, 470.00,'Teslim Edildi', DATEADD(day,-14,GETDATE())),
(20,3,9,12, 285.00,'Teslim Edildi', DATEADD(day,-13,GETDATE())),
(10,4,7,1,  140.00,'Teslim Edildi', DATEADD(day,-12,GETDATE())),
(11,5,8,3,  320.00,'Teslim Edildi', DATEADD(day,-11,GETDATE())),
(12,1,9,4,  255.00,'Teslim Edildi', DATEADD(day,-10,GETDATE())),
(13,2,7,5,  490.00,'Teslim Edildi', DATEADD(day,-9, GETDATE())),
(14,3,8,6,  175.00,'Teslim Edildi', DATEADD(day,-8, GETDATE())),
(15,4,9,7,  210.00,'Teslim Edildi', DATEADD(day,-7, GETDATE())),
(16,5,7,8,  145.00,'Teslim Edildi', DATEADD(day,-6, GETDATE()));
GO

-- Aktif/Bekleyen siparişler (20 adet)
INSERT INTO Siparisler (MusteriID, RestoranID, KuryeID, TeslimatAdresID, ToplamTutar, Durum) VALUES
(17,1,7,9,  310.00,'Yolda'),
(18,2,8,10, 280.00,'Yolda'),
(19,3,9,11, 330.00,'Hazirlaniyor'),
(20,4,NULL, 12, 190.00,'Hazirlaniyor'),
(10,5,NULL, 1,  220.00,'Beklemede'),
(11,1,NULL, 3,  410.00,'Beklemede'),
(12,2,NULL, 4,  265.00,'Beklemede'),
(13,3,NULL, 5,  180.00,'Iptal Edildi'),
(14,4,NULL, 6,  155.00,'Iptal Edildi'),
(15,5,NULL, 7,  310.00,'Beklemede'),
(16,1,NULL, 8,  240.00,'Beklemede'),
(17,2,NULL, 9,  370.00,'Beklemede'),
(18,3,NULL, 10, 200.00,'Beklemede'),
(19,4,NULL, 11, 185.00,'Beklemede'),
(20,5,NULL, 12, 120.00,'Beklemede'),
(10,1,NULL, 1,  295.00,'Beklemede'),
(11,2,NULL, 3,  440.00,'Beklemede'),
(12,3,NULL, 4,  260.00,'Beklemede'),
(13,4,NULL, 5,  175.00,'Beklemede'),
(14,5,NULL, 6,  230.00,'Beklemede');
GO

-- Askıda Yemek siparişleri (ihtiyaç sahipleri - 10 adet)
INSERT INTO Siparisler (MusteriID, RestoranID, KuryeID, TeslimatAdresID, ToplamTutar, Durum, TeslimTarihi) VALUES
(21,1,7,13, 0.00,'Teslim Edildi', DATEADD(day,-10,GETDATE())),  -- Ayşe
(22,2,8,14, 0.00,'Teslim Edildi', DATEADD(day,-9, GETDATE())),  -- Fatma
(23,4,9,15, 0.00,'Teslim Edildi', DATEADD(day,-8, GETDATE())),  -- Murat
(24,5,7,16, 0.00,'Teslim Edildi', DATEADD(day,-7, GETDATE())),  -- Elif
(21,3,8,13, 0.00,'Teslim Edildi', DATEADD(day,-5, GETDATE())),
(22,4,9,14, 0.00,'Teslim Edildi', DATEADD(day,-4, GETDATE())),
(23,1,7,15, 0.00,'Teslim Edildi', DATEADD(day,-3, GETDATE())),
(24,2,8,16, 0.00,'Teslim Edildi', DATEADD(day,-2, GETDATE())),
(21,5,9,13, 0.00,'Teslim Edildi', DATEADD(day,-1, GETDATE())),
(22,3,7,14, 0.00,'Teslim Edildi', GETDATE());
GO

-- ============================================================
-- 3. SİPARİŞ DETAYLARI (Temsili — teslim edilmiş siparişler için)
-- ============================================================
INSERT INTO SiparisDetaylari (SiparisID, UrunID, Adet, BirimFiyat) VALUES
(1,  1, 1, 180.00), (1,  8, 1, 45.00),
(2,  11,1, 280.00), (2,  14,1, 85.00),
(3,  21,1, 290.00),
(4,  31,1, 160.00), (4,  32,1, 75.00),
(5,  41,1, 220.00), (5,  46,1, 120.00),
(6,  2, 1, 210.00), (6,  9, 1, 30.00), (6,  7, 1, 120.00),
(7,  13,1, 280.00),
(8,  22,1, 290.00), (8,  23,1, 310.00),
(9,  34,1, 160.00),
(10, 41,1, 220.00),
(11, 3, 2, 160.00), (11, 8, 1, 45.00), (11, 10,1, 120.00);
GO

-- ============================================================
-- 4. ÖDEMELER
-- ============================================================
-- Teslim edilmiş normal siparişler için ödeme
INSERT INTO Odemeler (SiparisID, OdemeYontemi, Tutar, OdemeDurumu) VALUES
(1,  'Kart',   225.00, 'Tamamlandi'),
(2,  'Online', 365.00, 'Tamamlandi'),
(3,  'Kart',   290.00, 'Tamamlandi'),
(4,  'Nakit',  235.00, 'Tamamlandi'),
(5,  'Online', 340.00, 'Tamamlandi'),
(6,  'Kart',   390.00, 'Tamamlandi'),
(7,  'Nakit',  280.00, 'Tamamlandi'),
(8,  'Online', 550.00, 'Tamamlandi'),
(9,  'Kart',   160.00, 'Tamamlandi'),
(10, 'Nakit',  220.00, 'Tamamlandi'),
(11, 'Online', 430.00, 'Tamamlandi'),
(12, 'Kart',   630.00, 'Tamamlandi'),
(13, 'Nakit',  260.00, 'Tamamlandi'),
(14, 'Kart',   190.00, 'Tamamlandi'),
(15, 'Online', 350.00, 'Tamamlandi');
GO

-- Askıda Yemek ödemeleri (0 TL — havuzdan karşılandı)
INSERT INTO Odemeler (SiparisID, OdemeYontemi, Tutar, OdemeDurumu) VALUES
(91,  'AskidaYemek', 0.00, 'Tamamlandi'),
(92,  'AskidaYemek', 0.00, 'Tamamlandi'),
(93,  'AskidaYemek', 0.00, 'Tamamlandi'),
(94,  'AskidaYemek', 0.00, 'Tamamlandi'),
(95,  'AskidaYemek', 0.00, 'Tamamlandi'),
(96,  'AskidaYemek', 0.00, 'Tamamlandi'),
(97,  'AskidaYemek', 0.00, 'Tamamlandi'),
(98,  'AskidaYemek', 0.00, 'Tamamlandi'),
(99,  'AskidaYemek', 0.00, 'Tamamlandi'),
(100, 'AskidaYemek', 0.00, 'Tamamlandi');
GO

-- Askıda Sipariş kullanım kayıtları
INSERT INTO AskidaSiparisler (MusteriID, SiparisID, KullanilanMiktar) VALUES
(21, 91,  180.00),
(22, 92,  280.00),
(23, 93,  160.00),
(24, 94,  220.00),
(21, 95,  220.00),
(22, 96,  185.00),
(23, 97,  225.00),
(24, 98,  280.00),
(21, 99,  120.00),
(22, 100, 290.00);
GO

-- ============================================================
-- 5. YORUMLAR (Teslim edilmiş siparişler için)
-- ============================================================
INSERT INTO Yorumlar (SiparisID, KullaniciID, RestoranID, Puan, YorumMetni) VALUES
(1,  10, 1, 5, 'Mükemmel lezzet, hızlı teslimat!'),
(2,  11, 2, 4, 'Kebaplar gerçekten nefisti.'),
(3,  12, 3, 5, 'Pizza harika, tekrar sipariş vereceğim.'),
(4,  13, 4, 4, 'Ev yemeği gibi, çok beğendik.'),
(5,  14, 5, 5, 'Baklava efsane! Kesinlikle tavsiye ederim.'),
(6,  15, 1, 3, 'Biraz geç geldi ama lezzet iyiydi.'),
(7,  16, 2, 5, 'Adana kebap gerçekten çok iyiydi.'),
(8,  17, 3, 4, 'Karışık pizza çok doyurucuydu.'),
(9,  18, 4, 5, 'Kuru fasulye tıpkı annemin pişirdiği gibi.'),
(10, 19, 5, 4, 'Trileçe harikaydı, biraz küçük geldi.');
GO
