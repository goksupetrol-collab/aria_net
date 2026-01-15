-- Function: dbo.UDF_ALS_SAT_KONSOLIDE_ALS
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.683795
================================================================================

CREATE FUNCTION [dbo].[UDF_ALS_SAT_KONSOLIDE_ALS]
(@FIRMA_NO          INT,
@id  				INT,
@BAS_TAR		   DATETIME,
@BIT_TAR		   DATETIME)
RETURNS
 @TB_ALS_SAT_BASLIK TABLE (
    ID					 INT,
    PARENTID			 INT,	
    GRPNO				 INT,
    TIP			 		 VARCHAR(50) COLLATE Turkish_CI_AS,
    ACK         		 VARCHAR(100) COLLATE Turkish_CI_AS,
    ALS_MIKTAR      	 FLOAT,
    SAT_MIKTAR      	 FLOAT,
    ALS_TUTAR   	     FLOAT,
    SAT_TUTAR        	 FLOAT)
 AS
 BEGIN   
 
   DECLARE @TB_ALS_SAT TABLE (
    FIRMA_NO			 VARCHAR(50) COLLATE Turkish_CI_AS,
    FIRMA_AD         VARCHAR(100) COLLATE Turkish_CI_AS,
    TIP				 VARCHAR(50) COLLATE Turkish_CI_AS,				 
    ACK       		 VARCHAR(100) COLLATE Turkish_CI_AS,
    GC			   	 INT,
    MIKTAR   	 	 FLOAT,
    TUTAR   	 	 FLOAT)
 
    
    
   insert into @TB_ALS_SAT (FIRMA_NO,FIRMA_AD,TIP,ACK,GC,MIKTAR,TUTAR)
   SELECT m.cartip,M.carkod,h.stktip,h.stkod,m.gctip,
   (mik*carpan),
   ( (h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut))
   *(1+h.kdvyuz)*(mik*carpan)
   FROM faturamas as m 
   inner join faturahrklistesi as h on m.fatid=h.fatid
   and m.sil=0 and h.sil=0
    where m.firmano=@FIRMA_NO and M.fattip='FATAKALS' and
    m.tarih>=@BAS_TAR and m.tarih<=@BIT_TAR
    and h.stktip in ('akykt')
    
    
    
      update @TB_ALS_SAT set ACK=dt.grp1 from @TB_ALS_SAT as t join
      (select tip,kod,grp1 from stokkart where tip='akykt') dt 
      on t.TIP=dt.tip and t.ACK=dt.kod
      
      update @TB_ALS_SAT set ACK=dt.ad from @TB_ALS_SAT as t join
      (select id,ad from grup ) dt 
      on t.ACK=dt.id
      
      update @TB_ALS_SAT set FIRMA_NO=dt.kod,FIRMA_AD=dt.ad from 
      @TB_ALS_SAT as t join
      (select cartp,kod,ad from Genel_Kart ) dt 
      on t.FIRMA_NO=dt.cartp and t.FIRMA_AD=dt.kod
  


  declare @grp1id int
  declare @grp2id int

  declare @KOD      varchar(100)
  declare @TIP      varchar(30)
  declare @GRP_AD   varchar(100)
  declare @GRP_ID  	varchar(50)

  
  declare @ALS_MIKTAR  	float
  declare @SAT_MIKTAR  	float
  declare @ALS_TUTAR  	float
  declare @SAT_TUTAR  	float
  
  
  set @grp1id=@id
    
  insert into @TB_ALS_SAT_BASLIK (ID,PARENTID,ACK,ALS_MIKTAR,SAT_MIKTAR,
  ALS_TUTAR,SAT_TUTAR)
  VALUES (@grp1id,0,'ALIŞ TOPLAMLAR',0,0,0,0)
  
   declare mas_cur CURSOR FAST_FORWARD  FOR 
    select FIRMA_NO,FIRMA_AD from @TB_ALS_SAT GROUP BY FIRMA_NO,FIRMA_AD
      open mas_cur
       fetch next from  mas_cur into @GRP_ID,@GRP_AD
        while @@FETCH_STATUS=0
         begin
           set @id=@id+1 
           set @grp2id=@id
     
            insert into @TB_ALS_SAT_BASLIK (ID,PARENTID,ACK,
            ALS_MIKTAR,SAT_MIKTAR,ALS_TUTAR,SAT_TUTAR)
            VALUES (@id,@grp1id,@GRP_AD,0,0,0,0)
   
             set @id=@id+1 
             
             
             
             declare gec_cur CURSOR FAST_FORWARD  FOR 
              select TIP,ACK,
              SUM(CASE WHEN GC=1 THEN MIKTAR ELSE 0 END),
              SUM(CASE WHEN GC=2 THEN MIKTAR ELSE 0 END),
              SUM(CASE WHEN GC=1 THEN TUTAR ELSE 0 END),
              SUM(CASE WHEN GC=2 THEN TUTAR ELSE 0 END)
              FROM @TB_ALS_SAT 
              WHERE FIRMA_NO=@GRP_ID
              GROUP BY TIP,ACK 
               open gec_cur
                fetch next from  gec_cur into @TIP,@KOD,
                @ALS_MIKTAR,@SAT_MIKTAR,@ALS_TUTAR,@SAT_TUTAR
                 while @@FETCH_STATUS=0
                  begin
                  
               
                 insert into @TB_ALS_SAT_BASLIK (ID,PARENTID,
                 TIP,ACK,ALS_MIKTAR,SAT_MIKTAR,ALS_TUTAR,SAT_TUTAR)
                 VALUES (@id,@grp2id,@TIP,@KOD,@ALS_MIKTAR,@SAT_MIKTAR,
                 @ALS_TUTAR,@SAT_TUTAR)

                set @id=@id+1  

             FETCH next from  gec_cur into @TIP,@KOD,@ALS_MIKTAR,@SAT_MIKTAR,
                @ALS_TUTAR,@SAT_TUTAR
           end
         close gec_cur
         deallocate gec_cur
         
         
         
          update @TB_ALS_SAT_BASLIK set 
           ALS_MIKTAR=isnull(dt.ALS_MIKTAR,0),
           SAT_MIKTAR=isnull(dt.SAT_MIKTAR,0),
           ALS_TUTAR=isnull(dt.ALS_TUTAR,0),
           SAT_TUTAR=isnull(dt.SAT_TUTAR,0)
            from @TB_ALS_SAT_BASLIK as t
           join (select 
           sum(ALS_MIKTAR) as ALS_MIKTAR,
           sum(SAT_MIKTAR) as SAT_MIKTAR,
           sum(ALS_TUTAR) as ALS_TUTAR,
           sum(SAT_TUTAR) as SAT_TUTAR          
           from @TB_ALS_SAT_BASLIK where PARENTID=@grp2id ) dt 
           on t.ID=@grp2id     
                   
                   
          FETCH next from  mas_cur into @GRP_ID,@GRP_AD
         end
        Close mas_cur
        deallocate mas_cur      
         
         
         
         update @TB_ALS_SAT_BASLIK set 
          ALS_MIKTAR=isnull(dt.ALS_MIKTAR,0),
           SAT_MIKTAR=isnull(dt.SAT_MIKTAR,0),
           ALS_TUTAR=isnull(dt.ALS_TUTAR,0),
           SAT_TUTAR=isnull(dt.SAT_TUTAR,0)
            from @TB_ALS_SAT_BASLIK as t
           join (select 
           sum(ALS_MIKTAR) as ALS_MIKTAR,
           sum(SAT_MIKTAR) as SAT_MIKTAR,
           sum(ALS_TUTAR) as ALS_TUTAR,
           sum(SAT_TUTAR) as SAT_TUTAR 
         from @TB_ALS_SAT_BASLIK where PARENTID=@grp1id ) dt 
         on t.ID=@grp1id             
                 
 
  return

 END

================================================================================
