-- Function: dbo.UDF_CARIFIS_HRK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.698905
================================================================================

CREATE FUNCTION [dbo].[UDF_CARIFIS_HRK] (
@RAPTIP   VARCHAR(20),
@CARI_TIP VARCHAR(20),
@CARI_KOD VARCHAR(20),
@TARIH1   DATETIME,
@TARIH2   DATETIME,
@SAAT1    VARCHAR(8),
@SAAT2    VARCHAR(8),
@DEVIR    INT
)
RETURNS 
    @TB_CARI_EKSTRE TABLE (
    CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(100) COLLATE Turkish_CI_AS,
    CARI_TEL	VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_FAX	VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_CEP	VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_EMAIL	VARCHAR(50) COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)  COLLATE Turkish_CI_AS,
    VADETARIH       DATETIME,
    BELGENO     VARCHAR(30) COLLATE Turkish_CI_AS,
    YKNO        VARCHAR(20) COLLATE Turkish_CI_AS,
    STOKKOD     VARCHAR(20) COLLATE Turkish_CI_AS,
    STOKAD      VARCHAR(50) COLLATE Turkish_CI_AS,
    MIKTAR      FLOAT,
    BFIYAT      FLOAT,
    KM          float,
    PLAKA       VARCHAR(50) COLLATE Turkish_CI_AS,
    SURUCU      VARCHAR(50) COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(100) COLLATE Turkish_CI_AS,
    ISLTIPAD    VARCHAR(30)  COLLATE Turkish_CI_AS,
    ISLHRKAD    VARCHAR(30)  COLLATE Turkish_CI_AS,
    YERAD       VARCHAR(30)  COLLATE Turkish_CI_AS,
    KULAD       VARCHAR(50)  COLLATE Turkish_CI_AS,
    ISLTIP      VARCHAR(10)   COLLATE Turkish_CI_AS,
    ISLHRK      VARCHAR(10)   COLLATE Turkish_CI_AS,
    HRKID       FLOAT,
    MASID       FLOAT,
    BORC        FLOAT,
    ALACAK      FLOAT,
    BAKIYE      FLOAT,
    ISKTUTAR    FLOAT,
    FISTUTAR    FLOAT)
