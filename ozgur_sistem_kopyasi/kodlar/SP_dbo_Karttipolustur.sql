-- Stored Procedure: dbo.Karttipolustur
-- Tarih: 2026-01-14 20:06:08.341254
================================================================================

CREATE PROCEDURE [dbo].Karttipolustur
AS
BEGIN
 TRUNCATE table karttip

  insert into karttip (kod,ad) values
  ('carikart','CARİ KARLAR')
  
  insert into karttip (kod,ad) values
  ('perkart','PERSONEL KARTLAR')

  insert into karttip (kod,ad) values
  ('gelgidkart','GELİR-GİDER KARTLARI')

  insert into karttip (kod,ad) values
  ('bankakart','BANKA KARTLARI')

  insert into karttip (kod,ad) values
  ('poskart','POS KARTLARI')

  insert into karttip (kod,ad) values
  ('istkart','İŞLETME K. KARTLARI')
  
  
  insert into karttip (kod,ad) values
  ('kasakart','KASA KARTLARI')
  
  
  insert into karttip (kod,ad) values
  ('perakendekart','PERAKENDE KARTLAR')
  
   insert into karttip (kod,ad) values
  ('otomaskart','OTOMASYON KARTLARI')




END

================================================================================
