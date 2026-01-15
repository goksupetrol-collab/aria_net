-- Function: dbo.UDF_SATDAG_NAK_GIRIS
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.763631
================================================================================

CREATE FUNCTION [dbo].[UDF_SATDAG_NAK_GIRIS] 
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
     
     
     
     declare @parentid	   int
     

     set @parentid=@id 
   
      insert into @TABLE_SAT_DAG 
      (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@parentid,0,@GRP_ID,'NAKİT GIRIŞLERI',0,0,0,0)

  
     set @id=@id+1

 /*- PESIN SATIS  */
 
      insert into @TABLE_SAT_DAG 
      (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@id,@parentid,@GRP_ID,'PEŞİN SATIŞLAR',0,0,0,0)


       SELECT 
       @top_tutar=isnull(SUM(h.giren*h.KUR),0) FROM  
       kasahrk as h 
       inner join pomvardimas as m 
       on h.varno=m.varno and m.sil=0 and h.sil=0
       where m.tarih>=@BAS_TAR and m.tarih<=@BIT_TAR
       and h.yertip='pomvardimas' and h.islmhrk='TES' 
       and m.varok=1
       
       
       
       SELECT 
       @gun_say=isnull(DATEDIFF(day,@BAS_TAR,@BIT_TAR)+1,1),
       @top_tutar=@top_tutar+isnull(SUM(h.giren*h.KUR),0) FROM  
       kasahrk as h 
       inner join marvardimas as m 
       on h.varno=m.varno and m.sil=0 and h.sil=0
       where m.tarih>=@BAS_TAR and m.tarih<=@BIT_TAR
       and h.yertip='marvardimas' and h.islmhrk='TES'
        and m.varok=1
       
      update @TABLE_SAT_DAG set 
      GUN_SAY=@gun_say,
      TUTAR=@top_tutar,
      GUN_ORT=@top_tutar/@gun_say
        WHERE Id=@id
      
      
      
   /* POS SATIS */
   
   
     set @id=@id+1
 
       insert into @TABLE_SAT_DAG 
      (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@id,@parentid,@GRP_ID,'K.K (POS) SATIŞLAR',0,0,0,0)


       SELECT 
       @top_tutar=isnull(SUM(h.giren),0) FROM  
       poshrk as h 
       inner join pomvardimas as m 
       on h.varno=m.varno and m.sil=0 and h.sil=0
       where m.tarih>=@BAS_TAR and m.tarih<=@BIT_TAR
       and h.yertip='pomvardimas' and m.varok=1
       
       
       
       SELECT 
       @gun_say=isnull(DATEDIFF(day,@BAS_TAR,@BIT_TAR)+1,1),
       @top_tutar=@top_tutar+isnull(SUM(h.giren),0) FROM  
       poshrk as h 
       inner join marvardimas as m 
       on h.varno=m.varno and m.sil=0 and h.sil=0
       where m.tarih>=@BAS_TAR and m.tarih<=@BIT_TAR
       and h.yertip='marvardimas' and m.varok=1
       
       
       
    
      update @TABLE_SAT_DAG set 
      GUN_SAY=@gun_say,
      TUTAR=@top_tutar,
      GUN_ORT=@top_tutar/@gun_say
       WHERE Id=@id
      
      
      
      
      
    /* CARI SATIS */
   
   
     set @id=@id+1
 
       insert into @TABLE_SAT_DAG 
      (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@id,@parentid,@GRP_ID,'CARİ SATIŞLAR',0,0,0,0)


       SELECT 
       @top_tutar=isnull(SUM(h.toptut-ISNULL(h.isktop,0)),0) FROM  
       veresimas as h 
       inner join pomvardimas as m 
       on h.varno=m.varno and m.sil=0 and h.sil=0
       where m.tarih>=@BAS_TAR and m.tarih<=@BIT_TAR
       and h.yertip='pomvardimas' and m.varok=1
       and h.ototag=0
       
       
       
       SELECT 
       @gun_say=isnull(DATEDIFF(day,@BAS_TAR,@BIT_TAR)+1,1),
       @top_tutar=@top_tutar+isnull(SUM(h.toptut-ISNULL(h.isktop,0)),0) FROM  
       veresimas as h 
       inner join marvardimas as m 
       on h.varno=m.varno and m.sil=0 and h.sil=0
       where m.tarih>=@BAS_TAR and m.tarih<=@BIT_TAR
       and h.yertip='marvardimas' and m.varok=1
       and h.ototag=0     
       
       
    
      update @TABLE_SAT_DAG set 
      GUN_SAY=@gun_say,
      TUTAR=@top_tutar,
      GUN_ORT=@top_tutar/@gun_say
       WHERE Id=@id
         
     
     
     /* TTS SATIS */
   
   
     set @id=@id+1
 
       insert into @TABLE_SAT_DAG 
      (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@id,@parentid,@GRP_ID,'TTS SATIŞLAR',0,0,0,0)


       SELECT 
       @top_tutar=isnull(SUM(h.toptut-ISNULL(h.isktop,0)),0) FROM  
       veresimas as h 
       inner join pomvardimas as m 
       on h.varno=m.varno and m.sil=0 and h.sil=0
       where m.tarih>=@BAS_TAR and m.tarih<=@BIT_TAR
       and h.yertip='pomvardimas' and m.varok=1
       and h.ototag>0
       
    
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
