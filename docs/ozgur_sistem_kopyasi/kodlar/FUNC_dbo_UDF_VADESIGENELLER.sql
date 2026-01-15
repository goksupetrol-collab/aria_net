-- Function: dbo.UDF_VADESIGENELLER
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.773316
================================================================================

CREATE FUNCTION [dbo].UDF_VADESIGENELLER (
@firmano      	int,
@CEKIN 			VARCHAR(100),
@SLIP 			INT,
@SLIPBNK 		INT,
@ISTKART 		INT,
@ALSFATIN 		VARCHAR(100),
@SATFATIN 		VARCHAR(100),
@FISIN 			VARCHAR(8000),
@VADKRD			INT,
@TARIH1			DATETIME,
@TARIH2 		DATETIME)
RETURNS
  @TB_VADGEL_EKSTRE TABLE (
    FIRMANO   		INT,
    FIRMAAD  		VARCHAR(100)  COLLATE Turkish_CI_AS,
    ISLEMTURAD  	VARCHAR(50)  COLLATE Turkish_CI_AS,
    ISLEMHRKAD  	VARCHAR(50)  COLLATE Turkish_CI_AS,
    CARI_TIP    	VARCHAR(30)  COLLATE Turkish_CI_AS,
    CARI_TUR    	VARCHAR(50)  COLLATE Turkish_CI_AS,
    CARI_KOD    	VARCHAR(30)  COLLATE Turkish_CI_AS,
    CARI_UNVAN  	VARCHAR(150)  COLLATE Turkish_CI_AS,
    BELGENO     	VARCHAR(30)  COLLATE Turkish_CI_AS,
    REFNO       	VARCHAR(20)  COLLATE Turkish_CI_AS,
    ACIKLAMA    	VARCHAR(200) COLLATE Turkish_CI_AS,
    BANKAAD     	VARCHAR(150)  COLLATE Turkish_CI_AS,
    GIREN           FLOAT,
    CIKAN           FLOAT,
    VADETARIHI      DATETIME,
    ISLEMTARIHI     DATETIME,
    PARABRM         VARCHAR(10)  COLLATE Turkish_CI_AS,
    GCTIP           INT,
    MAS_ID			INT,
    TABLE_AD		VARCHAR(50)  COLLATE Turkish_CI_AS,
    NOT_ACK         VARCHAR(500)  COLLATE Turkish_CI_AS)
AS
BEGIN
  DECLARE @EKSTRE_VTEMP TABLE (
    FIRMANO   		INT,
    FIRMAAD  		VARCHAR(100)  COLLATE Turkish_CI_AS,
    ISLEMTURAD  VARCHAR(30)  COLLATE Turkish_CI_AS,
    ISLEMHRKAD  VARCHAR(50)   COLLATE Turkish_CI_AS,
    CARI_TIP    VARCHAR(30)   COLLATE Turkish_CI_AS,
    CARI_TUR    VARCHAR(50)   COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(30)   COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150)   COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(30)   COLLATE Turkish_CI_AS,
    REFNO       VARCHAR(20)   COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(200)  COLLATE Turkish_CI_AS,
    BANKAAD     VARCHAR(150)   COLLATE Turkish_CI_AS,
    DRM         VARCHAR(10)   COLLATE Turkish_CI_AS,
    GIREN           FLOAT,
    CIKAN           FLOAT,
    VADETARIHI      DATETIME,
    ISLEMTARIHI     DATETIME,
    PARABRM         VARCHAR(10)   COLLATE Turkish_CI_AS,
    GCTIP           INT,
    MAS_ID			INT,
    TABLE_AD		VARCHAR(50)  COLLATE Turkish_CI_AS )

  DECLARE @HRK_FIRMANO     INT
  DECLARE @HRK_FIRMAAD     VARCHAR(100)
  DECLARE @HRK_CARI_TIP    VARCHAR(30)
  DECLARE @HRK_CARI_TUR    VARCHAR(50)
  DECLARE @HRK_CARI_KOD    VARCHAR(30)
  DECLARE @HRK_CARI_UNVAN  VARCHAR(150)
  DECLARE @HRK_ISLEMHRKAD  VARCHAR(50)
  DECLARE @HRK_ISLEMTURAD  VARCHAR(50)
  DECLARE @HRK_BELGENO     VARCHAR(50)
  DECLARE @HRK_REFNO       VARCHAR(50)
  DECLARE @HRK_ACIKLAMA    VARCHAR(200)
  DECLARE @HRK_BANKAAD     VARCHAR(150)
  DECLARE @HRK_DRM         VARCHAR(10)
  DECLARE @HRK_PARABRM     VARCHAR(10)
  DECLARE @HRK_TABLE_AD    VARCHAR(50) 
 
  DECLARE @HRK_GCTIP      	INT
  
  DECLARE @HRK_GIREN           FLOAT
  DECLARE @HRK_CIKAN           FLOAT
  DECLARE @HRK_VADETARIHI      DATETIME
  DECLARE @HRK_ISLEMTARIHI     DATETIME
  DECLARE @HRK_MAS_ID          INT

