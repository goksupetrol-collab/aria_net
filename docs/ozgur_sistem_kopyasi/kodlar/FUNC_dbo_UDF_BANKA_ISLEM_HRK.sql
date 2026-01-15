-- Function: dbo.UDF_BANKA_ISLEM_HRK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.688543
================================================================================

CREATE FUNCTION [dbo].UDF_BANKA_ISLEM_HRK (
@firmano			int,
@BANK_KOD 			VARCHAR(50),
@TARIH1 			DATETIME,
@TARIH2				DATETIME,
@SILIN 				VARCHAR(20),
@DEVIR 				INT)
RETURNS
   @TB_BANK_EKSTRE TABLE (
    id          int     IDENTITY(1, 1) NOT NULL,
    Firmano     int,
    Firma_ad    VARCHAR(150) COLLATE Turkish_CI_AS,
    BANKA_KOD   VARCHAR(50) COLLATE Turkish_CI_AS,
    BANKA_AD    VARCHAR(150) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)  COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(50) COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(200) COLLATE Turkish_CI_AS,
    ISLTIP      VARCHAR(50)  COLLATE Turkish_CI_AS,
    ISLTIPAD    VARCHAR(50)  COLLATE Turkish_CI_AS,
    ISLHRK      VARCHAR(30)  COLLATE Turkish_CI_AS,
    ISLHRKAD    VARCHAR(50)  COLLATE Turkish_CI_AS,
    YERAD       VARCHAR(50)  COLLATE Turkish_CI_AS,
    YERTIP      VARCHAR(30)  COLLATE Turkish_CI_AS,
    KULAD       VARCHAR(70)  COLLATE Turkish_CI_AS,
    KULTAR      DATETIME,
    DVZ         VARCHAR(30)  COLLATE Turkish_CI_AS,
    VARNO       INT,
    VAROK       INT,
    SIL         INT,
    HRKID       FLOAT,
    MASID       FLOAT,
    BORC        DECIMAL(18,8),
    ALACAK      DECIMAL(18,8),
    BAKIYE      DECIMAL(18,8),
    REMOTE_ID   FLOAT,
    DEVIR       BIT,
    entegre_aktar    DATETIME)
