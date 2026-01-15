-- Function: dbo.UDF_GUNLUK_KASA_ODEME
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.730115
================================================================================

CREATE FUNCTION [dbo].[UDF_GUNLUK_KASA_ODEME] (
@FIRMA_NO       INT,
@id			   	INT,
@TARIH			DATETIME,
@TIP			INT,
@FATGC			INT)
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

  declare @CARTIPAD      	varchar(50)
    
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
  
  
      IF @TIP=1
      begin
      if @FIRMA_NO>0
      declare mas_cur CURSOR FAST_FORWARD  FOR 
        select h.fatid,
        h.cartip,h.carkod,
        case when h.gctip=2 THEN 
        h.genel_top ELSE 0 END,
        case when h.gctip=1 THEN 
        h.genel_top else 0 END,
        h.fatseri+cast(h.fatno as varchar),h.ack
        from faturamas as h with (nolock) where  
        h.sil=0 and h.firmano=@FIRMA_NO
        and h.vadtar= @TARIH 
        and h.cartip in ('carikart','perkart')
        and h.gctip=@FATGC and (h.odeme>0)
       else
        declare mas_cur CURSOR FAST_FORWARD  FOR 
        select h.fatid,
        h.cartip,h.carkod,
        case when h.gctip=2 THEN 
        h.genel_top ELSE 0 END,
        case when h.gctip=1 THEN 
        h.genel_top else 0 END,
        h.fatseri+cast(h.fatno as varchar),h.ack
        from faturamas as h with (nolock) where  
        h.sil=0 
        and h.vadtar= @TARIH 
        and h.cartip in ('carikart','perkart')
        and h.gctip=@FATGC and (h.odeme>0) 
        
        
        
      end  
        
               
        
       IF @TIP=0
       begin
        if @FIRMA_NO>0
        declare mas_cur CURSOR FAST_FORWARD  FOR 
        select h.fatid,
        h.cartip,h.carkod,
        case when h.gctip=2 THEN 
        h.genel_top ELSE 0 END,
        case when h.gctip=1 THEN 
        h.genel_top else 0 END,
        h.fatseri+cast(h.fatno as varchar),h.ack
        from faturamas as h with (nolock)  where  
        h.sil=0 and h.firmano=@FIRMA_NO 
        and h.vadtar <= @TARIH 
        and h.cartip in ('carikart','perkart')
        and h.gctip=@FATGC
        and (h.odeme=0 or h.odeme is null ) 
        union all
         select id,'perkart',kod,0,maas,
         kod,'MAAS TAHAKKUK' 
         from perkart as k with (nolock) where k.firmano=@FIRMA_NO 
         and  k.drm='Aktif' and sil=0 and maasgun=DAY(@TARIH) 
       else
        declare mas_cur CURSOR FAST_FORWARD  FOR 
        select h.fatid,
        h.cartip,h.carkod,
        case when h.gctip=2 THEN 
        h.genel_top ELSE 0 END,
        case when h.gctip=1 THEN 
        h.genel_top else 0 END,
        h.fatseri+cast(h.fatno as varchar),h.ack
        from faturamas as h with (nolock)  where  
        h.sil=0 
        and h.vadtar <= @TARIH 
        and h.cartip in ('carikart','perkart')
        and h.gctip=@FATGC
        and (h.odeme=0 or h.odeme is null ) 
        union all
         select id,'perkart',kod,0,maas,
         kod,'MAAS TAHAKKUK' 
         from perkart as k with (nolock) where k.drm='Aktif'
         and sil=0 and maasgun=DAY(@TARIH)   
         
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
              
              
              if @ACK1='' 
               set @ACK1=@BelgeNo
              
              if @CARTIP='carikart'
               set @CARTIPAD='CARI KARTLAR'
               
              if @CARTIP='perkart'
               set @CARTIPAD='PERSONEL KARTLAR'
               
              
              
                
            
              insert into @TABLE_MIZAN (ID,
              TIP_ACK,EVRAK_ACK,KART_KOD,ACK,ACK1,
              BELGENO,BORC,ALACAK)
              VALUES (@id,
              @CARTIPAD,@GRP_AD,@CARTIP,@KOD,@ACK1,
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
