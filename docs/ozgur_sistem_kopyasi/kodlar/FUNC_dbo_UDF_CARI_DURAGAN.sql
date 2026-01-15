-- Function: dbo.UDF_CARI_DURAGAN
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.692173
================================================================================

CREATE FUNCTION UDF_CARI_DURAGAN (@CARI_TIP VARCHAR(20),
@CARI_KOD VARCHAR(20),
@TARIH1 DATETIME, 
@TARIH2 DATETIME)
RETURNS
  @TB_CARI_EKSTRE TABLE (
    CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(50) COLLATE Turkish_CI_AS,
    SONHRKTARIH    DATETIME,
    HRKSAY       INT,
    SONFISTARIH    DATETIME,
    FISSAY       INT,
    SONBAKIYE       FLOAT)
AS
BEGIN
  DECLARE @EKSTRE_TEMP TABLE (
    CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(50) COLLATE Turkish_CI_AS,
    SONHRKTARIH    DATETIME,
    HRKSAY       INT,
    SONFISTARIH    DATETIME,
    FISSAY       INT,
    SONBAKIYE       FLOAT )

  DECLARE @HRK_CARI_TIP    VARCHAR(20)
  DECLARE @HRK_CARI_KOD    VARCHAR(20)
  DECLARE @HRK_CARI_UNVAN  VARCHAR(50)
  DECLARE @HRK_HRKSAY       INT
  DECLARE @HRK_FISSAY    INT
  DECLARE @HRK_SONHRKTARIH    DATETIME
  DECLARE @HRK_SONFISTARIH    DATETIME
  DECLARE @HRK_SONBAKIYE      FLOAT

DECLARE @hsay    INT
DECLARE @fsay    INT

   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
   SELECT
    'carikart',k.kod,k.unvan,(fisbak+carbak) FROM carikart as k where k.sil=0

  OPEN CRS_HRK

  FETCH NEXT FROM CRS_HRK INTO
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_SONBAKIYE

  WHILE @@FETCH_STATUS = 0
  BEGIN
  
  set @hsay=0
  set @fsay=0
  
  SELECT @hsay=count(carkod) FROM carihrk as h with (nolock) 
  where h.carkod=@HRK_CARI_KOD
  and h.cartip=@HRK_CARI_TIP and h.sil=0 AND
  (h.tarih+cast(h.saat as datetime)) >= @TARIH1 
  and (h.tarih+cast(h.saat as datetime)) <= @TARIH2 group by h.carkod,h.cartip
  
   if @hsay=0
   SELECT @HRK_SONHRKTARIH=MAX(h.tarih) FROM carihrk as h  with (nolock) 
   where h.carkod=@HRK_CARI_KOD
   and h.cartip=@HRK_CARI_TIP and h.sil=0 AND
   (h.tarih+cast(h.saat as datetime)) < @TARIH1 
   group by h.carkod,h.cartip


     SELECT @fsay=count(carkod) FROM veresimas as h with (nolock)  
     where h.carkod=@HRK_CARI_KOD
     and h.cartip=@HRK_CARI_TIP and h.sil=0 AND
     (h.tarih+cast(h.saat as datetime)) >= @TARIH1 
     and (h.tarih+cast(h.saat as datetime)) <= @TARIH2 
     group by h.carkod,h.cartip

      if @fsay=0
      SELECT @HRK_SONFISTARIH=MAX(h.tarih) FROM veresimas as h with (nolock) 
      where h.carkod=@HRK_CARI_KOD
      and h.cartip=@HRK_CARI_TIP and h.sil=0 AND
      (h.tarih+cast(h.saat as datetime)) < @TARIH1 group by h.carkod,h.cartip
      
      

      INSERT @EKSTRE_TEMP (CARI_TIP,CARI_KOD,CARI_UNVAN,SONHRKTARIH,HRKSAY,SONFISTARIH,FISSAY,SONBAKIYE)
      values (@HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_SONHRKTARIH,@hsay,
      @HRK_SONFISTARIH,@fsay,@HRK_SONBAKIYE)




    FETCH NEXT FROM CRS_HRK INTO
    @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_SONBAKIYE
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK

  /*---------------------------------------------------------------------------- */

  INSERT @TB_CARI_EKSTRE
    SELECT * FROM @EKSTRE_TEMP

  RETURN

END

================================================================================
