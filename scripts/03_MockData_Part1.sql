USE YemekSiparisDB;
GO

-- 1. Kullanıcılar (20+ Kişi: Müşteriler, Sahipler, Kuryeler)
INSERT INTO Kullanicilar (Ad, Soyad, Eposta, Telefon, Sifre, Rol, IsVerifiedNeedy) VALUES
('Ahmet', 'Yilmaz', 'ahmet@mail.com', '5551112233', 'pass123', 'Musteri', 0),
('Ayse', 'Demir', 'ayse@mail.com', '5551112234', 'pass123', 'Musteri', 1), -- İhtiyaç Sahibi
('Mehmet', 'Kaya', 'mehmet@mail.com', '5551112235', 'pass123', 'Musteri', 0),
('Fatma', 'Celik', 'fatma@mail.com', '5551112236', 'pass123', 'Musteri', 1), -- İhtiyaç Sahibi
('Can', 'Oz', 'can@mail.com', '5551112237', 'pass123', 'Restoran', 0), -- Sahip 1
('Ece', 'Aydin', 'ece@mail.com', '5551112238', 'pass123', 'Restoran', 0), -- Sahip 2
('Burak', 'Turan', 'burak@mail.com', '5551112239', 'pass123', 'Kurye', 0),
('Selin', 'Yildiz', 'selin@mail.com', '5551112240', 'pass123', 'Musteri', 0),
('Murat', 'Aksoy', 'murat@mail.com', '5551112241', 'pass123', 'Musteri', 1),
('Deniz', 'Yalcin', 'deniz@mail.com', '5551112242', 'pass123', 'Kurye', 0),
('Zeynep', 'Korkmaz', 'zeynep@mail.com', '5551112243', 'pass123', 'Musteri', 0),
('Ali', 'Aras', 'ali@mail.com', '5551112244', 'pass123', 'Musteri', 0),
('Gizem', 'Bakir', 'gizem@mail.com', '5551112245', 'pass123', 'Restoran', 0), -- Sahip 3
('Hakan', 'Sener', 'hakan@mail.com', '5551112246', 'pass123', 'Restoran', 0), -- Sahip 4
('Merve', 'Guler', 'merve@mail.com', '5551112247', 'pass123', 'Restoran', 0), -- Sahip 5
('Umut', 'Koc', 'umut@mail.com', '5551112248', 'pass123', 'Kurye', 0),
('Elif', 'Sari', 'elif@mail.com', '5551112249', 'pass123', 'Musteri', 1),
('Serkan', 'Dogan', 'serkan@mail.com', '5551112250', 'pass123', 'Musteri', 0),
('Pelin', 'Seker', 'pelin@mail.com', '5551112251', 'pass123', 'Musteri', 0),
('Kemal', 'Yurt', 'kemal@mail.com', '5551112252', 'pass123', 'Admin', 0);
GO

-- 2. Kurye Detayları
INSERT INTO Kuryeler (KuryeID, AracTipi, EhliyetNo) VALUES
(7, 'Motosiklet', 'A2-12345'),
(10, 'Motosiklet', 'A2-54321'),
(16, 'Bisiklet', 'B-99887');
GO

-- 3. Kategoriler
INSERT INTO Kategoriler (KategoriAdi) VALUES 
('Burger'), ('Kebap'), ('Pizza'), ('Tatli'), ('Icecek');
GO

-- 4. Restoranlar (En az 5 adet)
INSERT INTO Restoranlar (Ad, Adres, Telefon, Puani, SahipID) VALUES
('Burger Sarayi', 'Besiktas, Istanbul', '2125550001', 4.5, 5),
('Lezzet Kebap', 'Kadikoy, Istanbul', '2165550002', 4.8, 6),
('Pizza Dunyasi', 'Sisli, Istanbul', '2125550003', 4.2, 13),
('Sulu Yemek Evi', 'Fatih, Istanbul', '2125550004', 4.7, 14),
('Tatli Koseresi', 'Uskudar, Istanbul', '2165550005', 4.9, 15);
GO
