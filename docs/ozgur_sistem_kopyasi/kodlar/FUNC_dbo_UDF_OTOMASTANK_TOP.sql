-- Function: dbo.UDF_OTOMASTANK_TOP
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.758164
================================================================================

CREATE FUNCTION [dbo].UDF_OTOMASTANK_TOP (@TARIH DATETIME)
RETURNS
  @TB_TANK_EKSTRE TABLE (
    TANK_KOD    VARCHAR(20)  COLLATE Turkish_CI_AS,
    TANK_AD     VARCHAR(50)  COLLATE Turkish_CI_AS,
    KAPASITE    FLOAT,
    MEVCUT      FLOAT,
    YUZDE       INT)
AS
BEGIN
  DECLARE @TANK_TEMP TABLE (
    TANK_KOD    VARCHAR(20)  COLLATE Turkish_CI_AS,
    TANK_AD     VARCHAR(50)  COLLATE Turkish_CI_AS,
    KAPASITE    FLOAT,
    MEVCUT      FLOAT,
    YUZDE       INT)

  DECLARE @HRK_TANK_KOD    VARCHAR(20)
  DECLARE @HRK_TANK_AD     VARCHAR(50)
  DECLARE @HRK_KAPASITE    FLOAT
  DECLARE @HRK_MEVCUT      FLOAT
  DECLARE @HRK_YUZDE       FLOAT

  DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    SELECT k.kod,k.ad,k.kapsit,k.alsmik-k.satmik FROM tankkart as k where k.sil=0
    OPEN CRS_HRK

   FETCH NEXT FROM CRS_HRK INTO
   @HRK_TANK_KOD,@HRK_TANK_AD,@HRK_KAPASITE,@HRK_MEVCUT
   WHILE @@FETCH_STATUS = 0
    BEGIN

    SET @HRK_MEVCUT=@HRK_MEVCUT+isnull((select sum(litre) from otomasxml as x
    inner JOIN sayackart as s on x.Sayac_Kod=s.kod and s.tankod=@HRK_TANK_KOD),0)

    SET @HRK_YUZDE=0
    IF @HRK_KAPASITE>0 AND @HRK_MEVCUT>0
    SET @HRK_YUZDE=(@HRK_MEVCUT*100)/@HRK_KAPASITE

    INSERT @TANK_TEMP
      SELECT
       @HRK_TANK_KOD,@HRK_TANK_AD,@HRK_KAPASITE,@HRK_MEVCUT,@HRK_YUZDE

    FETCH NEXT FROM CRS_HRK INTO
     @HRK_TANK_KOD,@HRK_TANK_AD,@HRK_KAPASITE,@HRK_MEVCUT
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK

  /*---------------------------------------------------------------------------- */

  INSERT @TB_TANK_EKSTRE
    SELECT TANK_KOD,TANK_AD,KAPASITE,MEVCUT,YUZDE FROM @TANK_TEMP


  RETURN

END

================================================================================
