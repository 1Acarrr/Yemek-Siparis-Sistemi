-- ============================================================
-- VTYS-1 Dönem Projesi: Yemek Sipariş Sistemi
-- Dosya: 01_DDL_Tables.sql
-- Açıklama: Tüm tabloların ve kısıtlamaların oluşturulması
-- Öğrenci: İsa Acar — 23390008049
-- ============================================================

-- Veritabanı Oluşturma
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'YemekSiparisDB')
    CREATE DATABASE YemekSiparisDB;
GO

USE YemekSiparisDB;
GO

-- ============================================================
-- TABLO 1: Kullanicilar
-- Açıklama: Sistemdeki tüm kullanıcılar tek tabloda tutulur.
-- Rol alanı (Musteri, RestoranSahibi, Kurye, Admin) ile ayrım yapılır.
-- IsVerifiedNeedy: Admin tarafından onaylanmış ihtiyaç sahipleri için.
-- ============================================================
CREATE TABLE Kullanicilar (
    KullaniciID   INT           PRIMARY KEY IDENTITY(1,1),
    Ad            NVARCHAR(50)  NOT NULL,
    Soyad         NVARCHAR(50)  NOT NULL,
    Eposta        NVARCHAR(100) NOT NULL UNIQUE,
    Telefon       VARCHAR(15)   NOT NULL UNIQUE,
    SifreHash     NVARCHAR(255) NOT NULL,
    Rol           NVARCHAR(20)  NOT NULL
                  CHECK (Rol IN ('Musteri','RestoranSahibi','Kurye','Admin')),
    IsVerifiedNeedy BIT         DEFAULT 0,  -- 1 = Ihtiyac sahibi (Admin onaylı)
    KayitTarihi   DATETIME      DEFAULT GETDATE(),
    IsActive      BIT           DEFAULT 1   -- Soft Delete
);
GO

-- ============================================================
-- TABLO 2: Adresler
-- Açıklama: 3NF gereği adres bilgisi ayrı tabloda.
-- Bir kullanıcının birden fazla adresi olabilir.
-- ============================================================
CREATE TABLE Adresler (
    AdresID       INT           PRIMARY KEY IDENTITY(1,1),
    KullaniciID   INT           NOT NULL,
    AdresBasligi  NVARCHAR(50)  NOT NULL,  -- Ev, İş vb.
    AdresTarifi   NVARCHAR(255) NOT NULL,
    Ilce          NVARCHAR(50)  NOT NULL,
    Sehir         NVARCHAR(50)  NOT NULL,
    IsActive      BIT           DEFAULT 1,
    CONSTRAINT FK_Adres_Kullanici FOREIGN KEY (KullaniciID)
        REFERENCES Kullanicilar(KullaniciID)
);
GO

-- ============================================================
-- TABLO 3: Restoranlar
-- Açıklama: Restoran bilgileri. OrtalamaPuan trigger ile güncellenir.
-- ToplamCiro sipariş tesliminde trigger ile artar.
-- CHECK: Puan 1-5 arası olmalı.
-- ============================================================
CREATE TABLE Restoranlar (
    RestoranID    INT           PRIMARY KEY IDENTITY(1,1),
    SahipID       INT           NOT NULL,
    Ad            NVARCHAR(100) NOT NULL,
    Adres         NVARCHAR(255) NOT NULL,
    Telefon       VARCHAR(15)   NOT NULL,
    OrtalamaPuan  DECIMAL(3,2)  DEFAULT 0.00
                  CHECK (OrtalamaPuan BETWEEN 0 AND 5),  -- CHECK Constraint #1
    ToplamCiro    DECIMAL(15,2) DEFAULT 0.00,
    AcilisYili    INT,
    IsActive      BIT           DEFAULT 1,
    CONSTRAINT FK_Restoran_Sahip FOREIGN KEY (SahipID)
        REFERENCES Kullanicilar(KullaniciID)
);
GO

-- ============================================================
-- TABLO 4: MenuKategorileri
-- Açıklama: Burger, Pizza, Kebap, Tatlı, İçecek gibi kategoriler.
-- ============================================================
CREATE TABLE MenuKategorileri (
    KategoriID    INT           PRIMARY KEY IDENTITY(1,1),
    KategoriAdi   NVARCHAR(50)  NOT NULL UNIQUE,
    IsActive      BIT           DEFAULT 1
);
GO

