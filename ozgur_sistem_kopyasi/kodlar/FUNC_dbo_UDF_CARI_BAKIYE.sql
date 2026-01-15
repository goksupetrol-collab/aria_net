-- Function: dbo.UDF_CARI_BAKIYE
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.691506
================================================================================

CREATE FUNCTION UDF_CARI_BAKIYE (
@FIRMANO		int,
@CARI_TIP VARCHAR(20),
@CARI_KODIN VARCHAR(8000),
@TARIH1 DATETIME, 
@TARIH2 DATETIME)
RETURNS
  @TB_CARI_EKSTRE TABLE (
    FIRMANO     INT,
    CARI_TIP    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(200) COLLATE Turkish_CI_AS,
    CARI_FATUNVAN  VARCHAR(200) COLLATE Turkish_CI_AS,
    TEL			 VARCHAR(100) COLLATE Turkish_CI_AS,
    FAX			 VARCHAR(100) COLLATE Turkish_CI_AS,
    CEP			 VARCHAR(100) COLLATE Turkish_CI_AS,
    EPOSTA  	 VARCHAR(100) COLLATE Turkish_CI_AS,
    MUH_ON_KOD  VARCHAR(30) COLLATE Turkish_CI_AS,
    MUH_RES_KOD  VARCHAR(30) COLLATE Turkish_CI_AS,
    CARIHESAP       FLOAT,
    CARIFIS         FLOAT,
    CEKSENET        FLOAT,
    BORCBAKIYE		FLOAT,
    ALACAKBAKIYE	FLOAT,	
    GENELTOPLAM     FLOAT,
    CEKHARICIBAKIYE FLOAT )
AS
BEGIN

