# Yemek Sipariş Sistemi — Veritabanı Projesi (VTYS-1)

**Öğrenci:** İsa Acar — 23390008049  
**Ders:** Veritabanı Yönetim Sistemleri-1  
**Proje:** Çevrimiçi Yemek Sipariş Platformu Veritabanı Tasarımı

---

## Proje Hakkında

Gerçek dünya senaryolarına uygun, **3. Normal Form (3NF)** kurallarına tam uyumlu, 13 tablodan oluşan ilişkisel bir veritabanı tasarımıdır.

## Varlık-İlişki (ER) Diyagramı

![ER Diyagramı](docs/ER_Diyagrami.png)

## Öne Çıkan Özellikler

- **"Askıda Yemek" Modülü:** Trigger destekli bakiye yönetimi. Hem nakit hem de **spesifik yemek** bağışını destekler (Yemek bağışında fiyat otomatik hesaplanır).
- **Ödeme Takibi:** Her siparişin ödeme yöntemi ve durumu ayrı tabloda saklanır.
- **Saklı Yordamlar (Stored Procedures):** Bağış ve Askıda Sipariş işlemleri hata yakalama (TRY-CATCH) ve işlem güvenliği (Transaction) ile yönetilir.
- **Yorum & Puanlama:** Müşteri yorumları trigger ile restoranın ortalama puanını otomatik günceller.
- **Soft Delete:** Hiçbir veri fiziksel olarak silinmez, `IsActive = 0` ile pasife çekilir.
- **3 View, 3 Trigger, 4 Index** ile tam sektör standardında bir yapı.

## Proje Yapısı

```
/docs       → İş kuralları, gereksinimler, ER diyagramı
/scripts    → SQL DDL, DML ve programlanabilirlik dosyaları
README.md   → Bu dosya
AI_Beyani.md → Yapay Zeka kullanım beyanı
```

## Tablolar (13 Adet)

| # | Tablo | Açıklama |
|---|---|---|
| 1 | `Kullanicilar` | Tüm roller tek tabloda (Müşteri, Kurye, Restoran Sahibi, Admin) |
| 2 | `Adresler` | Kullanıcı teslimat adresleri (3NF gereği ayrı tablo) |
| 3 | `Restoranlar` | Restoran bilgileri, ortalama puan, toplam ciro |
| 4 | `MenuKategorileri` | Burger, Pizza, Kebap vb. kategoriler |
| 5 | `Urunler` | Menü ürünleri (Soft Delete destekli) |
| 6 | `Kuryeler` | Kurye detayları ve müsaitlik durumu |
| 7 | `Siparisler` | Merkez tablo; tüm bağlantıları tutar |
| 8 | `SiparisDetaylari` | Hangi siparişte hangi ürün, kaç adet |
| 9 | `Odemeler` | Ödeme yöntemi, tutarı ve durumu |
| 10 | `Yorumlar` | Müşteri yorumları ve puanları |
| 11 | `AskidaYemekHavuzu` | Merkezi bakiye (tek satır, kümülatif) |
| 12 | `Bagislar` | Bağış kayıtları (anonim destekli) |
| 13 | `AskidaSiparisler` | İhtiyaç sahibi kullanımlarının kaydı |

## GitHub Deposu

[https://github.com/1Acarrr/Yemek-Siparis-Sistemi](https://github.com/1Acarrr/Yemek-Siparis-Sistemi)
