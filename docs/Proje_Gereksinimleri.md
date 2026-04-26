# VTYS-1 Dönem Projesi: Çevrimiçi Yemek Sipariş Platformu Veritabanı Tasarımı

## Proje Amacı
Gerçek dünya senaryolarına uygun, ölçeklenebilir ve en az 3. Normal Form'a (3NF) uygun bir ilişkisel veritabanı tasarlamak. Bu proje bireysel olarak yapılacaktır.

## Sistem Gereksinimleri ve Özel Kural
Sisteminiz klasik bir yemek sipariş uygulaması (müşteri, restoran, kurye, menü, sipariş detayları) özelliklerini taşımalıdır. Ancak sisteminizde şu özel modül kesinlikle bulunmalıdır:

- **ÖZEL KURAL ("Askıda Yemek" Modülü):** Sistem, hayırsever müşterilerin kimliğini gizleyerek (veya açıkça) "Askıda Yemek" havuzuna bağış (yemek veya bakiye) yapabilmesini ve ihtiyaç sahibi olarak doğrulanmış kullanıcıların bu havuzdan ücretsiz sipariş verebilmesini desteklemelidir. Bu senaryonun tablolarını, ilişkilerini ve bakiye düşme mantığını tasarlamak tamamen sizin mühendislik becerinize bırakılmıştır.

## Zorunlu SQL İsterleri (Teknik Gereksinimler)
Teslim edeceğiniz .sql dosyasında (veritabanı yedeğinde) aşağıdaki SQL yapılarının ve nesnelerinin tamamı eksiksiz olarak bulunmak zorundadır.

### 1. Veri Tanımlama ve Kısıtlamalar (DDL & Constraints)
- **Primary Key (PK) ve Foreign Key (FK):** Tablolar arası ilişkiler referans bütünlüğüne (Referential Integrity) uygun olarak FOREIGN KEY ile bağlanmalıdır.
- **CHECK Kısıtlamaları:** Mantıksız veri girişini engellemek için en az 2 tabloda CHECK constraint kullanılmalıdır (Örn: SiparisTutari > 0 veya RestoranPuani BETWEEN 1 AND 5).
- **UNIQUE ve NOT NULL:** Gerekli kolonlarda boş geçilemez veya tekrarlanamaz (Örn: Telefon numarası, E-posta) kısıtlamaları doğru kurgulanmalıdır.

### 2. Veri Manipülasyonu (DML - Mock Data)
- **Sisteminizin test edilebilmesi için tablolarınızda anlamlı sahte veriler (INSERT INTO) bulunmalıdır.** (En az 5 restoran, 50 farklı ürün, 20 müşteri, "Askıda Yemek" havuzu işlemleri ve 100 sipariş hareketi).
- **Fiziksel silme yerine "Soft Delete" (Pasife çekme) mantığı kullanılmalıdır** (Örn: Bir restoran menüden ürün kaldırdığında veri silinmemeli, IsActive = 0 şeklinde güncellenmelidir).

