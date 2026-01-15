-- Function: dbo.UDF_VER_TARIHLI_PLAKA_SON_KM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.799532
================================================================================

CREATE FUNCTION [dbo].UDF_VER_TARIHLI_PLAKA_SON_KM (
@CARTIP		  VARCHAR(30),
@CARKOD		  VARCHAR(50),
@PLAKA		  VARCHAR(50),	
@TARIH        DATETIME)
RETURNS
   @TB_VER_PLAKA_KM TABLE (
    CARTIP               VARCHAR(30) COLLATE Turkish_CI_AS,
    CARKOD               VARCHAR(50) COLLATE Turkish_CI_AS,
    PLAKA                VARCHAR(50) COLLATE Turkish_CI_AS,
    KM 				     FLOAT)
AS
BEGIN

   INSERT INTO @TB_VER_PLAKA_KM
   (CARTIP,CARKOD,PLAKA,KM)
   SELECT cartip,carkod,plaka,MAX(km) from 
   veresimas as m where sil=0 and 
   cartip=@CARTIP and carkod=@CARKOD
   and plaka=@PLAKA 
   and tarih+cast(SAAT as datetime)<@TARIH
   GROUP BY cartip,carkod,plaka


  return


END

================================================================================
