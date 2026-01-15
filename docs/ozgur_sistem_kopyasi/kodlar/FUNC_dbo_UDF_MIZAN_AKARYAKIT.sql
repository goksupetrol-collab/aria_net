-- Function: dbo.UDF_MIZAN_AKARYAKIT
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.747403
================================================================================

CREATE FUNCTION [dbo].[UDF_MIZAN_AKARYAKIT] 
(
@FIRMA_NO       	INT,
@id  				INT,
@BAS_TAR        	DATETIME,
@BIT_TAR  	    	DATETIME,
@AK_FIYAT      		TINYINT,
@SIF_BAK3_GSTME 	TINYINT)
RETURNS

  @TABLE_MIZAN TABLE (
   ID					int,
   PARENTID				int,	
   GRPNO				int,
   KART_KOD				VARCHAR(50) COLLATE Turkish_CI_AS,
   ACK					VARCHAR(100) COLLATE Turkish_CI_AS,
   BORC				    float,
   ALACAK				float,
   BAKIYE_BORC			float,
   BAKIYE_ALACAK		float)

AS
BEGIN



  declare @grp1id int
  declare @grp2id int

  declare @KOD      varchar(100)
  declare @GRP_AD   varchar(100)
  declare @GRP_ID  	float
  declare @GRP_SR  	int
  
  declare @BORC  	float
  declare @ALACAK  	float
  declare @BAKIYE  	float
  
  
  declare @GIREN  		float
  declare @CIKAN  		float
  declare @BRMFIY  		float

  declare @ABAKIYE  	float
  declare @BBAKIYE  	float  


  declare @GEC_BRMFIY  	float

      set @grp1id=@id
    
       insert into @TABLE_MIZAN (ID,PARENTID,ACK,BORC,ALACAK,BAKIYE_BORC,BAKIYE_ALACAK)
       VALUES (@grp1id,0,'AKARYAKIT STOK KARTLARI',0,0,0,0)
       
       
      
      declare mas_cur CURSOR FAST_FORWARD  FOR 
       select id,sr,ad from grup where tabload='akytgrp' and sil=0 and sr=0
         open mas_cur
          fetch next from  mas_cur into @GRP_ID,@GRP_SR,@GRP_AD
           while @@FETCH_STATUS=0
            begin 
       
       
              set @id=@id+1 
      
              set @grp2id=@id
     
              insert into @TABLE_MIZAN (ID,PARENTID,ACK,BORC,
              ALACAK,BAKIYE_BORC,BAKIYE_ALACAK)
               VALUES (@id,@grp1id,@GRP_AD,0,0,0,0)
   
                 set @id=@id+1 
       
             IF (@FIRMA_NO=0)
              declare gec_cur CURSOR FAST_FORWARD  FOR 
              select h.stkod,
              sum(h.giren*h.brmfiykdvli),
              sum(h.cikan*h.brmfiykdvli),
              sum(h.giren),
              sum(h.cikan)       
              from
              stkhrk as h 
              inner join stokkart as k on h.stktip=k.tip and h.stkod=k.kod
              where h.stktip='akykt' and h. sil=0 and k.grp1=@GRP_ID
              and h.tarih>=@BAS_TAR 
              and h.tarih<=@BIT_TAR 
              group by h.stkod
              
              
              IF (@FIRMA_NO>0)
              declare gec_cur CURSOR FAST_FORWARD  FOR 
              select h.stkod,
              sum(h.giren*h.brmfiykdvli),
              sum(h.cikan*h.brmfiykdvli),
              sum(h.giren),
              sum(h.cikan)       
              from
              stkhrk as h 
              inner join stokkart as k on h.stktip=k.tip and h.stkod=k.kod
              where h.stktip='akykt' and h. sil=0 and k.grp1=@GRP_ID
              and h.firmano in (0,@FIRMA_NO)
              and h.tarih>=@BAS_TAR 
              and h.tarih<=@BIT_TAR 
              group by h.stkod 
              
              
              
              
               
               open gec_cur
                fetch next from  gec_cur into @KOD,@BORC,@ALACAK,@GIREN,@CIKAN
                 while @@FETCH_STATUS=0
                  begin
            
            
               if @AK_FIYAT=1
                begin 
                  SET @BRMFIY=DBO.UDF_Stok_Fiyat('akykt',2,@KOD,'Dahil',1)
                  SET @BORC=@GIREN*@BRMFIY
                  SET @ALACAK=@CIKAN*@BRMFIY
                end
 
                if @AK_FIYAT=2
                begin 
                  SET @BRMFIY=DBO.UDF_Stok_Fiyat('akykt',2,@KOD,'Dahil',2)
                  SET @BORC=@GIREN*@BRMFIY
                  SET @ALACAK=@CIKAN*@BRMFIY
                end           
                    
                if @AK_FIYAT=3
                begin 
                  SET @BRMFIY=DBO.UDF_Stok_Fiyat('akykt',2,@KOD,'Dahil',3)
                  SET @BORC=@GIREN*@BRMFIY
                  SET @ALACAK=@CIKAN*@BRMFIY
                end  
                    
                    
                if @AK_FIYAT=4
                begin 
                  SET @BRMFIY=DBO.UDF_Stok_Fiyat('akykt',2,@KOD,'Dahil',4)
                  SET @BORC=@GIREN*@BRMFIY
                  SET @ALACAK=@CIKAN*@BRMFIY
                end 
            
              if @AK_FIYAT=5
                begin 
                  SET @BRMFIY=DBO.UDF_Stok_Fiyat('akykt',2,@KOD,'Hariç',1)
                  SET @BORC=@GIREN*@BRMFIY
                  SET @ALACAK=@CIKAN*@BRMFIY
                end 
            
             if @AK_FIYAT=6
                begin 
                  SET @BRMFIY=DBO.UDF_Stok_Fiyat('akykt',2,@KOD,'Hariç',2)
                  SET @BORC=@GIREN*@BRMFIY
                  SET @ALACAK=@CIKAN*@BRMFIY
               end 
               
             if @AK_FIYAT=7
                begin 
                  SET @BRMFIY=DBO.UDF_Stok_Fiyat('akykt',2,@KOD,'Hariç',3)
                  SET @BORC=@GIREN*@BRMFIY
                  SET @ALACAK=@CIKAN*@BRMFIY
                end    
               
             if @AK_FIYAT=8
                begin 
                  SET @BRMFIY=DBO.UDF_Stok_Fiyat('akykt',2,@KOD,'Hariç',4)
                  SET @BORC=@GIREN*@BRMFIY
                  SET @ALACAK=@CIKAN*@BRMFIY
                end    
             
              if @AK_FIYAT=9
                begin 
                  SET @BRMFIY=DBO.UDF_Stok_Fiyat('akykt',1,@KOD,'Dahil',4)
                  SET @BORC=@GIREN*@BRMFIY
                  SET @ALACAK=@CIKAN*@BRMFIY
                end   
          
          
                if @AK_FIYAT=10
                begin 
                  SET @BRMFIY=DBO.UDF_Stok_Fiyat('akykt',1,@KOD,'Hariç',4)
                  SET @BORC=@GIREN*@BRMFIY
                  SET @ALACAK=@CIKAN*@BRMFIY
                end  
                
                
               SET @GEC_BRMFIY=0
                
               if @AK_FIYAT=11 /*alis fiyatı son tarihteki kdv dahil */
                begin 
                 
                 IF (@FIRMA_NO=0) 
                  SELECT TOP 1 @GEC_BRMFIY=h.brmfiykdvli 
                     from stkhrk as h
                    where stktip='akykt' and stkod=@KOD
                    and h.tarih<=@BIT_TAR and h.sil=0 and h.giren>0
                    order by h.tarih desc,h.saat desc 
                    
                    
                   IF (@FIRMA_NO>0) 
                  SELECT TOP 1 @GEC_BRMFIY=h.brmfiykdvli 
                     from stkhrk as h
                    where stktip='akykt' and stkod=@KOD and h.firmano in (0,@FIRMA_NO)
                    and h.tarih<=@BIT_TAR and h.sil=0 and h.giren>0
                    order by h.tarih desc,h.saat desc   
              
                  
                  SET @BORC=@GIREN*@GEC_BRMFIY
                  SET @ALACAK=@CIKAN*@GEC_BRMFIY
                end  
                
                
                
                if @AK_FIYAT=12 /*alis fiyatı son tarihteki kdv haric */
                begin 
                  
                  IF (@FIRMA_NO=0)
                    SELECT TOP 1 @GEC_BRMFIY=(h.brmfiykdvli/(1+(h.kdvyuz))) 
                     from stkhrk as h
                    where stktip='akykt' and stkod=@KOD
                    and h.tarih<=@BIT_TAR and h.sil=0 and h.giren>0
                    order by h.tarih desc,h.saat desc 
                    
                  IF (@FIRMA_NO>0)
                    SELECT TOP 1 @GEC_BRMFIY=(h.brmfiykdvli/(1+(h.kdvyuz))) 
                     from stkhrk as h
                    where stktip='akykt' and stkod=@KOD and h.firmano in (0,@FIRMA_NO)
                    and h.tarih<=@BIT_TAR and h.sil=0 and h.giren>0
                    order by h.tarih desc,h.saat desc    
                    
                    

                  SET @BORC=@GIREN*@GEC_BRMFIY
                  SET @ALACAK=@CIKAN*@GEC_BRMFIY
                end   
                
                
                
                if @AK_FIYAT=13 /*satis fiyatı son tarihteki kdv dahil */
                begin 
                 
                IF (@FIRMA_NO=0) 
                  SELECT TOP 1 @GEC_BRMFIY=h.brmfiykdvli 
                     from stkhrk as h
                    where stktip='akykt' and stkod=@KOD
                    and h.tarih<=@BIT_TAR and h.sil=0 and h.cikan>0
                    order by h.tarih desc,h.saat desc 
                
                 IF (@FIRMA_NO>0)
                  SELECT TOP 1 @GEC_BRMFIY=h.brmfiykdvli 
                     from stkhrk as h
                    where stktip='akykt' and stkod=@KOD and h.firmano in (0,@FIRMA_NO)
                    and h.tarih<=@BIT_TAR and h.sil=0 and h.cikan>0
                    order by h.tarih desc,h.saat desc 
                  
                  SET @BORC=@GIREN*@GEC_BRMFIY
                  SET @ALACAK=@CIKAN*@GEC_BRMFIY
                end  
                
                
                
                if @AK_FIYAT=14 /*satis fiyatı son tarihteki kdv haric */
                begin 
                 
                 IF (@FIRMA_NO=0)  
                  SELECT TOP 1 @GEC_BRMFIY=(h.brmfiykdvli/(1+(h.kdvyuz))) 
                     from stkhrk as h
                    where stktip='akykt' and stkod=@KOD
                    and h.tarih<=@BIT_TAR and h.sil=0 and h.cikan>0
                    order by h.tarih desc,h.saat desc 
                    
                 IF (@FIRMA_NO>0)   
                   SELECT TOP 1 @GEC_BRMFIY=(h.brmfiykdvli/(1+(h.kdvyuz))) 
                     from stkhrk as h
                    where stktip='akykt' and stkod=@KOD and h.firmano in (0,@FIRMA_NO)
                    and h.tarih<=@BIT_TAR and h.sil=0 and h.cikan>0
                    order by h.tarih desc,h.saat desc  
                    

                  SET @BORC=@GIREN*@GEC_BRMFIY
                  SET @ALACAK=@CIKAN*@GEC_BRMFIY
                end   
                
 
            
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
              insert into @TABLE_MIZAN (ID,PARENTID,KART_KOD,ACK,BORC,ALACAK,BAKIYE_BORC,BAKIYE_ALACAK)
              VALUES (@id,@grp2id,@KOD,@KOD,@BORC,@ALACAK,@BBAKIYE,@ABAKIYE)

           set @id=@id+1  

             FETCH next from  gec_cur into @KOD,@BORC,@ALACAK,@GIREN,@CIKAN
           end
         close gec_cur
         deallocate gec_cur
         
         
         
              update @TABLE_MIZAN set 
               BORC=isnull(dt.BORC,0),ALACAK=isnull(dt.ALACAK,0),
               BAKIYE_BORC=isnull(dt.BBORC,0),BAKIYE_ALACAK=isnull(dt.BALACAK,0)
                from @TABLE_MIZAN as t
               join (select sum(borc) as borc,sum(alacak) as alacak,
               case when  sum(borc-alacak)>0 then sum(borc-alacak) else 0 end bborc,
               case when sum(borc-alacak)<0 then -1*sum(borc-alacak) else 0 end balacak
               from @TABLE_MIZAN where PARENTID=@grp2id ) dt 
               on t.ID=@grp2id     
                 
                 
              FETCH next from  mas_cur into @GRP_ID,@GRP_SR,@GRP_AD
             end
            Close mas_cur
            deallocate mas_cur   
         

         
        update @TABLE_MIZAN set ACK=dt.ad from @TABLE_MIZAN as t join
        (select kod,ad from stokkart where tip='akykt') dt 
        on t.KART_KOD=dt.kod
         
       
        /* 
         update @TABLE_MIZAN set 
         BORC=isnull(dt.BORC,0),ALACAK=isnull(dt.ALACAK,0),
         BAKIYE_BORC=ISNULL(dt.BBORC,0),BAKIYE_ALACAK=isnull(dt.BALACAK,0)
          from @TABLE_MIZAN as t
         join (select sum(borc) as borc,sum(alacak) as alacak,
         case when  sum(borc-alacak)>0 then sum(borc-alacak) else 0 end bborc,
         case when sum(borc-alacak)<0 then -1*sum(borc-alacak) else 0 end balacak
         from @TABLE_MIZAN where PARENTID=@grp2id ) dt 
         on t.ID=@grp2id
        */ 
         
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