/*---CEKLER KONTROL EDİLİYOR */
     DECLARE CRS_CEK_HRK CURSOR FAST_FORWARD FOR
     SELECT
      c.firmano,C.cekid,'cekkart',
      case WHEN gctip='G' then C.cartip else C.vercartip end,
      case WHEN gctip='G' then C.carkod else C.vercarkod end,
      C.islmhrkad,c.drmad,
      c.ceksenno,c.refno,c.ack,case when drm='TAK' THEN
      (SELECT bk.ad from bankakart as bk where C.vercarkod=bk.kod)
      ELSE c.banka end,C.drm,c.giren,c.cikan,c.vadetar,c.tarih,C.parabrm
      from cekkart as c
      where c.sil=0 and c.drm in (SELECT * FROM dbo.CsvToSTR (@CEKIN))
      AND vadetar <= @TARIH2 and (c.sonuc=0 or c.sonuc is null )
      /*vadetar >= @TARIH1 and */
  OPEN CRS_CEK_HRK
  FETCH NEXT FROM CRS_CEK_HRK INTO
   @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,@HRK_BELGENO,
   @HRK_REFNO,@HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_DRM,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,
   @HRK_ISLEMTARIHI,@HRK_PARABRM

  WHILE @@FETCH_STATUS = 0
  BEGIN
  
   if @HRK_DRM='CIR'
   SET @HRK_GIREN=@HRK_CIKAN
   
   IF @HRK_GIREN>0
   SET @HRK_GCTIP=1
   
   IF @HRK_CIKAN>0
   SET @HRK_GCTIP=-1

   IF @HRK_GIREN=@HRK_CIKAN
   SET @HRK_GCTIP=0

    set @HRK_CARI_UNVAN=''
  
   select @HRK_CARI_TUR=C.tip,
   @HRK_CARI_UNVAN=isnull(c.ad,'') from  Genel_kart as c where c.cartp=@HRK_CARI_TIP
   and c.kod=@HRK_CARI_KOD
    INSERT @EKSTRE_VTEMP (FIRMANO,MAS_ID,TABLE_AD,ISLEMTURAD,ISLEMHRKAD,CARI_TIP,CARI_TUR,CARI_KOD,CARI_UNVAN,BELGENO,
    REFNO,ACIKLAMA,BANKAAD,GIREN,CIKAN,VADETARIHI,ISLEMTARIHI,PARABRM)
      SELECT @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
       @HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,
       @HRK_CARI_TIP,@HRK_CARI_TUR,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_BELGENO,@HRK_REFNO,
       @HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,@HRK_ISLEMTARIHI,
       @HRK_PARABRM
       
    FETCH NEXT FROM CRS_CEK_HRK INTO
    @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
    @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,@HRK_BELGENO,
   @HRK_REFNO,@HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_DRM,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,
   @HRK_ISLEMTARIHI,@HRK_PARABRM
  END

  CLOSE CRS_CEK_HRK
  DEALLOCATE CRS_CEK_HRK
  
