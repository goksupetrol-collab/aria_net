-- Function: dbo.UDF_MIZAN_CEK_SENET
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.748629
================================================================================

CREATE  FUNCTION [dbo].[UDF_MIZAN_CEK_SENET] 
(@FIRMA_NO       	INT,
 @id			   	INT,
 @BAS_TAR          	DATETIME,
 @BIT_TAR          	DATETIME,
 @AY_CARGRP      	TINYINT,
 @SIF_BAK3_GSTME 	TINYINT)
RETURNS

  @TABLE_MIZAN TABLE (
   ID					int,
   PARENTID				int,	
   GRPNO				int,
   KART_KOD				VARCHAR(50) COLLATE Turkish_CI_AS,
   ACK					VARCHAR(150) COLLATE Turkish_CI_AS,
   BELGENO				VARCHAR(50) COLLATE Turkish_CI_AS,
   BORC				    float,
   ALACAK				float,
   BAKIYE_BORC			float,
   BAKIYE_ALACAK		float)

AS
BEGIN


  declare @grp1id 	 	int
  declare @grp2id 		int

  declare @KOD_TIP    	varchar(100)
  declare @KOD      	varchar(100)
  declare @GRP_KOD   	varchar(50)
  declare @BelgeNo   	varchar(50)
  declare @GRP_AD   	varchar(100)
  declare @GRP_ID  		float
  declare @GRP_SR  		int
  
  declare @BORC  		float
  declare @ALACAK  		float
  declare @BAKIYE  		float

  declare @ABAKIYE  	float
  declare @BBAKIYE  	float  
  
  
 
      set @grp1id=@id
    
       insert into @TABLE_MIZAN (ID,PARENTID,ACK,BORC,ALACAK,BAKIYE_BORC,BAKIYE_ALACAK)
       VALUES (@grp1id,0,'ÇEKLER',0,0,0,0)

       declare mas_cur CURSOR FAST_FORWARD  FOR 
        select id,kod,ad from cektip where kod in ('POR','TAK','KSN')
         open mas_cur
          fetch next from  mas_cur into @GRP_ID,@GRP_KOD,@GRP_AD
           while @@FETCH_STATUS=0
            begin 
      
             set @id=@id+1 
      
              set @grp2id=@id
     
              insert into @TABLE_MIZAN (ID,PARENTID,ACK,BORC,
              ALACAK,BAKIYE_BORC,BAKIYE_ALACAK)
               VALUES (@id,@grp1id,@GRP_AD,0,0,0,0)
   
               set @id=@id+1     

     



           if @AY_CARGRP=1 
            begin
   
            /*if (@GRP_KOD='POR') OR (@GRP_KOD='TAK') */
            IF (@FIRMA_NO=0)
            declare gec_cur CURSOR FAST_FORWARD  FOR 
            SELECT Car_Tip,car_kod,BelgeNo,sum(borc),sum(alacak) from 
            Cek_Son_Drm (0,@GRP_KOD,@BAS_TAR,@BIT_TAR) as h
            group by h.Car_Tip,h.car_kod,BelgeNo
            
            
            IF (@FIRMA_NO>0)
            declare gec_cur CURSOR FAST_FORWARD  FOR 
            SELECT Car_Tip,car_kod,BelgeNo,sum(borc),sum(alacak) from 
            Cek_Son_Drm (@FIRMA_NO,@GRP_KOD,@BAS_TAR,@BIT_TAR) as h
            group by h.Car_Tip,h.car_kod,BelgeNo
             
              
           end
  
           if @AY_CARGRP=0
            begin

            IF (@FIRMA_NO=0)
            declare gec_cur CURSOR FAST_FORWARD  FOR 
            SELECT Car_Tip,car_kod,BelgeNo,borc,alacak from 
            Cek_Son_Drm (0,@GRP_KOD,@BAS_TAR,@BIT_TAR) as h
             order by h.Car_Tip,car_kod
             
            IF (@FIRMA_NO>0)
            declare gec_cur CURSOR FAST_FORWARD  FOR 
            SELECT Car_Tip,car_kod,BelgeNo,borc,alacak from 
            Cek_Son_Drm (@FIRMA_NO,@GRP_KOD,@BAS_TAR,@BIT_TAR) as h
             order by h.Car_Tip,car_kod 
             
             
           end
           
                      
             
             open gec_cur
          fetch next from  gec_cur into @KOD_TIP,@KOD,@BelgeNo,
          @BORC,@ALACAK
           while @@FETCH_STATUS=0
            begin
            
            
            set @BORC=ROUND(@BORC,2)
            set @ALACAK=ROUND(@ALACAK,2)
            
            set @BBAKIYE=0
            set @ABAKIYE=0
            
            SET @BAKIYE=@BORC-@ALACAK 
             
             if @BAKIYE>0
              set @BBAKIYE=@BAKIYE
              
             if @BAKIYE<0
              set @ABAKIYE=-1*@BAKIYE
                
            
             if (@SIF_BAK3_GSTME=0) OR (@SIF_BAK3_GSTME=1 AND (@BAKIYE <>0) ) 
              insert into @TABLE_MIZAN (ID,PARENTID,KART_KOD,ACK,
              BELGENO,BORC,ALACAK,BAKIYE_BORC,BAKIYE_ALACAK)
              VALUES (@id,@grp2id,@KOD_TIP,@KOD,@BelgeNo,
              @BORC,@ALACAK,@BBAKIYE,@ABAKIYE)

            set @id=@id+1  

             FETCH next from  gec_cur into @KOD_TIP,@KOD,@BelgeNo,
             @BORC,@ALACAK
           end
         close gec_cur
         deallocate gec_cur
         
           update @TABLE_MIZAN set 
           BORC=isnull(dt.BORC,0),ALACAK=isnull(dt.ALACAK,0),
           BAKIYE_BORC=ISNULL(dt.BBORC,0),BAKIYE_ALACAK=isnull(dt.BALACAK,0)
            from @TABLE_MIZAN as t
           join (select sum(borc) as borc,sum(alacak) as alacak,
           case when  sum(borc-alacak)>0 then sum(borc-alacak) else 0 end bborc,
           case when sum(borc-alacak)<0 then -1*sum(borc-alacak) else 0 end balacak
           from @TABLE_MIZAN where PARENTID=@grp2id ) dt 
           on t.ID=@grp2id
       
       
          FETCH next from  mas_cur into @GRP_ID,@GRP_KOD,@GRP_AD
         end
        Close mas_cur
        deallocate mas_cur   
   
   
        update @TABLE_MIZAN set ACK=dt.ad+' / '+t.BELGENO from @TABLE_MIZAN as t join
        (select cartp,kod,ad from Genel_Kart ) dt 
        on t.KART_KOD=dt.cartp and t.ACK=dt.kod
        
         update @TABLE_MIZAN set 
         BORC=isnull(dt.BORC,0),ALACAK=isnull(dt.ALACAK,0),
         BAKIYE_BORC=ISNULL(dt.BBORC,0),BAKIYE_ALACAK=isnull(dt.BALACAK,0)
          from @TABLE_MIZAN as t
         join (select sum(borc) as borc,sum(alacak) as alacak,
         case when  sum(borc-alacak)>0 then sum(borc-alacak) else 0 end bborc,
         case when sum(borc-alacak)<0 then -1*sum(borc-alacak) else 0 end balacak
         from @TABLE_MIZAN where PARENTID=@grp1id ) dt 
         on t.ID=@grp1id        
    


RETURN



END

================================================================================
