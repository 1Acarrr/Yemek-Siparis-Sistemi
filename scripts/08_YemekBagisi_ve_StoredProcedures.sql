-- ============================================================
-- VTYS-1 Dönem Projesi: Yemek Sipariş Sistemi
-- Dosya: 08_YemekBagisi_ve_StoredProcedures.sql
-- Açıklama: Yemek Bağışı Modülü + Stored Procedures
-- Geliştirme Nedeni: Proje gereksiniminde "yemek veya bakiye"
-- bağışı yapılabileceği belirtilmişti. Bu dosya her iki türü
-- de destekleyen gelişmiş bağış altyapısını eklemektedir.
-- ============================================================

USE YemekSiparisDB;
GO

-- ============================================================
-- ADIM 1: Bagislar Tablosunu Genişlet
-- Yeni Sütunlar:
--   BagisYontemi: 'Para' veya 'Yemek'
--   UrunID: Yemek bağışında hangi ürün (Para bağışında NULL)
--   Adet: Yemek bağışında kaç porsiyon (Para bağışında NULL)
-- ============================================================
ALTER TABLE Bagislar
    ADD BagisYontemi NVARCHAR(10) NOT NULL DEFAULT 'Para'
        CONSTRAINT CHK_BagisYontemi CHECK (BagisYontemi IN ('Para','Yemek'));
GO

ALTER TABLE Bagislar
    ADD UrunID INT NULL,
        Adet   INT NULL;
GO

ALTER TABLE Bagislar
    ADD CONSTRAINT FK_Bagis_Urun FOREIGN KEY (UrunID)
        REFERENCES Urunler(UrunID);
GO

-- ============================================================
-- ADIM 2: Mevcut Trigger'ı Güncelle
-- trg_HavuzBakiyeGuncelle artık her iki bağış türünü destekler:
--   Para → Miktar doğrudan eklenir
--   Yemek → Adet × Ürün Fiyatı hesaplanarak eklenir
-- ============================================================
DROP TRIGGER trg_HavuzBakiyeGuncelle;
GO

CREATE TRIGGER trg_HavuzBakiyeGuncelle
ON Bagislar
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @BagisYontemi  NVARCHAR(10);
    DECLARE @Miktar        DECIMAL(10,2);
    DECLARE @UrunID        INT;
    DECLARE @Adet          INT;
    DECLARE @EklenecekTutar DECIMAL(10,2);

    SELECT
        @BagisYontemi = BagisYontemi,
        @Miktar       = Miktar,
        @UrunID       = UrunID,
        @Adet         = Adet
    FROM inserted;

    -- Para bağışı: Miktar doğrudan eklenir
    IF @BagisYontemi = 'Para'
    BEGIN
        SET @EklenecekTutar = @Miktar;
    END

    -- Yemek bağışı: Adet × Ürünün güncel fiyatı hesaplanır
    ELSE IF @BagisYontemi = 'Yemek'
    BEGIN
        SELECT @EklenecekTutar = @Adet * Fiyat
        FROM Urunler
        WHERE UrunID = @UrunID;
    END

    -- Havuz bakiyesini güncelle
    UPDATE AskidaYemekHavuzu
    SET ToplamBakiye  = ToplamBakiye + @EklenecekTutar,
        ToplamBagis   = ToplamBagis + 1,
        SonGuncelleme = GETDATE()
    WHERE HavuzID = 1;
END;
GO