/*slipler */
   IF (@SLIP=1) and (@SLIPBNK=0)
   BEGIN
     DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     SELECT
      c.firmano,c.poshrkid,'poshrk',
      C.cartip,c.carkod,C.islmtipad,c.islmhrkad,
      c.belno,c.ack,bk.ad,
      c.giren,c.cikan,c.vadetar,c.tarih,C.parabrm
      from poshrk as c
      inner join bankakart bk on bk.kod=c.bankod
      where c.sil=0  and c.aktip in ('BK','BL')
      AND c.vadetar >= @TARIH1 and c.vadetar <= @TARIH2
   END

 IF (@SLIPBNK=1)
    BEGIN
     DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     SELECT
      c.firmano,0,'poshrk',
      '-','-',C.islmtipad,c.islmhrkad,
      '-' as belno,'-' as ack,bk.ad,
      SUM(c.giren),SUM(c.cikan),c.vadetar,c.tarih,C.parabrm
      from poshrk as c
      inner join bankakart bk on bk.kod=c.bankod
      where c.sil=0 and c.aktip in ('BK','BL')
      AND c.vadetar >= @TARIH1 and c.vadetar <= @TARIH2
      group by c.firmano,
      C.islmtipad,c.islmhrkad,bk.ad,c.vadetar,c.tarih,C.parabrm
   END
   
   
    if (@SLIP=1) or (@SLIPBNK=1)
    begin

     OPEN CRS_HRK
    
    FETCH NEXT FROM CRS_HRK INTO
    @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
    @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,@HRK_BELGENO,
    @HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,
    @HRK_ISLEMTARIHI,@HRK_PARABRM

  WHILE @@FETCH_STATUS = 0
  BEGIN
  set @HRK_REFNO=''
  
   IF @HRK_GIREN>0
   SET @HRK_GCTIP=1

   IF @HRK_CIKAN>0
   SET @HRK_GCTIP=-1

   IF @HRK_GIREN=@HRK_CIKAN
   SET @HRK_GCTIP=0
  
  
   Set @HRK_CARI_UNVAN=''
  
   IF @SLIPBNK=0
   begin
    select @HRK_CARI_TUR=C.tip,
   @HRK_CARI_UNVAN=isnull(c.ad,'') from  Genel_kart as c where c.cartp=@HRK_CARI_TIP
   and c.kod=@HRK_CARI_KOD
   end
   
   
    INSERT @EKSTRE_VTEMP (FIRMANO,MAS_ID,TABLE_AD,ISLEMTURAD,ISLEMHRKAD,CARI_TIP,CARI_TUR,CARI_KOD,CARI_UNVAN,BELGENO,
    REFNO,ACIKLAMA,BANKAAD,GIREN,CIKAN,VADETARIHI,ISLEMTARIHI,PARABRM)
      SELECT @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
      @HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,
       @HRK_CARI_TIP,@HRK_CARI_TUR,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_BELGENO,@HRK_REFNO,
       @HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,@HRK_ISLEMTARIHI,
       @HRK_PARABRM

    FETCH NEXT FROM CRS_HRK INTO
    @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
    @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,@HRK_BELGENO,
   @HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,
   @HRK_ISLEMTARIHI,@HRK_PARABRM
   END

   CLOSE CRS_HRK
   DEALLOCATE CRS_HRK
  end

  
