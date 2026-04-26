USE YemekSiparisDB;
GO

-- 5. Ürünler (Her restoran için 10'ar adet, toplam 50 ürün)

-- Burger Sarayi (RestoranID: 1)
INSERT INTO Urunler (RestoranID, KategoriID, UrunAdi, Aciklama, Fiyat) VALUES
(1, 1, 'Klasik Burger', '150gr köfte, marul, tursu', 180.00),
(1, 1, 'Cheeseburger', 'Cheddar peyniri, özel sos', 210.00),
(1, 1, 'Tavuk Burger', 'Citir tavuk gögsü', 160.00),
(1, 1, 'Veggie Burger', 'Sebze köftesi, humus', 190.00),
(1, 5, 'Kola 330ml', 'Soguk içecek', 45.00),
(1, 5, 'Ayran 300ml', 'Dogal yayik ayran', 30.00),
(1, 4, 'Sufle', 'Sicak çikolatali', 120.00),
(1, 1, 'Double Burger', '300gr köfte', 320.00),
(1, 1, 'Mantarli Burger', 'Karamelize sogan ve mantar', 230.00),
(1, 5, 'Su 500ml', 'Dogal kaynak suyu', 15.00);

-- Lezzet Kebap (RestoranID: 2)
INSERT INTO Urunler (RestoranID, KategoriID, UrunAdi, Aciklama, Fiyat) VALUES
(2, 2, 'Adana Kebap', 'Acili zirh kiymasi', 280.00),
(2, 2, 'Urfa Kebap', 'Acisiz zirh kiymasi', 280.00),
(2, 2, 'Kuzu Sis', 'Kuzu buttan lokum et', 350.00),
(2, 2, 'Lahmacun', 'Çitir hamur, bol malzeme', 85.00),
(2, 5, 'Salgam Suyu', 'Acili/Acisiz', 35.00),
(2, 4, 'Künefe', 'Sicak servis edilir', 150.00),
(2, 2, 'Beyti Sarma', 'Özel soslu', 320.00),
(2, 2, 'Ali Nazik', 'Patlican begendili', 340.00),
(2, 5, 'Ayran', 'Bol köpüklü', 35.00),
(2, 2, 'Karisik Izgara', 'Her çesit et', 550.00);

-- Pizza Dunyasi (RestoranID: 3)
INSERT INTO Urunler (RestoranID, KategoriID, UrunAdi, Aciklama, Fiyat) VALUES
(3, 3, 'Margarita', 'Mozzarella, domates sos', 220.00),
(3, 3, 'Karisik Pizza', 'Sucuk, sosis, mantar, misir', 290.00),
(3, 3, 'Pepperoni Pizza', 'Bol bol pepperoni', 310.00),
(3, 3, 'Sebzeli Pizza', 'Mevsim sebzeleri', 250.00),
(3, 5, 'Ice Tea', 'Seftali veya Limon', 45.00),
(3, 3, 'BBQ Tavuklu Pizza', 'Barbekü soslu tavuk', 280.00),
(3, 3, 'Dört Peynirli Pizza', 'Mozzarella, Parmesan, Rokfor, Cheddar', 330.00),
(3, 4, 'Tiramisu', 'Klasik Italyan tatlisi', 140.00),
(3, 5, 'Sprite', 'Gazli içecek', 45.00),
(3, 3, 'Akdeniz Pizzasi', 'Zeytin, beyaz peynir', 260.00);

-- Sulu Yemek Evi (RestoranID: 4)
INSERT INTO Urunler (RestoranID, KategoriID, UrunAdi, Aciklama, Fiyat) VALUES
(4, 2, 'Kuru Fasulye', 'Ispir fasulyesi', 160.00),
(4, 2, 'Pilav', 'Tereyagli baldo', 80.00),
(4, 2, 'Karniyarik', 'Patlican ve kiyma', 190.00),
(4, 2, 'Izmir Köfte', 'Sebzeli ve salçali', 210.00),
(4, 5, 'Cacik', 'Sarimsakli ve naneli', 60.00),
(4, 4, 'Sütlaç', 'Firinda sütlaç', 100.00),
(4, 2, 'Tas Kebabi', 'Dana etli', 250.00),
(4, 2, 'Mercimek Çorbasi', 'Tereyagli soslu', 75.00),
(4, 5, 'Limonata', 'Ev yapimi', 70.00),
(4, 2, 'Musakka', 'Patlicanli', 185.00);

-- Tatli Koseresi (RestoranID: 5)
INSERT INTO Urunler (RestoranID, KategoriID, UrunAdi, Aciklama, Fiyat) VALUES
(5, 4, 'Fistikli Baklava', '4 Dilim', 220.00),
(5, 4, 'Sütlü Nuriye', 'Hafif sütlü tatli', 180.00),
(5, 4, 'Kazandibi', 'Yanisik lezzet', 120.00),
(5, 4, 'Profiterol', 'Bol çikolatali', 140.00),
(5, 5, 'Türk Kahvesi', 'Geleneksel', 65.00),
(5, 5, 'Çay', 'Demleme', 25.00),
(5, 4, 'Magnolia', 'Mevsim meyveli', 130.00),
(5, 4, 'Trileçe', 'Karamelli', 120.00),
(5, 5, 'Sahlep', 'Tarçinli', 90.00),
(5, 4, 'Mozaik Pasta', 'Cevizli', 110.00);
GO
