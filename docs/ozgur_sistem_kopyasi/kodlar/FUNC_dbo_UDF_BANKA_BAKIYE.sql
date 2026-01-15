-- Function: dbo.UDF_BANKA_BAKIYE
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.687000
================================================================================

CREATE FUNCTION UDF_BANKA_BAKIYE (@CARI_TIP VARCHAR(20),
@CARI_KODIN VARCHAR(8000),
@TARIH1 DATETIME, 
@TARIH2 DATETIME)
RETURNS
  @TB_CARI_EKSTRE TABLE (
    CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(50) COLLATE Turkish_CI_AS,
    BORC         FLOAT,
    ALACAK       FLOAT,
    GENELTOPLAM  FLOAT )
AS
BEGIN

DECLARE @EKSTRE_CARITEMP TABLE (
 carkod     varchar(30)  COLLATE Turkish_CI_AS )

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
    CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(50) COLLATE Turkish_CI_AS,
    BORC           FLOAT,
    ALACAK         FLOAT,
    GENELTOPLAM    FLOAT )

  DECLARE @HRK_CARI_TIP    VARCHAR(20)
  DECLARE @HRK_CARI_KOD    VARCHAR(20)
  DECLARE @HRK_CARI_UNVAN  VARCHAR(50)
  DECLARE @HRK_BORC         FLOAT
  DECLARE @HRK_ALACAK         FLOAT
  DECLARE @HRK_GENELTOP        FLOAT


      DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
      SELECT
      'Bank Kartları',h.bankod,(vc.ad),
      isnull(sum(h.borc),0),
      isnull(sum(h.alacak),0)
      FROM bankahrk as h with (nolock) inner join bankakart as vc with (nolock)
      on vc.kod=h.bankod
      where h.sil=0 AND (h.tarih+cast(h.saat as datetime)) >= @TARIH1 
      and (h.tarih+cast(h.saat as datetime)) <= @TARIH2
      and vc.kod in (select * from @EKSTRE_CARITEMP)
      group by h.bankod,vc.ad


  OPEN CRS_HRK

  FETCH NEXT FROM CRS_HRK INTO
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_BORC,@HRK_ALACAK

  WHILE @@FETCH_STATUS = 0
  BEGIN
    SET @HRK_GENELTOP=@HRK_BORC-@HRK_ALACAK

    INSERT @EKSTRE_TEMP
      SELECT
       @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_BORC,@HRK_ALACAK,@HRK_GENELTOP
       
    FETCH NEXT FROM CRS_HRK INTO
    @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_BORC,@HRK_ALACAK
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK

  /*---------------------------------------------------------------------------- */

  INSERT @TB_CARI_EKSTRE
    SELECT * FROM @EKSTRE_TEMP

  RETURN

END

================================================================================