/*---isletme krdi kartları */
if @ISTKART=1
 begin
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     SELECT
      c.firmano,c.istkhrkid,'istkhrk',
      C.cartip,c.carkod,'İŞLETME K.KART',C.islmhrkad,
      c.belno,c.ack,bk.ad,
      c.borc,c.alacak,
      c.vadetar,c.tarih,C.parabrm
      from istkhrk as c
      inner join istkart bk on bk.kod=c.istkkod
      where c.sil=0 
      AND vadetar >= @TARIH1 and vadetar <= @TARIH2
     OPEN CRS_HRK
    FETCH NEXT FROM CRS_HRK INTO
   @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,@HRK_BELGENO,
   @HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,
   @HRK_ISLEMTARIHI,@HRK_PARABRM

  WHILE @@FETCH_STATUS = 0
  BEGIN

   set @HRK_REFNO=''

   IF @HRK_GIREN>0
   SET @HRK_GCTIP=1

   IF @HRK_CIKAN>0
   SET @HRK_GCTIP=-1

   IF @HRK_GIREN=@HRK_CIKAN
   SET @HRK_GCTIP=0


  set @HRK_CARI_UNVAN=''
   
    select @HRK_CARI_TUR=C.tip,
   @HRK_CARI_UNVAN=isnull(c.ad,'') from  Genel_kart as c where 
   c.cartp=@HRK_CARI_TIP
   and c.kod=@HRK_CARI_KOD
    INSERT @EKSTRE_VTEMP (FIRMANO,MAS_ID,TABLE_AD,
    ISLEMTURAD,ISLEMHRKAD,CARI_TIP,CARI_TUR,CARI_KOD,CARI_UNVAN,BELGENO,
    REFNO,ACIKLAMA,BANKAAD,GIREN,CIKAN,VADETARIHI,ISLEMTARIHI,PARABRM)
      SELECT @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
      @HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,
       @HRK_CARI_TIP,@HRK_CARI_TUR,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_BELGENO,@HRK_REFNO,
       @HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,@HRK_ISLEMTARIHI,
       @HRK_PARABRM

    FETCH NEXT FROM CRS_HRK INTO
    @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
    @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_ISLEMTURAD,
    @HRK_ISLEMHRKAD,@HRK_BELGENO,
   @HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,
   @HRK_ISLEMTARIHI,@HRK_PARABRM
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK
 end
  
 /*vadeli kredi taksit */
 if @VADKRD=1
 begin
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     SELECT
      bk.firmano,t.id,'taksit_hrk',
      'bankakart',bk.bankod,'BANKA KARTLARI',
      'VADELİ KREDİ TAKSİT',bk.belno,bk.ack,
      0,t.tutar,
      t.tarih,t.tarih,t.parabrm
      from bankahrk as bk
      inner join taksit_hrk t on bk.bankhrkid=t.mas_id
      where bk.sil=0 and t.sil=0
      and bk.islmtip='KRD' and bk.islmhrk='VKC'
      AND t.tarih >= @TARIH1 and t.tarih <= @TARIH2
     OPEN CRS_HRK
    FETCH NEXT FROM CRS_HRK INTO
   @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,@HRK_BELGENO,
   @HRK_ACIKLAMA,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,
   @HRK_ISLEMTARIHI,@HRK_PARABRM

  WHILE @@FETCH_STATUS = 0
  BEGIN

   set @HRK_REFNO=''

   IF @HRK_GIREN>0
   SET @HRK_GCTIP=1

   IF @HRK_CIKAN>0
   SET @HRK_GCTIP=-1

   IF @HRK_GIREN=@HRK_CIKAN
   SET @HRK_GCTIP=0


  set @HRK_CARI_UNVAN=''
   
   select @HRK_CARI_TUR=C.tip,
   @HRK_CARI_UNVAN=isnull(c.ad,'') from  Genel_kart as c where 
   c.cartp=@HRK_CARI_TIP
   and c.kod=@HRK_CARI_KOD
    
    INSERT @EKSTRE_VTEMP (FIRMANO,MAS_ID,TABLE_AD,
    ISLEMTURAD,ISLEMHRKAD,CARI_TIP,CARI_TUR,CARI_KOD,CARI_UNVAN,BELGENO,
    REFNO,ACIKLAMA,BANKAAD,GIREN,CIKAN,VADETARIHI,ISLEMTARIHI,PARABRM)
     
     SELECT @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
      @HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,
       @HRK_CARI_TIP,@HRK_CARI_TUR,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_BELGENO,@HRK_REFNO,
       @HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,@HRK_ISLEMTARIHI,
       @HRK_PARABRM

    FETCH NEXT FROM CRS_HRK INTO
    @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
    @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,@HRK_BELGENO,
   @HRK_ACIKLAMA,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,
   @HRK_ISLEMTARIHI,@HRK_PARABRM
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK
 end
  
  
  
  

