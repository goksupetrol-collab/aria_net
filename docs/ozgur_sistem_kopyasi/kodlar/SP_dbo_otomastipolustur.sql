-- Stored Procedure: dbo.otomastipolustur
-- Tarih: 2026-01-14 20:06:08.351866
================================================================================

CREATE PROCEDURE [dbo].otomastipolustur
AS
BEGIN

TRUNCATE table otomastip

 insert into otomastip (ad,onli,dosyatip)
  values ('Turpak ONL',1,'txt')
  
 insert into otomastip (ad,onli,dosyatip)
  values ('Turpak VRD',0,'txt')

 insert into otomastip (ad,onli,dosyatip)
  values ('Turpak VRD.XML',0,'zip')

 insert into otomastip (ad,onli,dosyatip)
  values ('Turpak Sale.XML',1,'xml')


 insert into otomastip (ad,onli,dosyatip)
  values ('Asis ONL',1,'txt')
  
 insert into otomastip (ad,onli,dosyatip)
  values ('Asis VRD',0,'txt')
  
 insert into otomastip (ad,onli,dosyatip)
  values ('Roseman ONL',1,'txt')
  
 insert into otomastip (ad,onli,dosyatip)
  values ('Roseman VRD',0,'txt')

 insert into otomastip (ad,onli,dosyatip)
  values ('IFS SQL',1,'sql')

 insert into otomastip (ad,onli,dosyatip)
  values ('IT Tailor ONL',1,'txt')

 insert into otomastip (ad,onli,dosyatip)
  values ('IT Tailor VRD',0,'txt')




END

================================================================================
