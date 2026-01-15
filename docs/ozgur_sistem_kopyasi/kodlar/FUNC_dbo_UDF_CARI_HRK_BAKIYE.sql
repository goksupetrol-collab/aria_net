-- Function: dbo.UDF_CARI_HRK_BAKIYE
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.695245
================================================================================

CREATE FUNCTION [dbo].UDF_CARI_HRK_BAKIYE (
@Firmano  		int,
@CARI_TIP 		VARCHAR(20),
@CARI_KODIN 	VARCHAR(8000),
@TARIH1 		DATETIME, 
@TARIH2 		DATETIME)
RETURNS
  @TB_CARIHRK_BAK_EKSTRE TABLE (
    CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)  COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(30)  COLLATE Turkish_CI_AS,
    PLAKA       VARCHAR(20)  COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(100) COLLATE Turkish_CI_AS,
    ISLTIPAD    VARCHAR(30)  COLLATE Turkish_CI_AS,
    ISLHRKAD    VARCHAR(30)  COLLATE Turkish_CI_AS,
    YERAD       VARCHAR(30)  COLLATE Turkish_CI_AS,
    KULAD       VARCHAR(50)  COLLATE Turkish_CI_AS,
    ISLTIP      VARCHAR(10)  COLLATE Turkish_CI_AS,
    ISLHRK      VARCHAR(10)  COLLATE Turkish_CI_AS,
    VADETAR     DATETIME,
    VARNO       FLOAT,
    HRKID       FLOAT,
    MASID       FLOAT,
    BORC        DECIMAL(18,8),
    ALACAK      DECIMAL(18,8),
    BAKIYE      DECIMAL(18,8))
AS
BEGIN

DECLARE @EKSTRE_CARITEMP TABLE (
 carkod     varchar(30))

