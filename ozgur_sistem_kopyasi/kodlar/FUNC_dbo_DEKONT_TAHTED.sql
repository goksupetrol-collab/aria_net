-- Function: dbo.DEKONT_TAHTED
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.650837
================================================================================

CREATE FUNCTION [dbo].DEKONT_TAHTED (@islmtip varchar(10),
@islmhrk varchar(10),@hrkid float)
RETURNS
  @TB_CARI_DEKONT TABLE (
    KART_TIP            VARCHAR(30)  COLLATE Turkish_CI_AS,
    KART_KOD            VARCHAR(30)  COLLATE Turkish_CI_AS,
    KART_UNVAN          VARCHAR(150)  COLLATE Turkish_CI_AS,
    CARI_TIP    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    CARI_ADRES1  		VARCHAR(150) COLLATE Turkish_CI_AS,
    CARI_ADRES2  		VARCHAR(150) COLLATE Turkish_CI_AS,
    CARI_TEL     		VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_CEP     		VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_FAX     		VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_VERGIDAIRE 	VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_VERGINO 		VARCHAR(50) COLLATE Turkish_CI_AS,    
    TARIH       DATETIME,
    SAAT        VARCHAR(20) COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(50) COLLATE Turkish_CI_AS,
    PARABIRIM   VARCHAR(20) COLLATE Turkish_CI_AS,
    PARASTR     VARCHAR(70) COLLATE Turkish_CI_AS,
    ISLEM       VARCHAR(30) COLLATE Turkish_CI_AS,
    ACK         VARCHAR(100) COLLATE Turkish_CI_AS,
    TUTAR       FLOAT,
    VADTAR      DATETIME,
    FIS_BAKIYE  FLOAT,
    CAR_BAKIYE  FLOAT,
    TOP_BAKIYE  FLOAT)
AS
BEGIN
   DECLARE @EKSTRE_TEMP TABLE (
    KART_TIP            VARCHAR(30)  COLLATE Turkish_CI_AS,
    KART_KOD            VARCHAR(30)  COLLATE Turkish_CI_AS,
    KART_UNVAN          VARCHAR(150)  COLLATE Turkish_CI_AS,
    CARI_TIP            VARCHAR(30)  COLLATE Turkish_CI_AS,
    CARI_KOD     		VARCHAR(30)  COLLATE Turkish_CI_AS,
    CARI_UNVAN  		VARCHAR(150) COLLATE Turkish_CI_AS,
    CARI_ADRES1  		VARCHAR(150) COLLATE Turkish_CI_AS,
    CARI_ADRES2  		VARCHAR(150) COLLATE Turkish_CI_AS,
    CARI_TEL     		VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_CEP     		VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_FAX     		VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_VERGIDAIRE 	VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_VERGINO 		VARCHAR(50) COLLATE Turkish_CI_AS,
    TARIH       		DATETIME,
    SAAT        		VARCHAR(20) COLLATE Turkish_CI_AS,
    BELGENO     		VARCHAR(50) COLLATE Turkish_CI_AS,
    PARABIRIM   		VARCHAR(20) COLLATE Turkish_CI_AS,
    PARASTR     		VARCHAR(70) COLLATE Turkish_CI_AS,
    ISLEM       		VARCHAR(20) COLLATE Turkish_CI_AS,
    ACK         		VARCHAR(100) COLLATE Turkish_CI_AS,
    TUTAR       		FLOAT,
    VADTAR      		DATETIME,
    FIS_BAKIYE  		FLOAT,
    CAR_BAKIYE  		FLOAT,
    TOP_BAKIYE  		FLOAT)


  DECLARE @HRK_KART_TIP             VARCHAR(30)
  DECLARE @HRK_KART_KOD     		VARCHAR(30)
  DECLARE @HRK_KART_UNVAN   		VARCHAR(150)


  DECLARE @HRK_CARI_TIP             VARCHAR(30)
  DECLARE @HRK_CARI_KOD     		VARCHAR(30)
  DECLARE @HRK_CARI_UNVAN   		VARCHAR(150)
  DECLARE @HRK_CARI_ADRES1  		VARCHAR(150)
  DECLARE @HRK_CARI_ADRES2  		VARCHAR(150)  
  DECLARE @HRK_CARI_TEL     		VARCHAR(50)    
  DECLARE @HRK_CARI_FAX     		VARCHAR(50)    
  DECLARE @HRK_CARI_CEP     		VARCHAR(50)    
  DECLARE @HRK_CARI_VERGINO 		VARCHAR(50)    
  DECLARE @HRK_CARI_VERGIDAIRE 		VARCHAR(50) 
  DECLARE @HRK_TARIH        		DATETIME
  DECLARE @HRK_SAAT         		VARCHAR(20)
  DECLARE @HRK_BELGENO      		VARCHAR(50)
  DECLARE @HRK_PARABIRIM    		VARCHAR(20)
  DECLARE @HRK_PARASTR      		VARCHAR(70)
  DECLARE @HRK_ISLEM        		VARCHAR(20)
  DECLARE @HRK_ACK          		VARCHAR(100)
  DECLARE @HRK_TUTAR        		FLOAT
  DECLARE @HRK_VADTAR       		DATETIME
  DECLARE @HRK_FISBAKIYE    		FLOAT
  DECLARE @HRK_CARBAKIYE    		FLOAT
  DECLARE @HRK_TOPBAKIYE    		FLOAT
  

