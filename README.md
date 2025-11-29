# 🗄️ SQL Portfolio Projects

Bu repo, **Microsoft SQL Server (T-SQL)** kullanılarak hazırlanmış veritabanı mimarisi ve ileri seviye veri analizi projelerini içerir. 

Amaç, ham veriden anlamlı işgörüler (insights) çıkarma ve sıfırdan veritabanı kurgulama yetkinliklerini sergilemektir.

## 📂 Proje İçerikleri

### 1. Library Database Design (Veritabanı Mimarisi) 🏗️
Sıfırdan bir kütüphane yönetim sistemi veritabanı tasarlanmıştır.
* **DDL (Data Definition Language):** `CREATE TABLE` ile tablolar oluşturuldu, `PRIMARY KEY` ve `FOREIGN KEY` ile ilişkisel bütünlük sağlandı.
* **DML (Data Manipulation Language):** `INSERT` ile örnek veriler girildi.
* **Analiz:** `JOIN` ve `IS NULL` filtreleri kullanılarak "Aktif Okuyucular" ve "En Popüler Yazarlar" raporlandı.

### 2. Northwind Advanced Analysis (İleri Seviye Analiz) 📈
Gerçek hayat ticaret senaryolarını simüle eden Northwind veritabanı üzerinde analizler yapılmıştır.
* **Window Functions:** `ROW_NUMBER`, `RANK`, `LAG` fonksiyonları ile performans sıralamaları ve dönemler arası karşılaştırmalar yapıldı.
* **CTE (Common Table Expressions):** Karmaşık sorgular parçalanarak okunabilirlik ve performans artırıldı.
* **Business Logic:** İndirim oranları hesaba katılarak Net Ciro (Net Revenue) hesaplamaları yapıldı.
* **Anti-Joins:** Hiç sipariş vermeyen "Pasif Müşteriler" tespit edildi.

## 🛠️ Kullanılan Teknolojiler
* **Database:** Microsoft SQL Server
* **Language:** T-SQL
* **Concepts:** Joins, Window Functions, CTE, Aggregations, Database Normalization

---
*Bu çalışma, Veri Analisti olma yolculuğumun SQL pratik aşamasıdır.*
