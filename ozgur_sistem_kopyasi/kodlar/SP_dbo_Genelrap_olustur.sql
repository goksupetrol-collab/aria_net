-- Stored Procedure: dbo.Genelrap_olustur
-- Tarih: 2026-01-14 20:06:08.332987
================================================================================

CREATE PROCEDURE [dbo].Genelrap_olustur
AS
BEGIN


truncate table Genel_Rap_Goster

insert into Genel_Rap_Goster (id,ad,Goster)
values (1,'Akaryakıt Satış Listesi',1)

insert into Genel_Rap_Goster (id,ad,Goster)
values (2,'Gider Listesi',1)

insert into Genel_Rap_Goster (id,ad,Goster)
values (3,'Gelir Listesi',1)

insert into Genel_Rap_Goster (id,ad,Goster)
values (4,'Cari Kartlar',1)

insert into Genel_Rap_Goster (id,ad,Goster)
values (5,'Personel Kartlar',1)

insert into Genel_Rap_Goster (id,ad,Goster)
values (6,'Banka Kartları',1)

insert into Genel_Rap_Goster (id,ad,Goster)
values (7,'Pos Kartları',1)

insert into Genel_Rap_Goster (id,ad,Goster)
values (8,'İşletme Kredi Kartları',1)


insert into Genel_Rap_Goster (id,ad,Goster)
values (9,'Çek',1)


insert into Genel_Rap_Goster (id,ad,Goster)
values (10,'Kasa',1)




END

================================================================================
