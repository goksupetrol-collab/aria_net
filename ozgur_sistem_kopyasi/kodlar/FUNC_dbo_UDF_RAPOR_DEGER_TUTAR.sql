-- Function: dbo.UDF_RAPOR_DEGER_TUTAR
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.762806
================================================================================

CREATE FUNCTION [dbo].UDF_RAPOR_DEGER_TUTAR 
(@FIRMA_NO			INT,
 @RAP_KOD			VARCHAR(50),
 @ID				INT,
 @KAY_ID			INT,
 @BAS_TAR			DATETIME,
 @BIT_TAR			DATETIME)
 
RETURNS           	FLOAT
AS
BEGIN
   

     declare @DEGER     FLOAT
     declare @cartip	varchar(30)
     declare @cartip_Id	varchar(30)
     declare @DEGER_Tip	INT
     declare @Hrk_Tip	varchar(10)
     
     
     declare @STK_TIP     varchar(10)
     declare @STK_KOD	  varchar(50)
     
     
     
     declare @DEGER_BA	FLOAT
     declare @DEGER_MN	FLOAT
     
     declare @BFIYAT	FLOAT
     
     
     SET @DEGER=0
     
     set @DEGER_MN=0
     
     if @KAY_ID>0
      BEGIN
        SELECT @DEGER=DEGER FROM Rapor_Deger
        WHERE KAY_Id=@KAY_ID and 
        table_name='Rapor_Grup_Kriter' 
        and table_Id=@ID
      
        RETURN @DEGER
      END
     
      select @cartip_Id=CarTip_Id,
       @DEGER_Tip=DEGER_Tip,
       @Hrk_Tip=Hrk_Tip
       
       from Rapor_Grup_Kriter
        where rap_kod=@RAP_KOD AND id=@ID
      
       select @cartip=kod from Cari_Tip
        where id=@cartip_Id  
        
    IF @Hrk_Tip='CTK'
     BEGIN
         select @DEGER_BA=isnull(SUM(borc),0) from  
         Cek_Son_Drm (@FIRMA_NO,'TAK',@BAS_TAR,@BIT_TAR)
    
     END   
        
        
    IF @Hrk_Tip='CPR'
     BEGIN
         select @DEGER_BA=isnull(SUM(borc),0) from  
         Cek_Son_Drm (@FIRMA_NO,'POR',@BAS_TAR,@BIT_TAR)
    
     END        
             
     
    IF @Hrk_Tip='BAK'
     BEGIN
     /* CARI HRK      */
      if (@cartip_Id=1) or (@cartip_Id=2)
         or (@cartip_Id=3)
      begin   
       SELECT 
        @DEGER_BA=isnull(SUM(h.borc-h.alacak),0)
        FROM  carihrk as h 
        where 
        h.tarih>=@BAS_TAR and h.tarih<=@BIT_TAR
        and h.sil=0 and h.cartip=@cartip 
        and carkod in 
        (select kart_kod from Rapor_Hrk_Kriter 
        where rap_kod=@RAP_KOD AND grp_Id=@ID)
        
        
        if (@DEGER_Tip=3) 
         SELECT 
        @DEGER_BA=@DEGER_BA+isnull(SUM(
        CASE WHEN fistip='FISVERSAT' THEN 
        (h.toptut-h.isktop) else -1*(h.toptut-h.isktop) end),0)
        FROM  veresimas as h 
         where 
         h.tarih>=@BAS_TAR and h.tarih<=@BIT_TAR
         and h.sil=0 and h.aktip in ('BK','BL')
         and h.cartip=@cartip 
         and carkod in 
         (select kart_kod from Rapor_Hrk_Kriter 
         where rap_kod=@RAP_KOD AND grp_Id=@ID) 
   
        
       end 
        
        
      /* BANKA HRK      */
      if (@cartip_Id=4)
       SELECT 
        @DEGER_BA=isnull(SUM((h.borc-h.alacak)*h.kur),0)
        FROM  bankahrk as h 
        where 
        h.tarih>=@BAS_TAR and h.tarih<=@BIT_TAR
        and h.sil=0 and h.bankod in 
        (select kart_kod from Rapor_Hrk_Kriter 
        where rap_kod=@RAP_KOD AND grp_Id=@ID)     
        
        
        
      /* POS HRK      */
      if (@cartip_Id=5)
       SELECT
        @DEGER_BA=isnull(SUM((h.giren-h.cikan)*h.kur),0)
        FROM  poshrk as h 
        where 
        h.tarih>=@BAS_TAR and h.tarih<=@BIT_TAR
        and h.sil=0 and aktip in ('BK') and 
        h.poskod in 
        (select kart_kod from Rapor_Hrk_Kriter 
        where rap_kod=@RAP_KOD AND grp_Id=@ID)     
        
     
        
       /* KASA HRK      */
       if (@cartip_Id=8)
        SELECT 
        @DEGER_BA=isnull(SUM((h.giren-h.cikan)*h.kur),0) 
        FROM  kasahrk as h 
        where 
        h.tarih>=@BAS_TAR and h.tarih<=@BIT_TAR
        and h.sil=0 and h.kaskod in 
        (select kart_kod from Rapor_Hrk_Kriter 
        where rap_kod=@RAP_KOD AND grp_Id=@ID)     
    
    END      
    
    
    IF @Hrk_Tip='KHA'
     BEGIN
        
       DECLARE @TB_STKHRK TABLE ( 
        STK_TIP			VARCHAR(50) COLLATE Turkish_CI_AS,
        STK_KOD			VARCHAR(50) COLLATE Turkish_CI_AS,
  		MIKTAR			FLOAT,
        BRMFYT    		FLOAT 
        PRIMARY KEY (STK_TIP,STK_KOD))
         
     
     
     
      if (@cartip_Id=10) or (@cartip_Id=11)
      BEGIN
      
        INSERT INTO @TB_STKHRK (STK_TIP,STK_KOD,MIKTAR,BRMFYT)
        SELECT 
         H.stktip,H.stkod,
         isnull( SUM(h.giren-h.cikan),0),0    
         FROM  STKHRK as h 
        where 
        h.tarih>=@BAS_TAR and h.tarih<=@BIT_TAR
        and h.sil=0 and h.stktip=@cartip 
        and h.stkod in 
        (select kart_kod from Rapor_Hrk_Kriter 
        where rap_kod=@RAP_KOD AND grp_Id=@ID)
        group by h.stktip,h.stkod 
      
        
   
      
      update @TB_STKHRK set BRMFYT=dt.tut from
      @TB_STKHRK as t JOIN
       (select STK_TIP,STK_KOD,(select Top 1 
                 (Hr.brmfiykdvli)/(1+hr.kdvyuz) as TUT 
                 from stkhrk as hr
                 where sil=0 and hr.tarih<=@BIT_TAR and hr.giren>0
                 and hr.stktip=k.STK_TIP and hr.stkod=k.STK_KOD
                 order by hr.tarih desc ) as tut
       from @TB_STKHRK as k ) dt on 
       dt.STK_TIP=t.STK_TIP and dt.STK_KOD=t.STK_KOD
      
    
        SELECT 
        @DEGER_BA=isnull(SUM(MIKTAR*BRMFYT),0) 
        FROM  @TB_STKHRK as h 
        
      END       
     
     
     
     
     
     
     END
    
    
    
        


     IF @DEGER_Tip=0
      BEGIN
       IF @DEGER_BA>0
         SET @DEGER=@DEGER_BA
      END 
       
     IF @DEGER_Tip=1
      BEGIN
       IF (@DEGER_BA)<0 
         SET @DEGER=-1*(@DEGER_BA)
      END 
   
     IF @DEGER_Tip=2
       SET @DEGER=@DEGER_MN
       
      IF @DEGER_Tip=3
      BEGIN
        SET @DEGER=(@DEGER_BA)
      END   
         
       
   
     RETURN @DEGER




END

================================================================================
