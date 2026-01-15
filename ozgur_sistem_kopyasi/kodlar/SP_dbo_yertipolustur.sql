-- Stored Procedure: dbo.yertipolustur
-- Tarih: 2026-01-14 20:06:08.391525
================================================================================

CREATE PROCEDURE [dbo].yertipolustur
AS
BEGIN

TRUNCATE TABLE yertipad;

insert into yertipad (kod,ad) values('pomvardimas','POMPACI VARDİYA');
insert into yertipad (kod,ad) values('marvardimas','MARKET VARDİYA');
insert into yertipad (kod,ad) values('veresiislem','VERESİYE İŞLEM');
insert into yertipad (kod,ad) values('faturamas','FATURA GİRİŞ');

insert into yertipad (kod,ad) values('irsaliyemas','İRSALİYE GİRİŞ');

insert into yertipad (kod,ad) values('carikart','CARİ KART');
insert into yertipad (kod,ad) values('perkart','PERSONEL KART');
insert into yertipad (kod,ad) values('gelgidkart','GELİR-GİDER KART');
insert into yertipad (kod,ad) values('perakendekart','PERAKENDE KART');
insert into yertipad (kod,ad) values('tankkart','TANK KART');
insert into yertipad (kod,ad) values('marstkkart','MARKET STOK KART');
insert into yertipad (kod,ad) values('poskart','POS KART');
insert into yertipad (kod,ad) values('bankakart','BANKA KART');
insert into yertipad (kod,ad) values('sayackart','SAYAÇ KART');
insert into yertipad (kod,ad) values('istkart','İŞLETME KREDİ KART');

insert into yertipad (kod,ad) values('otomas','OTOMASYON KART');
insert into yertipad (kod,ad) values('kasahrk','KASA HAREKET');

insert into yertipad (kod,ad) values('hizliislem','HIZLI İŞLEM');
insert into yertipad (kod,ad) values('ceksenislem','ÇEK SENET İŞLEM');
insert into yertipad (kod,ad) values('posislem','POS İŞLEM');
insert into yertipad (kod,ad) values('bankaislem','BANKA İŞLEM');
insert into yertipad (kod,ad) values('kasaislem','KASA İŞLEM');
insert into yertipad (kod,ad) values('haricislem','HARİCİ İŞLEM');
insert into yertipad (kod,ad) values('havuzislem','HAVUZ İŞLEM');
insert into yertipad (kod,ad) values('vts_islem','VTS İŞLEM');

insert into yertipad (kod,ad) values('deptrsislem','DEPO TRANSFER');

insert into yertipad (kod,ad) values('fireislem','ÖLÇÜM-FİRE İŞLEM');
insert into yertipad (kod,ad) values('yagdokislem','YAĞ DÖKME İŞLEM');
insert into yertipad (kod,ad) values('yazarkasa','YAZAR KASA AKTARIM');
insert into yertipad (kod,ad) values('sayim','SAYIM İŞLEM');

insert into yertipad (kod,ad) values('permaas','PERSONEL MAAŞ AKTARIM');

insert into yertipad (kod,ad) values('z_rapor','Z RAPOR');

END

================================================================================