-- ============================================================
-- ADIM 3: Stored Procedure 1 — usp_ParaBagisYap
-- Kullanım: Para bağışını güvenli ve atomik şekilde yapar.
-- TRY-CATCH ile hata yakalama, TRANSACTION ile atomiklik sağlar.
-- ============================================================
CREATE PROCEDURE usp_ParaBagisYap
    @KullaniciID INT = NULL,    -- NULL = Anonim bağış
    @Miktar      DECIMAL(10,2),
    @BagisNotu   NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Miktar kontrolü
    IF @Miktar <= 0
    BEGIN
        RAISERROR('Bagis miktari 0 dan buyuk olmalidir!', 16, 1);
        RETURN;
    END

    -- Kullanıcı kontrolü (NULL değilse varlığını doğrula)
    IF @KullaniciID IS NOT NULL AND
       NOT EXISTS (SELECT 1 FROM Kullanicilar WHERE KullaniciID = @KullaniciID AND IsActive = 1)
    BEGIN
        RAISERROR('Kullanici bulunamadi!', 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

            INSERT INTO Bagislar (KullaniciID, Miktar, BagisNotu, BagisYontemi)
            VALUES (@KullaniciID, @Miktar, @BagisNotu, 'Para');
            -- Trigger otomatik olarak havuzu güncelleyecek

        COMMIT TRANSACTION;

        PRINT 'Para bagisi basariyla tamamlandi. Tutar: ' + CAST(@Miktar AS NVARCHAR) + ' TL';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @Hata NVARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@Hata, 16, 1);
    END CATCH
END;
GO

-- ============================================================
-- ADIM 4: Stored Procedure 2 — usp_YemekBagisYap
-- Kullanım: Belirli bir ürünü belirli adet kadar bağışlar.
-- Sistem ürünün güncel fiyatını otomatik hesaplar.
-- ============================================================
CREATE PROCEDURE usp_YemekBagisYap
    @KullaniciID INT = NULL,    -- NULL = Anonim bağış
    @UrunID      INT,
    @Adet        INT,
    @BagisNotu   NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Adet kontrolü
    IF @Adet <= 0
    BEGIN
        RAISERROR('Bagis adedi 0 dan buyuk olmalidir!', 16, 1);
        RETURN;
    END

    -- Ürün kontrolü
    IF NOT EXISTS (SELECT 1 FROM Urunler WHERE UrunID = @UrunID AND IsActive = 1)
    BEGIN
        RAISERROR('Urun bulunamadi veya aktif degil!', 16, 1);
        RETURN;
    END

    DECLARE @UrunAdi  NVARCHAR(100);
    DECLARE @Fiyat    DECIMAL(10,2);
    DECLARE @ToplamDeger DECIMAL(10,2);

    SELECT @UrunAdi = UrunAdi, @Fiyat = Fiyat
    FROM Urunler WHERE UrunID = @UrunID;

    SET @ToplamDeger = @Adet * @Fiyat;

    BEGIN TRY
        BEGIN TRANSACTION;

            INSERT INTO Bagislar
                (KullaniciID, Miktar, BagisNotu, BagisYontemi, UrunID, Adet)
            VALUES
                (@KullaniciID, @ToplamDeger, @BagisNotu, 'Yemek', @UrunID, @Adet);
            -- Trigger otomatik olarak Adet × Fiyat = havuza ekleyecek

        COMMIT TRANSACTION;

        PRINT @Adet NVARCHAR(10) + ' porsiyon ' + @UrunAdi +
              ' bagisi tamamlandi. Havuza eklenen: ' +
              CAST(@ToplamDeger AS NVARCHAR) + ' TL';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @Hata NVARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@Hata, 16, 1);
    END CATCH
END;
GO

-- ============================================================
-- ADIM 5: Stored Procedure 3 — usp_AskidaSiparisVer
-- Kullanım: İhtiyaç sahibi kullanıcının havuzdan sipariş vermesini
-- tek bir güvenli prosedür çağrısıyla gerçekleştirir.
-- Kontroller: IsVerifiedNeedy, havuz bakiyesi
-- ============================================================
CREATE PROCEDURE usp_AskidaSiparisVer
    @MusteriID      INT,
    @RestoranID     INT,
    @TeslimatAdresID INT,
    @UrunID         INT,
    @Adet           INT