AS
BEGIN
  DECLARE @EKSTRE_TEMP TABLE (
    CARI_TIP    VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD VARCHAR(20)     COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(50)  COLLATE Turkish_CI_AS,
    CARI_TEL	VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_FAX	VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_CEP	VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_EMAIL	VARCHAR(50) COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)   COLLATE Turkish_CI_AS,
    VADETARIH       DATETIME,
    BELGENO    VARCHAR(30)   COLLATE Turkish_CI_AS,
    YKNO        VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOKKOD     VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOKAD      VARCHAR(50)  COLLATE Turkish_CI_AS,
    MIKTAR      FLOAT,
    BFIYAT      FLOAT,
    KM          FLOAT,
    PLAKA       VARCHAR(50)   COLLATE Turkish_CI_AS,
    SURUCU      VARCHAR(50) COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(100)  COLLATE Turkish_CI_AS,
    ISLTIPAD    VARCHAR(30)   COLLATE Turkish_CI_AS,
    ISLHRKAD    VARCHAR(30)   COLLATE Turkish_CI_AS,
    YERAD       VARCHAR(30)   COLLATE Turkish_CI_AS,
    KULAD       VARCHAR(50)   COLLATE Turkish_CI_AS,
    ISLTIP      VARCHAR(10)   COLLATE Turkish_CI_AS,
    ISLHRK      VARCHAR(10)   COLLATE Turkish_CI_AS,
    HRKID       FLOAT,
    MASID       FLOAT,
    BORC        FLOAT,
    ALACAK      FLOAT,
    BAKIYE      FLOAT,
    ISKTUTAR    FLOAT,
    FISID       FLOAT,
    FISTUTAR    FLOAT)

  DECLARE @HRK_CARI_TIP    VARCHAR(20)
  DECLARE @HRK_CARI_KOD    VARCHAR(20)
  DECLARE @HRK_CARI_UNVAN  VARCHAR(50)
  DECLARE @HRK_CARI_TEL  VARCHAR(50)
  DECLARE @HRK_CARI_FAX  VARCHAR(50)
  DECLARE @HRK_CARI_CEP  VARCHAR(50)
  DECLARE @HRK_CARI_EMAIL  VARCHAR(50)
  
  
  DECLARE @HRK_VADETARIH       DATETIME 
  DECLARE @HRK_TARIH       DATETIME
  DECLARE @HRK_SAAT        VARCHAR(8)
  DECLARE @HRK_BELGENO     VARCHAR(30)
  DECLARE @HRK_YKNO        VARCHAR(20)
  DECLARE @HRK_STOKKOD     VARCHAR(20)
  DECLARE @HRK_STOKAD      VARCHAR(50)
  DECLARE @HRK_MIKTAR      FLOAT
  DECLARE @HRK_BFIYAT      FLOAT
  DECLARE @HRK_KM          FLOAT
  DECLARE @HRK_PLAKA       VARCHAR(50)
  DECLARE @HRK_SURUCU      VARCHAR(50)
  DECLARE @HRK_ACIKLAMA    VARCHAR(100)
  DECLARE @HRK_ISLTIPAD    VARCHAR(30)
  DECLARE @HRK_ISLHRKAD    VARCHAR(30)
  DECLARE @HRK_YERAD       VARCHAR(30)
  DECLARE @HRK_KULAD       VARCHAR(50)
  DECLARE @HRK_ISLTIP      VARCHAR(10)
  DECLARE @HRK_ISLHRK      VARCHAR(10)
  DECLARE @HRK_HRKID       FLOAT
  DECLARE @HRK_MASID       FLOAT
  DECLARE @HRK_BORC        FLOAT
  DECLARE @HRK_ALACAK      FLOAT
  DECLARE @HRK_BAKIYE      FLOAT
  DECLARE @KUM_BAKIYE      FLOAT
  DECLARE @HRK_ISKTUTAR    FLOAT
  DECLARE @HRK_FISID       FLOAT 
  DECLARE @HRK_FISTUTAR    FLOAT 
  
  SET @KUM_BAKIYE = 0

  
  DECLARE @OTO_VADEFARK BIT

   select @HRK_CARI_UNVAN=ck.ad,
     @HRK_CARI_TEL=ck.tel,
      @HRK_CARI_FAX=ck.fax,
      @HRK_CARI_CEP=ck.cep,
      @HRK_CARI_EMAIL=ck.mail,
      @OTO_VADEFARK=Oto_FisVadeFark
         
 from Genel_Kart as ck with (nolock) 
 where kod=@CARI_KOD and ck.cartp=@CARI_TIP
 
 
 declare @FatFisIskYansit   bit
  
 
 select top 1 @FatFisIskYansit=FaturaFisIskonto from sistemtanim  
 
 
 
 
 

  /* Devir atanıyor */
  
  
