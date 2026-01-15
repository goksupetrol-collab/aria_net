-- Function: dbo.DEKONT_DOVIZ
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.649987
================================================================================

CREATE FUNCTION [dbo].DEKONT_DOVIZ (@grptip varchar(10),
@islmtip varchar(10),@hrkid float)
RETURNS
  @TB_DOVIZ_DEKONT TABLE (
    ISLEM         VARCHAR(20) COLLATE Turkish_CI_AS,
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
    B_PARABIRIM   VARCHAR(20) COLLATE Turkish_CI_AS,
    B_PARASTR     VARCHAR(70) COLLATE Turkish_CI_AS,
    KUR           FLOAT,
    B_TUTAR       FLOAT,
    A_PARABIRIM   VARCHAR(20) COLLATE Turkish_CI_AS,
    A_PARASTR     VARCHAR(70) COLLATE Turkish_CI_AS,
    A_TUTAR       FLOAT)
AS
BEGIN
   DECLARE @EKSTRE_TEMP TABLE (
    ISLEM         VARCHAR(20) COLLATE Turkish_CI_AS,
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
    B_PARABIRIM   VARCHAR(20) COLLATE Turkish_CI_AS,
    B_PARASTR     VARCHAR(70) COLLATE Turkish_CI_AS,
    KUR           FLOAT,
    B_TUTAR       FLOAT,
    A_PARABIRIM   VARCHAR(20) COLLATE Turkish_CI_AS,
    A_PARASTR     VARCHAR(70) COLLATE Turkish_CI_AS,
    A_TUTAR       FLOAT)

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
      DECLARE @HRK_KUR          FLOAT
      DECLARE @KUR              FLOAT
      DECLARE @say              int

     SET @KUR=1
     
  if (@grptip='bankahrk') 
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     select car.cartp as CARI_TIP,car.kod as CARI_KOD,
     car.ad as CARI_UNVAN,
     tarih AS TARIH,saat AS SAAT,
     belno AS BELGENO,hrk.ack,hrk.kur,abs(round(borc-alacak,2)) as TUTAR,PARABRM,
     dbo.ParaOku(round(borc-alacak,2)) as PARASTR from
     bankahrk hrk inner join Genel_Kart as car
     on hrk.bankod=car.kod and car.cartp='bankakart' where hrk.bankhrkid=@hrkid
     order by hrk.id


   if (@grptip='kasahrk') 
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     select car.cartp as CARI_TIP,car.kod as CARI_KOD,
     car.ad as CARI_UNVAN,
     tarih AS TARIH,saat AS SAAT,
     belno AS BELGENO,hrk.ack,hrk.kur,abs(round(giren-cikan,2)) as TUTAR,PARABRM,
     dbo.ParaOku(ABS(round(giren-cikan,2))) as PARASTR from
     kasahrk hrk inner join Genel_Kart as car
     on hrk.kaskod=car.kod and car.cartp='kasakart' where hrk.kashrkid=@hrkid
     order by hrk.id

   OPEN CRS_HRK
   SET @say=1
   FETCH NEXT FROM CRS_HRK INTO
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,
   @HRK_ACK,@HRK_KUR,@HRK_TUTAR,@HRK_PARABIRIM,@HRK_PARASTR

  WHILE @@FETCH_STATUS = 0
  BEGIN

    SET @KUR=@KUR*@HRK_KUR
    
    if @say=1
    INSERT @EKSTRE_TEMP (B_CARI_TIP,B_CARI_KOD,B_CARI_UNVAN,
    TARIH,SAAT,BELGENO,ACK,B_PARABIRIM,B_PARASTR,B_TUTAR)
    SELECT @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_TARIH,@HRK_SAAT,
    @HRK_BELGENO,@HRK_ACK,@HRK_PARABIRIM,@HRK_PARASTR,@HRK_TUTAR
    if @say=2
    UPDATE @EKSTRE_TEMP SET A_CARI_TIP=@HRK_CARI_TIP,
    A_CARI_KOD=@HRK_CARI_KOD,A_CARI_UNVAN=@HRK_CARI_UNVAN,
    A_PARABIRIM=@HRK_PARABIRIM,A_PARASTR=@HRK_PARASTR,A_TUTAR=@HRK_TUTAR,
    KUR=@KUR
    
    
    SET @say=@say+1

    FETCH NEXT FROM CRS_HRK INTO
    @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,
   @HRK_ACK,@HRK_KUR,@HRK_TUTAR,@HRK_PARABIRIM,@HRK_PARASTR
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK
  /*---------------------------------------------------------------------------- */

  INSERT @TB_DOVIZ_DEKONT
    SELECT * FROM @EKSTRE_TEMP

  RETURN
END

================================================================================
