-- Stored Procedure: dbo.genelrapolustur
-- Tarih: 2026-01-14 20:06:08.333624
================================================================================

CREATE PROCEDURE [dbo].genelrapolustur
AS
BEGIN


truncate table genelrap_goster

insert into genelrap_goster (id,ad,Goster)
values (1,'Akaryakıt Satış Listesi',1)

insert into genelrap_goster (id,ad,Goster)
values (2,'Gider Listesi',1)

insert into genelrap_goster (id,ad,Goster)
values (3,'Gelir Listesi',1)

insert into genelrap_goster (id,ad,Goster)
values (4,'Cari Veresiye',1)

insert into genelrap_goster (id,ad,Goster)
values (5,'Cari Tahsilat',1)

insert into genelrap_goster (id,ad,Goster)
values (6,'Cari Ödemeler',1)

insert into genelrap_goster (id,ad,Goster)
values (7,'Cari Bakiye',1)

insert into genelrap_goster (id,ad,Goster)
values (8,'Banka Kartları',1)

insert into genelrap_goster (id,ad,Goster)
values (9,'Pos Kartları',1)

insert into genelrap_goster (id,ad,Goster)
values (10,'Çek Listesi',1)

insert into genelrap_goster (id,ad,Goster)
values (11,'Kasa Listesi',1)


END

================================================================================
