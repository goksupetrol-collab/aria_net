-- Stored Procedure: dbo.eventhrkolustur
-- Tarih: 2026-01-14 20:06:08.321809
================================================================================

CREATE PROCEDURE [dbo].eventhrkolustur
AS
BEGIN

TRUNCATE TABLE eventhrk
/*-KART TANIMLARI */
/*ACIKLAMA ... NOLU KART EKLENDI,DUZELTİLDI,SİLİNDİ */
insert into eventhrk (id,ad) values (1,'CARİ KART')/* -1,0,1 EKLENDİ SİLİNDİ DÜZELTİLDİ */
insert into eventhrk (id,ad) values (2,'BANKA KART')
insert into eventhrk (id,ad) values (3,'PERSONEL KART')
insert into eventhrk (id,ad) values (4,'POS KART')
insert into eventhrk (id,ad) values (5,'İŞLETME KREDİ KART')
insert into eventhrk (id,ad) values (6,'KASA KART')
insert into eventhrk (id,ad) values (7,'GELİR GİDER KART')
insert into eventhrk (id,ad) values (8,'PERAKENDE KART')
insert into eventhrk (id,ad) values (9,'SAYAÇ KART')
insert into eventhrk (id,ad) values (10,'AKARYAKIT STOK KART')
insert into eventhrk (id,ad) values (11,'MARKET STOK KART')

/*VARRDIYA--50 */
insert into eventhrk (id,ad) values  (51,'POMPACI VARDIYA')/*1 ekleme, 2 geri alma, 3 kapatma,-1 silme */
/* POMPACI VARDİYA OLASILIKLAR
.. NOLU VARDIYA OLUSTURULDU
..NOLU YARATILDI SİLME
..NOLU YARATILDI GERI ALMA
...

*/
insert into eventhrk (id,ad) values  (52,'MARKET VARDIYA')

/* FATURA HRK-- 70 */
insert into eventhrk (id,ad) values  (71,'ALIŞ FATURASI')
insert into eventhrk (id,ad) values  (72,'SATIŞ FATURASI')

insert into eventhrk (id,ad) values  (73,'ALIŞ İRSALİYESİ')
insert into eventhrk (id,ad) values  (74,'SATIŞ İRSALİYESİ')

insert into eventhrk (id,ad) values  (75,'ALINAN SİPARİŞ')
insert into eventhrk (id,ad) values  (76,'VERİLEN SİPARİŞ')

insert into eventhrk (id,ad) values  (77,'VERESİYE FİŞ')
/*
VERESIYE FISI DEGİŞTİRİLDİ ACKLAMADA ORNEK (DEGİŞTİRLMEDEN ONCEKİ CARI KODU,UNVANI )

VERESIYE FISI DEGİŞTİRİLDİ SİLİNDİ

*/

insert into eventhrk (id,ad) values  (78,'ALACAK FİŞİ')



/*-ODEME HRKLERRRR -- 100 */
insert into eventhrk (id,ad) values  (101,'KASA TAHSİLAT')
insert into eventhrk (id,ad) values  (102,'KASA ÖDEME')
insert into eventhrk (id,ad) values  (103,'POS BORÇ')
insert into eventhrk (id,ad) values  (104,'POS ALACAK')
insert into eventhrk (id,ad) values  (104,'BANKA BORÇ')
insert into eventhrk (id,ad) values  (105,'BANKA ALACAK')
insert into eventhrk (id,ad) values  (106,'CARİ BORÇ')
insert into eventhrk (id,ad) values  (107,'CARİ ALACAK')
insert into eventhrk (id,ad) values  (106,'GELİR-GİDER BORÇ')
insert into eventhrk (id,ad) values  (107,'GELİR-GİDER ALACAK')
insert into eventhrk (id,ad) values  (108,'PERAKENDE BORÇ')
insert into eventhrk (id,ad) values  (109,'PERAKENDE ALACAK')

/*-CEK HRKLERİ --200 */
insert into eventhrk (id,ad) values  (201,'VERİLEN ÇEK');
insert into eventhrk (id,ad) values  (202,'ALINAN ÇEK');
insert into eventhrk (id,ad) values  (203,'CİROLANAN ÇEK');

/*-STOK HRK --300 */
insert into eventhrk (id,ad) values  (301,'HARİCİ İŞLEM')
insert into eventhrk (id,ad) values  (302,'STOK SATIŞ')
insert into eventhrk (id,ad) values  (303,'STOK ALIŞ')

insert into eventhrk (id,ad) values  (304,'STOK GİRİŞ')
insert into eventhrk (id,ad) values  (305,'STOK ÇIKIŞ')

insert into eventhrk (id,ad) values  (306,'KART AÇILIŞ')





END

================================================================================
