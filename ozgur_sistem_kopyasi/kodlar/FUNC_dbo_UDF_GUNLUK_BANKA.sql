-- Function: dbo.UDF_GUNLUK_BANKA
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.723813
================================================================================

CREATE FUNCTION [dbo].[UDF_GUNLUK_BANKA] 
(@FIRMA_NO       	INT,
 @id			   	INT,
 @TARIH				DATETIME)
RETURNS

  @TABLE_MIZAN TABLE (
   ID					int,
   GRPNO				int,
   TIP_ACK				VARCHAR(50) COLLATE Turkish_CI_AS,
   EVRAK_ACK			VARCHAR(50) COLLATE Turkish_CI_AS,
   KART_KOD				VARCHAR(50) COLLATE Turkish_CI_AS,
   ACK					VARCHAR(150) COLLATE Turkish_CI_AS,
   ACK1					VARCHAR(150) COLLATE Turkish_CI_AS,
   BELGENO				VARCHAR(50) COLLATE Turkish_CI_AS,
   BORC				    float,
   ALACAK				float)

AS
BEGIN


  declare @grp1id 	 	int
  declare @grp2id 		int

  declare @KOD      	varchar(100)
  declare @GRP_AD   	varchar(100)
  declare @ACK1   	    varchar(100)
  declare @GRP_ID  		float
  declare @GRP_SR  		int
  
  declare @BORC  		float
  declare @ALACAK  		float
  declare @BAKIYE  		float

  declare @ABAKIYE  	float
  declare @BBAKIYE  	float  
  
  
 
   

       declare mas_cur CURSOR FAST_FORWARD  FOR 
       select id,sr,ad from grup with (nolock) where tabload='bankakart' and sil=0 
         open mas_cur
          fetch next from  mas_cur into @GRP_ID,@GRP_SR,@GRP_AD
           while @@FETCH_STATUS=0
            begin 
 
           if @FIRMA_NO>0 
            declare gec_cur CURSOR FAST_FORWARD  FOR 
            select h.bankod,K.hesno,sum(h.borc),
            sum(h.alacak) from
            bankahrk as h with (NOLOCK)
            inner join bankakart as k with (NOLOCK) on k.kod=h.bankod
            and k.grp1=@GRP_ID and k.sil=0 and k.drm='Aktif'
            where h.firmano=@FIRMA_NO  and  h.sil=0 and h.tarih<=@TARIH 
            group by h.bankod,K.hesno 
           else
            declare gec_cur CURSOR FAST_FORWARD  FOR 
            select h.bankod,K.hesno,sum(h.borc),
            sum(h.alacak) from
            bankahrk as h with (NOLOCK)
            inner join bankakart as k with (NOLOCK) on k.kod=h.bankod
            and k.grp1=@GRP_ID and k.sil=0 and k.drm='Aktif'
            where h.sil=0
            and h.tarih<=@TARIH 
            group by h.bankod,K.hesno  
            
            
            
            
             open gec_cur
           fetch next from  gec_cur into @KOD,@ACK1,@BORC,@ALACAK
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
                
            
            insert into @TABLE_MIZAN (ID,TIP_ACK,EVRAK_ACK,
            KART_KOD,ACK,ACK1,BORC,ALACAK)
              VALUES (@id,'BANKALAR',@KOD,@KOD,@KOD,@ACK1,
              @BBAKIYE,@ABAKIYE)

            set @id=@id+1  

             FETCH next from  gec_cur into @KOD,@ACK1,@BORC,@ALACAK
           end
         close gec_cur
         deallocate gec_cur
         
         
          update @TABLE_MIZAN set ACK=dt.ad from @TABLE_MIZAN as t join
          (select kod,ad from bankakart with (nolock) ) dt 
          on t.KART_KOD=dt.kod 
    
       
          FETCH next from  mas_cur into @GRP_ID,@GRP_SR,@GRP_AD
         end
        Close mas_cur
        deallocate mas_cur      
         
         
   
    


RETURN



END

================================================================================
