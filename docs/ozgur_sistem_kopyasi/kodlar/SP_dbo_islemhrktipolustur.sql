-- Stored Procedure: dbo.islemhrktipolustur
-- Tarih: 2026-01-14 20:06:08.338248
================================================================================

CREATE PROCEDURE [dbo].islemhrktipolustur
AS
BEGIN

truncate table islemhrktip


insert into islemhrktip (tip,hrk,ad,gc) values ('ISL','KAC','KART AÇILIŞ','G');
insert into islemhrktip (tip,hrk,ad,gc) values ('ISL','DVR','DEVİR İŞLEMİ','G');

insert into islemhrktip (tip,hrk,ad,gc) values ('TAH','NAK','NAKİT TAHSİLAT','G');
insert into islemhrktip (tip,hrk,ad,gc) values ('TAH','TES','NAKİT TESLİMAT','G');
insert into islemhrktip (tip,hrk,ad,gc) values ('TAH','POS','KREDİ KARTI TAHSİL','G');


insert into islemhrktip (tip,hrk,ad,gc) values ('ODE','NAK','NAKİT ÖDEME','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('ODE','PRU','PARA ÜSTÜ','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('ODE','IKK','KREDİ KART İLE ÖDEME','C');

insert into islemhrktip (tip,hrk,ad,gc) values ('CEK','KSN','KESİLEN ÇEK','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('CEK','ALN','ALINAN ÇEK','G');

insert into islemhrktip (tip,hrk,ad,gc) values ('CEK','CIR','CİROLALAN ÇEK','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('CEK','TGR','TAKASTAN ALINAN ÇEK','G');
insert into islemhrktip (tip,hrk,ad,gc) values ('CEK','CGR','CİRODAN ALINAN ÇEK','G');
insert into islemhrktip (tip,hrk,ad,gc) values ('CEK','TKT','TAKAS ÇEKİ TAHSİL','G');
insert into islemhrktip (tip,hrk,ad,gc) values ('CEK','ELT','ELDEN ÇEK TAHSİL','G');
insert into islemhrktip (tip,hrk,ad,gc) values ('CEK','ODE','ÇEK ÖDEME','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('CEK','PID','PORTFÖYDEN ÇEK İADE','C');

insert into islemhrktip (tip,hrk,ad,gc) values ('CEK','CKR','CİRODAN KAŞILIKSIZ ÇEK','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('CEK','PKR','PORTFÖYDEN KAŞILIKSIZ ÇEK','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('CEK','TKR','TAKASTAN KAŞILIKSIZ ÇEK','C');



/*
if (tip='TGR') then
result:='Geri Al - Takastan';
if (tip='PKR') then
result:='Karşılıksız';
if (tip='TKR') then
result:='Karşılıksız';
if (tip='CKR') then
result:='Karşılıksız';
*/
insert into islemhrktip (tip,hrk,ad,gc) values ('SEN','VER','VERİLEN SENET','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('SEN','ALN','ALINAN SENET','G');
insert into islemhrktip (tip,hrk,ad,gc) values ('EMC','ALN','ALINAN E.M.Ç','G');

insert into islemhrktip (tip,hrk,ad,gc) values ('BNK','YTN','BANKAYA YATAN','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('BNK','CKN','BANKADAN ÇEKİLEN','G');
insert into islemhrktip (tip,hrk,ad,gc) values ('BNK','B-C','GİDEN HAVALE / EFT','G');
insert into islemhrktip (tip,hrk,ad,gc) values ('BNK','C-B','GELEN HAVALE / EFT','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('BNK','SLO','POS ÖDEME','G');
insert into islemhrktip (tip,hrk,ad,gc) values ('BNK','BKK','BANKA KOMİSYON','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('BNK','EKK','EK KOMİSYON','C');

insert into islemhrktip (tip,hrk,ad,gc) values ('BNK','IKO','BANKA I.K.K ÖDEME','G');


insert into islemhrktip (tip,hrk,ad,gc) values ('GLG','MRF','ÇEK MASRAFI','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('GLG','BMF','BANKA MASRAFI','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('GLG','BKK','BANKA KOMİSYON','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('GLG','EKK','EK KOMİSYON','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('GLG','MAR','MARKET GİDERİ','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('GLG','IND','İNDİRİM','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('GLG','GID','GİDER','C');

insert into islemhrktip (tip,hrk,ad,gc) values ('GLG','FIR','FİRE KAYDI','C');


insert into islemhrktip (tip,hrk,ad,gc) values ('MAH','GIR','MAHSUP GİRİŞ','G');
insert into islemhrktip (tip,hrk,ad,gc) values ('MAH','CIK','MAHSUP ÇIKIŞ','C');

insert into islemhrktip (tip,hrk,ad,gc) values ('DVA','DAG','DÖVİZ (A-S) GİRİŞ','G')
insert into islemhrktip (tip,hrk,ad,gc) values ('DVA','DAC','DÖVİZ (A-S) ÇIKIŞ','C')

insert into islemhrktip (tip,hrk,ad,gc) values ('DVS','DAG','DÖVİZ (A-S) GİRİŞ','G')
insert into islemhrktip (tip,hrk,ad,gc) values ('DVS','DAC','DÖVİZ (A-S) ÇIKIŞ','C')


insert into islemhrktip (tip,hrk,ad,gc) values ('VIR','VRG','VİRMAN GİRİŞ','G');
insert into islemhrktip (tip,hrk,ad,gc) values ('VIR','VRC','VİRMAN ÇIKIŞ','C');

insert into islemhrktip (tip,hrk,ad,gc) values ('HAR','BOR','HARİCİ BORÇ','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('HAR','ALC','HARİCİ ALACAK','G');

insert into islemhrktip (tip,hrk,ad,gc) values ('FIS','CAK','CARİ FİŞ AKTARIM','C');

insert into islemhrktip (tip,hrk,ad,gc) values ('FAT','GID','FATURA GİDER GİRİŞİ','C');

insert into islemhrktip (tip,hrk,ad,gc) values ('FAT','SHR','FATURA STOK GİRİŞİ','C');


insert into islemhrktip (tip,hrk,ad,gc) values ('VAR','ACK','VARDİYA AÇIK','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('VAR','FAZ','VARDİYA FAZLA','G');

insert into islemhrktip (tip,hrk,ad,gc) values ('VAR','VTO','VARDİYA TAHSİLAT ÖDEME','-');




insert into islemhrktip (tip,hrk,ad,gc) values ('SAY','ACK','SAYIM AÇIK','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('SAY','FAZ','SAYIM FAZLA','G');

insert into islemhrktip (tip,hrk,ad,gc) values ('MAS','AKT','MAAŞ AKTARIM','G');

insert into islemhrktip (tip,hrk,ad,gc) values ('VAD','CFK','CARİ VADE FARKI','G');

insert into islemhrktip (tip,hrk,ad,gc) values ('VAD','FVF','FİŞ VADE FARKI','G');

insert into islemhrktip (tip,hrk,ad,gc) values ('GLG','FYF','FİŞ YENİ FİYAT FARKI','G');



/*----faturalar */
insert into islemhrktip (tip,hrk,ad,gc) values ('FAT','AKA','AKARYAKIT ALIŞ FATURASI','G');
insert into islemhrktip (tip,hrk,ad,gc) values ('FAT','MRA','MARKET ALIŞ FATURASI','G');
insert into islemhrktip (tip,hrk,ad,gc) values ('FAT','YGA','YAĞ ALIŞ FATURASI','G');
insert into islemhrktip (tip,hrk,ad,gc) values ('FAT','GGA','GELİR-GİDER ALIŞ FATURASI','G');

insert into islemhrktip (tip,hrk,ad,gc) values ('FAT','VRS','VERESİYE SATIŞ FATURASI','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('FAT','TPS','TOPTAN SATIŞ FATURASI','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('FAT','PRS','PERAKENDE SATIŞ FATURASI','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('FAT','GGS','GELİR-GİDER SATIŞ FATURASI','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('FAT','IAS','SATIŞTAN İADE FATURASI','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('FAT','IAA','ALIŞTAN İADE FATURASI','C');

/*----irsaliye */
insert into islemhrktip (tip,hrk,ad,gc) values ('IRS','AKA','AKARYAKIT ALIŞ İRSALİYESİ','G');
insert into islemhrktip (tip,hrk,ad,gc) values ('IRS','MRA','MARKET ALIŞ İRSALİYESİ','G');
insert into islemhrktip (tip,hrk,ad,gc) values ('IRS','YGA','YAĞ ALIŞ İRSALİYESİ','G');

insert into islemhrktip (tip,hrk,ad,gc) values ('IRS','AKS','AKARYAKIT SATIŞ İRSALİYESİ','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('IRS','MRS','MARKET SATIŞ İRSALİYESİ','C');
insert into islemhrktip (tip,hrk,ad,gc) values ('IRS','YGS','YAĞ SATIŞ İRSALİYESİ','C');


END

================================================================================