/*alış faturası */
     DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     SELECT
      c.firmano,c.fatid,'faturamas',
      C.cartip,c.carkod,'FATURA',C.fatad,
      c.fatseri+cast(c.fatno as varchar),c.ack,'',
      0,((fattop-(satisktop+genisktop))+(kdvtop+giderkdvtop+gidertop+yuvtop)),
      c.vadtar,c.tarih,C.parabrm
      from faturamas as c
      where c.sil=0 and c.fattur_id=1 and c.fattip in (SELECT * FROM dbo.CsvToSTR (@ALSFATIN))
      AND vadtar >= @TARIH1 and vadtar <= @TARIH2 and (c.odeme=0 or c.odeme is null )
     OPEN CRS_HRK
    FETCH NEXT FROM CRS_HRK INTO
   @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,@HRK_BELGENO,
   @HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,
   @HRK_ISLEMTARIHI,@HRK_PARABRM

  WHILE @@FETCH_STATUS = 0
  BEGIN

   set @HRK_REFNO=''

   IF @HRK_GIREN>0
   SET @HRK_GCTIP=1

   IF @HRK_CIKAN>0
   SET @HRK_GCTIP=-1

   IF @HRK_GIREN=@HRK_CIKAN
   SET @HRK_GCTIP=0

   set @HRK_CARI_UNVAN=''

   select @HRK_CARI_TUR=C.tip,
   @HRK_CARI_UNVAN=isnull(c.ad,'') from  Genel_kart as c where c.cartp=@HRK_CARI_TIP
   and c.kod=@HRK_CARI_KOD
    INSERT @EKSTRE_VTEMP (FIRMANO,MAS_ID,TABLE_AD,
    ISLEMTURAD,ISLEMHRKAD,CARI_TIP,CARI_TUR,CARI_KOD,CARI_UNVAN,BELGENO,
    REFNO,ACIKLAMA,BANKAAD,GIREN,CIKAN,VADETARIHI,ISLEMTARIHI,PARABRM)
      SELECT @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
      @HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,
       @HRK_CARI_TIP,@HRK_CARI_TUR,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_BELGENO,@HRK_REFNO,
       @HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,@HRK_ISLEMTARIHI,
       @HRK_PARABRM

    FETCH NEXT FROM CRS_HRK INTO
    @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
    @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,@HRK_BELGENO,
   @HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,
   @HRK_ISLEMTARIHI,@HRK_PARABRM
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK


