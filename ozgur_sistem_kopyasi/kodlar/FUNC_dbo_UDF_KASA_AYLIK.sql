-- Function: dbo.UDF_KASA_AYLIK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.732440
================================================================================

CREATE FUNCTION [dbo].UDF_KASA_AYLIK (
@firmano			int,
@KASA_BRM           VARCHAR(20),
@KASA_KOD           VARCHAR(20),
@TARIH1             DATETIME,
@TARIH2             DATETIME)
RETURNS
  @TB_CARI_EKSTRE TABLE (
    Firmano   int,
    Firma_Ad    VARCHAR(150) COLLATE Turkish_CI_AS,
    KASA_BRM    VARCHAR(20)  COLLATE Turkish_CI_AS,
    KASA_KOD    VARCHAR(20)  COLLATE Turkish_CI_AS,
    KASA_AD     VARCHAR(50)  COLLATE Turkish_CI_AS,
    AY           INT,
    AYISIM       VARCHAR(20)  COLLATE Turkish_CI_AS,
    GIREN        FLOAT,
    CIKAN        FLOAT,
    BAKIYE      FLOAT )
AS
BEGIN
  DECLARE @EKSTRE_TEMP TABLE (
    Firmano   int,
    Firma_Ad   VARCHAR(150) COLLATE Turkish_CI_AS,
    KASA_BRM    VARCHAR(20)  COLLATE Turkish_CI_AS,
    KASA_KOD    VARCHAR(20)  COLLATE Turkish_CI_AS,
    KASA_AD     VARCHAR(50)  COLLATE Turkish_CI_AS,
    AY           INT,
    AYISIM       VARCHAR(20)  COLLATE Turkish_CI_AS,
    GIREN        FLOAT,
    CIKAN        FLOAT,
    BAKIYE      FLOAT)

  DECLARE @HRK_FIRMA_ID    INT
  DECLARE @HRK_KASA_BRM    VARCHAR(20)
  DECLARE @HRK_KASA_KOD    VARCHAR(20)
  DECLARE @HRK_KASA_AD     VARCHAR(50)
  DECLARE @HRK_AY          INT
  DECLARE @HRK_AYISIM      VARCHAR(20)
  DECLARE @HRK_GIREN          FLOAT
  DECLARE @HRK_CIKAN          FLOAT
  DECLARE @HRK_BAKIYE        FLOAT
  
  
   if @firmano=0
     DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     SELECT @firmano,k.parabrm,k.kod,k.ad,MONTH(h.tarih),
     isnull(sum(h.giren),0),
     isnull(sum(h.cikan),0)
     FROM kasahrk as h inner join kasakart as k on
     k.kod=h.kaskod and k.sil=0
     where  h.tarih >= @TARIH1 and h.tarih <= @TARIH2 and h.sil=0
     group by k.parabrm,k.kod,k.ad,MONTH(h.tarih)
     order by MONTH(h.tarih)
     
   if @firmano>0
     DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     SELECT h.firmano,k.parabrm,k.kod,k.ad,MONTH(h.tarih),
     isnull(sum(h.giren),0),
     isnull(sum(h.cikan),0)
     FROM kasahrk as h inner join kasakart as k on
     k.kod=h.kaskod and k.sil=0 
     where h.firmano=@firmano
     and h.tarih >= @TARIH1 and h.tarih <= @TARIH2 and h.sil=0
     group by h.firmano,k.parabrm,k.kod,k.ad,MONTH(h.tarih)
     order by MONTH(h.tarih)

     
     
     

  OPEN CRS_HRK

  FETCH NEXT FROM CRS_HRK INTO
   @HRK_FIRMA_ID,@HRK_KASA_BRM,@HRK_KASA_KOD,@HRK_KASA_AD,@HRK_AY,@HRK_GIREN,@HRK_CIKAN

  WHILE @@FETCH_STATUS = 0
  BEGIN

    SET @HRK_BAKIYE=@HRK_GIREN-@HRK_CIKAN

        set @HRK_AYISIM=
        (select
          CASE @HRK_AY
           WHEN 1 THEN 'OCAK'
           WHEN 2 THEN 'ŞUBAT'
           WHEN 3 THEN 'MART'
           WHEN 4 THEN 'NİSAN'
           WHEN 5 THEN 'MAYIS'
           WHEN 6 THEN 'HAZİRAN'
           WHEN 7 THEN 'TEMMUZ'
           WHEN 8 THEN 'AĞUSTOS'
           WHEN 9 THEN 'EYLÜL'
           WHEN 10 THEN 'EKİM'
           WHEN 11 THEN 'KASIM'
           WHEN 12 THEN 'ARALIK'
          END)
    

    INSERT @EKSTRE_TEMP
      SELECT
       @HRK_FIRMA_ID,'',@HRK_KASA_BRM,@HRK_KASA_KOD,@HRK_KASA_AD,@HRK_AY,@HRK_AYISIM,@HRK_GIREN,@HRK_CIKAN,
       @HRK_BAKIYE
       
    FETCH NEXT FROM CRS_HRK INTO
    @HRK_FIRMA_ID,@HRK_KASA_BRM,@HRK_KASA_KOD,@HRK_KASA_AD,@HRK_AY,@HRK_GIREN,@HRK_CIKAN
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK

  /*---------------------------------------------------------------------------- */


  update @TB_CARI_EKSTRE set firma_ad=dt.ad
  from @TB_CARI_EKSTRE as t join
  (select id,ad from Firma) dt on dt.id=t.firmano



  INSERT @TB_CARI_EKSTRE
    SELECT * FROM @EKSTRE_TEMP ORDER BY AY

  RETURN

END

================================================================================
