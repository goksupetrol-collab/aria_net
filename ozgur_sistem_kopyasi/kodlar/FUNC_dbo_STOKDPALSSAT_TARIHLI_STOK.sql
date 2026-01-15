-- Function: dbo.STOKDPALSSAT_TARIHLI_STOK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.678981
================================================================================

CREATE FUNCTION dbo.STOKDPALSSAT_TARIHLI_STOK (@depkod varchar(20),
@stktip varchar(20),@stkod varchar(20),@TARIH1 datetime,@TARIH2 datetime,
@SAAT1 VARCHAR(8), @SAAT2 VARCHAR(8) )
RETURNS
   @TB_MAL_ALIS TABLE (
    DEPO_MIKTAR     FLOAT,
    DEPO_TUTAR      FLOAT,
    ALIS_MIKTAR     FLOAT,
    ALIS_TUTAR      FLOAT,
    SATIS_MIKTAR     FLOAT,
    SATIS_TUTAR      FLOAT)
BEGIN

 DECLARE @STOK_TEMP TABLE (
    STOK_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    MIKTAR      FLOAT,
    TUTAR       FLOAT)




  DECLARE @DEPO_MIKTAR FLOAT
  DECLARE @DEPO_TUTAR FLOAT
  DECLARE @ALIS_MIKTAR FLOAT
  DECLARE @ALIS_TUTAR FLOAT
  DECLARE @SATIS_MIKTAR FLOAT
  DECLARE @SATIS_TUTAR FLOAT
  
  
  
  
  
  
  RETURN
  

  



END

================================================================================
