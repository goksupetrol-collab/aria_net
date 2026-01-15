-- Function: dbo.UDF_GUNLUK_KASA
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.729167
================================================================================

CREATE FUNCTION [dbo].[UDF_GUNLUK_KASA] 
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
  declare @EVK_AD   	varchar(100)
  declare @GRP_ID  		float
  declare @GRP_SR  		int
  
  declare @BORC  		float
  declare @ALACAK  		float
  declare @BAKIYE  		float

  declare @ABAKIYE  	float
  declare @BBAKIYE  	float  
  
  
 
      set @grp1id=@id
    
      declare mas_cur CURSOR FAST_FORWARD  FOR 
       select parabrm from kasakart with (nolock) where sil=0 group by parabrm
         open mas_cur
          fetch next from  mas_cur into @GRP_AD
           while @@FETCH_STATUS=0
            begin 
      
          if @FIRMA_NO>0 
            declare gec_cur CURSOR FAST_FORWARD  FOR 
            select h.kaskod,sum(h.giren*h.KUR),
            sum(h.cikan*h.KUR) from
            kasahrk as h with (nolock) 
            inner join kasakart as k with (nolock) on k.kod=h.kaskod
            and k.parabrm=@GRP_AD and k.sil=0
            where h.firmano=@FIRMA_NO and h.sil=0 and h.tarih<@TARIH 
            group by h.kaskod 
           else
            declare gec_cur CURSOR FAST_FORWARD  FOR 
            select h.kaskod,sum(h.giren*h.KUR),
            sum(h.cikan*h.KUR) from
            kasahrk as h with (nolock) 
            inner join kasakart as k with (nolock) on k.kod=h.kaskod
            and k.parabrm=@GRP_AD and k.sil=0
            where h.sil=0
            and h.tarih<@TARIH 
            group by h.kaskod 
            
            
            
            
            
            /*
             finas gosterme ve tek teslimat pasif se
            
            select sum(giren),sum(cikan) from kasahrk where tarih='2010-05-17'
            and ((varno>0 and islmhrk='TES') or varno=0   ) and sil=0
            
            
            */
            
            
             open gec_cur
          fetch next from  gec_cur into @KOD,
          @BORC,@ALACAK
           while @@FETCH_STATUS=0
            begin
            
            set @BORC=ROUND(@BORC,2)
            set @ALACAK=ROUND(@ALACAK,2)
            
            set @BBAKIYE=0
            set @ABAKIYE=0
            
            SET @BAKIYE=@BORC-@ALACAK 
            
           if @FIRMA_NO>0 
             select @BAKIYE=@BAKIYE+sum(h.giren*h.KUR)
            from kasahrk as h with (nolock) 
            where h.firmano=@FIRMA_NO and h.kaskod=@KOD 
            and h.tarih=@TARIH  and h.sil=0
            group by h.kaskod 
           else 
            select @BAKIYE=@BAKIYE+sum(h.giren*h.KUR)
            from kasahrk as h with (nolock) 
            where h.kaskod=@KOD
            and h.tarih=@TARIH and h.sil=0 
            group by h.kaskod 
            
             
             if @BAKIYE>0
              set @BBAKIYE=@BAKIYE
              
             if @BAKIYE<0
              set @ABAKIYE=-1*@BAKIYE
            
    
            
             insert into @TABLE_MIZAN (ID,TIP_ACK,EVRAK_ACK,KART_KOD,ACK,ACK1,
             BORC,ALACAK)
              VALUES (@id,'KASALAR',@EVK_AD,@KOD,@KOD,'-',@BBAKIYE,@ABAKIYE)

             set @id=@id+1  

             FETCH next from  gec_cur into @KOD,@BORC,@ALACAK
           end
         close gec_cur
         deallocate gec_cur
         
           
   
       
          FETCH next from  mas_cur into @GRP_AD
         end
        Close mas_cur
        deallocate mas_cur      
         
        
        
        update @TABLE_MIZAN set ACK=dt.ad from @TABLE_MIZAN as t join
         (select kod,ad as ad from kasakart with (nolock)  ) dt 
         on t.KART_KOD=dt.kod 
        
        
        
         
           
    


RETURN



END

================================================================================