### 3. İleri Düzey Sorgular (DQL & Analitik)
Proje dosyanızın en altında, sistemin çalıştığını gösteren açıklama satırlarıyla (comment) belirtilmiş şu sorgular yer almalıdır:
- **JOIN Kullanımı:** En az 3 tabloyu birbirine bağlayan (INNER JOIN, LEFT JOIN) detaylı bir sipariş fişi sorgusu.
- **Agregasyon ve Gruplama:** SUM, COUNT, AVG fonksiyonlarının GROUP BY ve HAVING ile birlikte kullanıldığı analitik bir sorgu (Örn: Son 1 ayda toplam 5'ten fazla sipariş alan restoranların ortalama sepet tutarları).
- **Alt Sorgu (Subquery):** IN, EXISTS veya NOT EXISTS içeren mantıksal bir alt sorgu (Örn: Hiç "Askıda Yemek" bağışı yapmamış ama platformu aktif kullanan müşteriler).

### 4. Veritabanı Programlanabilirliği (Gelişmiş Nesneler)
- **Görünümler (View):** Karmaşık sorguları basitleştiren en az 2 adet View oluşturulmalıdır (Örn: vw_AktifRestoranMenuleri veya vw_AskidaYemekHavuzDurumu).
- **Tetikleyiciler (Trigger):** İş kurallarını otomatize eden en az 2 adet Trigger yazılmalıdır. (Örn: Bir sipariş "Teslim Edildi" statüsüne geçtiğinde, restoranın toplam ciro hanesini güncelleyen veya "Askıda Yemek" kullanıldığında havuzdaki bakiyeyi otomatik düşüren bir tetikleyici.)
- **İndeksleme (Index):** Veritabanı performansını artırmak için, aramaların sık yapılacağı kolonlara (Primary Key'ler dışında) en az 2 adet anlamlı Index tanımlanmalıdır.

## Yapay Zeka (AI) Kullanım Politikası
Projeyi tasarlarken ChatGPT, Claude, Gemini vb. araçları "asistan" olarak kullanmak serbesttir. SQL hatalarınızı çözdürebilir, test verisi ürettirebilir veya karmaşık mantıkları tartışabilirsiniz. Ancak unutmayın: Çıkan sonucu anlamadan projenize eklerseniz, aşağıdaki değerlendirme aşamalarında projeden kalırsınız. Sorumluluk tamamen size aittir.

## Değerlendirme Sistemi (Geçme Kriterleri)
Projenizin notu sadece gönderdiğiniz dosyalara göre değil, projeye olan hakimiyetinize göre 3 aşamalı bir güvenlik sistemiyle verilecektir.

### 1. Proje Dosyalarının Teslimi (%40)
- Sistemin İş Kuralları listesi ("Askıda Yemek" modülünün çalışma mantığı dahil).
- Tüm tablo ilişkilerini gösteren Varlık-İlişki (ER) Diyagramı.
- Veritabanı altyapısı: SQL DDL kodları (CREATE TABLE, Primary/Foreign Key tanımları) ve içerisine eklenmiş test verileri (INSERT INTO).
- İleri Düzey SQL Nesneleri: Yönergede istenen Görünümler (View), Tetikleyiciler (Trigger) ve analitik sorguları (JOIN, GROUP BY) içeren eksiksiz .sql dosyası.
- Yapay Zeka (AI) Beyanı: Hangi araçların, hangi aşamada ve nasıl kullanıldığını açıklayan kısa dürüstlük raporu.
- GitHub Deposu (Repository) Linki: Tüm SQL kodlarınız, ER diyagramınız ve açıklama dokümanlarınız Public (Herkese Açık) bir GitHub reposuna yüklenmelidir.
- **Önemli Uyarı:** Projenin son gece tek bir parça halinde (tek commit ile) GitHub'a yüklenmesi değerlendirmede eksi puan sebebidir. Projenizin gelişim aşamalarını kanıtlamak için kodlarınızı geliştirme süreciniz boyunca parça parça commit etmeniz (versiyonlamanız) beklenmektedir.

### 2. "Final Sınavı" (%60)
- Proje tesliminden sonraki hafta (Final Sınavında) sınıfta bilgisayarsız/internetsiz kısa bir sınav yapılacaktır.
- Bu sınavda size kendi tasarladığınız veritabanı şemasına göre SQL sorguları yazdırılacaktır.
- Eğer veritabanınızı yapay zekaya yaptırıp hiç incelemediyseniz, kendi tablolarınızın isimlerini ve ilişkilerini bilemeyeceğiniz için bu sınavdan geçemezsiniz.

### 3. Rastgele Özgünlük Doğrulaması
- Dersin son haftasında sınıftan rastgele kura ile öğrenciler seçilecek ve tahtaya çağrılacaktır.
- Seçilen öğrencilere kendi ER diyagramları ekrana yansıtılarak anlık tasarım soruları sorulacaktır.
- **Kural:** Tahtaya çıkan öğrenci kendi projesini mantıklı bir şekilde açıklayamazsa, projesi geçersiz (0 puan) sayılacaktır.
- Bu bir "Özgünlük Doğrulaması"dır. Teslim ettiğiniz her satır kodun ve her tablonun ne işe yaradığını adınız gibi bilmek zorundasınız.
