-- Function: dbo.DEKONT_MAHVIR
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.650486
================================================================================

CREATE FUNCTION [dbo].DEKONT_MAHVIR (@grptip varchar(10),
@islmtip varchar(10),@hrkid float)
RETURNS
  @TB_MAHVIR_DEKONT TABLE (
    B_CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    B_CARI_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    B_CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    A_CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    A_CARI_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    A_CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    TARIH         DATETIME,
    SAAT          VARCHAR(10) COLLATE Turkish_CI_AS,
    BELGENO       VARCHAR(20) COLLATE Turkish_CI_AS,
    ACK           VARCHAR(100) COLLATE Turkish_CI_AS,
    PARABIRIM     VARCHAR(20) COLLATE Turkish_CI_AS,
    PARASTR       VARCHAR(70) COLLATE Turkish_CI_AS,
    TUTAR         FLOAT)
AS
BEGIN
   DECLARE @EKSTRE_TEMP TABLE (
    B_CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    B_CARI_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    B_CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    A_CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    A_CARI_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    A_CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    TARIH         DATETIME,
    SAAT          VARCHAR(10) COLLATE Turkish_CI_AS,
    BELGENO       VARCHAR(20) COLLATE Turkish_CI_AS,
    ACK           VARCHAR(100) COLLATE Turkish_CI_AS,
    PARABIRIM     VARCHAR(20) COLLATE Turkish_CI_AS,
    PARASTR       VARCHAR(70) COLLATE Turkish_CI_AS,
    TUTAR         FLOAT)

      DECLARE @HRK_CARI_TIP     VARCHAR(20)
      DECLARE @HRK_CARI_KOD     VARCHAR(20)
      DECLARE @HRK_CARI_UNVAN   VARCHAR(150)
      DECLARE @HRK_TARIH        DATETIME
      DECLARE @HRK_SAAT         VARCHAR(10)
      DECLARE @HRK_BELGENO      VARCHAR(20)
      DECLARE @HRK_ACK          VARCHAR(100)
      DECLARE @HRK_PARABIRIM    VARCHAR(20)
      DECLARE @HRK_PARASTR      VARCHAR(70)
      DECLARE @HRK_ISLEM        VARCHAR(20)
      DECLARE @HRK_TUTAR        FLOAT
      DECLARE @say              int

/*MAHSUP */
  if (@grptip='carihrk') and  (@islmtip='MAH')
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     select car.cartp as CARI_TIP,car.kod as CARI_KOD,
     car.ad as CARI_UNVAN,
     tarih AS TARIH,saat AS SAAT,
     belno AS BELGENO,hrk.ack,abs(borc-alacak) as TUTAR,PARABRM,
     dbo.ParaOku(ABS(borc-alacak)) as PARASTR from
     carihrk hrk inner join Genel_Kart as car
     on hrk.carkod=car.kod and hrk.cartip=car.cartp where hrk.carhrkid=@hrkid
     order by hrk.id


  if (@grptip='bankahrk') and  (@islmtip='VIR')
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     select car.cartp as CARI_TIP,car.kod as CARI_KOD,
     car.ad as CARI_UNVAN,
     tarih AS TARIH,saat AS SAAT,
     belno AS BELGENO,hrk.ack,abs(borc-alacak) as TUTAR,PARABRM,
     dbo.ParaOku(ABS(borc-alacak)) as PARASTR from
     bankahrk hrk inner join Genel_Kart as car
     on hrk.bankod=car.kod and car.cartp='bankakart' where hrk.bankhrkid=@hrkid
     order by hrk.id


   if (@grptip='kasahrk') and  (@islmtip='VIR')
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     select car.cartp as CARI_TIP,car.kod as CARI_KOD,
     car.ad as CARI_UNVAN,
     tarih AS TARIH,saat AS SAAT,
     belno AS BELGENO,hrk.ack,abs(giren-cikan) as TUTAR,PARABRM,
     dbo.ParaOku(ABS(giren-cikan)) as PARASTR from
     kasahrk hrk inner join Genel_Kart as car
     on hrk.kaskod=car.kod and car.cartp='kasakart' where hrk.kashrkid=@hrkid
     order by hrk.id

   OPEN CRS_HRK
   SET @say=1
 FETCH NEXT FROM CRS_HRK INTO
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,
   @HRK_ACK,@HRK_TUTAR,@HRK_PARABIRIM,@HRK_PARASTR

  WHILE @@FETCH_STATUS = 0
  BEGIN

    if @say=1
    INSERT @EKSTRE_TEMP (B_CARI_TIP,B_CARI_KOD,B_CARI_UNVAN,
    TARIH,SAAT,BELGENO,ACK,PARABIRIM,
    PARASTR,TUTAR)
    SELECT @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_TARIH,@HRK_SAAT,
    @HRK_BELGENO,@HRK_ACK,@HRK_PARABIRIM,@HRK_PARASTR,@HRK_TUTAR
    if @say=2
    UPDATE @EKSTRE_TEMP SET A_CARI_TIP=@HRK_CARI_TIP,
    A_CARI_KOD=@HRK_CARI_KOD,A_CARI_UNVAN=@HRK_CARI_UNVAN
    
    SET @say=@say+1

    FETCH NEXT FROM CRS_HRK INTO
    @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,
   @HRK_ACK,@HRK_TUTAR,@HRK_PARABIRIM,@HRK_PARASTR
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK
  /*---------------------------------------------------------------------------- */

  INSERT @TB_MAHVIR_DEKONT
    SELECT * FROM @EKSTRE_TEMP

  RETURN
END

================================================================================
