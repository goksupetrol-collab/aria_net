-- Function: dbo.UDF_PUMPOTOMAS_PER
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.762405
================================================================================

CREATE FUNCTION [dbo].UDF_PUMPOTOMAS_PER (@TARIH1 DATETIME,@TARIH2 DATETIME)
RETURNS
  @TB_PUMP_PER_EKSTRE TABLE (
    PER_KOD      VARCHAR(20)   COLLATE Turkish_CI_AS,
    PER_AD       VARCHAR(50)   COLLATE Turkish_CI_AS,
    DOLUM        INT,
    ST_1         FLOAT,
    ST_2         FLOAT,
    ST_3         FLOAT,
    ST_4         FLOAT,
    ST_5         FLOAT,
    ST_6         FLOAT,
    TUTAR        FLOAT)
AS
BEGIN
  DECLARE @EKSTRE_TEMP TABLE (
    PER_KOD      VARCHAR(20)   COLLATE Turkish_CI_AS,
    PER_AD       VARCHAR(50)   COLLATE Turkish_CI_AS,
    DOLUM        INT,
    ST_1         FLOAT,
    ST_2         FLOAT,
    ST_3         FLOAT,
    ST_4         FLOAT,
    ST_5         FLOAT,
    ST_6         FLOAT,
    TUTAR        FLOAT)
    
  DECLARE @HRK_PER_KOD     VARCHAR(20)
  DECLARE @HRK_PER_AD      VARCHAR(50)
  DECLARE @HRK_DOLUM       INT
  DECLARE @HRK_ST_1        FLOAT
  DECLARE @HRK_ST_2        FLOAT
  DECLARE @HRK_ST_3        FLOAT
  DECLARE @HRK_ST_4        FLOAT
  DECLARE @HRK_ST_5        FLOAT
  DECLARE @HRK_ST_6        FLOAT
  DECLARE @POMP_GRP1       INT
  

 select @POMP_GRP1=grp_perpomid from sistemtanim



   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    SELECT K.KOD,k.ad+' '+k.soyad  FROM perkart as k where
    k.grp1=@POMP_GRP1 and k.sil=0
    OPEN CRS_HRK

   FETCH NEXT FROM CRS_HRK INTO @HRK_PER_KOD,@HRK_PER_AD
   WHILE @@FETCH_STATUS = 0
    BEGIN

    /* FROM otomasxml as x inner join */


  /*  SET @HRK_MEVCUT=@HRK_MEVCUT+isnull((select sum(litre) from otomasxml as x */
   /* inner JOIN sayackart as s on x.Sayac_Kod=s.kod and s.tankod=@HRK_TANK_KOD),0) */

    INSERT @EKSTRE_TEMP (PER_AD)
      SELECT  @HRK_PER_AD

    FETCH NEXT FROM CRS_HRK INTO @HRK_PER_KOD,@HRK_PER_AD
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK

  /*---------------------------------------------------------------------------- */

  INSERT @TB_PUMP_PER_EKSTRE (PER_KOD,PER_AD)
    SELECT PER_KOD,PER_AD FROM @EKSTRE_TEMP

  RETURN

END

================================================================================
