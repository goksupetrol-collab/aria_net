-- Stored Procedure: dbo.cektipolustur
-- Tarih: 2026-01-14 20:06:08.321253
================================================================================

CREATE PROCEDURE [dbo].cektipolustur
AS
BEGIN

TRUNCATE TABLE cektip

insert into cektip (kod,ad) values ('CIR','CİRO');
insert into cektip (kod,ad) values ('POR','PORTFÖYDE');
insert into cektip (kod,ad) values ('TAK','TAKASTA');
insert into cektip (kod,ad) values ('TGR','TAKASTAN GERİ AL');
insert into cektip (kod,ad) values ('CGR','CİRODAN GERİ AL');
insert into cektip (kod,ad) values ('PID','PORTFÖYDEN İADE');
insert into cektip (kod,ad) values ('PKR','PORTFÖYDEN KARŞILIKSIZ');
insert into cektip (kod,ad) values ('TKR','TAKASTAN KARŞILIKSIZ');
insert into cektip (kod,ad) values ('CKR','CİRODAN KARŞILIKSIZ');
insert into cektip (kod,ad) values ('KGR','KARŞILIKSIZDAN GERİ AL');
insert into cektip (kod,ad) values ('ELT','ELDEN TAHSİL');
insert into cektip (kod,ad) values ('TKT','TAKASTAN TAHSİL');
insert into cektip (kod,ad) values ('KSN','KESİLEN');
insert into cektip (kod,ad) values ('ODE','KESİLEN ÇEK ÖDEME');
insert into cektip (kod,ad) values ('OTI','ÖDEME / TAHSİL İPTAL');

END

================================================================================
