-- Function: dbo.UDF_GUNLUK_CEK_SENET
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.728704
================================================================================

CREATE FUNCTION [dbo].UDF_GUNLUK_CEK_SENET (
@FIRMA_NO       INT,
@id			   	INT,
@TARIH			DATETIME,
@TIP			INT)
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
  
  
     if @TIP=1  
     begin
      if @FIRMA_NO>0   
      declare mas_cur CURSOR FAST_FORWARD  FOR 
        select cekid,
        case 
        when islmhrk='ALN' THEN cartip 
        when islmhrk='KSN' THEN vercartip
        END,
        case 
        when islmhrk='ALN' THEN carkod 
        when islmhrk='KSN' THEN vercarkod 
        END,
        m.giren,m.cikan,m.ceksenno,M.banka
        from cekkart as m with (nolock)  
        where m.sil=0 and m.firmano=@FIRMA_NO
        and m.vadetar = @TARIH 
        and m.sonuc=1 and m.drm not in ('PID','CIR')
      else
        declare mas_cur CURSOR FAST_FORWARD  FOR 
        select cekid,
        case 
        when islmhrk='ALN' THEN cartip 
        when islmhrk='KSN' THEN vercartip
        END,
        case 
        when islmhrk='ALN' THEN carkod 
        when islmhrk='KSN' THEN vercarkod 
        END,
        m.giren,m.cikan,m.ceksenno,M.banka
        from cekkart as m with (nolock) where 
        m.sil=0 
        and m.vadetar = @TARIH 
        and m.sonuc=1 and m.drm not in ('PID','CIR')
     end   
        
        
       if @TIP=0
       begin
       if @FIRMA_NO>0  
        declare mas_cur CURSOR FAST_FORWARD  FOR 
        select cekid,
        case 
        when islmhrk='ALN' THEN cartip 
        when islmhrk='KSN' THEN vercartip
        END,
        case 
        when islmhrk='ALN' THEN carkod 
        when islmhrk='KSN' THEN vercarkod 
        END,
        m.giren,m.cikan,m.ceksenno,M.banka
        from cekkart as m with (nolock) 
        where m.sil=0 and m.firmano=@FIRMA_NO
        and m.vadetar <= @TARIH
         and m.sonuc=0 and m.drm not in ('PID','CIR')
       else
        declare mas_cur CURSOR FAST_FORWARD  FOR 
        select cekid,
        case 
        when islmhrk='ALN' THEN cartip 
        when islmhrk='KSN' THEN vercartip
        END,
        case 
        when islmhrk='ALN' THEN carkod 
        when islmhrk='KSN' THEN vercarkod 
        END,
        m.giren,m.cikan,m.ceksenno,M.banka
        from cekkart as m with (nolock) where 
        m.sil=0 and m.vadetar <= @TARIH
         and m.sonuc=0 and m.drm not in ('PID','CIR') 
         
         
         
       end 
        
        
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
              'ÇEKLER',@GRP_AD,@CARTIP,@KOD,@ACK1,
              @BelgeNo,@BORC,@ALACAK)

            set @id=@id+1  

                    
               
       
         fetch next from  mas_cur into 
          @masid,@CARTIP,@KOD,@BORC,@ALACAK,@BelgeNo,@ACK1
         end
        Close mas_cur
        deallocate mas_cur   
   
    
        update @TABLE_MIZAN set ACK=dt.ad+' / '+t.BELGENO 
        from @TABLE_MIZAN as t join
        (select cartp,kod,ad from Genel_Kart ) dt 
        on t.KART_KOD=dt.cartp and t.ACK=dt.kod
      
    


RETURN






END

================================================================================
