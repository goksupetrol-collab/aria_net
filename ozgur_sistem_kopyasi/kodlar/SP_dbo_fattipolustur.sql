-- Stored Procedure: dbo.fattipolustur
-- Tarih: 2026-01-14 20:06:08.323510
================================================================================

CREATE PROCEDURE [dbo].fattipolustur
AS
BEGIN

TRUNCATE table fattip


/*------FATURA */
insert into fattip (kod,ad,gc,tip) values('FATAKALS','AKARYAKIT ALIŞ FATURASI','G','FAT');
insert into fattip (kod,ad,gc,tip) values('FATMRALS','MARKET ALIŞ FATURASI','G','FAT');
insert into fattip (kod,ad,gc,tip) values('FATGGALS','GELİR GİDER ALIŞ FATURASI','G','FAT');
insert into fattip (kod,ad,gc,tip) values('FATYGALS','YAĞ ALIŞ FATURASI','G','FAT');

insert into fattip (kod,ad,gc,tip) values('FATVERSAT','VERESİYE SATIŞ FATURASI','C','FAT');
insert into fattip (kod,ad,gc,tip) values('FATGGSAT','GELİR GİDER SATIŞ FATURASI','C','FAT');
insert into fattip (kod,ad,gc,tip) values('FATTOPSAT','TOPTAN SATIŞ FATURASI','C','FAT');
insert into fattip (kod,ad,gc,tip) values('FATPERSAT','PERAKENDE SATIŞ FATURASI','C','FAT');
insert into fattip (kod,ad,gc,tip) values('FATZRAPSAT','Z RAPORU SATIŞ ','C','FAT');

insert into fattip (kod,ad,gc,tip) values('FATIADALS','ALIŞTAN İADE FATURASI','C','FAT');
insert into fattip (kod,ad,gc,tip) values('FATIADSAT','SATIŞTAN İADE FATURASI','G','FAT');


/*--IRSALIYE */
insert into fattip (kod,ad,gc,tip) values('IRSAKALS','AKARYAKIT ALIŞ İRSALİYESİ','G','IRS');
insert into fattip (kod,ad,gc,tip) values('IRSMRALS','MARKET ALIŞ İRSALİYESİ','G','IRS');
insert into fattip (kod,ad,gc,tip) values('IRSYGALS','YAĞ ALIŞ İRSALİYESİ','G','IRS');

insert into fattip (kod,ad,gc,tip) values('IRSAKSAT','AKARYAKIT SATIŞ İRSALİYESİ','C','IRS');
insert into fattip (kod,ad,gc,tip) values('IRSMRSAT','MARKET SATIŞ İRSALİYESİ','C','IRS');
insert into fattip (kod,ad,gc,tip) values('IRSYGSAT','YAĞ SATIŞ İRSALİYESİ','C','IRS');

/*--SİPARİŞ */
insert into fattip (kod,ad,gc,tip) values('SIPALS','ALINAN SİPARİŞ','G','SIP');
insert into fattip (kod,ad,gc,tip) values('SIPSAT','VERILEN SİPARİŞ','C','SIP');

/*VERESIYE */
insert into fattip (kod,ad,gc,tip) values('FISVERSAT','VERESİYE SATIŞ FİŞİ','C','FIS');
insert into fattip (kod,ad,gc,tip) values('FISALCSAT','ALACAK SATIŞ FİŞİ','C','FIS');


/*ZRAPOR */
insert into fattip (kod,ad,gc,tip) values('FATZRPSAT','Z RAPORU SATIŞ ','C','ZRP');

END

================================================================================