/*------------satis faturası */
     DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     SELECT
      c.firmano,c.fatid,'faturamas',
      C.cartip,c.carkod,'FATURA',C.fatad,
      c.fatseri+cast(c.fatno as varchar),c.ack,'',
      ((fattop-(satisktop+genisktop))+(kdvtop+giderkdvtop+gidertop+yuvtop)),0,
      c.vadtar,c.tarih,C.parabrm
      from faturamas as c
      where c.sil=0 and c.fattur_id=2 and c.fattip in (SELECT * FROM dbo.CsvToSTR (@SATFATIN))
      AND vadtar >= @TARIH1 and vadtar <= @TARIH2 and (c.odeme=0 or c.odeme is null )
     OPEN CRS_HRK
    FETCH NEXT FROM CRS_HRK INTO
   @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,@HRK_BELGENO,
   @HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,
   @HRK_ISLEMTARIHI,@HRK_PARABRM

  WHILE @@FETCH_STATUS = 0
  BEGIN

   set @HRK_REFNO=''

   IF @HRK_GIREN>0
   SET @HRK_GCTIP=1

   IF @HRK_CIKAN>0
   SET @HRK_GCTIP=-1

   IF @HRK_GIREN=@HRK_CIKAN
   SET @HRK_GCTIP=0

    set @HRK_CARI_UNVAN=''

   select @HRK_CARI_TUR=C.tip,
   @HRK_CARI_UNVAN=isnull(c.ad,'') from  Genel_kart as c where c.cartp=@HRK_CARI_TIP
   and c.kod=@HRK_CARI_KOD
    INSERT @EKSTRE_VTEMP (FIRMANO,MAS_ID,TABLE_AD,
    ISLEMTURAD,ISLEMHRKAD,CARI_TIP,CARI_TUR,CARI_KOD,CARI_UNVAN,BELGENO,
    REFNO,ACIKLAMA,BANKAAD,GIREN,CIKAN,VADETARIHI,ISLEMTARIHI,PARABRM)
      SELECT @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
      @HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,
       @HRK_CARI_TIP,@HRK_CARI_TUR,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_BELGENO,@HRK_REFNO,
       @HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,@HRK_ISLEMTARIHI,
       @HRK_PARABRM

    FETCH NEXT FROM CRS_HRK INTO
    @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
    @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,@HRK_BELGENO,
   @HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,
   @HRK_ISLEMTARIHI,@HRK_PARABRM
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK
  
  
/*----veresiye fisler */

    DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     SELECT
      c.firmano,c.verid,'veresimas',
      C.cartip,ck.tip,c.carkod,ck.ad,'FİŞ',c.fisad,
      c.seri+cast(c.no as varchar),c.ack,'',
      c.toptut,0,
      c.vadtar,c.tarih,C.parabrm
      from veresimas as c
      inner join Genel_kart as ck on
      ck.kod=c.carkod and c.cartip=ck.cartp
      where c.sil=0 and c.fistip='FISVERSAT' AND c.aktip='BK'
      and ck.id in (SELECT * FROM dbo.CsvToInt (@FISIN))
      AND vadtar >= @TARIH1 and vadtar <= @TARIH2
     OPEN CRS_HRK
    FETCH NEXT FROM CRS_HRK INTO
   @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
   @HRK_CARI_TIP,@HRK_CARI_TUR,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,@HRK_BELGENO,
   @HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,
   @HRK_ISLEMTARIHI,@HRK_PARABRM

  WHILE @@FETCH_STATUS = 0
  BEGIN

   set @HRK_REFNO=''

   IF @HRK_GIREN>0
   SET @HRK_GCTIP=1

   IF @HRK_CIKAN>0
   SET @HRK_GCTIP=-1

   IF @HRK_GIREN=@HRK_CIKAN
   SET @HRK_GCTIP=0


    INSERT @EKSTRE_VTEMP (FIRMANO,MAS_ID,TABLE_AD,
    ISLEMTURAD,ISLEMHRKAD,CARI_TIP,CARI_TUR,CARI_KOD,CARI_UNVAN,BELGENO,
    REFNO,ACIKLAMA,BANKAAD,GIREN,CIKAN,VADETARIHI,ISLEMTARIHI,PARABRM)
      SELECT @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
      @HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,
       @HRK_CARI_TIP,@HRK_CARI_TUR,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_BELGENO,@HRK_REFNO,
       @HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,@HRK_ISLEMTARIHI,
       @HRK_PARABRM

    FETCH NEXT FROM CRS_HRK INTO
    @HRK_FIRMANO,@HRK_MAS_ID,@HRK_TABLE_AD,
    @HRK_CARI_TIP,@HRK_CARI_TUR,@HRK_CARI_KOD,@HRK_CARI_UNVAN,@HRK_ISLEMTURAD,@HRK_ISLEMHRKAD,@HRK_BELGENO,
   @HRK_ACIKLAMA,@HRK_BANKAAD,@HRK_GIREN,@HRK_CIKAN,@HRK_VADETARIHI,
   @HRK_ISLEMTARIHI,@HRK_PARABRM
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK

  
  /*---------------------------------------------------------------------------- */
    INSERT @TB_VADGEL_EKSTRE (FIRMANO,MAS_ID,TABLE_AD,
    ISLEMTURAD,ISLEMHRKAD,CARI_TIP,CARI_TUR,CARI_KOD,CARI_UNVAN,BELGENO,
    REFNO,ACIKLAMA,BANKAAD,GIREN,CIKAN,VADETARIHI,ISLEMTARIHI,PARABRM,GCTIP)
    SELECT FIRMANO,MAS_ID,TABLE_AD,
    ISLEMTURAD,ISLEMHRKAD,CARI_TIP,CARI_TUR,CARI_KOD,CARI_UNVAN,BELGENO,
    REFNO,ACIKLAMA,BANKAAD,GIREN,CIKAN,VADETARIHI,ISLEMTARIHI,PARABRM,
    GCTIP FROM @EKSTRE_VTEMP
 
  
    update @TB_VADGEL_EKSTRE set FIRMAAD=dt.ad from @TB_VADGEL_EKSTRE as t
    join (select id,ad from firma as k ) dt
    on dt.id=t.FIRMANO
  
    update @TB_VADGEL_EKSTRE set NOT_ACK=dt.ack from 
    @TB_VADGEL_EKSTRE as t join (select Table_Ad,Mas_id,
    ack from evrak_Not as k ) dt
    on dt.table_ad=t.table_ad and dt.mas_id=t.mas_Id
  
    
  
  
  
  
    /*if @firmano>0 */
     /*delete from @TB_VADGEL_EKSTRE where FIRMANO not in (@firmano) */
  
  
  
  
  
 RETURN
END

================================================================================
