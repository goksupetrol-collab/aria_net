-- Stored Procedure: dbo.userformolustur
-- Tarih: 2026-01-14 20:06:08.385697
================================================================================

CREATE PROCEDURE [dbo].userformolustur
AS
BEGIN
declare @grupkod varchar(30)
declare @sr int;
/*
----------tanimlar
set @grupkod='tanim'
set @sr=10
insert into userformgrup (kod,ad,grpsr) values (@grupkod,'Tanım',@sr)

insert into userformlar (grupkod,formkod,fromack,sira) values (@grupkod,'firtan','Firma Tanımı',@sr+1)
insert into userformlar (grupkod,formkod,fromack,sira) values (@grupkod,'depotan','Depo Kart Tanımı',@sr+2)
insert into userformlar (grupkod,formkod,fromack,sira) values (@grupkod,'stkbrm','Stok Birim Tanımı',@sr+3)
insert into userformlar (grupkod,formkod,fromack,sira) values (@grupkod,'kurgrs','Kur Girişi',@sr+4)
insert into userformlar (grupkod,formkod,fromack,sira) values (@grupkod,'kultan','Kullanıcı Tanımı',@sr+5)	
insert into userformlar (grupkod,formkod,fromack,sira) values (@grupkod,'sistemtan','Sistem Tanımları',@sr+6)
insert into userformlar (grupkod,formkod,fromack,sira) values (@grupkod,'raportan','Rapor Tanımı',@sr+7)




----------grup kodları
set @grupkod='kart'
set @sr=20
insert into userformgrup (kod,ad,grpsr) values (@grupkod,'Kart',@sr)

insert into userformlar (grupkod,formkod,fromack,sira) values (@grupkod,'astokkart','Akaryakıt Stok Kart Tanımı',@sr+1)
insert into userformlar (grupkod,formkod,fromack,sira) values (@grupkod,'mstokkart','Market Stok Kart Tanımı',@sr+2)
insert into userformlar (grupkod,formkod,fromack,sira) values (@grupkod,'carikart','Cari Kart Tanımı',@sr+3)
insert into userformlar (grupkod,formkod,fromack,sira) values (@grupkod,'perkart','Personel Kart Tanımı',@sr+4)
insert into userformlar (grupkod,formkod,fromack,sira) values (@grupkod,'perakendekart','Perekande Kart Tanımı',@sr+5)	
insert into userformlar (grupkod,formkod,fromack,sira) values (@grupkod,'gelgidkart','Gelir - Gider Kart Tanımı',@sr+6)
insert into userformlar (grupkod,formkod,fromack,sira) values (@grupkod,'bankkart','Banka Kart Tanımı',@sr+7)
insert into userformlar (grupkod,formkod,fromack,sira) values (@grupkod,'poskart','Pos Kart Tanımı',@sr+8)
insert into userformlar (grupkod,formkod,fromack,sira) values (@grupkod,'istkredikart','İşletme Kredi Kartları',@sr+9)
insert into userformlar (grupkod,formkod,fromack,sira) values (@grupkod,'sayackart','Sayaç Kart Tanımı',@sr+10)
insert into userformlar (grupkod,formkod,fromack,sira) values (@grupkod,'tankkart','Tank Kart Tanımı',@sr+11)
*/


END

================================================================================
