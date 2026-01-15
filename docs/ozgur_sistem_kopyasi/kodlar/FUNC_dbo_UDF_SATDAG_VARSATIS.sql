-- Function: dbo.UDF_SATDAG_VARSATIS
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.764434
================================================================================

CREATE FUNCTION [dbo].[UDF_SATDAG_VARSATIS] 
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
     declare @Gun_ORT    float
     declare @gun_say	   int
     declare @parentid	   int
     

     set @parentid=@id 
   
      insert into @TABLE_SAT_DAG 
      (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@parentid,0,@GRP_ID,'SATIŞLAR',0,0,0,0)
     

 
 /* AKARYAKIT  SATIS */
      set @id=@id+1
 
      insert into @TABLE_SAT_DAG 
      (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@id,@parentid,@GRP_ID,'AKARYAKIT SATIŞLARI',0,0,0,0)


      SELECT 
       @gun_say=isnull(DATEDIFF(day,@BAS_TAR,@BIT_TAR)+1,1),
       @top_tutar=isnull(SUM(
       CASE 
       WHEN @KDVTIP=1 then h.TUTAR
       WHEN @KDVTIP=0 then (h.TUTAR/(1+h.kdvyuz)) end),0) FROM  
       pomvardisayac as h 
       inner join pomvardimas as m 
       on h.varno=m.varno and m.sil=0 and h.sil=0
       where m.tarih>=@BAS_TAR and m.tarih<=@BIT_TAR
       and m.varok=1
    
      update @TABLE_SAT_DAG set 
      GUN_SAY=@gun_say,
      TUTAR=@top_tutar,
      GUN_ORT=@top_tutar/@gun_say
       WHERE Id=@id
 
 
 
   set @id=@id+1


     /* MARKET SATIS */


      insert into @TABLE_SAT_DAG 
      (ID,PARENTID,GRP_ID,ACK,GUN_SAY,GUN_ORT,TUTAR,YUZDE)
       VALUES (@id,@parentid,@GRP_ID,'MARKET SATIŞLARI',0,0,0,0)


      SELECT 
       @gun_say=isnull(DATEDIFF(day,@BAS_TAR,@BIT_TAR)+1,1),
       @top_tutar=isnull(SUM(
       CASE 
       WHEN (@KDVTIP=1) and (h.islmtip='satis') then  (h.mik*h.brmfiy)
       WHEN (@KDVTIP=1) and (h.islmtip='iade') then -1*(h.mik*h.brmfiy)
       WHEN (@KDVTIP=0) and (h.islmtip='satis') then 
       ((h.mik*h.brmfiy) / (1+h.kdvyuz))
       WHEN (@KDVTIP=0) and (h.islmtip='iade') then 
       -1*((h.mik*h.brmfiy) / (1+h.kdvyuz))
       end),0) 
       
       FROM  
       marsathrk as h
       inner join marvardimas as m 
       on h.varno=m.varno and m.sil=0 and h.sil=0
       where m.tarih>=@BAS_TAR and m.tarih<=@BIT_TAR
       and m.varok=1
       
    
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
      
    

  
      UPDATE @TABLE_SAT_DAG 
      SET GUN_SAY=@gun_say,
      GUN_ORT=case when @top_tutar>0 then 
      (@top_tutar/@gun_say) else 0 end,
      TUTAR=@top_tutar,
      YUZDE=100 where PARENTID=0
      
     
       
       
       
       
       
       
   RETURN



END

================================================================================
