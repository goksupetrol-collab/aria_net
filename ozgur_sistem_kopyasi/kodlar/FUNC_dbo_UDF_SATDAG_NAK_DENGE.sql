-- Function: dbo.UDF_SATDAG_NAK_DENGE
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.763207
================================================================================

CREATE FUNCTION [dbo].[UDF_SATDAG_NAK_DENGE] 
(@FIRMA_NO       	INT,
 @id			   	INT,
 @GRP_ID			INT,
 @BAS_TAR          	DATETIME,
 @BIT_TAR          	DATETIME,
 @FARK_TUT			FLOAT)
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
     declare @Gun_ORT    float
     declare @gun_say	   int
     declare @parentid	   int
     DECLARE @cartip		varchar(50)
     
     DECLARE @SAG_DENGE     FLOAT
     DECLARE @BNK_BORKUL    FLOAT
     DECLARE @BNK_BORODE    FLOAT
     

     set @parentid=@id 
   
      insert into @TABLE_SAT_DAG 
      (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@parentid,0,@GRP_ID,'NAKİT DENGE',0,0,0,100)
     

 
 /* NAKİT AKIMI */
      set @id=@id+1
 
      insert into @TABLE_SAT_DAG 
      (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@id,@parentid,@GRP_ID,'NET NAKIT AKIMI',0,0,@FARK_TUT,0)


      
   set @id=@id+1


     /* BAŞLANGIÇ NAKIT DENGESI */


      insert into @TABLE_SAT_DAG 
      (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@id,@parentid,@GRP_ID,'BAŞLANGIÇ NAKIT DENGESI',0,0,0,0)


      SELECT 
       @gun_say=isnull(DATEDIFF(day,@BAS_TAR,@BIT_TAR)+1,1),
       @top_tutar= isnull(SUM((h.borc-h.alacak)*H.kur),0) 
       FROM  
       bankahrk as h
       inner join bankakart as m 
       on h.bankod=m.kod and 
       m.sil=0 and h.sil=0
       where h.tarih<=@BIT_TAR and m.drm='Aktif'
       
    
   
       SELECT 
       @gun_say=isnull(DATEDIFF(day,@BAS_TAR,@BIT_TAR)+1,1),
       @top_tutar=@top_tutar+isnull(SUM((h.giren-h.cikan)*H.kur),0) 
       FROM  
       kasahrk as h
       inner join kasakart as m 
       on h.kaskod=m.kod and 
       m.sil=0 and h.sil=0
       where h.tarih<=@BIT_TAR 
   
   
   
      update @TABLE_SAT_DAG set 
      GUN_SAY=@gun_say,
      TUTAR=@top_tutar,
      GUN_ORT=@top_tutar/@gun_say
       WHERE Id=@id
       
       
   /* SAĞLANABILEN DENGE       */

     set @id=@id+1
     
      SET @SAG_DENGE=@FARK_TUT+@top_tutar
      insert into @TABLE_SAT_DAG 
      (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@id,@parentid,@GRP_ID,'SAĞLANABILEN DENGE',0,0,
       @SAG_DENGE,0)
      
       
  
  /* BORC KULLANMA */
        
     set @id=@id+1

     select @cartip=CarTip_Id from Rapor_Grup_Kriter
      where rap_kod='SATIS_DAGILIM' AND id=6
      
      select @cartip=kod from Cari_Tip
      where id=@cartip

       insert into @TABLE_SAT_DAG 
       (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@id,@parentid,@GRP_ID,'BORÇ KULLANMA',0,0,0,0)
       SELECT 
        @top_tutar=isnull(SUM(h.borc*h.kur),0) FROM  
        bankahrk as h 
        where 
        h.tarih>=@BAS_TAR and h.tarih<=@BIT_TAR
        and h.sil=0 and h.bankod in 
        (select kart_kod from Rapor_Hrk_Kriter 
        where rap_kod='SATIS_DAGILIM' AND grp_Id=6)
        
    
  
     SET @BNK_BORKUL=@top_tutar
  
       update @TABLE_SAT_DAG set 
        GUN_SAY=@gun_say,
        TUTAR=@top_tutar,
        GUN_ORT=@top_tutar/@gun_say
       WHERE Id=@id    
       
       
    /* BORC ÖDEME */
        
     set @id=@id+1

     select @cartip=CarTip_Id from Rapor_Grup_Kriter
      where rap_kod='SATIS_DAGILIM' AND id=7
      
      select @cartip=kod from Cari_Tip
      where id=@cartip

       insert into @TABLE_SAT_DAG 
       (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@id,@parentid,@GRP_ID,'BORÇ ÖDEME',0,0,0,0)
       SELECT 
        @top_tutar=isnull(SUM(h.alacak*h.kur),0) FROM  
        bankahrk as h 
        where 
        h.tarih>=@BAS_TAR and h.tarih<=@BIT_TAR
        and h.sil=0 and h.bankod in 
        (select kart_kod from Rapor_Hrk_Kriter 
        where rap_kod='SATIS_DAGILIM' AND grp_Id=7)
        
    
  
     SET @BNK_BORODE=@top_tutar
  
       update @TABLE_SAT_DAG set 
        GUN_SAY=@gun_say,
        TUTAR=@top_tutar,
        GUN_ORT=@top_tutar/@gun_say
       WHERE Id=@id      
       
       
  
    /*TOPLAM */
   
      select @top_tutar=SUM(TUTAR),
      @gun_say=MAX(GUN_SAY) 
      from @TABLE_SAT_DAG 
      WHERE GRP_ID=@GRP_ID
  
  
  
      UPDATE @TABLE_SAT_DAG 
      SET YUZDE=case when @top_tutar>0 then 
      (TUTAR*100)/@top_tutar else 0 end 
      WHERE GRP_ID=@GRP_ID
      
    
     set @top_tutar=(@SAG_DENGE+@BNK_BORKUL)-@BNK_BORODE
  
      UPDATE @TABLE_SAT_DAG 
      SET GUN_SAY=@gun_say,
      GUN_ORT=case when @top_tutar>0 then 
      (@top_tutar/@gun_say) else 0 end,
      TUTAR=@top_tutar,
      YUZDE=100 where PARENTID=0
      
     
       
       
       
       
       
       
   RETURN



END

================================================================================