/*NAKIT TAHSILAT VE ODEME */
  if ((@islmtip='TAH') OR (@islmtip='ODE')) AND (@islmhrk='NAK')
   DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     select 
     'kasakart',hrk.kaskod,'',
     hrk.cartip as CARI_TIP,hrk.carkod as CARI_KOD,
     '','','','','','','','',
     tarih AS TARIH,saat AS SAAT,
     belno AS BELGENO,hrk.ack,abs(giren-cikan) as TUTAR,PARABRM,
     dbo.ParaOku(ABS(giren-cikan)) as PARASTR,
     case when giren>0 then 'TAHSİLAT' else 'ÖDEME' end as ISLEM,
     tarih AS VADTAR,
     0,0,0
     from kasahrk hrk
     /*inner join View_Cariler_Kart_Bakiye as car */
    /* on hrk.carkod=car.kod and hrk.cartip=car.cartp  */
     where kashrkid=@hrkid
 /*POS TAHSILAT */
   if (@islmtip='TAH') AND (@islmhrk='POS')
     DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     select 
     'poskart',hrk.poskod,'',
     hrk.cartip as CARI_TIP,hrk.carkod as CARI_KOD,
     '','','','','','','','',
     tarih AS TARIH,saat AS SAAT,
     belno AS BELGENO,hrk.ack,abs(giren-cikan) as TUTAR,PARABRM,
     dbo.ParaOku(ABS(giren-cikan)) as PARASTR,
     case when giren>0 then 'TAHSİLAT' else 'ÖDEME' end as ISLEM,
     vadetar as VADTAR,
     0,0,0
     from poshrk hrk 
     /*left join View_Cariler_Kart_Bakiye as car */
     /*on hrk.carkod=car.kod and hrk.cartip=car.cartp  */
     where poshrkid=@hrkid

   /*banka dekont */
   if (@islmtip='BNK') 
     DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     select 
     case when hrk.cartip='kasakart' then 'kasakart' else 'bankakart' end,
     case when hrk.cartip='kasakart' then hrk.carkod else hrk.bankod end,
     '',
     case when hrk.cartip='kasakart' then 'bankakart' else hrk.cartip end,
     /*car.cartp as CARI_TIP, */
     case when hrk.cartip='kasakart' then hrk.bankod else hrk.carkod end,
     /*car.kod as CARI_KOD, */
     '','','','','','','','',
     tarih AS TARIH,saat AS SAAT,
     belno AS BELGENO,hrk.ack,abs(borc-alacak) as TUTAR,PARABRM,
     dbo.ParaOku(ABS(borc-alacak)) as PARASTR,
     case when alacak>0 then 'TAHSİLAT' else 'ÖDEME' end as ISLEM,
     NULL AS VADTAR,
     0,0,0 from
     bankahrk hrk 
     /*inner join View_Cariler_Kart_Bakiye as car */
     /*on hrk.carkod=car.kod and hrk.cartip=car.cartp where  */
     where bankhrkid=@hrkid
     
     
  

   /*kredi kart dekont */
    if (@islmtip='ODE') AND (@islmhrk='IKK')
     DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     select 
     'istkart',hrk.istkkod,'',
     hrk.cartip as CARI_TIP,hrk.carkod as CARI_KOD,
     '','','','','','','','',
     tarih AS TARIH,saat AS SAAT,
     belno AS BELGENO,hrk.ack,abs(borc-alacak) as TUTAR,PARABRM,
     dbo.ParaOku(ABS(borc-alacak)) as PARASTR,
     case when Borc>0 then 'TAHSİLAT' else 'ÖDEME' end as ISLEM,
     vadetar as VADTAR,
     0,0,0 from
     istkhrk hrk 
     /*inner join View_Cariler_Kart_Bakiye as car */
     /*on hrk.carkod=car.kod and hrk.cartip=car.cartp  */
     where istkhrkid=@hrkid

   /*cek dekont */
    if (@islmtip='CEK') 
     DECLARE CRS_HRK CURSOR FAST_FORWARD FOR
     select 
     'cekkart','','',
     hrk.cartip as CARI_TIP,hrk.carkod as CARI_KOD,
     '','','','','','','','',
     tarih AS TARIH,saat AS SAAT,
     ceksenno AS BELGENO,hrk.ack,abs(giren-cikan) as TUTAR,PARABRM,
     dbo.ParaOku(ABS(giren-cikan)) as PARASTR,
     case when giren>0 then 'TAHSİLAT' else 'ÖDEME' end as ISLEM,
     vadetar as VADTAR,
     0,0,0  from
     cekkart hrk 
     /*inner join View_Cariler_Kart_Bakiye as car */
     /*on hrk.carkod=car.kod and hrk.cartip=car.cartp  */
     where cekid=@hrkid


   OPEN CRS_HRK

 FETCH NEXT FROM CRS_HRK INTO
   @HRK_KART_TIP,@HRK_KART_KOD,@HRK_KART_UNVAN,
   @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,
   @HRK_CARI_ADRES1,@HRK_CARI_ADRES2,@HRK_CARI_TEL,@HRK_CARI_CEP,
   @HRK_CARI_FAX,@HRK_CARI_VERGINO,@HRK_CARI_VERGIDAIRE,
   @HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,
   @HRK_ACK,@HRK_TUTAR,@HRK_PARABIRIM,@HRK_PARASTR,@HRK_ISLEM,@HRK_VADTAR,
   @HRK_FISBAKIYE,@HRK_CARBAKIYE,@HRK_TOPBAKIYE

  WHILE @@FETCH_STATUS = 0
  BEGIN

    INSERT @EKSTRE_TEMP
      SELECT
       @HRK_KART_TIP,@HRK_KART_KOD,@HRK_KART_UNVAN,
       @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,
       @HRK_CARI_ADRES1,@HRK_CARI_ADRES2,@HRK_CARI_TEL,@HRK_CARI_CEP,
       @HRK_CARI_FAX,@HRK_CARI_VERGINO,@HRK_CARI_VERGIDAIRE,
       @HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,
       @HRK_PARABIRIM,@HRK_PARASTR,@HRK_ISLEM,@HRK_ACK,@HRK_TUTAR,@HRK_VADTAR,
       @HRK_FISBAKIYE,@HRK_CARBAKIYE,@HRK_TOPBAKIYE

    FETCH NEXT FROM CRS_HRK INTO
    @HRK_KART_TIP,@HRK_KART_KOD,@HRK_KART_UNVAN,
    @HRK_CARI_TIP,@HRK_CARI_KOD,@HRK_CARI_UNVAN,
    @HRK_CARI_ADRES1,@HRK_CARI_ADRES2,@HRK_CARI_TEL,@HRK_CARI_CEP,
   @HRK_CARI_FAX,@HRK_CARI_VERGINO,@HRK_CARI_VERGIDAIRE,
    @HRK_TARIH,@HRK_SAAT,@HRK_BELGENO,
    @HRK_ACK,@HRK_TUTAR,@HRK_PARABIRIM,@HRK_PARASTR,@HRK_ISLEM,@HRK_VADTAR,
    @HRK_FISBAKIYE,@HRK_CARBAKIYE,@HRK_TOPBAKIYE
  END

  CLOSE CRS_HRK
  DEALLOCATE CRS_HRK
  /*---------------------------------------------------------------------------- */




   update @EKSTRE_TEMP set KART_UNVAN=dt.AD
   FROM @EKSTRE_TEMP AS T join
   (select cartp,kod,ad from genel_kart) dt
   on dt.cartp=t.KART_TIP and dt.kod=t.KART_KOD
   
   
   update @EKSTRE_TEMP set 
   CARI_UNVAN=dt.AD,
   CARI_ADRES1=dt.adres,
   CARI_ADRES2=dt.adres2,
   CARI_TEL=dt.tel,
   CARI_CEP=DT.cep,
   CARI_FAX=DT.fax,
   CARI_VERGINO=DT.vergino,
   CARI_VERGIDAIRE=DT.vergidaire,
   FIS_BAKIYE=fisbak,
   CAR_BAKIYE=carbak,
   TOP_BAKIYE=topbak  
   FROM @EKSTRE_TEMP AS T join
   (select cartp,kod,ad,adres,adres2,tel,cep,fax,
    vergino,vergidaire,fisbak,carbak,topbak 
    from View_Cariler_Kart_Bakiye) dt
    on dt.cartp=t.CARI_TIP and dt.kod=t.CARI_KOD
   
   

     

  INSERT @TB_CARI_DEKONT
    SELECT * FROM @EKSTRE_TEMP

  RETURN
END

================================================================================
