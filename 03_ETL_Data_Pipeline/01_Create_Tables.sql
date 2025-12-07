CREATE DATABASE ETL_Otomasyon
GO

USE ETL_Otomasyon
GO

CREATE TABLE Raw_Satislar (
	ID INT IDENTITY(1,1),
	CustomerName NVARCHAR(50),
	ProductCode NVARCHAR(20),
	Price NVARCHAR(50),
	Amount INT,
	TransactionDate DATE
	)

CREATE TABLE Fact_Satislar (
	SalesID INT IDENTITY(1,1) PRIMARY KEY,
	CustomerName NVARCHAR(50),
	ProductCode NVARCHAR(20),
	Ciro DECIMAL(18,2),
	RegistrationDate DATETIME
	)

CREATE TABLE Transaction_Logs (
	LogID INT IDENTITY(1,1),
	TransactionName NVARCHAR(100),
	Situation NVARCHAR(20),
	RecordingTime DATETIME DEFAULT GETDATE()
	)


INSERT INTO Raw_Satislar (CustomerName, ProductCode, Price, Amount, TransactionDate)
VALUES 
('Ahmet Yýlmaz', 'IPHONE 15', '54000', 1, '2025-01-10'),
('Mehmet Demir', 'PS5 SLIM', '25.000 TL', 1, '2025-01-11'),
('Ayþe Kaya', 'DYSON V15', 'Stok Yok', 1, '2025-01-12'),
('Fatma Çelik', 'MACBOOK', '45000', -2, '2025-01-13'),
('Caner Erkin', 'AIRPODS', '8000', 2, '2025-01-14');