AS
BEGIN
 

 DECLARE @SIL_TEMP TABLE (
 sil      int)

 declare @separator char(1)
  set @separator = ','

 declare @separator_position int
 declare @array_value varchar(1000)

 IF (LEN(RTRIM(@SILIN)) > 0)
 BEGIN
  set @SILIN = @SILIN + ','
 END

 while patindex('%,%' , @SILIN) <> 0
 begin

   select @separator_position =  patindex('%,%' , @SILIN)
   select @array_value = left(@SILIN, @separator_position - 1)

  Insert @SIL_TEMP
  Values (@array_value)

   select @SILIN = stuff(@SILIN, 1, @separator_position, '')
 end

 
  
  /*DECLARE @ONCEBKOD        VARCHAR(30) */
  
  DECLARE @ONDA_HANE       INT
  

 SELECT @ONDA_HANE=PARA_ondalik from sistemtanim


  /*SET @KUM_BAKIYE = 0 */
  
  /*SET @ONCEBKOD='' */
  
  /*-devir */
  
    
    IF @BANK_KOD=''
    begin
      
    IF @DEVIR=1
     begin 
      if @firmano=0
       insert @TB_BANK_EKSTRE
       (Firmano,Firma_Ad,BANKA_KOD,BANKA_AD,CARI_KOD,CARI_TIP,CARI_UNVAN,
       TARIH,SAAT,BELGENO,ACIKLAMA,ISLTIP,ISLTIPAD,ISLHRK,ISLHRKAD,
       YERAD,YERTIP,KULAD,KULTAR,DVZ,SIL,VARNO,VAROK,HRKID,MASID,
       BORC,ALACAK,BAKIYE,REMOTE_ID,DEVIR)
       SELECT
       @firmano,'','','','','','',
       DATEADD(day,-1,@TARIH1),'00:00:00','DEVIR','DEVIR',
       'DEV','DEVIR','-','-',
       '-','-','-',NULL,'-',
       0,0,0,0,0,
       isnull(sum(round(h.borc,@ONDA_HANE)),0),
       isnull(sum(round(h.alacak,@ONDA_HANE)),0),
       isnull(sum(round(h.borc-h.alacak,@ONDA_HANE)),0),
       0,1
       from bankahrk as h with (nolock)  where 
       /*h.bankod=@HRK_BANK_KOD and  */
       h.sil=0 and tarih < @TARIH1
       
          
      if @firmano>0             
      insert @TB_BANK_EKSTRE
       (Firmano,Firma_Ad,BANKA_KOD,BANKA_AD,CARI_KOD,CARI_TIP,CARI_UNVAN,
       TARIH,SAAT,BELGENO,ACIKLAMA,ISLTIP,ISLTIPAD,ISLHRK,ISLHRKAD,
       YERAD,YERTIP,KULAD,KULTAR,DVZ,SIL,VARNO,VAROK,HRKID,MASID,
       BORC,ALACAK,BAKIYE,REMOTE_ID,DEVIR)
       SELECT
       @firmano,'','','','','','',
       DATEADD(day,-1,@TARIH1),'00:00:00','DEVIR','DEVIR',
       'DEV','DEVIR','-','-',
       '-','-','-',NULL,'-',
       0,0,0,0,0,
       isnull(sum(round(h.borc,@ONDA_HANE)),0),
       isnull(sum(round(h.alacak,@ONDA_HANE)),0),
       isnull(sum(round(h.borc-h.alacak,@ONDA_HANE)),0),
       0,1
       from bankahrk as h with (nolock) where (h.firmano=@firmano or h.firmano=0)
      /*and h.bankod=@HRK_BANK_KOD */
      and h.sil=0 and tarih < @TARIH1
    end 
    
    
    
    IF @DEVIR=2
     begin 
      if @firmano=0
       insert @TB_BANK_EKSTRE
       (Firmano,Firma_Ad,BANKA_KOD,BANKA_AD,CARI_KOD,CARI_TIP,CARI_UNVAN,
       TARIH,SAAT,BELGENO,ACIKLAMA,ISLTIP,ISLTIPAD,ISLHRK,ISLHRKAD,
       YERAD,YERTIP,KULAD,KULTAR,DVZ,SIL,VARNO,VAROK,HRKID,MASID,
       BORC,ALACAK,BAKIYE,REMOTE_ID,DEVIR)
       SELECT
       @firmano,'',h.bankod,b.ad,'','','',
       DATEADD(day,-1,@TARIH1),'00:00:00','DEVIR','DEVIR',
       'DEV','DEVIR','-','-',
       '-','-','-',NULL,'-',
       0,0,0,0,0,
       isnull(sum(round(h.borc,@ONDA_HANE)),0),
       isnull(sum(round(h.alacak,@ONDA_HANE)),0),
       isnull(sum(round(h.borc-h.alacak,@ONDA_HANE)),0),
       0,1
        from bankakart as b with (nolock) inner join bankahrk as h with (nolock)
       on h.bankod=b.kod and b.sil=0 
       where h.sil=0 and tarih < @TARIH1
       group by h.bankod,b.ad
       
          
      if @firmano>0             
      insert @TB_BANK_EKSTRE
       (Firmano,Firma_Ad,BANKA_KOD,BANKA_AD,CARI_KOD,CARI_TIP,CARI_UNVAN,
       TARIH,SAAT,BELGENO,ACIKLAMA,ISLTIP,ISLTIPAD,ISLHRK,ISLHRKAD,
       YERAD,YERTIP,KULAD,KULTAR,DVZ,SIL,VARNO,VAROK,HRKID,MASID,
       BORC,ALACAK,BAKIYE,REMOTE_ID,DEVIR)
       SELECT
       @firmano,'',h.bankod,b.ad,'','','',
       DATEADD(day,-1,@TARIH1),'00:00:00','DEVIR','DEVIR',
       'DEV','DEVIR','-','-',
       '-','-','-',NULL,'-',
       0,0,0,0,0,
       isnull(sum(round(h.borc,@ONDA_HANE)),0),
       isnull(sum(round(h.alacak,@ONDA_HANE)),0),
       isnull(sum(round(h.borc-h.alacak,@ONDA_HANE)),0),
       0,1
       from bankakart as b with (nolock) inner join bankahrk as h with (nolock)
       on h.bankod=b.kod and b.sil=0
       where (h.firmano=@firmano or h.firmano=0)
      /*and h.bankod=@HRK_BANK_KOD */
      and h.sil=0 and tarih < @TARIH1
       group by h.bankod,b.ad
    end 
    
               
     if @firmano=0
        insert @TB_BANK_EKSTRE
        (Firmano,Firma_Ad,BANKA_KOD,BANKA_AD,CARI_KOD,CARI_TIP,CARI_UNVAN,
        TARIH,SAAT,BELGENO,ACIKLAMA,ISLTIP,ISLTIPAD,ISLHRK,ISLHRKAD,
        YERAD,YERTIP,KULAD,KULTAR,DVZ,SIL,VARNO,VAROK,HRKID,MASID,
        BORC,ALACAK,BAKIYE,REMOTE_ID,DEVIR,entegre_aktar)
        SELECT  h.firmano,'',b.kod,b.ad,h.carkod,h.cartip,'',h.tarih,h.saat,
        h.belno,h.ack,h.islmtip,h.islmtipad,h.islmhrk,
        h.islmhrkad,h.yerad,h.yertip,
        h.olususer,h.olustarsaat,h.parabrm,h.sil,h.varno,h.varok,
        h.bankhrkid,h.masterid,
        round(h.borc,@ONDA_HANE),
        round(h.alacak,@ONDA_HANE),
        round(h.borc-h.alacak,@ONDA_HANE),
        h.remote_id,0,H.entegre_aktar
        from bankakart as b with (nolock) inner join bankahrk as h with (nolock)
        on h.bankod=b.kod and b.sil=0 and h.sil in (select * from @SIL_TEMP)
        where tarih  >= @TARIH1
        and tarih <= @TARIH2
        ORDER BY b.kod,tarih,saat
        
        
        if @firmano>0
        insert @TB_BANK_EKSTRE
        (Firmano,Firma_Ad,BANKA_KOD,BANKA_AD,CARI_KOD,CARI_TIP,CARI_UNVAN,
        TARIH,SAAT,BELGENO,ACIKLAMA,ISLTIP,ISLTIPAD,ISLHRK,ISLHRKAD,
        YERAD,YERTIP,KULAD,KULTAR,DVZ,SIL,VARNO,VAROK,HRKID,MASID,
        BORC,ALACAK,BAKIYE,REMOTE_ID,DEVIR,entegre_aktar)
        SELECT  h.firmano,'',b.kod,b.ad,h.carkod,h.cartip,'',h.tarih,h.saat,
        h.belno,h.ack,h.islmtip,h.islmtipad,h.islmhrk,
        h.islmhrkad,h.yerad,h.yertip,
        h.olususer,h.olustarsaat,h.parabrm,h.sil,
        h.varno,h.varok,h.bankhrkid,h.masterid,
        round(h.borc,@ONDA_HANE),
        round(h.alacak,@ONDA_HANE),
        round(h.borc-h.alacak,@ONDA_HANE),
        h.remote_id,0,h.entegre_aktar
        from bankakart as b with (nolock) inner join bankahrk as h with (nolock)
        on h.bankod=b.kod and b.sil=0 and h.sil in (select * from @SIL_TEMP)
        where (h.firmano=@firmano or h.firmano=0) and tarih  >= @TARIH1
        and tarih <= @TARIH2
        ORDER BY b.kod,tarih,saat    
        
        
    end

    IF @BANK_KOD<>''
     begin
      
      IF @DEVIR=1
        begin 
       if @firmano=0
       insert @TB_BANK_EKSTRE
       (Firmano,Firma_Ad,BANKA_KOD,BANKA_AD,CARI_KOD,CARI_TIP,CARI_UNVAN,
       TARIH,SAAT,BELGENO,ACIKLAMA,ISLTIP,ISLTIPAD,ISLHRK,ISLHRKAD,
       YERAD,YERTIP,KULAD,KULTAR,DVZ,SIL,VARNO,VAROK,HRKID,MASID,
       BORC,ALACAK,BAKIYE,REMOTE_ID,DEVIR)
       SELECT
       @firmano,'','','','','','',
       DATEADD(day,-1,@TARIH1),'00:00:00','DEVIR','DEVIR',
       'DEV','DEVIR','-','-',
       '-','-','-',NULL,'-',
       0,0,0,0,0,
       isnull(sum(round(h.borc,@ONDA_HANE)),0),
       isnull(sum(round(h.alacak,@ONDA_HANE)),0),
       isnull(sum(round(h.borc-h.alacak,@ONDA_HANE)),0),
       0,1
       from bankahrk as h with (nolock) where 
       h.bankod=@BANK_KOD and 
       h.sil=0 and tarih < @TARIH1
       
          
      if @firmano>0             
      insert @TB_BANK_EKSTRE
      (Firmano,Firma_Ad,BANKA_KOD,BANKA_AD,CARI_KOD,CARI_TIP,CARI_UNVAN,
       TARIH,SAAT,BELGENO,ACIKLAMA,ISLTIP,ISLTIPAD,ISLHRK,ISLHRKAD,
       YERAD,YERTIP,KULAD,KULTAR,DVZ,SIL,VARNO,VAROK,HRKID,MASID,
       BORC,ALACAK,BAKIYE,REMOTE_ID,DEVIR)
       SELECT
       @firmano,'','','','','','',
       DATEADD(day,-1,@TARIH1),'00:00:00','DEVIR','DEVIR',
       'DEV','DEVIR','-','-',
       '-','-','-',NULL,'-',
       0,0,0,0,0,
       isnull(sum(round(h.borc,@ONDA_HANE)),0),
       isnull(sum(round(h.alacak,@ONDA_HANE)),0),
       isnull(sum(round(h.borc-h.alacak,@ONDA_HANE)),0),
       0,1
       from bankahrk as h with (nolock) where (h.firmano=@firmano or h.firmano=0)
      and h.bankod=@BANK_KOD
      and h.sil=0 and tarih < @TARIH1
     end
     
     
       IF @DEVIR=2
        begin 
       if @firmano=0
       insert @TB_BANK_EKSTRE
       (Firmano,Firma_Ad,BANKA_KOD,BANKA_AD,CARI_KOD,CARI_TIP,CARI_UNVAN,
       TARIH,SAAT,BELGENO,ACIKLAMA,ISLTIP,ISLTIPAD,ISLHRK,ISLHRKAD,
       YERAD,YERTIP,KULAD,KULTAR,DVZ,SIL,VARNO,VAROK,HRKID,MASID,
       BORC,ALACAK,BAKIYE,REMOTE_ID,DEVIR)
       SELECT
       @firmano,'',b.kod,b.ad,'','','',
       DATEADD(day,-1,@TARIH1),'00:00:00','DEVIR','DEVIR',
       'DEV','DEVIR','-','-',
       '-','-','-',NULL,'-',
       0,0,0,0,0,
       isnull(sum(round(h.borc,@ONDA_HANE)),0),
       isnull(sum(round(h.alacak,@ONDA_HANE)),0),
       isnull(sum(round(h.borc-h.alacak,@ONDA_HANE)),0),
       0,1
        from bankakart as b with (nolock) inner join bankahrk as h with (nolock)
        on h.bankod=b.kod and b.sil=0 
        where 
        h.bankod=@BANK_KOD and 
        h.sil=0 and tarih < @TARIH1
        group by b.kod,b.ad
       
          
      if @firmano>0             
      insert @TB_BANK_EKSTRE
      (Firmano,Firma_Ad,BANKA_KOD,BANKA_AD,CARI_KOD,CARI_TIP,CARI_UNVAN,
       TARIH,SAAT,BELGENO,ACIKLAMA,ISLTIP,ISLTIPAD,ISLHRK,ISLHRKAD,
       YERAD,YERTIP,KULAD,KULTAR,DVZ,SIL,VARNO,VAROK,HRKID,MASID,
       BORC,ALACAK,BAKIYE,REMOTE_ID,DEVIR)
       SELECT
       @firmano,'',b.kod,b.ad,'','','',
       DATEADD(day,-1,@TARIH1),'00:00:00','DEVIR','DEVIR',
       'DEV','DEVIR','-','-',
       '-','-','-',NULL,'-',
       0,0,0,0,0,
       isnull(sum(round(h.borc,@ONDA_HANE)),0),
       isnull(sum(round(h.alacak,@ONDA_HANE)),0),
       isnull(sum(round(h.borc-h.alacak,@ONDA_HANE)),0),
       0,1
        from bankakart as b with (nolock) inner join bankahrk as h with (nolock)
        on h.bankod=b.kod and b.sil=0 
        where (h.firmano=@firmano or h.firmano=0)
      and h.bankod=@BANK_KOD
      and h.sil=0 and tarih < @TARIH1
      group by b.kod,b.ad
     end
     
     
     
     
       if @firmano=0
        insert @TB_BANK_EKSTRE
        (Firmano,Firma_Ad,BANKA_KOD,BANKA_AD,CARI_KOD,CARI_TIP,CARI_UNVAN,
        TARIH,SAAT,BELGENO,ACIKLAMA,ISLTIP,ISLTIPAD,ISLHRK,ISLHRKAD,
        YERAD,YERTIP,KULAD,KULTAR,DVZ,SIL,VARNO,VAROK,HRKID,MASID,
        BORC,ALACAK,BAKIYE,REMOTE_ID,DEVIR,entegre_aktar)
        SELECT  h.firmano,'',b.kod,b.ad,h.carkod,h.cartip,'',h.tarih,h.saat,
        h.belno,h.ack,h.islmtip,h.islmtipad,h.islmhrk,
        h.islmhrkad,h.yertip,h.yerad,
        h.olususer,h.olustarsaat,h.parabrm,h.sil,
        h.varno,h.varok,h.bankhrkid,h.masterid,
        round(h.borc,@ONDA_HANE),
        round(h.alacak,@ONDA_HANE),
        round(h.borc-h.alacak,@ONDA_HANE),
        h.remote_id,0,h.entegre_aktar
        from bankakart as b with (nolock) inner join bankahrk as h with (nolock)
        on h.bankod=b.kod and b.sil=0 and h.sil in (select * from @SIL_TEMP)
        and b.kod=@BANK_KOD
        where tarih >= @TARIH1
        and tarih  <= @TARIH2
        ORDER BY b.kod,tarih,saat
        
        if @firmano>0
        insert @TB_BANK_EKSTRE
        (Firmano,Firma_Ad,BANKA_KOD,BANKA_AD,CARI_KOD,CARI_TIP,CARI_UNVAN,
        TARIH,SAAT,BELGENO,ACIKLAMA,ISLTIP,ISLTIPAD,ISLHRK,ISLHRKAD,
        YERAD,YERTIP,KULAD,KULTAR,DVZ,SIL,VARNO,VAROK,HRKID,MASID,
        BORC,ALACAK,BAKIYE,REMOTE_ID,DEVIR,entegre_aktar)
        SELECT  h.firmano,'',b.kod,b.ad,h.carkod,h.cartip,'',h.tarih,h.saat,
        h.belno,h.ack,h.islmtip,h.islmtipad,h.islmhrk,
        h.islmhrkad,h.yertip,h.yerad,
        h.olususer,h.olustarsaat,h.parabrm,h.sil,
        h.varno,h.varok,h.bankhrkid,h.masterid,
        round(h.borc,@ONDA_HANE),
        round(h.alacak,@ONDA_HANE),
        round(h.borc-h.alacak,@ONDA_HANE),
        h.remote_id,0,h.entegre_aktar
        from bankakart as b with (nolock) inner join bankahrk as h with (nolock)
        on h.bankod=b.kod and b.sil=0 and h.sil in (select * from @SIL_TEMP)
        and b.kod=@BANK_KOD
        where (h.firmano=@firmano or h.firmano=0) and tarih >= @TARIH1
        and tarih  <= @TARIH2
        ORDER BY b.kod,tarih,saat  
        
        
     end
     

   update @TB_BANK_EKSTRE set CARI_UNVAN=dt.ad from @TB_BANK_EKSTRE as t join
   (select kod,ad,cartp from Genel_Kart with (nolock))
   dt on t.CARI_KOD=dt.kod and t.CARI_TIP=dt.cartp

   update @TB_BANK_EKSTRE set Firma_Ad=dt.ad from @TB_BANK_EKSTRE as t join
   (select id,ad from Firma with (nolock))
   dt on t.Firmano=dt.id



/*
  INSERT @TB_BANK_EKSTRE
    (Firmano,Firma_Ad,BANKA_KOD,BANKA_AD,CARI_KOD,CARI_TIP,CARI_UNVAN,
    TARIH,SAAT,BELGENO,ACIKLAMA,ISLTIP,ISLTIPAD,ISLHRK,ISLHRKAD,
    YERAD,YERTIP,KULAD,KULTAR,DVZ,SIL,VARNO,VAROK,HRKID,MASID,
    BORC,ALACAK,BAKIYE,REMOTE_ID,DEVIR)
    SELECT Firmano,Firma_Ad,BANKA_KOD,BANKA_AD,CARI_KOD,CARI_TIP,CARI_UNVAN,
    TARIH,SAAT,BELGENO,ACIKLAMA,ISLTIP,ISLTIPAD,ISLHRK,ISLHRKAD,
    YERAD,YERTIP,KULAD,KULTAR,DVZ,SIL,VARNO,VAROK,HRKID,MASID,
    BORC,ALACAK,BAKIYE,REMOTE_ID,DEVIR FROM @EKSTRE_TEMP 
*/



  RETURN

END

================================================================================