-- ============================================================
-- TABLO 5: Urunler
-- Açıklama: Restoran menüsündeki ürünler.
-- Fiyat 0'dan büyük olmalı (CHECK Constraint #2).
-- Soft Delete: Menüden kaldırılan ürün IsActive=0 yapılır.
-- ============================================================
CREATE TABLE Urunler (
    UrunID        INT           PRIMARY KEY IDENTITY(1,1),
    RestoranID    INT           NOT NULL,
    KategoriID    INT           NOT NULL,
    UrunAdi       NVARCHAR(100) NOT NULL,
    Aciklama      NVARCHAR(MAX),
    Fiyat         DECIMAL(10,2) NOT NULL
                  CHECK (Fiyat > 0),  -- CHECK Constraint #2
    HazirlamaSuresi INT,               -- Dakika cinsinden (ör: 15)
    IsActive      BIT           DEFAULT 1,
    CONSTRAINT FK_Urun_Restoran  FOREIGN KEY (RestoranID)
        REFERENCES Restoranlar(RestoranID),
    CONSTRAINT FK_Urun_Kategori  FOREIGN KEY (KategoriID)
        REFERENCES MenuKategorileri(KategoriID)
);
GO

-- ============================================================
-- TABLO 6: Kuryeler
-- Açıklama: Kullanicilar tablosundaki Kurye rolündeki kişilerin ek bilgileri.
-- IsAvailable: 1=Müsait, 0=Aktif siparişte
-- ============================================================
CREATE TABLE Kuryeler (
    KuryeID       INT           PRIMARY KEY,
    AracTipi      NVARCHAR(30)  NOT NULL,  -- Motosiklet, Bisiklet, Araba
    PlakaNo       VARCHAR(15),
    IsAvailable   BIT           DEFAULT 1,
    CONSTRAINT FK_Kurye_Kullanici FOREIGN KEY (KuryeID)
        REFERENCES Kullanicilar(KullaniciID)
);
GO

-- ============================================================
-- TABLO 7: Siparisler
-- Açıklama: Sistemin merkez tablosu. Tüm bağlantıları burada toplanır.
-- ToplamTutar >= 0 (Askıda Yemek siparişleri 0 TL olabilir).
-- CHECK Constraint #3
-- ============================================================
CREATE TABLE Siparisler (
    SiparisID     INT           PRIMARY KEY IDENTITY(1,1),
    MusteriID     INT           NOT NULL,
    RestoranID    INT           NOT NULL,
    KuryeID       INT,
    TeslimatAdresID INT         NOT NULL,
    ToplamTutar   DECIMAL(10,2) NOT NULL DEFAULT 0
                  CHECK (ToplamTutar >= 0),  -- CHECK Constraint #3
    Durum         NVARCHAR(20)  NOT NULL DEFAULT 'Beklemede'
                  CHECK (Durum IN ('Beklemede','Hazirlaniyor','Yolda','Teslim Edildi','Iptal Edildi')),
    SiparisTarihi DATETIME      DEFAULT GETDATE(),
    TeslimTarihi  DATETIME,
    IsActive      BIT           DEFAULT 1,
    CONSTRAINT FK_Siparis_Musteri  FOREIGN KEY (MusteriID)
        REFERENCES Kullanicilar(KullaniciID),
    CONSTRAINT FK_Siparis_Restoran FOREIGN KEY (RestoranID)
        REFERENCES Restoranlar(RestoranID),
    CONSTRAINT FK_Siparis_Kurye    FOREIGN KEY (KuryeID)
        REFERENCES Kuryeler(KuryeID),
    CONSTRAINT FK_Siparis_Adres    FOREIGN KEY (TeslimatAdresID)
        REFERENCES Adresler(AdresID)
);
GO

-- ============================================================
-- TABLO 8: SiparisDetaylari
-- Açıklama: Her siparişin hangi ürünü kaç adet içerdiği.
-- ============================================================
CREATE TABLE SiparisDetaylari (
    DetayID       INT           PRIMARY KEY IDENTITY(1,1),
    SiparisID     INT           NOT NULL,
    UrunID        INT           NOT NULL,
    Adet          INT           NOT NULL CHECK (Adet > 0),
    BirimFiyat    DECIMAL(10,2) NOT NULL,  -- Sipariş anındaki fiyat saklanır
    CONSTRAINT FK_Detay_Siparis FOREIGN KEY (SiparisID)
        REFERENCES Siparisler(SiparisID),
    CONSTRAINT FK_Detay_Urun   FOREIGN KEY (UrunID)
        REFERENCES Urunler(UrunID)
);
GO

-- ============================================================
-- TABLO 9: Odemeler
-- Açıklama: Her siparişin ödeme bilgisi. Sektör standardı.
-- OdemeYontemi: Nakit, Kart, Online, AskidaYemek
-- ============================================================
CREATE TABLE Odemeler (
    OdemeID       INT           PRIMARY KEY IDENTITY(1,1),
    SiparisID     INT           NOT NULL UNIQUE,  -- 1 sipariş = 1 ödeme
    OdemeYontemi  NVARCHAR(20)  NOT NULL
                  CHECK (OdemeYontemi IN ('Nakit','Kart','Online','AskidaYemek')),
    Tutar         DECIMAL(10,2) NOT NULL CHECK (Tutar >= 0),
    OdemeDurumu   NVARCHAR(20)  NOT NULL DEFAULT 'Bekliyor'
                  CHECK (OdemeDurumu IN ('Bekliyor','Tamamlandi','Basarisiz','Iade')),
    OdemeTarihi   DATETIME      DEFAULT GETDATE(),
    CONSTRAINT FK_Odeme_Siparis FOREIGN KEY (SiparisID)
        REFERENCES Siparisler(SiparisID)
);
GO

