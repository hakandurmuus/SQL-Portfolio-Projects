
/*
PROJECT: Library Management System Design & Analysis
DATABASE: LibraryDB (Custom)
TOOL: Microsoft SQL Server (T-SQL)
DESCRIPTION: Bu script, sıfırdan bir kütüphane veritabanı şeması oluşturur, 
örnek verileri girer ve temel iş zekası sorularını cevaplar.
*/

-- =============================================
-- BÖLÜM 1: DATABASE SETUP (DDL & DML)
-- Veritabanı Mimarisi ve Örnek Veri Girişi
-- =============================================

-- 1. Yazarlar Tablosu
CREATE TABLE dbo.Authors (
    AuthorID INT PRIMARY KEY,
    AuthorName NVARCHAR(100)
);

-- 2. Kitaplar Tablosu
CREATE TABLE dbo.Books (
    BookID INT PRIMARY KEY,
    Title NVARCHAR(150),
    AuthorID INT,
    Category NVARCHAR(50),
    PageCount INT,
    FOREIGN KEY (AuthorID) REFERENCES dbo.Authors(AuthorID)
);

-- 3. Üyeler Tablosu
CREATE TABLE dbo.Members (
    MemberID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    JoinDate DATE
);

-- 4. Ödünç Alma (Loans) Tablosu
CREATE TABLE dbo.Loans (
    LoanID INT PRIMARY KEY,
    BookID INT,
    MemberID INT,
    LoanDate DATE,
    ReturnDate DATE, -- NULL ise kitap hala üyededir
    FOREIGN KEY (BookID) REFERENCES dbo.Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES dbo.Members(MemberID)
);

-- VERİ GİRİŞİ (SEED DATA)
INSERT INTO dbo.Authors VALUES 
(1, 'J.K. Rowling'), (2, 'George Orwell'), (3, 'J.R.R. Tolkien'), (4, 'Fyodor Dostoyevsky'), (5, 'Sabahattin Ali');

INSERT INTO dbo.Books VALUES 
(101, 'Harry Potter ve Felsefe Taşı', 1, 'Fantastik', 223),
(102, '1984', 2, 'Bilim Kurgu', 328),
(103, 'Yüzüklerin Efendisi', 3, 'Fantastik', 1020),
(104, 'Suç ve Ceza', 4, 'Klasik', 671),
(105, 'Kürk Mantolu Madonna', 5, 'Roman', 160),
(106, 'Hayvan Çiftliği', 2, 'Siyasi Hiciv', 152);

INSERT INTO dbo.Members VALUES 
(1, 'Ahmet', 'Yılmaz', '2023-01-10'),
(2, 'Ayşe', 'Demir', '2023-05-15'),
(3, 'Mehmet', 'Kaya', '2024-02-20'),
(4, 'Zeynep', 'Çelik', '2024-03-01');

INSERT INTO dbo.Loans VALUES 
(1, 101, 1, '2024-01-05', '2024-01-15'), -- İade edilmiş
(2, 102, 1, '2024-02-01', NULL),          -- İade EDİLMEMİŞ (Aktif)
(3, 105, 2, '2024-02-10', '2024-02-20'), -- İade edilmiş
(4, 103, 3, '2024-03-01', NULL),          -- İade EDİLMEMİŞ (Aktif)
(5, 104, 2, '2024-03-05', '2024-03-25'), -- İade edilmiş
(6, 101, 4, '2024-04-01', NULL);          -- İade EDİLMEMİŞ (Aktif)


-- =============================================
-- BÖLÜM 2: VERİ ANALİZİ SENARYOLARI
-- =============================================

-- Soru 1: Mevcut kütüphane envanter analizi
-- Toplam kitap sayısı ve en kalın kitap bilgisi
SELECT COUNT(BookID) as Total_Books_Count FROM dbo.Books;

SELECT TOP 1 Title as Longest_Book, PageCount 
FROM dbo.Books 
ORDER BY PageCount DESC;


-- Soru 2: Aktif Okuyucular (Kitabı iade etmeyenler)
-- IS NULL filtresi kullanılarak şu an kimde hangi kitap var?
SELECT 
    l.LoanID,
    m.FirstName,
    m.LastName,
    b.Title as Book_Title,
    l.LoanDate
FROM dbo.Loans l
LEFT JOIN dbo.Members m ON m.MemberID = l.MemberID
LEFT JOIN dbo.Books b ON b.BookID = l.BookID
WHERE l.ReturnDate IS NULL;


-- Soru 3: En Popüler Yazarlar
-- Hangi yazarın kitapları toplam kaç kez ödünç alınmış?
SELECT 
    a.AuthorName,
    COUNT(*) as Read_Count
FROM dbo.Loans l
LEFT JOIN dbo.Books b ON b.BookID = l.BookID
LEFT JOIN dbo.Authors a ON a.AuthorID = b.AuthorID
GROUP BY a.AuthorName
ORDER BY Read_Count DESC;


-- Soru 4: Kitap Kurtları (HAVING Kullanımı)
-- Birden fazla kez kütüphaneden kitap ödünç almış sadık üyeler
SELECT 
    m.FirstName,
    m.LastName,
    COUNT(*) as Total_Loans
FROM dbo.Loans l
LEFT JOIN dbo.Members m ON m.MemberID = l.MemberID
GROUP BY m.MemberID, m.FirstName, m.LastName
HAVING COUNT(*) > 1;


-- Soru 5: Kategori Durum Analizi (CASE Expression)
-- "Fantastik" kategorisindeki kitapların anlık durumu (Rafta mı, Okuyucuda mı?)
SELECT 
    b.Title,
    b.Category,
    CASE
        WHEN l.ReturnDate IS NULL THEN 'Okuyucuda (Active Loan)' 
        ELSE 'Rafta (Available)'
    END as Status
FROM dbo.Books b
LEFT JOIN dbo.Loans l ON l.BookID = b.BookID
WHERE b.Category = N'Fantastik';

