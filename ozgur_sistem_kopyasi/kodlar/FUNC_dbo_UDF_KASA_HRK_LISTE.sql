-- Function: dbo.UDF_KASA_HRK_LISTE
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.734404
================================================================================

CREATE FUNCTION   [dbo].UDF_KASA_HRK_LISTE (
@firmano			int,
@KOD                VARCHAR(20),
@TARIH1             DATETIME,
@TARIH2             DATETIME,
@silin              varchar(10),
@Rgin				varchar(10),
@devir              tinyint)
RETURNS
   @TB_KASA_HRK_LISTE TABLE(
   id             int,
   Firmano        int,
   Firma_Ad       VARCHAR(150) COLLATE Turkish_CI_AS,
   kashrkid       int,
   fisfattip      varchar(5) COLLATE Turkish_CI_AS NULL,
   fisfatid       int,
   TARIH          datetime,
   SAAT           varchar(8) COLLATE Turkish_CI_AS NULL,
   KASKOD         varchar(20) COLLATE Turkish_CI_AS NULL,
   GCTIP          varchar(1) COLLATE Turkish_CI_AS NULL,
   VAROK          int,
   SIL            int,
   VARNO          int,
   MASTERID       int,
   ISLMTIP        varchar(20) COLLATE Turkish_CI_AS NULL,
   ISLMTIPAD      varchar(50) COLLATE Turkish_CI_AS NULL,
   ISLMHRK        varchar(20) COLLATE Turkish_CI_AS NULL,
   ISLMHRKAD      varchar(50) COLLATE Turkish_CI_AS NULL,
   YERTIP         varchar(20) COLLATE Turkish_CI_AS NULL,
   YERAD          varchar(50) COLLATE Turkish_CI_AS NULL,
   KULAD          varchar(50) COLLATE Turkish_CI_AS NULL,
   BELGENO        varchar(20) COLLATE Turkish_CI_AS NULL,
   ACIKLAMA       varchar(100) COLLATE Turkish_CI_AS NULL,
   GIREN          float,
   CIKAN          float,
   BAKIYE         Float,
   KUR			  FLOAT,
   KUR_GIREN	  FLOAT,
   KUR_CIKAN	  FLOAT,
   KUR_BAKIYE     FLOAT,
   REMOTE_ID      FLOAT,
   DOVIZBRM       varchar(10) COLLATE Turkish_CI_AS NULL,
   CARKOD 		  varchar(30) COLLATE Turkish_CI_AS NULL,
   UNVAN          varchar(150) COLLATE Turkish_CI_AS NULL,
   RG             INT,
   devir		  bit,
   OLUSUSER		  varchar(150) COLLATE Turkish_CI_AS NULL,
   OLUSTARSAAT    datetime,
   DEGUSER		  varchar(150) COLLATE Turkish_CI_AS NULL,
   DEGTARSAAT    datetime  
   )
