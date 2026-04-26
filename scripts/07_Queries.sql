-- ============================================================
-- VTYS-1 Dönem Projesi: Yemek Sipariş Sistemi
-- Dosya: 07_Queries.sql
-- Açıklama: İleri düzey DQL sorguları (JOIN, GROUP BY, Subquery)
-- ============================================================

USE YemekSiparisDB;
GO

-- ============================================================
-- SORGU 1: JOIN KULLANIMI
-- Açıklama: En az 3 tabloyu birleştiren detaylı sipariş fişi.
-- Müşteri, Restoran, Kurye, Ürün ve Ödeme bilgilerini bir arada gösterir.
-- ============================================================

-- Belirli bir siparişin tüm detayları (INNER JOIN + LEFT JOIN)
SELECT
    s.SiparisID,
    s.SiparisTarihi,
    s.Durum,
    (mu.Ad + ' ' + mu.Soyad)  AS Musteri,
    r.Ad                       AS Restoran,
    ISNULL((ku.Ad + ' ' + ku.Soyad), 'Henuz Atanmadi') AS Kurye,
    u.UrunAdi,
    sd.Adet,
    sd.BirimFiyat,
    (sd.Adet * sd.BirimFiyat) AS SatirToplam,
    s.ToplamTutar,
    o.OdemeYontemi,
    o.OdemeDurumu
FROM Siparisler s
INNER JOIN Kullanicilar mu   ON s.MusteriID       = mu.KullaniciID
INNER JOIN Restoranlar r     ON s.RestoranID       = r.RestoranID
LEFT  JOIN Kullanicilar ku   ON s.KuryeID          = ku.KullaniciID
INNER JOIN SiparisDetaylari sd ON s.SiparisID      = sd.SiparisID
INNER JOIN Urunler u         ON sd.UrunID          = u.UrunID
LEFT  JOIN Odemeler o        ON s.SiparisID        = o.SiparisID
WHERE s.IsActive = 1
ORDER BY s.SiparisTarihi DESC;
GO

-- ============================================================
-- SORGU 2: AGREGASYON VE GRUPLAMA
-- Açıklama: Son 1 ayda en az 5 sipariş alan restoranların
-- toplam cirosu ve ortalama sepet tutarı.
-- GROUP BY + HAVING + SUM + COUNT + AVG kullanımı.
-- ============================================================

SELECT
    r.Ad                              AS RestoranAdi,
    COUNT(s.SiparisID)                AS ToplamSiparisSayisi,
    SUM(s.ToplamTutar)                AS ToplamCiro,
    AVG(s.ToplamTutar)                AS OrtalamaSepetTutari,
    MAX(s.SiparisTarihi)              AS SonSiparisTarihi
FROM Restoranlar r
INNER JOIN Siparisler s ON r.RestoranID = s.RestoranID
WHERE s.Durum = 'Teslim Edildi'
  AND s.SiparisTarihi >= DATEADD(MONTH, -1, GETDATE())
  AND s.IsActive = 1
GROUP BY r.RestoranID, r.Ad
HAVING COUNT(s.SiparisID) >= 5
ORDER BY ToplamCiro DESC;
GO

-- ============================================================
-- SORGU 3: ALT SORGU (SUBQUERY)
-- Açıklama: Platformu aktif kullanan (en az 1 sipariş vermiş) ama
-- hiç "Askıda Yemek" bağışı yapmamış müşteriler.
-- NOT EXISTS kullanımı.
-- ============================================================

SELECT
    k.KullaniciID,
    k.Ad,
    k.Soyad,
    k.Eposta,
    k.KayitTarihi
FROM Kullanicilar k
WHERE k.Rol = 'Musteri'
  AND k.IsActive = 1
  AND EXISTS (
      -- En az 1 sipariş vermiş olanlar
      SELECT 1 FROM Siparisler s
      WHERE s.MusteriID = k.KullaniciID
        AND s.IsActive = 1
  )
  AND NOT EXISTS (
      -- Hiç bağış yapmamış olanlar
      SELECT 1 FROM Bagislar b
      WHERE b.KullaniciID = k.KullaniciID
        AND b.IsActive = 1
  )
ORDER BY k.KayitTarihi;
GO

-- ============================================================
-- BONUS SORGU: Askıda Yemek modülü raporu
-- Son 1 haftada havuzdan yararlanan ihtiyaç sahiplerinin listesi
-- ============================================================

SELECT
    k.Ad + ' ' + k.Soyad  AS IhtiyacSahibi,
    COUNT(a.AskidaSiparisID) AS KullanimSayisi,
    SUM(a.KullanilanMiktar)  AS ToplamYararlandigiTutar,
    MAX(a.KullanimTarihi)    AS SonKullanimTarihi
FROM AskidaSiparisler a
INNER JOIN Kullanicilar k ON a.MusteriID = k.KullaniciID
WHERE a.KullanimTarihi >= DATEADD(WEEK, -1, GETDATE())
GROUP BY k.KullaniciID, k.Ad, k.Soyad
ORDER BY ToplamYararlandigiTutar DESC;
GO