DECLARE @EKSTRE_CARITEMP TABLE (
 carkod     varchar(30) COLLATE Turkish_CI_AS )

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
    FIRMANO     INT,
    CARI_TIP    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    CARI_FATUNVAN  VARCHAR(200) COLLATE Turkish_CI_AS,
    TEL			 VARCHAR(100) COLLATE Turkish_CI_AS,
    FAX			 VARCHAR(100) COLLATE Turkish_CI_AS,
    CEP			 VARCHAR(100) COLLATE Turkish_CI_AS,
    EPOSTA  	 VARCHAR(100) COLLATE Turkish_CI_AS,
    MUH_ON_KOD  VARCHAR(30) COLLATE Turkish_CI_AS,
    MUH_RES_KOD  VARCHAR(30) COLLATE Turkish_CI_AS,
    CARIHESAP       FLOAT,
    CARIFIS         FLOAT,
    CEKSENET        FLOAT,
    BORCBAKIYE		FLOAT,
    ALACAKBAKIYE	FLOAT,	    
    GENELTOPLAM     FLOAT,
    CEKHARICIBAKIYE FLOAT)

  DECLARE @HRK_CARI_TIP    VARCHAR(30)
  DECLARE @HRK_CARI_KOD    VARCHAR(30)
  DECLARE @HRK_MUH_ON_KOD  VARCHAR(30)
  DECLARE @HRK_MUH_RES_KOD  VARCHAR(30)
  DECLARE @HRK_CARI_UNVAN  VARCHAR(200)
  DECLARE @HRK_CARI_FATUNVAN  VARCHAR(200)
  DECLARE @HRK_CARI_TEL  VARCHAR(100)
  DECLARE @HRK_CARI_FAX  VARCHAR(100)
  DECLARE @HRK_CARI_CEP  VARCHAR(100)
  DECLARE @HRK_CARI_EPOSTA  VARCHAR(100)
  DECLARE @HRK_CARIHESAP       FLOAT
  DECLARE @HRK_CARIFIS         FLOAT
  DECLARE @HRK_CEKSENET        FLOAT
  DECLARE @HRK_BORCBAKIYE      FLOAT
  DECLARE @HRK_ALACAKBAKIYE    FLOAT
  DECLARE @HRK_GENELTOP        FLOAT
  DECLARE @HRK_CEKHARICIBAKIYE  FLOAT

  DECLARE @HRK_VADETUTAR   FLOAT

   /*S.tarih+cast(saat as datetime)) */

 IF @FIRMANO=0  
  DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     SELECT 
      @CARI_TIP,vc.kod,(vc.ad),vc.fatunvan,
      vc.tel,vc.fax,vc.cep,vc.mail,
      vc.muhonkod,VC.muhkod,
      (select isnull(sum(h.borc-h.alacak),0) from carihrk as h with (nolock) where
      (h.tarih+cast(h.saat as datetime)) >= @TARIH1 
      and (h.tarih+cast(h.saat as datetime)) <= @TARIH2 and h.sil=0 and 
      h.cartip=@CARI_TIP
      and h.carkod=vc.kod and h.islmtip!='VAD' and h.islmhrk !='OFV'),
      (select isnull(sum( case
       when fistip='FISVERSAT' THEN (toptut-isnull(isktop,0))
       when fistip='FISALCSAT' THEN -1*(toptut-isnull(isktop,0))
       else 0  end),0) from veresimas as vrs with (nolock) where
      (vrs.tarih+cast(vrs.saat as datetime)) >= @TARIH1 
      and (vrs.tarih+cast(vrs.saat as datetime)) <= @TARIH2 
      and vrs.sil=0 and vrs.cartip=@CARI_TIP and isnull(vrs.Devir,0)=0
      and vrs.carkod=vc.kod and vrs.aktip in ('BK','BL')),
      (select isnull(sum(-1*(giren-cikan)),0) from cekkart 
      as c where c.sil=0 and c.drm in ('POR','TAK','KSN')
      and (c.tarih+cast(c.saat as datetime)) >= @TARIH1 
      and (c.tarih+cast(c.saat as datetime)) <= @TARIH2 and 
      ( (c.cartip=@CARI_TIP and c.carkod=vc.kod) or 
      (c.vercartip=@CARI_TIP and c.vercarkod=vc.kod) ) ),
      
      (select isnull(sum(h.borc),0) from carihrk as h with (nolock) where
      (h.tarih+cast(h.saat as datetime)) >= @TARIH1 
      and (h.tarih+cast(h.saat as datetime)) <= @TARIH2 and h.sil=0 and h.cartip=@CARI_TIP
      and h.carkod=vc.kod and h.islmtip!='VAD' and h.islmhrk !='OFV'), /*BORC BAKIYE */
      
      (select isnull(sum(h.alacak),0) from carihrk as h with (nolock) where
      (h.tarih+cast(h.saat as datetime)) >= @TARIH1 
      and (h.tarih+cast(h.saat as datetime)) <= @TARIH2 and h.sil=0 and h.cartip=@CARI_TIP
      and h.carkod=vc.kod)/*ALACAK BAKIYE */
      
      FROM Genel_Kart as vc with (nolock) where  vc.cartp=@CARI_TIP and
      vc.kod in (select * from @EKSTRE_CARITEMP)

    
  IF @FIRMANO>0  
  DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     SELECT 
      @CARI_TIP,vc.kod,(vc.ad),vc.fatunvan,
      vc.tel,vc.fax,vc.cep,vc.mail,
      vc.muhonkod,VC.muhkod,
      
      (select isnull(sum(h.borc-h.alacak),0) from carihrk as h with (nolock) where
      h.firmano in (0,@FIRMANO) 
      and (h.tarih+cast(h.saat as datetime)) >= @TARIH1 
      and (h.tarih+cast(h.saat as datetime)) <= @TARIH2 and h.sil=0 and 
      h.cartip=@CARI_TIP
      and h.carkod=vc.kod and h.islmtip!='VAD' and h.islmhrk !='OFV'),
      
      (select isnull(sum( case
       when fistip='FISVERSAT' THEN (toptut-isnull(isktop,0))
       when fistip='FISALCSAT' THEN -1*(toptut-isnull(isktop,0))
       else 0  end),0) from veresimas as vrs with (nolock) where
      vrs.firmano in (0,@FIRMANO) 
      and (vrs.tarih+cast(vrs.saat as datetime)) >= @TARIH1 
      and (vrs.tarih+cast(vrs.saat as datetime)) <= @TARIH2 
      and vrs.sil=0 and vrs.cartip=@CARI_TIP and isnull(vrs.Devir,0)=0
      and vrs.carkod=vc.kod and vrs.aktip in ('BK','BL')),
      
      (select isnull(sum(-1*(giren-cikan)),0) from cekkart as c  with (nolock) 
      where c.firmano in (0,@FIRMANO) and
      c.sil=0 and c.drm in ('POR','TAK','KSN')
      and (c.tarih+cast(c.saat as datetime)) >= @TARIH1 
      and (c.tarih+cast(c.saat as datetime)) <= @TARIH2 and 
      ( (c.cartip=@CARI_TIP and c.carkod=vc.kod) or 
      (c.vercartip=@CARI_TIP and c.vercarkod=vc.kod) ) ),
      
      (select isnull(sum(h.borc),0) from carihrk as h with (nolock) where
      h.firmano in (0,@FIRMANO) 
      and (h.tarih+cast(h.saat as datetime)) >= @TARIH1 
      and (h.tarih+cast(h.saat as datetime)) <= @TARIH2 
      and h.sil=0 and h.cartip=@CARI_TIP
      and h.carkod=vc.kod and h.islmtip!='VAD' and h.islmhrk !='OFV'), /*BORC BAKIYE */
      
      (select isnull(sum(h.alacak),0) from carihrk as h with (nolock) 
      where h.firmano in (0,@FIRMANO) 
      and (h.tarih+cast(h.saat as datetime)) >= @TARIH1 
      and (h.tarih+cast(h.saat as datetime)) <= @TARIH2 and h.sil=0 and h.cartip=@CARI_TIP
      and h.carkod=vc.kod)/*ALACAK BAKIYE */
      
      FROM Genel_Kart as vc with (nolock) where  
      vc.cartp=@CARI_TIP and  vc.kod in (select * from @EKSTRE_CARITEMP)


  OPEN CRS_HRK

  FETCH NEXT FROM CRS_HRK INTO
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,
   @HRK_CARI_FATUNVAN,@HRK_CARI_TEL,@HRK_CARI_FAX,
   @HRK_CARI_CEP,@HRK_CARI_EPOSTA,
   @HRK_MUH_ON_KOD,@HRK_MUH_RES_KOD,
   @HRK_CARIHESAP,
   @HRK_CARIFIS,@HRK_CEKSENET,@HRK_BORCBAKIYE,@HRK_ALACAKBAKIYE

  WHILE @@FETCH_STATUS = 0
  BEGIN
    
    SET @HRK_VADETUTAR=0
    
    Select @HRK_VADETUTAR=v.CARI_VADETUTAR from UDF_CariFisVadeFark_Tarih (@HRK_CARI_KOD,@TARIH2) AS v
            
    set @HRK_CARIHESAP=@HRK_CARIHESAP+ISNULL(@HRK_VADETUTAR,0)
   
    set @HRK_BORCBAKIYE=@HRK_BORCBAKIYE+ISNULL(@HRK_VADETUTAR,0)
        
    SET @HRK_GENELTOP=@HRK_CARIHESAP+@HRK_CARIFIS

    SET @HRK_CEKHARICIBAKIYE=@HRK_GENELTOP-@HRK_CEKSENET



    /*IF @HRK_GENELTOP<>0 */
    INSERT @EKSTRE_TEMP SELECT @FIRMANO,
       @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,
       @HRK_CARI_FATUNVAN,@HRK_CARI_TEL,@HRK_CARI_FAX,
       @HRK_CARI_CEP,@HRK_CARI_EPOSTA,
       @HRK_MUH_ON_KOD,@HRK_MUH_RES_KOD,
       @HRK_CARIHESAP,
       @HRK_CARIFIS,@HRK_CEKSENET,@HRK_BORCBAKIYE,@HRK_ALACAKBAKIYE,
       @HRK_GENELTOP,@HRK_CEKHARICIBAKIYE
       
       
       
    FETCH NEXT FROM CRS_HRK INTO
    @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,
    @HRK_CARI_FATUNVAN,@HRK_CARI_TEL,@HRK_CARI_FAX,
    @HRK_CARI_CEP,@HRK_CARI_EPOSTA,
    @HRK_MUH_ON_KOD,@HRK_MUH_RES_KOD,
    @HRK_CARIHESAP,
    @HRK_CARIFIS,@HRK_CEKSENET,@HRK_BORCBAKIYE,@HRK_ALACAKBAKIYE
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK

  /*---------------------------------------------------------------------------- */

  INSERT @TB_CARI_EKSTRE
    SELECT * FROM @EKSTRE_TEMP 

  RETURN

END

================================================================================
