-- Function: dbo.UDF_SATDAG_NAK_ODEME
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.764034
================================================================================

CREATE FUNCTION [dbo].[UDF_SATDAG_NAK_ODEME] 
(@FIRMA_NO       	INT,
 @id			   	INT,
 @GRP_ID			INT,
 @BAS_TAR          	DATETIME,
 @BIT_TAR          	DATETIME,
 @KDVTIP			INT)
RETURNS

  @TABLE_SAT_DAG TABLE (
   ID					int,
   PARENTID				int,
   GRP_ID				INT,
   ACK					VARCHAR(100) COLLATE Turkish_CI_AS,
   GUN_SAY				INT,
   GUN_ORT			    Float,
   TUTAR				Float,
   YUZDE				FLOAT)
AS
BEGIN
 


   

     declare @top_tutar    float
     declare @gun_say	   int
     declare @cartip	   varchar(50)
     
     
     declare @parentid	   int
     

     set @parentid=@id 
   
      insert into @TABLE_SAT_DAG 
      (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@parentid,0,@GRP_ID,'NAKİT ÇIKIŞLARI',0,0,0,0)

     set @id=@id+1
  
    /*- FATURA ALIS */
 
      insert into @TABLE_SAT_DAG 
      (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@id,@parentid,@GRP_ID,'SATIN ALIMLAR (ALIM FATURALARI)',0,0,0,0)


       SELECT 
       @gun_say=isnull(DATEDIFF(day,@BAS_TAR,@BIT_TAR)+1,1),
       @top_tutar=
       case 
       when @KDVTIP=1 then isnull(SUM(h.genel_top),0) 
       when @KDVTIP=0 then isnull(SUM(h.genel_net_top),0)
       end      
       FROM  
       faturamas as h 
       where h.tarih>=@BAS_TAR and h.tarih<=@BIT_TAR
       and h.sil=0

       
      update @TABLE_SAT_DAG set 
      GUN_SAY=@gun_say,
      TUTAR=@top_tutar,
      GUN_ORT=@top_tutar/@gun_say
        WHERE Id=@id
      
      
     
   /* MAAS VE UCRET */
   
   
     set @id=@id+1



      select @cartip=CarTip_Id from Rapor_Grup_Kriter
      where rap_kod='SATIS_DAGILIM' AND id=1
      
      select @cartip=kod from Cari_Tip
      where id=@cartip

       insert into @TABLE_SAT_DAG 
       (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@id,@parentid,@GRP_ID,'MAAS VE UCRETLER',0,0,0,0)
       SELECT 
        @top_tutar=isnull(SUM(h.borc),0) FROM  
        carihrk as h 
        where 
        h.tarih>=@BAS_TAR and h.tarih<=@BIT_TAR
        and h.sil=0 and h.cartip=@cartip 
        and carkod in 
        (select kart_kod from Rapor_Hrk_Kriter 
        where rap_kod='SATIS_DAGILIM' AND grp_Id=1)
        
    
       update @TABLE_SAT_DAG set 
        GUN_SAY=@gun_say,
        TUTAR=@top_tutar,
        GUN_ORT=@top_tutar/@gun_say
       WHERE Id=@id
      
   
   
     /* KIRALAR  */
   
   
     set @id=@id+1

     select @cartip=CarTip_Id from Rapor_Grup_Kriter
      where rap_kod='SATIS_DAGILIM' AND id=2
      
      select @cartip=kod from Cari_Tip
      where id=@cartip

       insert into @TABLE_SAT_DAG 
       (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@id,@parentid,@GRP_ID,'KIRALAR',0,0,0,0)
       SELECT 
        @top_tutar=isnull(SUM(h.borc),0) FROM  
        carihrk as h 
        where 
        h.tarih>=@BAS_TAR and h.tarih<=@BIT_TAR
        and h.sil=0 and h.cartip=@cartip 
        and carkod in 
        (select kart_kod from Rapor_Hrk_Kriter 
        where rap_kod='SATIS_DAGILIM' AND grp_Id=2)
        
    
       update @TABLE_SAT_DAG set 
        GUN_SAY=@gun_say,
        TUTAR=@top_tutar,
        GUN_ORT=@top_tutar/@gun_say
       WHERE Id=@id
   
   
   
      
     /* İŞLETME  */
  
     set @id=@id+1

     select @cartip=CarTip_Id from Rapor_Grup_Kriter
      where rap_kod='SATIS_DAGILIM' AND id=3
      
      select @cartip=kod from Cari_Tip
      where id=@cartip

       insert into @TABLE_SAT_DAG 
       (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@id,@parentid,@GRP_ID,'IŞLETME GIDERLERI',0,0,0,0)
       SELECT 
        @top_tutar=isnull(SUM(h.borc),0) FROM  
        carihrk as h 
        where 
        h.tarih>=@BAS_TAR and h.tarih<=@BIT_TAR
        and h.sil=0 and h.cartip=@cartip 
        and carkod in 
        (select kart_kod from Rapor_Hrk_Kriter 
        where rap_kod='SATIS_DAGILIM' AND grp_Id=3)
        
    
       update @TABLE_SAT_DAG set 
        GUN_SAY=@gun_say,
        TUTAR=@top_tutar,
        GUN_ORT=@top_tutar/@gun_say
       WHERE Id=@id
       
       
       
       
   /* VERGI  */
  
     set @id=@id+1

     select @cartip=CarTip_Id from Rapor_Grup_Kriter
      where rap_kod='SATIS_DAGILIM' AND id=4
      
      select @cartip=kod from Cari_Tip
      where id=@cartip

       insert into @TABLE_SAT_DAG 
       (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@id,@parentid,@GRP_ID,'VERGI ODEMELERI',0,0,0,0)
       SELECT 
        @top_tutar=isnull(SUM(h.borc),0) FROM  
        carihrk as h 
        where 
        h.tarih>=@BAS_TAR and h.tarih<=@BIT_TAR
        and h.sil=0 and h.cartip=@cartip 
        and carkod in 
        (select kart_kod from Rapor_Hrk_Kriter 
        where rap_kod='SATIS_DAGILIM' AND grp_Id=4)
        
    
       update @TABLE_SAT_DAG set 
        GUN_SAY=@gun_say,
        TUTAR=@top_tutar,
        GUN_ORT=@top_tutar/@gun_say
       WHERE Id=@id
      
 

  /* FAIZ  */
  
     set @id=@id+1

     select @cartip=CarTip_Id from Rapor_Grup_Kriter
      where rap_kod='SATIS_DAGILIM' AND id=5
      
      select @cartip=kod from Cari_Tip
      where id=@cartip

       insert into @TABLE_SAT_DAG 
       (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@id,@parentid,@GRP_ID,'FAIZ GİDERLERİ',0,0,0,0)
       SELECT 
        @top_tutar=isnull(SUM(h.borc),0) FROM  
        carihrk as h 
        where 
        h.tarih>=@BAS_TAR and h.tarih<=@BIT_TAR
        and h.sil=0 and h.cartip=@cartip 
        and carkod in 
        (select kart_kod from Rapor_Hrk_Kriter 
        where rap_kod='SATIS_DAGILIM' AND grp_Id=5)
        
    
       update @TABLE_SAT_DAG set 
        GUN_SAY=@gun_say,
        TUTAR=@top_tutar,
        GUN_ORT=@top_tutar/@gun_say
       WHERE Id=@id
      



    
    /*TOPLAM */
   
     set @id=@id+1
  
      select @top_tutar=SUM(TUTAR),
      @gun_say=MAX(GUN_SAY) 
      from @TABLE_SAT_DAG 
      WHERE GRP_ID=@GRP_ID
  
  
  
      UPDATE @TABLE_SAT_DAG 
      SET YUZDE=case when @top_tutar>0 then 
      (TUTAR*100)/@top_tutar else 0 end 
      WHERE GRP_ID=@GRP_ID
      
          
      UPDATE @TABLE_SAT_DAG 
      SET GUN_SAY=@gun_say,
      GUN_ORT=case when @top_tutar>0 then 
      (@top_tutar/@gun_say) else 0 end,
      TUTAR=@top_tutar,
      YUZDE=100 where PARENTID=0
       
    
    
      
      
       
       
   RETURN



END

================================================================================
