-- ============================================================
-- VTYS-1 Dönem Projesi: Yemek Sipariş Sistemi
-- Dosya: 06_Indexes.sql
-- Açıklama: 4 adet Index — Sorgu performansı için
-- ============================================================

USE YemekSiparisDB;
GO

-- ============================================================
-- INDEX 1: IX_Siparisler_MusteriID
-- Neden: "Bu müşterinin siparişlerini getir" sorgusu sık çalışır.
-- MusteriID üzerindeki index bu aramaları hızlandırır.
-- ============================================================
CREATE NONCLUSTERED INDEX IX_Siparisler_MusteriID
ON Siparisler(MusteriID);
GO

-- ============================================================
-- INDEX 2: IX_Urunler_RestoranID
-- Neden: "Bu restoranın menüsünü getir" sorgusu en sık çalışan sorgudur.
-- ============================================================
CREATE NONCLUSTERED INDEX IX_Urunler_RestoranID
ON Urunler(RestoranID)
INCLUDE (UrunAdi, Fiyat, IsActive);  -- Cover index: ek sütunlar da dahil
GO

-- ============================================================
-- INDEX 3: IX_Siparisler_SiparisTarihi
-- Neden: "Son 1 aydaki siparişler" gibi tarih bazlı analitik sorgularda
-- tarih sütununa index olmadan tam tablo taraması yapılır.
-- ============================================================
CREATE NONCLUSTERED INDEX IX_Siparisler_SiparisTarihi
ON Siparisler(SiparisTarihi DESC);
GO

-- ============================================================
-- INDEX 4: IX_Bagislar_BagisTarihi
-- Neden: Bağış raporları ve Askıda Yemek analitikleri tarih bazlıdır.
-- ============================================================
CREATE NONCLUSTERED INDEX IX_Bagislar_BagisTarihi
ON Bagislar(BagisTarihi DESC);
GO
