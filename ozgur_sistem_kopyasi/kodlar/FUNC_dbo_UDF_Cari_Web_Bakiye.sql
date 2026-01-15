-- Function: dbo.UDF_Cari_Web_Bakiye
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.705412
================================================================================

CREATE FUNCTION [dbo].UDF_Cari_Web_Bakiye (
@id int)
RETURNS
  @TB_CAR_WEB_GENEL TABLE
  (id           int,
  carkod        VARCHAR (30),
  ad            VARCHAR (100),
  soyad         VARCHAR (100),
  fis_bakiye    float,
  car_bakiye   float,
  top_bakiye    float
  )
AS
BEGIN

  insert into @TB_CAR_WEB_GENEL
  (id,carkod,ad,soyad,fis_bakiye,car_bakiye,top_bakiye)
  select
  id,kod,ad,soyad,fis_bakiye,car_bakiye,top_bakiye
  from Cari_Kart_Listesi where id=@id
  
  return


  
END

================================================================================
