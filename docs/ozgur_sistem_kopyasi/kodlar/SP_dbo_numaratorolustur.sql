-- Stored Procedure: dbo.numaratorolustur
-- Tarih: 2026-01-14 20:06:08.350108
================================================================================

CREATE PROCEDURE [dbo].numaratorolustur
AS
BEGIN

TRUNCATE TABLE numarator

insert into numarator   (seri,numara,tip,tipack,uzunluk) values
('CR',0,'carikart','Cari Kartlar',5)
insert into numarator   (seri,numara,tip,tipack,uzunluk) values
('PRS',0,'perkart','Personel Kartları',5)
insert into numarator   (seri,numara,tip,tipack,uzunluk) values
('PRD',0,'perakendekart','Perakende Kartlar',5)
insert into numarator   (seri,numara,tip,tipack,uzunluk) values
('BNK',0,'bankakart','Banka Kartları',5)
insert into numarator   (seri,numara,tip,tipack,uzunluk) values
('MDP',0,'mardepkart','Market Depo Kartları',5)
insert into numarator   (seri,numara,tip,tipack,uzunluk) values
('GDR',0,'gelirkart','Gelir Kartları',5)
insert into numarator   (seri,numara,tip,tipack,uzunluk) values
('GLR',0,'giderkart','Gider Kartları',5)
insert into numarator   (seri,numara,tip,tipack,uzunluk) values
('SYC',0,'sayackart','Sayaç Kartları',5)
insert into numarator   (seri,numara,tip,tipack,uzunluk) values
('POS',0,'poskart','Pos Kartları',5)
insert into numarator   (seri,numara,tip,tipack,uzunluk) values
('ISKR',0,'istkredikart','İşletme Kredi Kartları',5)


insert into numarator   (seri,numara,tip,tipack,uzunluk) values
('TNK',0,'tankkart','Tank Kartları',5)
insert into numarator   (seri,numara,tip,tipack,uzunluk) values
('MST',0,'marktstkkart','Market Stok Kartları',5)
insert into numarator   (seri,numara,tip,tipack,uzunluk) values
('AST',0,'akyktstkkart','Akaryakıt Stok Kartları',5)
insert into numarator   (seri,numara,tip,tipack,uzunluk) values
('A',0,'makbuz','MAKBUZ',5)




END

================================================================================
