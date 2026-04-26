USE YemekSiparisDB;
GO

-- ========================================================
-- 1. JOIN Kullanımı: Detaylı Sipariş Fişi Sorgusu
-- (Müşteri, Restoran, Ürün ve Sipariş tablolarını birleştirir)
-- ========================================================
SELECT 
    s.SiparisID,
    s.SiparisTarihi,
    k.Ad + ' ' + k.Soyad AS Musteri,
    r.Ad AS Restoran,
    u.UrunAdi,
    sd.Adet,
    sd.BirimFiyat,
    (sd.Adet * sd.BirimFiyat) AS SatirToplam
FROM Siparisler s
JOIN Kullanicilar k ON s.MusteriID = k.KullaniciID
JOIN Restoranlar r ON s.RestoranID = r.RestoranID
JOIN SiparisDetaylari sd ON s.SiparisID = sd.SiparisID
JOIN Urunler u ON sd.UrunID = u.UrunID
ORDER BY s.SiparisTarihi DESC;
GO

-- ========================================================
-- 2. Agregasyon ve Gruplama: Restoran Performans Analizi
-- (En az 5 sipariş alan restoranların ciro ve ortalama sepet tutarı)
-- ========================================================
SELECT 
    r.Ad AS RestoranAdi,
    COUNT(s.SiparisID) AS ToplamSiparisSayisi,
    SUM(s.ToplamTutar) AS ToplamCiro,
    AVG(s.ToplamTutar) AS OrtalamaSepetTutari
FROM Restoranlar r
LEFT JOIN Siparisler s ON r.RestoranID = s.RestoranID
GROUP BY r.Ad
HAVING COUNT(s.SiparisID) >= 5 -- En az 5 sipariş alanlar
ORDER BY ToplamCiro DESC;
GO

-- ========================================================
-- 3. Alt Sorgu (Subquery): Bağış Yapmayan Aktif Müşteriler
-- (Platformdan sipariş vermiş ama hiç 'Askıda Yemek' bağışı yapmamış olanlar)
-- ========================================================
SELECT 
    k.Ad,
    k.Soyad,
    k.Eposta
FROM Kullanicilar k
WHERE k.Rol = 'Musteri'
AND EXISTS (SELECT 1 FROM Siparisler s WHERE s.MusteriID = k.KullaniciID) -- Sipariş vermiş olanlar
AND NOT EXISTS (SELECT 1 FROM Bagislar b WHERE b.Bagis_KullaniciID = k.KullaniciID) -- Bağış yapmamış olanlar
GO
