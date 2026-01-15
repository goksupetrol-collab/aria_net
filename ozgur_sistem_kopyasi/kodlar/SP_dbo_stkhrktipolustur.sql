-- Stored Procedure: dbo.stkhrktipolustur
-- Tarih: 2026-01-14 20:06:08.382119
================================================================================

CREATE PROCEDURE [dbo].stkhrktipolustur
AS
BEGIN

truncate table stkhrktip

insert into stkhrktip (kod,ad,gc) values('KARTAC','KART AÇILIŞ','GC');
insert into stkhrktip (kod,ad,gc) values('DEVIR','DEVİR İŞLEMİ','GC');
/*------FATURA */
insert into stkhrktip (kod,ad,gc) values('FATAKALS','AKARYAKIT ALIŞ FATURASI','G');
insert into stkhrktip (kod,ad,gc) values('FATMRALS','MARKET ALIŞ FATURASI','G');
insert into stkhrktip (kod,ad,gc) values('FATGGALS','GELİR GİDER ALIŞ FATURASI','G');
insert into stkhrktip (kod,ad,gc) values('FATYGALS','YAĞ ALIŞ FATURASI','G');

insert into stkhrktip (kod,ad,gc) values('FATVERSAT','VERESIYE SATIŞ FATURASI','C');
insert into stkhrktip (kod,ad,gc) values('FATGGSAT','GELİR GİDER SATIŞ FATURASI','C');
insert into stkhrktip (kod,ad,gc) values('FATTOPSAT','TOPTAN SATIŞ FATURASI','C');
insert into stkhrktip (kod,ad,gc) values('FATPERSAT','PERAKENDE SATIŞ FATURASI','C');

insert into stkhrktip (kod,ad,gc) values('FATIADALS','ALIŞTAN IADE FATURASI','C');
insert into stkhrktip (kod,ad,gc) values('FATIADSAT','SATIŞTAN IADE FATURASI','G');


/*--IRSALIYE */
insert into stkhrktip (kod,ad,gc) values('IRSAKALS','AKARYAKIT ALIŞ İRSALİYESİ','G');
insert into stkhrktip (kod,ad,gc) values('IRSMRALS','MARKET ALIŞ İRSALİYESİ','G');
insert into stkhrktip (kod,ad,gc) values('IRSYGALS','YAĞ ALIŞ İRSALİYESİ','G');

insert into stkhrktip (kod,ad,gc) values('IRSAKSAT','AKARYAKIT SATIŞ İRSALİYESİ','C');
insert into stkhrktip (kod,ad,gc) values('IRSMRSAT','MARKET SATIŞ İRSALİYESİ','C');
insert into stkhrktip (kod,ad,gc) values('IRSYGSAT','YAĞ SATIŞ İRSALİYESİ','C');

/*VERESIYE */
insert into stkhrktip (kod,ad,gc) values('FISVERSAT','VERESİYE SATIŞ','C');

/*-POPMACI */
insert into stkhrktip (kod,ad,gc) values('POMSAYSAT','SAYAÇ SATIŞ','C');
insert into stkhrktip (kod,ad,gc) values('POMMARSAT','YAĞ-EMTİA SATIŞ','C');

/*-POMPACI TRANSFER İŞLEM */
insert into stkhrktip (kod,ad,gc) values('POMTRANS','SAYAÇ TRANSFER','C');

/*-MARKET */
insert into stkhrktip (kod,ad,gc) values('MARSAT','MARKET SATIŞ','C');
insert into stkhrktip (kod,ad,gc) values('MARIAD','MARKET İADE','G');

/*-SAYIM */
insert into stkhrktip (kod,ad,gc) values('SAYSON','SAYIM SONUC','GC');

/*-DEPO TRANSFER */
insert into stkhrktip (kod,ad,gc) values('DEPTRAN','DEPO TRANSFER','GC');

/*-SAYAC YAG DOK */
insert into stkhrktip (kod,ad,gc) values('YAGDOK','SAYAÇA YAĞ DÖK','GC');


/*-FİRE TRANSFER */
insert into stkhrktip (kod,ad,gc) values('STKFIRE','FİRE KAYDI','GC');

/*-HARICI İŞLEM */
insert into stkhrktip (kod,ad,gc) values('HARGIRCIK','HARİCİ GİRİŞ ÇIKIŞ','GC');


END

================================================================================
