/*
PROJECT: Northwind Sales & Logistics Analysis
DATABASE: Northwind
TOOL: Microsoft SQL Server (T-SQL)
*/

-- =============================================
-- BÖLÜM 1: TEMEL SORGULAR VE FİLTRELEME
-- =============================================

-- Soru 1: Ürünleri fiyata göre sıralama
SELECT ProductName, UnitPrice 
FROM Products 
ORDER BY UnitPrice DESC;

-- Soru 2: Kritik stok seviyesi kontrolü (<10)
SELECT ProductID, ProductName, UnitsInStock 
FROM Products 
WHERE UnitsInStock < 10;

-- Soru 3: Satış Temsilcilerini listeleme
SELECT FirstName, LastName, HireDate 
FROM Employees 
WHERE Title = 'Sales Representative';

-- Soru 4: USA lokasyonlu müşteriler
SELECT CompanyName, City 
FROM Customers 
WHERE Country = 'USA';


-- =============================================
-- BÖLÜM 2: AGGREGATION & GROUPING
-- =============================================

-- Soru 5: Kategori bazlı toplam stok analizi
SELECT CategoryID, SUM(UnitsInStock) as Total_Stock
FROM Products
GROUP BY CategoryID;

-- Soru 6: Ülke bazlı müşteri dağılımı
SELECT Country, COUNT(*) as Customer_Count
FROM Customers
GROUP BY Country
ORDER BY Customer_Count DESC;

-- Soru 7: Yüksek navlun ücreti olan taşıyıcılar (HAVING kullanımı)
SELECT ShipVia, AVG(Freight) as Avg_Freight
FROM Orders
GROUP BY ShipVia
HAVING AVG(Freight) > 50;

-- Soru 8: Yıllara göre sipariş trendi
SELECT YEAR(OrderDate) as Order_Year, COUNT(OrderID) as Total_Orders
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY Order_Year DESC;


-- =============================================
-- BÖLÜM 3: JOINS (TABLO BİRLEŞTİRME)
-- =============================================

-- Soru 9: Ürün ve Kategori isimlerini birleştirme (LEFT JOIN)
SELECT p.ProductName, c.CategoryName
FROM Products p
LEFT JOIN Categories c ON c.CategoryID = p.CategoryID;

-- Soru 10: Hangi siparişi hangi çalışan aldı? (CONCAT kullanımı)
SELECT o.OrderID, o.OrderDate, CONCAT(e.FirstName, ' ', e.LastName) as Employee_Name
FROM Orders o
LEFT JOIN Employees e ON e.EmployeeID = o.EmployeeID;

-- Soru 11: Tedarikçi ve Ürün eşleşmesi
SELECT p.ProductName, s.CompanyName as Supplier_Name
FROM Products p
LEFT JOIN Suppliers s ON s.SupplierID = p.SupplierID;

-- Soru 12: Kayıtlı olup hiç sipariş vermeyen müşteriler (Anti-Join Mantığı)
SELECT c.CompanyName, c.ContactName
FROM Customers c
LEFT JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;


-- =============================================
-- BÖLÜM 4: ADVANCED SQL (WINDOW FUNCTIONS & CTE)
-- =============================================

-- Soru 13: Kategori bazlı fiyat sıralaması (PARTITION BY)
SELECT 
    ProductName, 
    CategoryID, 
    UnitPrice,
    ROW_NUMBER() OVER (PARTITION BY CategoryID ORDER BY UnitPrice DESC) as Rank_In_Category
FROM Products;

-- Soru 14: En çok ciro yapan çalışanı bulma (AGGREGATE + RANK)
SELECT 
    o.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) as Name,
    SUM(o.Freight) as Total_Freight,
    RANK() OVER (ORDER BY SUM(o.Freight) DESC) as Performance_Rank
FROM Orders o
LEFT JOIN Employees e ON e.EmployeeID = o.EmployeeID
GROUP BY o.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName);

-- Soru 15: Siparişler arası navlun farkı (LAG & CTE)
WITH Freight_Analysis AS (
    SELECT 
        OrderID,
        OrderDate,
        Freight,
        LAG(Freight, 1) OVER (ORDER BY OrderDate) as Previous_Freight
    FROM Orders
)
SELECT 
    *,
    (Freight - Previous_Freight) as Freight_Diff
FROM Freight_Analysis;


-- =============================================
-- BONUS: BUSINESS LOGIC (CIRO HESABI)
-- =============================================

-- Soru 16: En çok kazandıran ilk 5 ürün (İndirim hesaba katılarak)
SELECT TOP 5
    p.ProductName,
    SUM(od.Quantity) as Total_Units_Sold,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) as Net_Revenue
FROM Order Details od
LEFT JOIN Products p ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY Net_Revenue DESC;