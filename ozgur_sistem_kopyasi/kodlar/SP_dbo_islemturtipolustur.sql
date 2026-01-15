-- Stored Procedure: dbo.islemturtipolustur
-- Tarih: 2026-01-14 20:06:08.338888
================================================================================

CREATE PROCEDURE [dbo].islemturtipolustur
AS
BEGIN

truncate table islemturtip

insert into islemturtip (tip,ad) values ('ISL','İŞLEM');
insert into islemturtip (tip,ad) values ('TAH','TAHSİLAT');
insert into islemturtip (tip,ad) values ('ODE','ÖDEME');
insert into islemturtip (tip,ad) values ('CEK','ÇEK');
insert into islemturtip (tip,ad) values ('SEN','SENET');
insert into islemturtip (tip,ad) values ('EMC','E.M.Ç');
insert into islemturtip (tip,ad) values ('BNK','BANKA');
insert into islemturtip (tip,ad) values ('GLG','GELİR-GİDER');
insert into islemturtip (tip,ad) values ('MAH','MAHSUP');
insert into islemturtip (tip,ad) values ('DVA','DÖVİZ ALIŞ');
insert into islemturtip (tip,ad) values ('DVS','DÖVİZ SATIŞ');
insert into islemturtip (tip,ad) values ('VIR','VİRMAN');
insert into islemturtip (tip,ad) values ('HAR','HARİCİ');
insert into islemturtip (tip,ad) values ('FIS','FİŞ');
insert into islemturtip (tip,ad) values ('VAR','VARDİYA');

insert into islemturtip (tip,ad) values ('FAT','FATURA');
insert into islemturtip (tip,ad) values ('IRS','İRSALİYESİ');

insert into islemturtip (tip,ad) values ('SAY','SAYIM');

insert into islemturtip (tip,ad) values ('MAS','MAAŞ');

insert into islemturtip (tip,ad) values ('VAD','VADE');

END

================================================================================
