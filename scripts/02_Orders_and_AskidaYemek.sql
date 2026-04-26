USE YemekSiparisDB;
GO

-- 6. Kuryeler Tablosu (Kullanıcılar tablosuna ek detaylar)
CREATE TABLE Kuryeler (
    KuryeID INT PRIMARY KEY,
    AracTipi NVARCHAR(30), -- Motor, Bisiklet vb.
    EhliyetNo VARCHAR(20),
    IsAvailable BIT DEFAULT 1,
    CONSTRAINT FK_Kurye_Kullanici FOREIGN KEY (KuryeID) REFERENCES Kullanicilar(KullaniciID)
);
GO

-- 7. Siparişler Tablosu
CREATE TABLE Siparisler (
    SiparisID INT PRIMARY KEY IDENTITY(1,1),
    MusteriID INT NOT NULL,
    RestoranID INT NOT NULL,
    KuryeID INT,
    ToplamTutar DECIMAL(10,2) NOT NULL DEFAULT 0,
    Durum NVARCHAR(20) DEFAULT 'Hazirlaniyor' CHECK (Durum IN ('Hazirlaniyor', 'Yolda', 'Teslim Edildi', 'Iptal Edildi')),
    SiparisTarihi DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    CONSTRAINT FK_Siparis_Musteri FOREIGN KEY (MusteriID) REFERENCES Kullanicilar(KullaniciID),
    CONSTRAINT FK_Siparis_Restoran FOREIGN KEY (RestoranID) REFERENCES Restoranlar(RestoranID),
    CONSTRAINT FK_Siparis_Kurye FOREIGN KEY (KuryeID) REFERENCES Kuryeler(KuryeID)
);
GO

-- 8. Sipariş Detayları Tablosu
CREATE TABLE SiparisDetaylari (
    DetayID INT PRIMARY KEY IDENTITY(1,1),
    SiparisID INT NOT NULL,
    UrunID INT NOT NULL,
    Adet INT NOT NULL CHECK (Adet > 0),
    BirimFiyat DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Detay_Siparis FOREIGN KEY (SiparisID) REFERENCES Siparisler(SiparisID),
    CONSTRAINT FK_Detay_Urun FOREIGN KEY (UrunID) REFERENCES Urunler(UrunID)
);
GO

-- 9. Askıda Yemek Havuzu (Sistemin tekil havuzu)
CREATE TABLE AskidaYemekHavuzu (
    HavuzID INT PRIMARY KEY IDENTITY(1,1),
    ToplamBakiye DECIMAL(12,2) DEFAULT 0,
    SonGuncelleme DATETIME DEFAULT GETDATE()
);
GO

-- 10. Bağışlar Tablosu
CREATE TABLE Bagislar (
    BagisID INT PRIMARY KEY IDENTITY(1,1),
    Bagis_KullaniciID INT NULL, -- NULL ise anonim bağıştır
    Miktar DECIMAL(10,2) NOT NULL CHECK (Miktar > 0),
    BagisTarihi DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    CONSTRAINT FK_Bagis_Kullanici FOREIGN KEY (Bagis_KullaniciID) REFERENCES Kullanicilar(KullaniciID)
);
GO

-- 11. Askıda Sipariş Kullanımları
CREATE TABLE AskidaSiparisKullanimlari (
    KullanimID INT PRIMARY KEY IDENTITY(1,1),
    MusteriID INT NOT NULL, -- İhtiyaç sahibi
    SiparisID INT NOT NULL,
    KullanilanMiktar DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Askida_Musteri FOREIGN KEY (MusteriID) REFERENCES Kullanicilar(KullaniciID),
    CONSTRAINT FK_Askida_Siparis FOREIGN KEY (SiparisID) REFERENCES Siparisler(SiparisID)
);
GO

-- Havuzun başlangıç değerini ekleyelim
INSERT INTO AskidaYemekHavuzu (ToplamBakiye) VALUES (0);
GO
