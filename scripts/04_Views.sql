-- ============================================================
-- VTYS-1 Dönem Projesi: Yemek Sipariş Sistemi
-- Dosya: 04_Views.sql
-- Açıklama: 3 adet View tanımı
-- ============================================================

USE YemekSiparisDB;
GO

-- ============================================================
-- VIEW 1: vw_AktifRestoranMenuleri
-- Açıklama: Sadece aktif restoranların aktif ürünlerini gösterir.
-- Kullanım: Müşteri uygulamasında menü sayfası sorgusu bu view'dan yapılır.
-- Soft Delete mantığı: IsActive=0 olan restoran/ürün burada görünmez.
-- ============================================================
CREATE VIEW vw_AktifRestoranMenuleri AS
SELECT
    r.RestoranID,
    r.Ad           AS RestoranAdi,
    r.OrtalamaPuan,
    k.KategoriAdi,
    u.UrunID,
    u.UrunAdi,
    u.Aciklama,
    u.Fiyat,
    u.HazirlamaSuresi
FROM Restoranlar r
JOIN Urunler u          ON r.RestoranID = u.RestoranID
JOIN MenuKategorileri k ON u.KategoriID = k.KategoriID
WHERE r.IsActive = 1
  AND u.IsActive = 1
  AND k.IsActive = 1;
GO

-- ============================================================
-- VIEW 2: vw_AskidaYemekHavuzDurumu
-- Açıklama: Askıda Yemek modülünün anlık raporunu gösterir.
-- Havuz bakiyesi, toplam bağış ve kullanım istatistiklerini bir arada sunar.
-- ============================================================
CREATE VIEW vw_AskidaYemekHavuzDurumu AS
SELECT
    h.ToplamBakiye                               AS MevcutBakiye,
    h.ToplamBagis                                AS ToplamBagisSayisi,
    ISNULL(SUM(b.Miktar), 0)                     AS ToplamBagisTutari,
    h.ToplamKullanimSayisi                       AS ToplamKullanimSayisi,
    ISNULL(SUM(a.KullanilanMiktar), 0)           AS ToplamKullanilanTutar,
    h.SonGuncelleme
FROM AskidaYemekHavuzu h
LEFT JOIN Bagislar b            ON b.IsActive = 1
LEFT JOIN AskidaSiparisler a    ON 1 = 1
GROUP BY h.ToplamBakiye, h.ToplamBagis, h.ToplamKullanimSayisi, h.SonGuncelleme;
GO

-- ============================================================
-- VIEW 3: vw_SiparisFisi
-- Açıklama: Müşteri, Restoran, Kurye ve Ürün bilgilerini birleştiren
-- detaylı sipariş fişi. JOIN yetkinliğini kanıtlar.
-- ============================================================
CREATE VIEW vw_SiparisFisi AS
SELECT
    s.SiparisID,
    s.SiparisTarihi,
    s.TeslimTarihi,
    s.Durum,
    -- Müşteri Bilgisi
    (ku.Ad + ' ' + ku.Soyad)  AS MusteriAdSoyad,
    ku.Telefon                 AS MusteriTelefon,
    -- Teslimat Adresi
    (a.Ilce + ', ' + a.Sehir) AS TeslimatAdresi,
    -- Restoran Bilgisi
    r.Ad                       AS RestoranAdi,
    r.Telefon                  AS RestoranTelefon,
    -- Kurye Bilgisi
    (kr.Ad + ' ' + kr.Soyad)  AS KuryeAdSoyad,
    -- Sipariş Kalemleri
    u.UrunAdi,
    sd.Adet,
    sd.BirimFiyat,
    (sd.Adet * sd.BirimFiyat) AS KalemToplam,
    s.ToplamTutar,
    -- Ödeme
    o.OdemeYontemi,
    o.OdemeDurumu
FROM Siparisler s
JOIN Kullanicilar ku    ON s.MusteriID       = ku.KullaniciID
JOIN Adresler a         ON s.TeslimatAdresID = a.AdresID
JOIN Restoranlar r      ON s.RestoranID      = r.RestoranID
LEFT JOIN Kullanicilar kr ON s.KuryeID       = kr.KullaniciID
JOIN SiparisDetaylari sd ON s.SiparisID      = sd.SiparisID
JOIN Urunler u          ON sd.UrunID         = u.UrunID
LEFT JOIN Odemeler o    ON s.SiparisID       = o.SiparisID
WHERE s.IsActive = 1;
GO
