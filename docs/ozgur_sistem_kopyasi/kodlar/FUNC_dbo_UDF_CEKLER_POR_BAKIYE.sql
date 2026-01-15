-- Function: dbo.UDF_CEKLER_POR_BAKIYE
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.709416
================================================================================

CREATE FUNCTION [dbo].UDF_CEKLER_POR_BAKIYE ()
RETURNS
   @TB_CEKLER_BAKIYE TABLE (
    PORTFOY     FLOAT,
    BANKAPOR    FLOAT)
BEGIN
DECLARE @PORTFOY FLOAT
DECLARE @BANKAPOR   FLOAT

declare @firmano int
set @firmano=0

 SELECT @PORTFOY=ISNULL(sum(giren),0) from cekkart where sil=0
 and firmano=@firmano and drm='POR'
 
 SELECT @PORTFOY=ISNULL(sum(giren),0) from cekkart where sil=0
 and firmano=@firmano and drm='TAK'


  INSERT @TB_CEKLER_BAKIYE (PORTFOY,BANKAPOR)
   VALUES (@PORTFOY,@BANKAPOR)

  RETURN

 
END

================================================================================