AS
BEGIN
  DECLARE @BAK_BAKIYE FLOAT
  DECLARE @BAK_GIREN  FLOAT
  DECLARE @BAK_CIKAN  FLOAT
  DECLARE @BAK_TAR    DATETIME

  DECLARE @HRK_ID          INT
  DECLARE @HRK_FIRMANO     int
  DECLARE @HRK_KSID        INT
  DECLARE @HRK_FISFATTIP   VARCHAR(5)
  DECLARE @HRK_FISFATID    INT    
  DECLARE @HRK_TARIH       DATETIME
  DECLARE @HRK_SAAT        VARCHAR(8)
  DECLARE @HRK_KASKOD      VARCHAR(30)
  DECLARE @HRK_GCTIP       VARCHAR(1)
  DECLARE @HRK_ISLTIP      VARCHAR(10)
  DECLARE @HRK_ISLHRK      VARCHAR(10)
  DECLARE @HRK_ISLTIPAD    VARCHAR(30)
  DECLARE @HRK_ISLHRKAD    VARCHAR(30)
  DECLARE @HRK_YERAD       VARCHAR(30)
  DECLARE @HRK_YERTIP      VARCHAR(20)
  DECLARE @HRK_KULAD       VARCHAR(50)
  DECLARE @HRK_BELNO       VARCHAR(20)
  DECLARE @HRK_ACK         VARCHAR(100)
  DECLARE @HRK_DVZ         VARCHAR(10)
  DECLARE @HRK_CARKOD      VARCHAR(30)
  DECLARE @HRK_UNVAN       VARCHAR(150)
  DECLARE @HRK_VAROK       INT
  DECLARE @HRK_SIL         INT
  DECLARE @HRK_VARNO       FLOAT
  DECLARE @HRK_HRKID       FLOAT
  DECLARE @HRK_MASID       FLOAT
  DECLARE @HRK_GIREN       FLOAT
  DECLARE @HRK_CIKAN       FLOAT
  DECLARE @HRK_BAKIYE      FLOAT
  DECLARE @HRK_KUR         FLOAT
  DECLARE @HRK_KUR_GIREN   FLOAT
  DECLARE @HRK_KUR_CIKAN   FLOAT
  DECLARE @HRK_KUR_BAKIYE  FLOAT
  
  DECLARE @HRK_REMOTE_ID   FLOAT
  
  DECLARE @ONDA_HANE       INT
  DECLARE @SIS_PARABRM     VARCHAR(30)
  
  DECLARE @HRK_PARABRM		VARCHAR(30)
  
  DECLARE @HRK_OLUSUSER		VARCHAR(100)
  DECLARE @HRK_OLUSTARIH       DATETIME
  DECLARE @HRK_DEGUSER		VARCHAR(100)
  DECLARE @HRK_DEGTARIH       DATETIME
  

  SELECT @ONDA_HANE=Para_ondalik from sistemtanim


   


  if @devir=1
   begin
    SET @BAK_TAR=DATEADD(day,-1,@TARIH1)
    SELECT @BAK_BAKIYE=(GIREN-CIKAN),
    @BAK_GIREN=GIREN,
    @BAK_CIKAN=CIKAN
    FROM UDF_KASA_TAR_SONDURUM (@firmano,@KOD,'2000-01-01',@BAK_TAR)

    SELECT @SIS_PARABRM=sistem_parabrm from sistemtanim

    SELECT @HRK_PARABRM=parabrm from kasakart where kod=@KOD
    
     set @HRK_KUR=1

    if @HRK_PARABRM<>@SIS_PARABRM
    set @HRK_KUR=dbo.UDF_CAPRAZ_KUR (@BAK_TAR,@HRK_PARABRM,@SIS_PARABRM)


    INSERT INTO @TB_KASA_HRK_LISTE
    (id,Firmano,kashrkid,fisfattip,fisfatid,
    TARIH,SAAT,KASKOD,GCTIP,VAROK,SIL,VARNO,MASTERID,ISLMTIP,ISLMTIPAD,
    ISLMHRK,ISLMHRKAD,YERTIP,YERAD,BELGENO,ACIKLAMA,GIREN,CIKAN,BAKIYE,
    KUR,KUR_GIREN,KUR_CIKAN,KUR_BAKIYE,
    REMOTE_ID,DOVIZBRM,UNVAN,RG,devir)
    SELECT 0,@firmano,0,'-',0,@BAK_TAR,'00:00:00',@KOD,'',0,0,0,0,'','','','',
    'DEVIR','DEVIR','DEVIR','DEVIR',@BAK_GIREN,@BAK_CIKAN,@BAK_BAKIYE,
    @HRK_KUR,round(@BAK_GIREN*@HRK_KUR,@ONDA_HANE),
    round(@BAK_CIKAN*@HRK_KUR,@ONDA_HANE),round(@BAK_BAKIYE*@HRK_KUR,@ONDA_HANE),
    0,
    k.parabrm,k.ad,1,1
     FROM kasakart AS k where k.kod=@KOD
   end
    /*and ( (varno>0 and varok=1 and islmhrk='TES') or (varno=0)) */

  /*DECLARE CRS_KASA_HRK CURSOR FAST_FORWARD FOR */
  
  INSERT INTO @TB_KASA_HRK_LISTE
  (id,Firmano,kashrkid,fisfattip,fisfatid,
  TARIH,SAAT,KASKOD,GCTIP,VAROK,SIL,VARNO,MASTERID,ISLMTIP,ISLMTIPAD,
  ISLMHRK,ISLMHRKAD,YERTIP,YERAD,BELGENO,ACIKLAMA,KULAD,
  OLUSUSER,OLUSTARSAAT,DEGUSER,DEGTARSAAT,
  GIREN,CIKAN,BAKIYE,
  KUR,KUR_GIREN,KUR_CIKAN,KUR_BAKIYE,
  REMOTE_ID,
  DOVIZBRM,UNVAN,CARKOD,RG,devir)
   select h.id,h.Firmano,h.kashrkid,h.fisfattip,h.fisfatid,h.tarih,h.saat,h.kaskod,h.gctip,h.varok,
    h.sil,h.varno,h.masterid,h.islmtip,h.islmtipad,h.islmhrk,
    h.islmhrkad,h.yertip,h.yerad,h.belno,h.ack,H.olususer,
    h.olususer,h.olustarsaat,h.DegUser,h.DegTarSaat,
    round(h.giren,@ONDA_HANE),
    round(h.cikan,@ONDA_HANE),0,
    H.kur,round(h.giren*H.kur,@ONDA_HANE),
    round(h.cikan*H.kur,@ONDA_HANE),0,
    h.remote_id,
    h.parabrm,unvan,carkod,H.RG,h.devir
    from UDF_KASA_GENEL_HRK 
    (@firmano,@KOD,@TARIH1,@TARIH2,@silin) as h order by h.tarih,h.saat
 
 /*
    OPEN CRS_KASA_HRK

    FETCH NEXT FROM CRS_KASA_HRK INTO
    @HRK_ID,@HRK_FIRMANO,@HRK_KSID,@HRK_FISFATTIP,@HRK_FISFATID,
    @HRK_TARIH,@HRK_SAAT,@HRK_KASKOD,@HRK_GCTIP,@HRK_VAROK,
    @HRK_SIL,@HRK_VARNO,@HRK_MASID,@HRK_ISLTIP,@HRK_ISLTIPAD,@HRK_ISLHRK,
    @HRK_ISLHRKAD,@HRK_YERTIP,@HRK_YERAD,@HRK_BELNO,@HRK_ACK,@HRK_KULAD,
    @HRK_GIREN,@HRK_CIKAN,@HRK_REMOTE_ID,
    @HRK_DVZ,@HRK_UNVAN,@HRK_CARKOD

      WHILE @@FETCH_STATUS = 0
      BEGIN
       SET @BAK_BAKIYE =@BAK_BAKIYE+@HRK_GIREN-@HRK_CIKAN

       INSERT INTO @TB_KASA_HRK_LISTE
       (id,Firmano,kashrkid,fisfattip,fisfatid,
       TARIH,SAAT,KASKOD,GCTIP,VAROK,SIL,VARNO,MASTERID,ISLMTIP,ISLMTIPAD,
       ISLMHRK,ISLMHRKAD,YERTIP,YERAD,BELGENO,ACIKLAMA,KULAD,
       GIREN,CIKAN,BAKIYE,REMOTE_ID,
       DOVIZBRM,UNVAN,CARKOD)
       values
       (@HRK_ID,@HRK_FIRMANO,@HRK_KSID,@HRK_FISFATTIP,@HRK_FISFATID,
       @HRK_TARIH,@HRK_SAAT,@HRK_KASKOD,@HRK_GCTIP,@HRK_VAROK,
       @HRK_SIL,@HRK_VARNO,@HRK_MASID,@HRK_ISLTIP,@HRK_ISLTIPAD,@HRK_ISLHRK,
       @HRK_ISLHRKAD,@HRK_YERTIP,@HRK_YERAD,@HRK_BELNO,@HRK_ACK,@HRK_KULAD,
       @HRK_GIREN,@HRK_CIKAN,@BAK_BAKIYE,
       @HRK_REMOTE_ID,@HRK_DVZ,@HRK_UNVAN,@HRK_CARKOD)


       FETCH NEXT FROM CRS_KASA_HRK INTO
       @HRK_ID,@HRK_FIRMANO,@HRK_KSID,@HRK_FISFATTIP,@HRK_FISFATID,
       @HRK_TARIH,@HRK_SAAT,@HRK_KASKOD,@HRK_GCTIP,@HRK_VAROK,
       @HRK_SIL,@HRK_VARNO,@HRK_MASID,@HRK_ISLTIP,@HRK_ISLTIPAD,@HRK_ISLHRK,
       @HRK_ISLHRKAD,@HRK_YERTIP,@HRK_YERAD,@HRK_BELNO,@HRK_ACK,@HRK_KULAD,
       @HRK_GIREN,@HRK_CIKAN,
       @HRK_REMOTE_ID,@HRK_DVZ,@HRK_UNVAN,@HRK_CARKOD
      END

     CLOSE CRS_KASA_HRK
     DEALLOCATE CRS_KASA_HRK
    */ 
     
     update @TB_KASA_HRK_LISTE set firma_ad=dt.ad
      from @TB_KASA_HRK_LISTE as t join
      (select id,ad from Firma) dt on dt.id=t.firmano
     
     


RETURN
END

================================================================================