/*- HRK VE AKTARILMAMIS FİŞ DOKUMLERİ */
  if @RAPTIP='HRK_BEKFIS'
  BEGIN
  IF @DEVIR=1
   BEGIN
          INSERT @EKSTRE_TEMP
            SELECT
              '',/*CARI TIP */
              @CARI_KOD, /* CARI_KOD */
              @HRK_CARI_UNVAN, /* CARI_UNVAN */
              @HRK_CARI_TEL,
              @HRK_CARI_FAX,
              @HRK_CARI_CEP,
              @HRK_CARI_EMAIL,
              @TARIH1,
              @SAAT1,
              @TARIH1,
              'DEVİR', /* BELGE NO */
              '',/*YKNO */
              '',/*STOKKOD */
              '',/*STOKAD */
              0,/*MİKTAR */
              0,/*BFIYAT */
              0,
              '', /*PLAKA */
              '',/*SURUCU */
              CONVERT(VARCHAR(10), @TARIH1, 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA */
              '-','-','-','-','-','-',0,0,
              ISNULL(SUM(CASE WHEN borc>0 THEN borc ELSE 0 END),0), /* BORC */
              ISNULL(SUM(CASE WHEN alacak>0 THEN alacak ELSE 0 END),0), /* ALACAK */
              ISNULL(SUM((borc-alacak)),0),
              0,0,0              
              FROM carihrk WITH (NOLOCK)
              WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
             /*and islmhrk not in ('CAK','FATVERSAT') */
              and sil=0  AND tarih < @TARIH1

              SELECT @KUM_BAKIYE = BAKIYE FROM @EKSTRE_TEMP

     
              /* veresiye hareketlerinden gelen bakiye alınıyor */
            SELECT
                @HRK_BORC   = ISNULL(SUM(case when fistip='FISVERSAT' THEN toptut-isktop else 0 end ),0),
                @HRK_ALACAK = ISNULL(SUM(case when fistip='FISALCSAT' THEN toptut-isktop else 0 end),0),
                @HRK_BAKIYE = ISNULL(SUM(case when fistip='FISVERSAT' then toptut-isktop else -toptut-isktop end  ),0)
              FROM veresimas WITH (NOLOCK)
              WHERE cartip=@CARI_TIP and carkod=@CARI_KOD 
              and aktip in ('BK','BL')
              and sil=0  AND tarih < @TARIH1

              /* Faturalardan gelen bakiye hareketlerden gelen bakiyeye ekleniyor */
              UPDATE @EKSTRE_TEMP SET
                BORC    = BORC    + @HRK_BORC,
                ALACAK  = ALACAK  + @HRK_ALACAK,
                BAKIYE  = BAKIYE  + @HRK_BAKIYE

              /* Kümülatif bakiye için kullanılacak değişkene devir bakiyesi atanıyor. */
               SELECT @KUM_BAKIYE = BAKIYE FROM @EKSTRE_TEMP
         END
    END /*'HRK_BEKFIS' */
    
  if @RAPTIP='HRK_TUMFIS'
  BEGIN
  IF @DEVIR=1
   BEGIN
          INSERT @EKSTRE_TEMP
            SELECT
              '',/*CARI TIP */
              @CARI_KOD, /* CARI_KOD */
              @HRK_CARI_UNVAN, /* CARI_UNVAN */
              @HRK_CARI_TEL,
              @HRK_CARI_FAX,
              @HRK_CARI_CEP,
              @HRK_CARI_EMAIL,
              @TARIH1,
              @SAAT1,
              @TARIH1,
              'DEVİR', /* BELGE NO */
              '',/*YKNO */
              '',/*STOKKOD */
              '',/*STOKAD */
              0,/*MİKTAR */
              0,/*BFIYAT */
              0,
              '', /*PLAKA */
              '',/*SURUCU */
              CONVERT(VARCHAR(10), @TARIH1, 104) +' DEVİR BAKİYESİ', /* AÇIKLAMA */
              '-','-','-','-','-','-',0,0,
              ISNULL(SUM(CASE WHEN borc>0 THEN borc ELSE 0 END),0), /* BORC */
              ISNULL(SUM(CASE WHEN alacak>0 THEN alacak ELSE 0 END),0), /* ALACAK */
              ISNULL(SUM((borc-alacak)),0),0,0,0
              FROM carihrk with (nolock)
              WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
              and islmhrk not in ('CAK','FATVERSAT','FATTTSSAT')
              and sil=0  AND tarih < @TARIH1

              SELECT @KUM_BAKIYE = BAKIYE FROM @EKSTRE_TEMP

           
              /* veresiye hareketlerinden gelen bakiye alınıyor */
             /* if @FatFisIskYansit=0
              SELECT
                @HRK_BORC   = ISNULL(SUM(case when fistip='FISVERSAT' THEN toptut-isktop else 0 end ),0),
                @HRK_ALACAK = ISNULL(SUM(case when fistip='FISALCSAT' THEN toptut-isktop else 0 end),0),
                @HRK_BAKIYE = ISNULL(SUM(case when fistip='FISVERSAT' then toptut-isktop else -toptut-isktop end  ),0)
               FROM veresimas as v with (nolock) 
               WHERE v.cartip=@CARI_TIP and v.carkod=@CARI_KOD
               and isnull(v.devir,0)=0
               and v.sil=0  AND v.tarih < @TARIH1
           
              
              if @FatFisIskYansit=1
              */
              SELECT
               @HRK_BORC   = ISNULL(SUM(CASE WHEN v.fistip='FISVERSAT' THEN  (h.brmfiy*(1-(isnull(h.Fat_IskYuz,0)/100)))*h.mik else 0 end ),0),
               @HRK_ALACAK = ISNULL(SUM(CASE WHEN v.fistip='FISALCSAT' THEN (h.brmfiy*(1-(isnull(h.Fat_IskYuz,0)/100)))*h.mik else 0 end ),0),
               @HRK_BAKIYE = ISNULL(SUM(CASE WHEN v.fistip='FISVERSAT' THEN  -1*(h.brmfiy*(1-(isnull(h.Fat_IskYuz,0)/100)))*h.mik else
               (h.brmfiy*(1-(isnull(h.Fat_IskYuz,0)/100)))*h.mik end ),0)
               FROM veresimas as v with (nolock) 
               inner join veresihrk h with (nolock) on
               v.verid=h.verid and h.sil=0 and 
               v.cartip=@CARI_TIP and v.carkod=@CARI_KOD
               and isnull(v.devir,0)=0
               and v.sil=0  AND v.tarih < @TARIH1
               
         
              

              /* Faturalardan gelen bakiye hareketlerden gelen bakiyeye ekleniyor */
              UPDATE @EKSTRE_TEMP SET
                BORC    = BORC    + @HRK_BORC,
                ALACAK  = ALACAK  + @HRK_ALACAK,
                BAKIYE  = BAKIYE  + @HRK_BAKIYE
                
              /* Kümülatif bakiye için kullanılacak değişkene devir bakiyesi atanıyor. */
               SELECT @KUM_BAKIYE = BAKIYE FROM @EKSTRE_TEMP
         END
      END /*'HRK_TUMFIS' */

  if @RAPTIP='HRK_BEKFIS'
   BEGIN
    DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    SELECT
      @CARI_TIP,@CARI_KOD,@HRK_CARI_UNVAN,
      @HRK_CARI_TEL,
       @HRK_CARI_FAX,
       @HRK_CARI_CEP,
      @HRK_CARI_EMAIL,
       tarih,saat,vadetar,belno,
       '',/*YKNO */
       '',/*STOKKOD */
       '',/*STOKAD */
       0,/*MİKTAR */
       0,/*BFIYAT */
       0,
       '', /*PLAKA */
       '',/*SURUCU */
      ack, /* AÇIKLAMA, */
      islmtipad,islmhrkad,yerad,olususer,islmtip,islmhrk,carhrkid,masterid,
      borc,
      alacak,
      borc-alacak AS BAKIYE,
      0 ISKTUTAR,0 FISID,0 FISTUTAR
    FROM carihrk with (nolock)
    WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
     /*and islmhrk not in ('CAK','FATVERSAT') */
     and sil=0 AND (tarih >= @TARIH1)
     AND (tarih <= @TARIH2)
     UNION ALL
    /* veresiye Hareketleri */
     SELECT
      @CARI_TIP,@CARI_KOD,@HRK_CARI_UNVAN,
      @HRK_CARI_TEL,
      @HRK_CARI_FAX,
      @HRK_CARI_CEP,
      @HRK_CARI_EMAIL,
       tarih,saat,vadtar,
       seri+cast([no] as varchar),
       m.ykno,/*YKNO */
       stkod,
       s.ad,
       mik,
       brmfiy,/*BFIYAT */
       km,
       plaka, /*PLAKA */
       surucu,/*SURUCU */
       ack, /* AÇIKLAMA, */
       fisad,fisad,yerad,h.olususer,'-',fistip,m.verid,0,
       CASE WHEN fistip='FISVERSAT' THEN  (brmfiy*(1-(iskyuz/100)))*mik else 0 end,
       CASE WHEN fistip='FISALCSAT' THEN (brmfiy*(1-(iskyuz/100)))*mik else 0 end,
       CASE WHEN fistip='FISALCSAT' THEN  -1*(brmfiy*(1-(iskyuz/100)))*mik else
       (brmfiy*(1-(iskyuz/100)))*mik end AS BAKIYE,
       (brmfiy*((iskyuz/100)))*mik AS ISKTUTAR,M.verid FISID,0 FISTUTAR
       
       
    FROM veresihrk as h with (nolock) 
    inner join veresimas as m with (nolock)
    on h.verid=m.verid
    and m.sil=0 and h.sil=0 
    left join gelgidlistok as s on 
    s.kod=h.stkod
    and s.tip=h.stktip
     where cartip=@CARI_TIP and carkod=@CARI_KOD and aktip in ('BK','BL')
     and (tarih >= @TARIH1) AND (tarih <= @TARIH2)
    ORDER BY tarih,saat
  END /*- 'HRK_BEKFIS' */





  if @RAPTIP='HRK_TUMFIS'
   BEGIN
   
 
    DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
    /* Cari Fişlerden gelen harektler */
     SELECT
      @CARI_TIP,@CARI_KOD,@HRK_CARI_UNVAN,
      @HRK_CARI_TEL,
      @HRK_CARI_FAX,
      @HRK_CARI_CEP,
      @HRK_CARI_EMAIL,
       tarih,saat,Vadetar,belno,
       '',/*YKNO */
       '',/*STOKKOD */
       '',/*STOKAD */
       0,/*MİKTAR */
       0,/*BFIYAT */
       0,
       '', /*PLAKA */
       '',/*SURUCU */
      ack, /* AÇIKLAMA, */
      islmtipad,islmhrkad,yerad,olususer,islmtip,islmhrk,carhrkid,masterid,
      borc,
      alacak,
      borc-alacak AS BAKIYE,
      0 ISKTUTAR,0 FISID,0 FISTUTAR
    FROM carihrk with (nolock)
    WHERE cartip=@CARI_TIP and carkod=@CARI_KOD
     and islmhrk not in ('CAK','FATVERSAT','FATTTSSAT')
     and sil=0 AND (tarih >= @TARIH1) AND (tarih <= @TARIH2)
     UNION ALL
    /* veresiye Hareketleri */
    
     SELECT
      @CARI_TIP,@CARI_KOD,@HRK_CARI_UNVAN,
      @HRK_CARI_TEL,
      @HRK_CARI_FAX,
      @HRK_CARI_CEP,
      @HRK_CARI_EMAIL,
       tarih,saat,vadtar,
       seri+cast([no] as varchar),
       m.ykno,/*YKNO */
       stkod,
       s.ad,
       mik,
       brmfiy,/*BFIYAT */
       km,
       plaka, /*PLAKA */
       surucu,/*SURUCU */
       ack, /* AÇIKLAMA, */
       fisad,fisad,yerad,h.olususer,'-',fistip,m.verid,0,
       CASE WHEN fistip='FISVERSAT' THEN  (brmfiy*(1-(isnull(Fat_IskYuz,0)/100)))*mik else 0 end,
       CASE WHEN fistip='FISALCSAT' THEN (brmfiy*(1-(isnull(Fat_IskYuz,0)/100)))*mik else 0 end,
       CASE WHEN fistip='FISALCSAT' THEN  -1*(brmfiy*(1-(isnull(Fat_IskYuz,0)/100)))*mik 
       else (brmfiy*(1-(isnull(Fat_IskYuz,0)/100)))*mik end AS BAKIYE,
       (brmfiy*((isnull(Fat_IskYuz,0)/100)))*mik AS ISKTUTAR,m.verid FISID,0 FISTUTAR
       FROM veresihrk as h with (nolock) inner join veresimas as m  with (nolock)on
       h.verid=m.verid
       and m.sil=0 and h.sil=0 
       left join gelgidlistok as s on 
      s.kod=h.stkod
      and s.tip=h.stktip
      where cartip=@CARI_TIP and carkod=@CARI_KOD /*and aktip in ('BK','BL') */
      and (tarih >= @TARIH1) AND (tarih <= @TARIH2)
      and isnull(m.devir,0)=0
      ORDER BY tarih,saat
    
    
    
    END /*'HRK_TUMFIS' */

 
 
     OPEN CRS_HRK

       FETCH NEXT FROM CRS_HRK INTO
       @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,
       @HRK_CARI_TEL,@HRK_CARI_FAX,@HRK_CARI_CEP,@HRK_CARI_EMAIL,
       @HRK_TARIH,@HRK_SAAT,@HRK_VADETARIH,@HRK_BELGENO,@HRK_YKNO,@HRK_STOKKOD,
       @HRK_STOKAD,@HRK_MIKTAR,@HRK_BFIYAT,@HRK_KM,@HRK_PLAKA,@HRK_SURUCU,@HRK_ACIKLAMA,
       @HRK_ISLTIPAD,@HRK_ISLHRKAD,@HRK_YERAD,@HRK_KULAD,@HRK_ISLTIP,@HRK_ISLHRK,@HRK_HRKID,@HRK_MASID,
       @HRK_BORC,@HRK_ALACAK,@HRK_BAKIYE,@HRK_ISKTUTAR,@HRK_FISID,@HRK_FISTUTAR 

      WHILE @@FETCH_STATUS = 0
      BEGIN
        SET @KUM_BAKIYE = @KUM_BAKIYE + @HRK_BAKIYE
        
        if @HRK_FISID>0
         SET @HRK_FISTUTAR=@HRK_ISKTUTAR+@HRK_BORC
        
       
        INSERT @EKSTRE_TEMP
          SELECT
           @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,
           @HRK_CARI_TEL,@HRK_CARI_FAX,@HRK_CARI_CEP,@HRK_CARI_EMAIL,
           @HRK_TARIH,@HRK_SAAT,@HRK_VADETARIH,@HRK_BELGENO,@HRK_YKNO,@HRK_STOKKOD,
           @HRK_STOKAD,@HRK_MIKTAR,@HRK_BFIYAT,@HRK_KM,@HRK_PLAKA,@HRK_SURUCU,@HRK_ACIKLAMA,
           @HRK_ISLTIPAD,@HRK_ISLHRKAD,@HRK_YERAD,@HRK_KULAD,@HRK_ISLTIP,@HRK_ISLHRK,@HRK_HRKID,@HRK_MASID,
           @HRK_BORC, @HRK_ALACAK,@KUM_BAKIYE,@HRK_ISKTUTAR,@HRK_FISID,@HRK_FISTUTAR
   
        FETCH NEXT FROM CRS_HRK INTO
          @HRK_CARI_TIP,@HRK_CARI_KOD, @HRK_CARI_UNVAN,
          @HRK_CARI_TEL,@HRK_CARI_FAX,@HRK_CARI_CEP,@HRK_CARI_EMAIL,
          @HRK_TARIH,@HRK_SAAT,@HRK_VADETARIH,@HRK_BELGENO,@HRK_YKNO,@HRK_STOKKOD,
          @HRK_STOKAD,@HRK_MIKTAR,@HRK_BFIYAT,@HRK_KM,@HRK_PLAKA,@HRK_SURUCU,@HRK_ACIKLAMA,
          @HRK_ISLTIPAD,@HRK_ISLHRKAD,@HRK_YERAD,@HRK_KULAD,@HRK_ISLTIP,@HRK_ISLHRK,@HRK_HRKID,@HRK_MASID,
          @HRK_BORC, @HRK_ALACAK, @HRK_BAKIYE,@HRK_ISKTUTAR,@HRK_FISID,@HRK_FISTUTAR
      END

      CLOSE CRS_HRK
      DEALLOCATE CRS_HRK
      
      
      
     if @OTO_VADEFARK=1
     begin
     
     if @TARIH2>=DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)
       set @TARIH2=DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)
     
      delete from @EKSTRE_TEMP where ISLTIP='VAD' and ISLHRK='OFV'

     INSERT @EKSTRE_TEMP
     (CARI_TIP,CARI_KOD,CARI_UNVAN,
     CARI_TEL,CARI_FAX,CARI_CEP,CARI_EMAIL,
     TARIH,SAAT,VADETARIH,BELGENO,
     YKNO,STOKKOD,STOKAD,MIKTAR,BFIYAT,
     KM,PLAKA,SURUCU,ACIKLAMA,
     ISLTIPAD,ISLHRKAD,YERAD,
     KULAD,ISLTIP,ISLHRK,
     HRKID,MASID,
     BORC,ALACAK,BAKIYE,ISKTUTAR,FISTUTAR)
     SELECT @CARI_TIP,@CARI_KOD,@HRK_CARI_UNVAN,
     @HRK_CARI_TEL,@HRK_CARI_FAX,@HRK_CARI_CEP,@HRK_CARI_EMAIL,
     @TARIH2,CONVERT(VARCHAR(8),GETDATE(),108),@TARIH2,'',
     '','','',0,0,0,
     '','','OTOMATİK FİŞ VADE FARKI',
     'VADE','CARİ OTO. FİŞ VADE FARKI','CARİ KART',
     'SERVIS','VAD','OFV',
     0,0,
     ISNULL(v.CARI_VADETUTAR,0),0,0,0,0 
     from UDF_CariFisVadeFark_Tarih (@CARI_KOD,@TARIH2) AS v
    
    end
      
       
      


    INSERT @TB_CARI_EKSTRE
    SELECT CARI_TIP,CARI_KOD,CARI_UNVAN,
    CARI_TEL,CARI_FAX,CARI_CEP,CARI_EMAIL,
    TARIH,SAAT,VADETARIH,BELGENO,YKNO,STOKKOD,
    STOKAD,MIKTAR,BFIYAT,KM,PLAKA,SURUCU,ACIKLAMA,ISLTIPAD,ISLHRKAD,YERAD,KULAD,ISLTIP,ISLHRK,
    HRKID,MASID,BORC,ALACAK,BAKIYE,ISKTUTAR,FISTUTAR FROM @EKSTRE_TEMP

  RETURN

END

================================================================================
