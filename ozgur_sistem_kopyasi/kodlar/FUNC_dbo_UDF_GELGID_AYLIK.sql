-- Function: dbo.UDF_GELGID_AYLIK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.716580
================================================================================

CREATE FUNCTION [dbo].UDF_GELGID_AYLIK (@CARI_TIP VARCHAR(20),
@CARI_KOD VARCHAR(20),
@TARIH1 DATETIME, @TARIH2 DATETIME)
RETURNS
  @TB_CARI_EKSTRE TABLE (
    CARI_TIP    VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(20)   COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(50)  COLLATE Turkish_CI_AS,
    AY           INT,
    AYISIM       VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARIBORC         FLOAT,
    CARIALACAK        FLOAT,
    CARIBAKIYE        FLOAT,
    BAKIYE     FLOAT )
AS
BEGIN
  DECLARE @EKSTRE_TEMP TABLE (
    CARI_TIP    VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(50)  COLLATE Turkish_CI_AS,
     AY           INT,
     AYISIM       VARCHAR(20)  COLLATE Turkish_CI_AS,
     CARIBORC         FLOAT,
     CARIALACAK        FLOAT,
     CARIBAKIYE        FLOAT,
     BAKIYE     FLOAT )

  DECLARE @HRK_CARI_TIP    VARCHAR(20)
  DECLARE @HRK_CARI_CARTIP VARCHAR(20)
  DECLARE @HRK_CARI_KOD    VARCHAR(20)
  DECLARE @HRK_CARI_UNVAN  VARCHAR(50)
  DECLARE @HRK_AY           INT
  DECLARE @HRK_AYISIM       VARCHAR(20)
  DECLARE @HRK_BORC          FLOAT
  DECLARE @HRK_ALACAK        FLOAT
  DECLARE @HRK_CARIBAKIYE        FLOAT
  DECLARE @HRK_GENELTOP      FLOAT
  
      DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
      SELECT
      vc.tip,carkod,(vc.ad),MONTH(h.tarih),
      isnull(sum(h.borc),0),
      isnull(sum(h.alacak),0)
      FROM carihrk as h inner join Genel_Kart as vc
      on vc.cartp=h.cartip and vc.kod=h.carkod and h.cartip=@CARI_TIP
      where  h.sil=0 AND tarih >= @TARIH1 and tarih <= @TARIH2
      group by h.cartip,vc.tip,h.carkod,vc.ad,MONTH(h.tarih)
      order by MONTH(h.tarih)

  OPEN CRS_HRK

  FETCH NEXT FROM CRS_HRK INTO
   @HRK_CARI_CARTIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_AY,@HRK_BORC,@HRK_ALACAK

  WHILE @@FETCH_STATUS = 0
  BEGIN

    SET @HRK_GENELTOP=@HRK_BORC-@HRK_ALACAK
    SET @HRK_CARIBAKIYE=@HRK_BORC-@HRK_ALACAK;
    
    
    
    
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
       @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_AY,@HRK_AYISIM,@HRK_BORC,@HRK_ALACAK,
       @HRK_CARIBAKIYE,@HRK_GENELTOP
       
    FETCH NEXT FROM CRS_HRK INTO
    @HRK_CARI_CARTIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_AY,@HRK_BORC,@HRK_ALACAK
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK

  /*---------------------------------------------------------------------------- */

  INSERT @TB_CARI_EKSTRE
    SELECT * FROM @EKSTRE_TEMP ORDER BY AY

  RETURN

END

================================================================================
