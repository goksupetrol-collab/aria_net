PROJE BILGILERI - SQL SERVER ORTAMI
===================================

Bu dosya yeni sohbet acanlar icin proje ve SQL Server bilgilerini tek yerde toplar.

PROJE OZETI
-----------
- Proje adi: aria_net
- Konum: D:\tayfun
- Backend: Django 5.2.9
- Frontend: Telerik Kendo UI (jQuery)
- Ana sayfa: dashboard/templates/dashboard/telerik_yeni_proje.html
- Base template: dashboard/templates/dashboard/base.html

SQL SERVER ORTAMI
-----------------
- Surum: SQL Server 2025 Developer Edition
- Kurulum tipi: Custom install
- Authentication: Mixed Mode
- Instance: SQL2025
- Sunucu: localhost\SQL2025
- Windows kullanicisi SQL admin olarak eklendi (Add Current User)

SQL KULLANICI BILGILERI (Django icin tercih edilen)
---------------------------------------------------
- Kullanici adi: sa
- Sifre: Mt5652472!

VERITABANI
----------
- Ana veritabani: aria_net
- aria_net_log: SQL Server tarafindan otomatik log veritabanidir

UYGULAMA BAGLANTISI
-------------------
- Django tarafinda SQL Server aktif edildi.
- Ayarlar dosyasi: aria_net/settings.py
- Database engine: mssql (mssql-django + pyodbc)
- ODBC Driver: ODBC Driver 18 for SQL Server
- Baglanti parametresi: TrustServerCertificate=yes;Encrypt=yes

NOTLAR
------
- SQLite artik hedef degil; SQL Server aktif.
- Mevcut SQLite verileri kritik degil; veri tasima sonra gerekirse yapilacak.
