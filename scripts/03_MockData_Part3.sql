USE YemekSiparisDB;
GO

-- 6. Bağışlar (Havuzu dolduralım)
INSERT INTO Bagislar (Bagis_KullaniciID, Miktar) VALUES
(1, 500.00),  -- Ahmet 500 TL bağışladı
(3, 1000.00), -- Mehmet 1000 TL bağışladı
(NULL, 250.00), -- Anonim bağış
(8, 750.00),  -- Selin 750 TL bağışladı
(12, 100.00), -- Ali 100 TL bağışladı
(NULL, 2000.00); -- Anonim büyük bağış
GO

-- Havuz bakiyesini manuel güncelleyelim (Henüz trigger eklemedik, o Adım 5'te gelecek)
UPDATE AskidaYemekHavuzu SET ToplamBakiye = 4600.00 WHERE HavuzID = 1;
GO

-- 7. Siparişler ve Detaylar (Örnekleme yoluyla 100 hareket)
-- Not: Burada toplu INSERT kullanarak 100 hareketi simüle edeceğiz.

-- Birkaç manuel sipariş örneği
INSERT INTO Siparisler (MusteriID, RestoranID, KuryeID, ToplamTutar, Durum) VALUES
(1, 1, 7, 225.00, 'Teslim Edildi'),
(2, 2, 10, 85.00, 'Teslim Edildi'), -- İhtiyaç sahibi Ayşe lahmacun yedi
(3, 3, 16, 290.00, 'Yolda'),
(4, 4, 7, 160.00, 'Hazirlaniyor');
GO

-- Sipariş Detayları
INSERT INTO SiparisDetaylari (SiparisID, UrunID, Adet, BirimFiyat) VALUES
(1, 1, 1, 180.00), (1, 5, 1, 45.00), -- Sipariş 1 detayları
(2, 14, 1, 85.00),                   -- Sipariş 2 detayları
(3, 22, 1, 290.00),                  -- Sipariş 3 detayları
(4, 31, 1, 160.00);                  -- Sipariş 4 detayları
GO

-- Geri kalan 96 siparişi simüle eden hızlı INSERT bloğu (Test amaçlı)
-- (Normalde bu veriler zamanla oluşur, biz tek seferde yüklüyoruz)
DECLARE @Counter INT = 5;
WHILE @Counter <= 100
BEGIN
    INSERT INTO Siparisler (MusteriID, RestoranID, KuryeID, ToplamTutar, Durum)
    VALUES (
        (ABS(CHECKSUM(NEWID())) % 15) + 1, -- Rastgele müşteri
        (ABS(CHECKSUM(NEWID())) % 5) + 1,  -- Rastgele restoran
        CASE WHEN @Counter % 3 = 0 THEN 7 WHEN @Counter % 3 = 1 THEN 10 ELSE 16 END,
        (ABS(CHECKSUM(NEWID())) % 500) + 50, -- Rastgele tutar
        'Teslim Edildi'
    );
    SET @Counter = @Counter + 1;
END
GO
