-- Function: dbo.UDF_CARI_LIMITPLAKA
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.696815
================================================================================

CREATE FUNCTION UDF_CARI_LIMITPLAKA (@CARI_TIP VARCHAR(20),
@PLAKA VARCHAR(20),
@TARIH1 DATETIME, @TARIH2 DATETIME)
RETURNS
  @TB_CARI_EKSTRE TABLE (
    CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    CARI_PLAKA  VARCHAR(50) COLLATE Turkish_CI_AS,
    LIMTIP      VARCHAR(50) COLLATE Turkish_CI_AS,
    STOK_KOD      VARCHAR(50) COLLATE Turkish_CI_AS,
    PLAKALIMIT        FLOAT,
    GENELBAKIYE       FLOAT,
    FARK              FLOAT )
AS
BEGIN
  DECLARE @EKSTRE_TEMP TABLE (
    CARI_TIP    VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(50)  COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150)  COLLATE Turkish_CI_AS,
    CARI_PLAKA  VARCHAR(50)  COLLATE Turkish_CI_AS,
    LIMITTIP  VARCHAR(20)    COLLATE Turkish_CI_AS,
    STOK_KOD      VARCHAR(50) COLLATE Turkish_CI_AS,
    PLAKALIMIT        FLOAT,
    GENELBAKIYE       FLOAT,
    FARK              FLOAT  )

  DECLARE @HRK_CARI_TIP    VARCHAR(20)
  DECLARE @HRK_CARI_KOD    VARCHAR(50)
  DECLARE @HRK_CARI_UNVAN  VARCHAR(150)
  DECLARE @HRK_PLAKA       VARCHAR(50)
  DECLARE @HRK_LIMTIP      VARCHAR(20)
  DECLARE @HRK_STOKKOD     VARCHAR(50)
  DECLARE @HRK_GENELBAKIYE     FLOAT
  DECLARE @HRK_LIMIT           FLOAT
  DECLARE @HRK_FARK            FLOAT

  DECLARE @HRK_CARIBAKIYE      FLOAT
  DECLARE @HRK_FISBAKIYETUT    FLOAT
  DECLARE @HRK_FISLITRE        FLOAT


   IF @PLAKA=''
   BEGIN
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     SELECT
      'Cari Kartlar',k.kod,k.unvan,oto.plaka,oto.limit,oto.limitturu,oto.stkod
       FROM carikart as k with (nolock) inner join otomasgenkod as oto with (nolock)
       on oto.kod=k.kod and oto.cartip='carikart'
       where  k.sil=0
    END
    
    IF @PLAKA<>''
   BEGIN
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     SELECT
      'Cari Kartlar',k.kod,k.unvan,oto.plaka,oto.limit,oto.limitturu,oto.stkod
       FROM carikart as k with (nolock) inner join otomasgenkod as oto with (nolock)
       on oto.kod=k.kod and oto.cartip='carikart'
       where  k.sil=0 and oto.plaka=@PLAKA
    END
    
       
       

    OPEN CRS_HRK

  FETCH NEXT FROM CRS_HRK INTO
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_PLAKA,@HRK_LIMIT,@HRK_LIMTIP,@HRK_STOKKOD

  WHILE @@FETCH_STATUS = 0
  BEGIN

      if @HRK_LIMTIP='Tutar'
      set @HRK_FISBAKIYETUT=(select isnull(sum(case WHEN fistip='BOR' THEN toptut ELSE -1*toptut END),0)
      from veresimas as vrs with (nolock)
      where vrs.plaka=@HRK_PLAKA and vrs.sil=0 and vrs.cartip='carikart'
      and vrs.carkod=@HRK_CARI_KOD and vrs.aktip='BK'
      AND (vrs.tarih+cast(vrs.saat as datetime)) >= @TARIH1 
      and (vrs.tarih+cast(vrs.saat as datetime)) <= @TARIH2 )
      
      if @HRK_LIMTIP='Litre'
      set @HRK_FISLITRE=(select isnull(sum(case WHEN vrs.fistip='BOR' THEN vhr.mik ELSE -1*vhr.mik END ),0) from
      veresimas as vrs inner join veresihrk as vhr on vrs.verid=vhr.verid and vrs.sil=0 and vhr.sil=0
      and vrs.plaka=@HRK_PLAKA
      where vrs.cartip='carikart' and vrs.carkod=@HRK_CARI_KOD
      and vrs.aktip='BK' 
      AND (vrs.tarih+cast(vrs.saat as datetime)) >= @TARIH1 
      and (vrs.tarih+cast(vrs.saat as datetime)) <= @TARIH2 )
      
      

      

     if @HRK_LIMTIP='Tutar'
     SET @HRK_GENELBAKIYE=@HRK_FISBAKIYETUT

     if @HRK_LIMTIP='Litre'
     SET @HRK_GENELBAKIYE=@HRK_FISLITRE
     
     if @HRK_GENELBAKIYE is null
     set @HRK_GENELBAKIYE=0
     
     if @HRK_FARK is null
     set @HRK_FARK=0
     
     
     SET @HRK_FARK=@HRK_LIMIT-@HRK_GENELBAKIYE


     INSERT @EKSTRE_TEMP (CARI_TIP,CARI_KOD,CARI_UNVAN,CARI_PLAKA,PLAKALIMIT,
     LIMITTIP,STOK_KOD,GENELBAKIYE,FARK) VALUES
     (@HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_PLAKA,@HRK_LIMIT,
     @HRK_LIMTIP,@HRK_STOKKOD,@HRK_GENELBAKIYE,@HRK_FARK)

       
    FETCH NEXT FROM CRS_HRK INTO
       @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_PLAKA,@HRK_LIMIT,@HRK_LIMTIP,@HRK_STOKKOD
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK

  /*---------------------------------------------------------------------------- */

  INSERT @TB_CARI_EKSTRE
    SELECT * FROM @EKSTRE_TEMP

  RETURN

END

================================================================================
