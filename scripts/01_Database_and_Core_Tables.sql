-- ========================================================
-- ADIM 2: Veritabanı ve Temel Tablo Yapıları
-- Proje: Yemek Sipariş Sistemi (VTYS-1)
-- ========================================================

-- 1. Veritabanı Oluşturma
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'YemekSiparisDB')
BEGIN
    CREATE DATABASE YemekSiparisDB;
END
GO

USE YemekSiparisDB;
GO

-- 2. Kullanıcılar Tablosu (Müşteri, Restoran Sahibi, Kurye, Admin)
CREATE TABLE Kullanicilar (
    KullaniciID INT PRIMARY KEY IDENTITY(1,1),
    Ad NVARCHAR(50) NOT NULL,
    Soyad NVARCHAR(50) NOT NULL,
    Eposta NVARCHAR(100) NOT NULL UNIQUE,
    Telefon VARCHAR(15) NOT NULL UNIQUE,
    Sifre NVARCHAR(255) NOT NULL,
    Rol NVARCHAR(20) NOT NULL CHECK (Rol IN ('Musteri', 'Restoran', 'Kurye', 'Admin')),
    IsVerifiedNeedy BIT DEFAULT 0, -- İhtiyaç sahibi doğrulaması
    KayitTarihi DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1 -- Soft Delete için
);
GO

-- 3. Restoranlar Tablosu
CREATE TABLE Restoranlar (
    RestoranID INT PRIMARY KEY IDENTITY(1,1),
    Ad NVARCHAR(100) NOT NULL,
    Adres NVARCHAR(255) NOT NULL,
    Telefon VARCHAR(15) NOT NULL,
    Puani DECIMAL(3,2) DEFAULT 0 CHECK (Puani BETWEEN 0 AND 5), -- CHECK Constraint
    SahipID INT NOT NULL,
    IsActive BIT DEFAULT 1, -- Soft Delete için
    CONSTRAINT FK_Restoran_Sahibi FOREIGN KEY (SahipID) REFERENCES Kullanicilar(KullaniciID)
);
GO

-- 4. Kategoriler Tablosu
CREATE TABLE Kategoriler (
    KategoriID INT PRIMARY KEY IDENTITY(1,1),
    KategoriAdi NVARCHAR(50) NOT NULL,
    IsActive BIT DEFAULT 1
);
GO

-- 5. Ürünler Tablosu
CREATE TABLE Urunler (
    UrunID INT PRIMARY KEY IDENTITY(1,1),
    RestoranID INT NOT NULL,
    KategoriID INT NOT NULL,
    UrunAdi NVARCHAR(100) NOT NULL,
    Aciklama NVARCHAR(MAX),
    Fiyat DECIMAL(10,2) NOT NULL CHECK (Fiyat > 0), -- CHECK Constraint
    IsActive BIT DEFAULT 1, -- Soft Delete için
    CONSTRAINT FK_Urun_Restoran FOREIGN KEY (RestoranID) REFERENCES Restoranlar(RestoranID),
    CONSTRAINT FK_Urun_Kategori FOREIGN KEY (KategoriID) REFERENCES Kategoriler(KategoriID)
);
GO