declare @separator char(1)
 set @separator = ','

 declare @separator_position int
 declare @array_value varchar(1000)

 IF (LEN(RTRIM(@CARI_KODIN)) > 0)
 BEGIN
  set @CARI_KODIN = @CARI_KODIN + ','
 END

 while patindex('%,%' , @CARI_KODIN) <> 0
 begin

   select @separator_position =  patindex('%,%' , @CARI_KODIN)
   select @array_value = left(@CARI_KODIN, @separator_position - 1)

  Insert @EKSTRE_CARITEMP
  Values (@array_value)

   select @CARI_KODIN = stuff(@CARI_KODIN, 1, @separator_position, '')
 end


  DECLARE @EKSTRE_TEMP TABLE (
    CARI_TIP    VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD VARCHAR(20)     COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(50)   COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)    COLLATE Turkish_CI_AS,
    BELGENO    VARCHAR(30)    COLLATE Turkish_CI_AS,
    PLAKA       VARCHAR(20)   COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(100)  COLLATE Turkish_CI_AS,
    ISLTIPAD    VARCHAR(30)   COLLATE Turkish_CI_AS,
    ISLHRKAD    VARCHAR(30)   COLLATE Turkish_CI_AS,
    YERAD       VARCHAR(30)   COLLATE Turkish_CI_AS,
    KULAD       VARCHAR(50)   COLLATE Turkish_CI_AS,
    ISLTIP      VARCHAR(10)   COLLATE Turkish_CI_AS,
    ISLHRK      VARCHAR(10)   COLLATE Turkish_CI_AS,
    VADETAR     DATETIME,
    VARNO       FLOAT,
    HRKID       FLOAT,
    MASID       FLOAT,
    BORC        DECIMAL(18,8),
    ALACAK      DECIMAL(18,8),
    BAKIYE      DECIMAL(18,8))

  DECLARE @HRK_CARI_TIP    VARCHAR(20)
  DECLARE @HRK_CARI_KOD    VARCHAR(20)
  DECLARE @HRK_CARI_UNVAN  VARCHAR(50)
  DECLARE @HRK_TARIH       DATETIME
  DECLARE @HRK_SAAT        VARCHAR(8)
  DECLARE @HRK_BELGENO     VARCHAR(30)
  DECLARE @HRK_PLAKA       VARCHAR(20)
  DECLARE @HRK_ACIKLAMA    VARCHAR(100)
  DECLARE @HRK_ISLTIPAD    VARCHAR(30)
  DECLARE @HRK_ISLHRKAD    VARCHAR(30)
  DECLARE @HRK_YERAD       VARCHAR(30)
  DECLARE @HRK_KULAD       VARCHAR(50)
  DECLARE @HRK_ISLTIP      VARCHAR(10)
  DECLARE @HRK_ISLHRK      VARCHAR(10)
  DECLARE @HRK_VADETAR     DATETIME
  DECLARE @HRK_VARNO       FLOAT
  DECLARE @HRK_HRKID       FLOAT
  DECLARE @HRK_MASID       FLOAT
  DECLARE @HRK_BORC        DECIMAL(18,8)
  DECLARE @HRK_ALACAK      DECIMAL(18,8)
  DECLARE @HRK_BAKIYE      DECIMAL(18,8)
  DECLARE @KUM_BAKIYE      DECIMAL(18,8)
  
  DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    /* Cari Fişlerden gelen harektler */
    SELECT
      vc.cartp,vc.kod,vc.ad,
       tarih,saat,belno,
      '', /*PLAKA */
      ack, /* AÇIKLAMA, */
      islmtipad,islmhrkad,yerad,olususer,islmtip,islmhrk,vadetar,varno,carhrkid,masterid,
      borc,
      alacak,
      (borc-alacak) AS BAKIYE
    FROM Genel_Kart as vc
    inner join carihrk as h with (nolock) on h.cartip=vc.cartp
    and h.carkod=vc.kod and
    vc.cartp=@CARI_TIP and vc.kod in (select carkod from @EKSTRE_CARITEMP)
    and h.sil=0  AND tarih >= @TARIH1 and tarih <= @TARIH2
    ORDER BY tarih


  OPEN CRS_HRK

  FETCH NEXT FROM CRS_HRK INTO
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,@HRK_PLAKA,@HRK_ACIKLAMA,
   @HRK_ISLTIPAD,@HRK_ISLHRKAD,@HRK_YERAD,@HRK_KULAD,@HRK_ISLTIP,@HRK_ISLHRK,@HRK_VADETAR,
   @HRK_VARNO,@HRK_HRKID,@HRK_MASID,@HRK_BORC, @HRK_ALACAK, @HRK_BAKIYE

  WHILE @@FETCH_STATUS = 0
  BEGIN

    INSERT @EKSTRE_TEMP
      SELECT
       @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,@HRK_PLAKA,@HRK_ACIKLAMA,
       @HRK_ISLTIPAD,@HRK_ISLHRKAD,@HRK_YERAD,@HRK_KULAD,@HRK_ISLTIP,@HRK_ISLHRK,@HRK_VADETAR,
       @HRK_VARNO,@HRK_HRKID,@HRK_MASID,@HRK_BORC, @HRK_ALACAK, @HRK_BAKIYE

    FETCH NEXT FROM CRS_HRK INTO
      @HRK_CARI_TIP,@HRK_CARI_KOD, @HRK_CARI_UNVAN,@HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,@HRK_PLAKA,@HRK_ACIKLAMA,
      @HRK_ISLTIPAD,@HRK_ISLHRKAD,@HRK_YERAD,@HRK_KULAD,@HRK_ISLTIP,@HRK_ISLHRK,@HRK_VADETAR,
      @HRK_VARNO,@HRK_HRKID,@HRK_MASID,@HRK_BORC, @HRK_ALACAK, @HRK_BAKIYE
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK

  /*---------------------------------------------------------------------------- */

  INSERT @TB_CARIHRK_BAK_EKSTRE
    SELECT CARI_TIP,CARI_KOD,CARI_UNVAN,TARIH,SAAT,BELGENO,PLAKA,ACIKLAMA,
    ISLTIPAD,ISLHRKAD,YERAD,KULAD,ISLTIP,ISLHRK,VADETAR,VARNO,HRKID,MASID,BORC,ALACAK,BAKIYE FROM @EKSTRE_TEMP

  RETURN

END

================================================================================
