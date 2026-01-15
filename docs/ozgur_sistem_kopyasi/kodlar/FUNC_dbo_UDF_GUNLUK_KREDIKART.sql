-- Function: dbo.UDF_GUNLUK_KREDIKART
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.730501
================================================================================

CREATE  FUNCTION [dbo].[UDF_GUNLUK_KREDIKART] (
@FIRMA_NO       INT,
@id			   	INT,
@TARIH			DATETIME)
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

  DECLARE @masid 		int	
  declare @KOD      	varchar(100)
  declare @CARTIP      	varchar(30)
    
  declare @GRP_KOD   	varchar(50)
  declare @BelgeNo   	varchar(50)
  declare @ACK1   	    varchar(50)
  declare @GRP_AD   	varchar(100)
  declare @GRP_ID  		float
  declare @GRP_SR  		int
  
  declare @BORC  		float
  declare @ALACAK  		float
  declare @BAKIYE  		float

  declare @ABAKIYE  	float
  declare @BBAKIYE  	float  
  
  
    if @FIRMA_NO>0
      declare mas_cur CURSOR FAST_FORWARD  FOR 
        select h.istkhrkid,
        'istkart',h.istkkod,
        h.borc,h.alacak,
        h.belno,h.istkkod
        from istkhrk as h with (nolock)  where  
        h.sil=0 and h.firmano=@FIRMA_NO
        and h.vadetar = @TARIH 
        and h.alacak>0
     else
       declare mas_cur CURSOR FAST_FORWARD  FOR 
        select h.istkhrkid,
        'istkart',h.istkkod,
        h.borc,h.alacak,
        h.belno,h.istkkod
        from istkhrk as h with (nolock)  where  
        h.sil=0 
        and h.vadetar = @TARIH 
        and h.alacak>0   
                
         open mas_cur
          fetch next from  mas_cur into 
          @masid,@CARTIP,@KOD,@BORC,@ALACAK,@BelgeNo,@ACK1
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
                
            
              insert into @TABLE_MIZAN (ID,
              TIP_ACK,EVRAK_ACK,KART_KOD,ACK,ACK1,
              BELGENO,BORC,ALACAK)
              VALUES (@id,
              'KREDİ KARTI',@GRP_AD,@CARTIP,@KOD,@ACK1,
              @BelgeNo,@BORC,@ALACAK)

            set @id=@id+1  

                    
               
       
         fetch next from  mas_cur into 
          @masid,@CARTIP,@KOD,@BORC,@ALACAK,@BelgeNo,@ACK1
         end
        Close mas_cur
        deallocate mas_cur   
   
    
        update @TABLE_MIZAN set ACK=dt.ad
        from @TABLE_MIZAN as t join
        (select cartp,kod,ad from Genel_Kart ) dt 
        on t.KART_KOD=dt.cartp and t.ACK=dt.kod
      
    


RETURN






END

================================================================================