AS
BEGIN
    SET NOCOUNT ON;

    -- İhtiyaç sahibi doğrulaması
    IF NOT EXISTS (
        SELECT 1 FROM Kullanicilar
        WHERE KullaniciID = @MusteriID
          AND IsVerifiedNeedy = 1
          AND IsActive = 1
    )
    BEGIN
        RAISERROR('Bu kullanici ihtiyac sahibi olarak dogrulanmamistir!', 16, 1);
        RETURN;
    END

    -- Ürün fiyatını hesapla
    DECLARE @BirimFiyat   DECIMAL(10,2);
    DECLARE @ToplamTutar  DECIMAL(10,2);
    DECLARE @MevcutBakiye DECIMAL(12,2);

    SELECT @BirimFiyat = Fiyat FROM Urunler
    WHERE UrunID = @UrunID AND IsActive = 1;

    IF @BirimFiyat IS NULL
    BEGIN
        RAISERROR('Urun bulunamadi veya aktif degil!', 16, 1);
        RETURN;
    END

    SET @ToplamTutar = @Adet * @BirimFiyat;

    -- Havuz bakiyesi kontrolü
    SELECT @MevcutBakiye = ToplamBakiye
    FROM AskidaYemekHavuzu WHERE HavuzID = 1;

    IF @MevcutBakiye < @ToplamTutar
    BEGIN
        RAISERROR('Havuzda yeterli bakiye yok! Mevcut: %s TL, Gereken: %s TL',
                  16, 1,
                  CAST(@MevcutBakiye AS NVARCHAR),
                  CAST(@ToplamTutar AS NVARCHAR));
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

            -- Siparişi oluştur (0 TL — havuzdan karşılanacak)
            DECLARE @YeniSiparisID INT;

            INSERT INTO Siparisler
                (MusteriID, RestoranID, TeslimatAdresID, ToplamTutar, Durum)
            VALUES
                (@MusteriID, @RestoranID, @TeslimatAdresID, @ToplamTutar, 'Beklemede');

            SET @YeniSiparisID = SCOPE_IDENTITY();

            -- Sipariş detayını ekle
            INSERT INTO SiparisDetaylari (SiparisID, UrunID, Adet, BirimFiyat)
            VALUES (@YeniSiparisID, @UrunID, @Adet, @BirimFiyat);

            -- Ödeme kaydını ekle (AskidaYemek — trigger havuzdan düşecek)
            INSERT INTO Odemeler (SiparisID, OdemeYontemi, Tutar, OdemeDurumu)
            VALUES (@YeniSiparisID, 'AskidaYemek', @ToplamTutar, 'Tamamlandi');

            -- AskidaSiparisler tablosuna kayıt ekle
            INSERT INTO AskidaSiparisler (MusteriID, SiparisID, KullanilanMiktar)
            VALUES (@MusteriID, @YeniSiparisID, @ToplamTutar);

            -- Havuz bakiyesini düş
            UPDATE AskidaYemekHavuzu
            SET ToplamBakiye         = ToplamBakiye - @ToplamTutar,
                ToplamKullanimSayisi = ToplamKullanimSayisi + 1,
                SonGuncelleme        = GETDATE()
            WHERE HavuzID = 1;

        COMMIT TRANSACTION;

        PRINT 'Askida Yemek siparisi basariyla olusturuldu! SiparisID: ' +
              CAST(@YeniSiparisID AS NVARCHAR);
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @Hata NVARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@Hata, 16, 1);
    END CATCH
END;
GO

-- ============================================================
-- TEST VERİLERİ: Yemek Bağışı Örnekleri
-- ============================================================

-- Ahmet 3 porsiyon Lahmacun bağışlıyor (3 × 85 = 255 TL havuza gidecek)
EXEC usp_YemekBagisYap
    @KullaniciID = 10,
    @UrunID      = 14,   -- Lahmacun
    @Adet        = 3,
    @BagisNotu   = '3 porsiyon lahmacun bagisliyorum';

-- Anonim bağışçı 5 porsiyon Kuru Fasulye bağışlıyor (5 × 160 = 800 TL)
EXEC usp_YemekBagisYap
    @KullaniciID = NULL,
    @UrunID      = 31,   -- Kuru Fasulye
    @Adet        = 5,
    @BagisNotu   = NULL;

-- Selin 200 TL para bağışı yapıyor
EXEC usp_ParaBagisYap
    @KullaniciID = 11,
    @Miktar      = 200.00,
    @BagisNotu   = 'Hayirli olsun';
GO
