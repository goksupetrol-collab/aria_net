-- Function: dbo.UDF_CEK_DRM_HRK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.708557
================================================================================

CREATE FUNCTION [dbo].[UDF_CEK_DRM_HRK] (
@CEKIDIN VARCHAR(8000))
RETURNS
  @TB_CEK_HRK TABLE (
    CEKID       FLOAT,
    CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    TARIH		DATETIME,
    DURUM       VARCHAR(30) COLLATE Turkish_CI_AS)
    AS
BEGIN
 

   INSERT @TB_CEK_HRK (CEKID,CARI_TIP,CARI_KOD,CARI_UNVAN,TARIH,DURUM)
    select h.cekid,car.tip,car.KOD,car.ad,H.tarih,h.DRMAD
    from cekhrk as h left join Genel_Kart as car on 
    (h.carkod=car.kod and h.cartip=car.cartp)
     where h.cekid in (select * from CsvToInt(@CEKIDIN))
    order by h.cekid 

  RETURN

END

================================================================================
