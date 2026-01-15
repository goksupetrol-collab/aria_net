-- Function: dbo.UDF_CARIWEBFIS_HRK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.702463
================================================================================

CREATE FUNCTION [dbo].UDF_CARIWEBFIS_HRK (
@FISTIP INT,
@CARI_TIP VARCHAR(20),
@CARI_KOD VARCHAR(20),
@TARIH1 DATETIME,@TARIH2 DATETIME)
RETURNS
  @TB_STOKFIS_EKSTRE TABLE (
    STOK_KOD    VARCHAR(20)   COLLATE Turkish_CI_AS,
    STOK_AD     VARCHAR(50)   COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)    COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(30)   COLLATE Turkish_CI_AS,
    YKNO        VARCHAR(30)   COLLATE Turkish_CI_AS,
    PLAKA       VARCHAR(30)   COLLATE Turkish_CI_AS,
    SURUCU      VARCHAR(50)   COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(100)  COLLATE Turkish_CI_AS,
    FISAD       VARCHAR(30)   COLLATE Turkish_CI_AS,
    BRMFIY      FLOAT,
    BIRIM       VARCHAR(10)   COLLATE Turkish_CI_AS,
    TUTAR       FLOAT)
AS
BEGIN
  DECLARE @EKSTRE_TEMP TABLE (
    STOK_KOD    VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_AD     VARCHAR(50)  COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)   COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(30)  COLLATE Turkish_CI_AS,
    YKNO        VARCHAR(30)  COLLATE Turkish_CI_AS,
    PLAKA       VARCHAR(20)  COLLATE Turkish_CI_AS,
    SURUCU      VARCHAR(50)   COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(100) COLLATE Turkish_CI_AS,
    FISAD       VARCHAR(30)  COLLATE Turkish_CI_AS,
    BRMFIY      FLOAT,
    BIRIM       VARCHAR(10)  COLLATE Turkish_CI_AS,
    TUTAR       FLOAT)

  DECLARE @HRK_STOK_KOD    VARCHAR(20)
  DECLARE @HRK_STOK_AD     VARCHAR(50)
  DECLARE @HRK_TARIH       DATETIME
  DECLARE @HRK_SAAT        VARCHAR(8)
  DECLARE @HRK_BELGENO     VARCHAR(30)
  DECLARE @HRK_YKNO        VARCHAR(30)
  DECLARE @HRK_PLAKA       VARCHAR(20)
  DECLARE @HRK_SURUCU      VARCHAR(50)
  DECLARE @HRK_ACIKLAMA    VARCHAR(100)
  DECLARE @HRK_FISAD       VARCHAR(30)
  DECLARE @HRK_BRMFIY      FLOAT
  DECLARE @HRK_BIRIM       VARCHAR(10)
  DECLARE @HRK_MIKTAR      FLOAT
  DECLARE @HRK_TUTAR       FLOAT
  DECLARE @FISTIPIN        VARCHAR(20)


  IF @FISTIP=1 
  SET @FISTIPIN='BK,BL,HV'
  IF @FISTIP=0 
  SET @FISTIPIN='FT,CH'


  DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    /* Cari Fişlerden gelen harektler */
    SELECT
       stkod,k.ad,tarih,saat,
       seri+cast([no] as varchar),
       m.ykno,m.plaka,m.surucu,
       ack, /* AÇIKLAMA, */
       fisad,brmfiy,h.brim,
       CASE WHEN fistip='FISVERSAT' THEN mik else  -1*mik end 
       FROM veresihrk as h inner join veresimas as m on h.verid=m.verid
       and m.sil=0 and h.sil=0
       inner join stokkart as k on k.kod=h.stkod
       and k.tip=h.stktip
       WHERE cartip=@CARI_TIP
       and carkod=@CARI_KOD and m.aktip in (SELECT * FROM CsvToSTR(@FISTIPIN))
       AND tarih >= @TARIH1  AND tarih <= @TARIH2
      ORDER BY tarih


   OPEN CRS_HRK

  FETCH NEXT FROM CRS_HRK INTO
   @HRK_STOK_KOD,@HRK_STOK_AD,@HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,@HRK_YKNO,
   @HRK_PLAKA,@HRK_SURUCU,@HRK_ACIKLAMA,
   @HRK_FISAD,@HRK_BRMFIY,@HRK_BIRIM,@HRK_MIKTAR

  WHILE @@FETCH_STATUS = 0
  BEGIN

    SET @HRK_TUTAR=(@HRK_BRMFIY*@HRK_MIKTAR)
    

    INSERT @EKSTRE_TEMP
      SELECT
       @HRK_STOK_KOD,@HRK_STOK_AD,@HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,@HRK_YKNO,
       @HRK_PLAKA,@HRK_SURUCU,@HRK_ACIKLAMA,
       @HRK_FISAD,@HRK_BRMFIY,@HRK_BIRIM,@HRK_TUTAR

    FETCH NEXT FROM CRS_HRK INTO
      @HRK_STOK_KOD,@HRK_STOK_AD,@HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,@HRK_YKNO,
      @HRK_PLAKA,@HRK_SURUCU,@HRK_ACIKLAMA,
      @HRK_FISAD,@HRK_BRMFIY,@HRK_BIRIM,@HRK_MIKTAR
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK

  /*---------------------------------------------------------------------------- */

  INSERT @TB_STOKFIS_EKSTRE
    SELECT STOK_KOD,STOK_AD,TARIH,SAAT,BELGENO,YKNO,PLAKA,SURUCU,ACIKLAMA,
    FISAD,BRMFIY,BIRIM,TUTAR FROM @EKSTRE_TEMP

  RETURN

END

================================================================================