-- ============================================================
-- TABLO 10: Yorumlar
-- Açıklama: Müşteri yorumları. Puan 1-5 arası (CHECK Constraint #4).
-- Yeni yorum eklenince restoran OrtalamaPuan trigger ile güncellenir.
-- ============================================================
CREATE TABLE Yorumlar (
    YorumID       INT           PRIMARY KEY IDENTITY(1,1),
    SiparisID     INT           NOT NULL UNIQUE,  -- Her sipariş için 1 yorum
    KullaniciID   INT           NOT NULL,
    RestoranID    INT           NOT NULL,
    Puan          TINYINT       NOT NULL
                  CHECK (Puan BETWEEN 1 AND 5),  -- CHECK Constraint #4
    YorumMetni    NVARCHAR(500),
    YorumTarihi   DATETIME      DEFAULT GETDATE(),
    IsActive      BIT           DEFAULT 1,
    CONSTRAINT FK_Yorum_Siparis   FOREIGN KEY (SiparisID)
        REFERENCES Siparisler(SiparisID),
    CONSTRAINT FK_Yorum_Kullanici FOREIGN KEY (KullaniciID)
        REFERENCES Kullanicilar(KullaniciID),
    CONSTRAINT FK_Yorum_Restoran  FOREIGN KEY (RestoranID)
        REFERENCES Restoranlar(RestoranID)
);
GO

-- ============================================================
-- TABLO 11: AskidaYemekHavuzu
-- Açıklama: Sistemin tek merkezi bağış havuzu.
-- Tek satır tutulur; trigger ile güncellenir.
-- ============================================================
CREATE TABLE AskidaYemekHavuzu (
    HavuzID       INT           PRIMARY KEY IDENTITY(1,1),
    ToplamBakiye  DECIMAL(12,2) DEFAULT 0.00,
    ToplamBagis   INT           DEFAULT 0,    -- Kaç bağış yapıldı
    ToplamKullanimSayisi INT    DEFAULT 0,    -- Kaç kez kullanıldı
    SonGuncelleme DATETIME      DEFAULT GETDATE()
);
GO

-- Havuzun başlangıç kaydını oluştur (tek satır)
INSERT INTO AskidaYemekHavuzu DEFAULT VALUES;
GO

-- ============================================================
-- TABLO 12: Bagislar
-- Açıklama: Havuza yapılan her bağışın kaydı.
-- KullaniciID NULL olabilir (anonim bağış).
-- Miktar 0'dan büyük olmalı (CHECK Constraint #5).
-- ============================================================
CREATE TABLE Bagislar (
    BagisID       INT           PRIMARY KEY IDENTITY(1,1),
    KullaniciID   INT           NULL,  -- NULL = Anonim bağış
    Miktar        DECIMAL(10,2) NOT NULL CHECK (Miktar > 0),  -- CHECK Constraint #5
    BagisNotu     NVARCHAR(200),
    BagisTarihi   DATETIME      DEFAULT GETDATE(),
    IsActive      BIT           DEFAULT 1,
    CONSTRAINT FK_Bagis_Kullanici FOREIGN KEY (KullaniciID)
        REFERENCES Kullanicilar(KullaniciID)
);
GO

-- ============================================================
-- TABLO 13: AskidaSiparisler
-- Açıklama: İhtiyaç sahibi bir siparişi havuzdan aldığında bu tabloya kayıt düşer.
-- Hangi kullanıcı, hangi siparişte, ne kadar havuz kullandı.
-- ============================================================
CREATE TABLE AskidaSiparisler (
    AskidaSiparisID INT         PRIMARY KEY IDENTITY(1,1),
    MusteriID       INT         NOT NULL,
    SiparisID       INT         NOT NULL UNIQUE,
    KullanilanMiktar DECIMAL(10,2) NOT NULL,
    KullanimTarihi  DATETIME    DEFAULT GETDATE(),
    CONSTRAINT FK_AskidaSiparis_Musteri  FOREIGN KEY (MusteriID)
        REFERENCES Kullanicilar(KullaniciID),
    CONSTRAINT FK_AskidaSiparis_Siparis  FOREIGN KEY (SiparisID)
        REFERENCES Siparisler(SiparisID)
);
GO
