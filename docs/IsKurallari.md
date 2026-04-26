# Veritabanı İş Kuralları (Business Rules)

Bu doküman, sistemin mantıksal işleyişini ve veritabanı kısıtlamalarını tanımlar.

## 1. Kullanıcı ve Yetkilendirme
- Sistemde 4 ana rol bulunur: **Müşteri, Restoran, Kurye, Admin**.
- Her kullanıcının E-posta ve Telefon bilgisi sistemde **benzersiz (UNIQUE)** olmalıdır.
- İhtiyaç sahibi kullanıcılar, Admin onayıyla `IsVerifiedNeedy = 1` durumuna getirilir.

## 2. Restoran ve Menü Yönetimi
- Her restoranın en az bir sahibi (kullanıcı) olmalıdır.
- Restoran puanları **1 ile 5 arasında (CHECK constraint)** olmalıdır.
- Ürünler kategorilere ayrılmalıdır (Ana Yemek, Tatlı, İçecek vb.).

## 3. Sipariş Akışı
- Sipariş tutarı **0'dan büyük** olmalıdır.
- Sipariş durumları: `Hazırlanıyor`, `Yolda`, `Teslim Edildi`, `İptal Edildi`.
- Sipariş "Teslim Edildi" durumuna geçtiğinde, restoranın toplam cirosu otomatik olarak güncellenmelidir (Trigger).

## 4. "Askıda Yemek" Modül Mantığı
- **Bağış Süreci:** Hayırsever müşteriler havuza bakiye bağışlar. Bağışlar anonim yapılabilir.
- **Havuz Yönetimi:** Bağışlanan tutarlar `AskidaYemekHavuzu` tablosunda kümülatif olarak toplanır.
- **Kullanım:** Sadece `IsVerifiedNeedy = 1` olan kullanıcılar havuzdan sipariş verebilir.
- **Otomatik Düşüm:** İhtiyaç sahibi sipariş verdiğinde, sipariş tutarı havuz bakiyesinden otomatik olarak düşer (Trigger).

## 5. Veri Güvenliği ve Silme (Soft Delete)
- Hiçbir tablo kaydı `DELETE` komutuyla fiziksel olarak silinmez.
- Tüm tablolarda `IsActive` (BIT) kolonu bulunur. Silme işlemi `UPDATE ... SET IsActive = 0` şeklinde yapılır.
- Sistem genelinde sadece `IsActive = 1` olan veriler işlem görür (Viewlar üzerinden süzülür).
