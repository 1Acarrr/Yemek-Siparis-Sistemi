-- ============================================================
-- VTYS-1 Dönem Projesi: Yemek Sipariş Sistemi
-- Dosya: 05_Triggers.sql
-- Açıklama: 3 adet Trigger — Otomatik iş mantığı
-- ============================================================

USE YemekSiparisDB;
GO

-- ============================================================
-- TRIGGER 1: trg_HavuzBakiyeGuncelle
-- Tablo: Bagislar (AFTER INSERT)
-- İş Mantığı: Yeni bir bağış eklendiğinde, AskidaYemekHavuzu
-- tablosundaki ToplamBakiye ve ToplamBagis otomatik olarak artar.
-- Böylece havuz bakiyesi her zaman güncel kalır.
-- ============================================================
CREATE TRIGGER trg_HavuzBakiyeGuncelle
ON Bagislar
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EklenenMiktar DECIMAL(10,2);
    SELECT @EklenenMiktar = Miktar FROM inserted;

    UPDATE AskidaYemekHavuzu
    SET ToplamBakiye  = ToplamBakiye + @EklenenMiktar,
        ToplamBagis   = ToplamBagis + 1,
        SonGuncelleme = GETDATE()
    WHERE HavuzID = 1;
END;
GO

-- ============================================================
-- TRIGGER 2: trg_AskidaHavuzDus
-- Tablo: Odemeler (AFTER INSERT)
-- İş Mantığı: Ödeme yöntemi 'AskidaYemek' olan yeni bir ödeme
-- eklendiğinde:
--   1. Havuz bakiyesi yeterliyse → düşür, AskidaSiparisler'e kayıt ekle
--   2. Havuz bakiyesi yetersizse → ROLLBACK + hata mesajı
-- ============================================================
CREATE TRIGGER trg_AskidaHavuzDus
ON Odemeler
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Sadece AskidaYemek ödemeleri için çalış
    IF NOT EXISTS (SELECT 1 FROM inserted WHERE OdemeYontemi = 'AskidaYemek')
        RETURN;

    DECLARE @SiparisID      INT;
    DECLARE @SiparisTutari  DECIMAL(10,2);
    DECLARE @MusteriID      INT;
    DECLARE @MevcutBakiye   DECIMAL(12,2);

    SELECT @SiparisID = SiparisID FROM inserted WHERE OdemeYontemi = 'AskidaYemek';

    -- Siparişin gerçek tutarını ve müşterisini al
    SELECT @SiparisTutari = ToplamTutar,
           @MusteriID     = MusteriID
    FROM Siparisler
    WHERE SiparisID = @SiparisID;

    -- Havuz bakiyesini kontrol et
    SELECT @MevcutBakiye = ToplamBakiye FROM AskidaYemekHavuzu WHERE HavuzID = 1;

    IF @MevcutBakiye < @SiparisTutari
    BEGIN
        RAISERROR ('Askida Yemek havuzunda yeterli bakiye bulunmamaktadir!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Bakiyeyi düş
    UPDATE AskidaYemekHavuzu
    SET ToplamBakiye         = ToplamBakiye - @SiparisTutari,
        ToplamKullanimSayisi = ToplamKullanimSayisi + 1,
        SonGuncelleme        = GETDATE()
    WHERE HavuzID = 1;

    -- Kullanım kaydını ekle
    INSERT INTO AskidaSiparisler (MusteriID, SiparisID, KullanilanMiktar)
    VALUES (@MusteriID, @SiparisID, @SiparisTutari);
END;
GO

-- ============================================================
-- TRIGGER 3: trg_RestoranCiroVePuanGuncelle
-- Tablo: Siparisler (AFTER UPDATE)
-- İş Mantığı: Bir sipariş 'Teslim Edildi' statüsüne geçtiğinde:
--   1. Restoranın ToplamCiro değerini artır
--   2. Kuryeyi müsait yap (IsAvailable = 1)
-- Ayrıca: Yorumlar tablosuna yeni kayıt geldiğinde restoranın
--   OrtalamaPuan değeri yeniden hesaplanır.
-- ============================================================
CREATE TRIGGER trg_RestoranCiroGuncelle
ON Siparisler
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sadece 'Teslim Edildi' durumuna geçişlerde çalış
    IF NOT EXISTS (
        SELECT 1 FROM inserted i JOIN deleted d ON i.SiparisID = d.SiparisID
        WHERE i.Durum = 'Teslim Edildi' AND d.Durum <> 'Teslim Edildi'
    )
        RETURN;

    DECLARE @RestoranID    INT;
    DECLARE @Tutar         DECIMAL(10,2);
    DECLARE @KuryeID       INT;

    SELECT @RestoranID = RestoranID,
           @Tutar      = ToplamTutar,
           @KuryeID    = KuryeID
    FROM inserted
    WHERE Durum = 'Teslim Edildi';

    -- Restoranın toplam cirosunu güncelle
    UPDATE Restoranlar
    SET ToplamCiro = ToplamCiro + @Tutar
    WHERE RestoranID = @RestoranID;

    -- Kurye varsa müsait yap
    IF @KuryeID IS NOT NULL
    BEGIN
        UPDATE Kuryeler
        SET IsAvailable = 1
        WHERE KuryeID = @KuryeID;
    END;
END;
GO

-- ============================================================
-- BONUS TRIGGER: trg_YorumSonrasiPuanGuncelle
-- Tablo: Yorumlar (AFTER INSERT)
-- İş Mantığı: Yeni yorum eklenince o restoranın tüm yorumlarının
-- ortalaması yeniden hesaplanır ve Restoranlar.OrtalamaPuan güncellenir.
-- ============================================================
CREATE TRIGGER trg_YorumSonrasiPuanGuncelle
ON Yorumlar
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RestoranID INT;
    SELECT @RestoranID = RestoranID FROM inserted;

    UPDATE Restoranlar
    SET OrtalamaPuan = (
        SELECT AVG(CAST(Puan AS DECIMAL(5,2)))
        FROM Yorumlar
        WHERE RestoranID = @RestoranID
          AND IsActive = 1
    )
    WHERE RestoranID = @RestoranID;
END;
GO
