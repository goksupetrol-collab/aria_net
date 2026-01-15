-- Function: dbo.UDF_SAYACPDA_HRK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.767486
================================================================================

CREATE FUNCTION [dbo].UDF_SAYACPDA_HRK (@TARIH1 DATETIME, @TARIH2 DATETIME, @SAAT1 VARCHAR(8), @SAAT2 VARCHAR(8))
RETURNS
  @TB_SAYAC_PDA TABLE (
    SIRA_NO        INT,
    SAYAC_KOD   VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_KOD    VARCHAR(20)  COLLATE Turkish_CI_AS,
    LITRE       FLOAT,
    TUTAR       FLOAT)
AS
BEGIN
  DECLARE @SAYAC_PDA_TEMP TABLE (
    SIRA_NO        INT,
    SAYAC_KOD   VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_KOD    VARCHAR(20)  COLLATE Turkish_CI_AS,
    LITRE       FLOAT,
    TUTAR       FLOAT)
    
  DECLARE @HRK_SIRANO      INT
  DECLARE @HRK_SAYAC_KOD   VARCHAR(20)
  DECLARE @HRK_STOK_KOD    VARCHAR(20)
  DECLARE @HRK_LITRE       FLOAT
  DECLARE @HRK_TUTAR       FLOAT

 /*---------------------------------------------------------------------------- */
 SET @HRK_SIRANO=0
 SET @HRK_LITRE=0
 SET @HRK_TUTAR=0

 DECLARE PDA_SAYAC_CUR CURSOR FAST_FORWARD FOR
  SELECT k.kod,t.bagak from sayackart as k inner join tankkart as t on t.kod=k.tankod
   where t.sil=0 and k.sil=0 and k.drm='Aktif' order by k.kod
   OPEN PDA_SAYAC_CUR
   FETCH NEXT FROM PDA_SAYAC_CUR INTO @HRK_SAYAC_KOD,@HRK_STOK_KOD

    WHILE @@FETCH_STATUS = 0
      BEGIN
      SET @HRK_SIRANO = @HRK_SIRANO + 1

      INSERT @SAYAC_PDA_TEMP
      SELECT  @HRK_SIRANO,@HRK_SAYAC_KOD,@HRK_STOK_KOD,
      @HRK_LITRE,@HRK_TUTAR

    FETCH NEXT FROM PDA_SAYAC_CUR INTO @HRK_SAYAC_KOD,@HRK_STOK_KOD
  END

  CLOSE PDA_SAYAC_CUR
  DEALLOCATE PDA_SAYAC_CUR


  INSERT @TB_SAYAC_PDA
    SELECT SIRA_NO,SAYAC_KOD,STOK_KOD,LITRE,TUTAR
     FROM @SAYAC_PDA_TEMP

  RETURN

END

================================================================================
