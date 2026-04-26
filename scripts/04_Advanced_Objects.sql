USE YemekSiparisDB;
GO

-- ========================================================
-- 1. INDEXLER (Performans Optimizasyonu)
-- ========================================================

-- Siparişleri müşteri ID'sine göre ararken hız kazanmak için
CREATE INDEX IX_Siparis_MusteriID ON Siparisler(MusteriID);
GO

-- Ürünleri restoran bazlı listelerken hız kazanmak için
CREATE INDEX IX_Urun_RestoranID ON Urunler(RestoranID);
GO


-- ========================================================
-- 2. VIEWS (Raporlama ve Kolay Erişim)
-- ========================================================

-- Aktif Restoran ve Ürün Menüleri View
CREATE VIEW vw_AktifRestoranMenuleri AS
SELECT 
    r.Ad AS RestoranAdi,
    k.KategoriAdi,
    u.UrunAdi,
    u.Fiyat
FROM Restoranlar r
JOIN Urunler u ON r.RestoranID = u.RestoranID
JOIN Kategoriler k ON u.KategoriID = k.KategoriID
WHERE r.IsActive = 1 AND u.IsActive = 1;
GO

-- Askıda Yemek Havuzu ve Bağış Özeti View
CREATE VIEW vw_AskidaYemekHavuzDurumu AS
SELECT 
    (SELECT ToplamBakiye FROM AskidaYemekHavuzu) AS MevcutBakiye,
    COUNT(BagisID) AS ToplamBagisSayisi,
    SUM(Miktar) AS ToplamBagisTutari
FROM Bagislar
WHERE IsActive = 1;
GO


-- ========================================================
-- 3. TRIGGERS (Otomatik İş Mantığı)
-- ========================================================

-- Trigger: Bağış yapıldığında havuz bakiyesini güncelle
CREATE TRIGGER trg_UpdateHavuzBakiyeOnBagis
ON Bagislar
AFTER INSERT
AS
BEGIN
    DECLARE @EklenenMiktar DECIMAL(10,2);
    SELECT @EklenenMiktar = Miktar FROM inserted;

    UPDATE AskidaYemekHavuzu 
    SET ToplamBakiye = ToplamBakiye + @EklenenMiktar,
        SonGuncelleme = GETDATE()
    WHERE HavuzID = 1;
END;
GO

-- Restoranlar tablosuna toplam ciro kolonu ekleyelim (Trigger kullanımı için)
ALTER TABLE Restoranlar ADD ToplamCiro DECIMAL(15,2) DEFAULT 0;
GO

-- Trigger: Sipariş 'Teslim Edildi' olduğunda restoranın cirosunu güncelle
CREATE TRIGGER trg_UpdateRestoranCiro
ON Siparisler
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Durum)
    BEGIN
        DECLARE @YeniDurum NVARCHAR(20);
        DECLARE @Tutar DECIMAL(10,2);
        DECLARE @RestoranID INT;

        SELECT @YeniDurum = Durum, @Tutar = ToplamTutar, @RestoranID = RestoranID FROM inserted;

        IF @YeniDurum = 'Teslim Edildi'
        BEGIN
            UPDATE Restoranlar 
            SET ToplamCiro = ToplamCiro + @Tutar
            WHERE RestoranID = @RestoranID;
        END
    END
END;
GO
