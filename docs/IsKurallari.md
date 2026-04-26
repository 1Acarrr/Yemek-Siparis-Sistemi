# Veritabanı İş Kuralları (Business Rules)

Bu doküman, sistemin tüm iş mantığını, kısıtlamalarını ve "Askıda Yemek" modülünün çalışma prensiplerini tanımlar.

---

## 1. Kullanıcı Yönetimi

- Sistemde 4 rol bulunur: **Musteri**, **RestoranSahibi**, **Kurye**, **Admin**.
- Her kullanıcının e-posta ve telefon bilgisi **benzersiz (UNIQUE)** ve dolu **(NOT NULL)** olmalıdır.
- Kullanıcı silindiğinde fiziksel olarak kaldırılmaz; `IsActive = 0` yapılır.
- İhtiyaç sahibi müşteriler Admin onayıyla `IsVerifiedNeedy = 1` statüsüne alınır. Yalnızca bu kullanıcılar "Askıda Yemek" havuzundan sipariş verebilir.
- Her kullanıcı birden fazla teslimat adresi tanımlayabilir (3NF: adres bilgisi ayrı tabloda tutulur).

## 2. Restoran ve Menü Yönetimi

- Her restoran bir kullanıcı sahibine (Rol: RestoranSahibi) bağlıdır.
- Restoran ortalama puanı **1 ile 5 arasında** olmalıdır (CHECK constraint).
- Ürünler **menü kategorilerine** ayrılır (Ana Yemek, Tatlı, İçecek vb.).
- Ürün fiyatı **0'dan büyük** olmalıdır (CHECK constraint).
- Restoran menüden ürün kaldırdığında veri silinmez; `IsActive = 0` yapılır (Soft Delete).
- Restoranın toplam cirosu, sipariş "Teslim Edildi" statüsüne geçtiğinde **Trigger** ile otomatik güncellenir.

## 3. Kurye Yönetimi

- Bir kurye aynı anda en fazla **1 aktif sipariş** taşıyabilir.
- Kurye bir siparişi teslim ettiğinde `IsAvailable = 1` yapılarak müsait hale gelir.
- Kurye bilgileri `Kullanicilar` tablosuna bağlıdır; ek detaylar `Kuryeler` tablosunda tutulur.

## 4. Sipariş Akışı

- Sipariş toplam tutarı **0'dan büyük veya eşit** olmalıdır (Askıda Yemek siparişleri 0 TL olabilir).
- Sipariş durumları sırayla ilerler: `Beklemede` → `Hazirlaniyor` → `Yolda` → `Teslim Edildi` / `Iptal Edildi`.
- Sipariş "Teslim Edildi" durumuna geçtiğinde:
  - Restoranın `ToplamCiro` değeri **Trigger** ile otomatik artar.
  - Kuryenin `IsAvailable` değeri **1** yapılır.
- Her sipariş için ayrı bir `Odemeler` kaydı tutulur (nakit/kart/online/AskidaYemek).

## 5. Yorum ve Puanlama

- Yalnızca `Teslim Edildi` statüsündeki siparişler için yorum yapılabilir.
- Yorum puanı **1 ile 5 arasında** olmalıdır (CHECK constraint).
- Yeni bir yorum eklendiğinde, restoranın `OrtalamaPuan` değeri **Trigger** ile otomatik yeniden hesaplanır.

## 6. "Askıda Yemek" Modülü — Merkezi İş Mantığı

### Bağış Süreci
- Hayırsever müşteriler `Bagislar` tablosuna bağış kaydeder.
- Bağış miktarı **0'dan büyük** olmalıdır (CHECK constraint).
- Bağış **anonim** yapılabilir (`KullaniciID = NULL`).
- Yeni bağış eklendiğinde **Trigger** (`trg_HavuzBakiyeGuncelle`) devreye girer ve `AskidaYemekHavuzu.ToplamBakiye` otomatik artar.

### Kullanım Süreci
- Yalnızca `IsVerifiedNeedy = 1` olan kullanıcılar havuzdan sipariş verebilir.
- Sipariş ödeme yöntemi `AskidaYemek` seçildiğinde **Trigger** (`trg_AskidaHavuzDus`) devreye girer:
  - Havuz bakiyesi sipariş tutarından **büyük veya eşitse** → bakiye düşülür, `AskidaSiparisler` tablosuna kayıt eklenir.
  - Havuz bakiyesi yetersizse → **işlem geri alınır (ROLLBACK)** ve hata mesajı fırlatılır.

### Anonimlik
- `Bagislar.KullaniciID` alanı **NULL** kabul eder.
- Raporlarda anonim bağışçılar "Hayırsever" olarak görünür.

## 7. Veri Güvenliği — Soft Delete

- Hiçbir tabloda `DELETE` komutu kullanılmaz.
- Tüm tablolarda `IsActive BIT DEFAULT 1` kolonu bulunur.
- Pasife çekme: `UPDATE [Tablo] SET IsActive = 0 WHERE ID = X`
- Tüm View'lar yalnızca `IsActive = 1` olan kayıtları gösterir.
