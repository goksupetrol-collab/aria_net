-- Stored Procedure: dbo.SlipBirlestir
-- Tarih: 2026-01-14 20:06:08.365477
================================================================================

CREATE PROCEDURE [dbo].SlipBirlestir @Ana_id bigint
AS
BEGIN


   declare @TopTutar		float
   declare @mesaj			nvarchar(500)	
   
   if (select count(*) from poshrk
   where ana_id=@Ana_id and aktip='AK' and sil=0)>0 
    begin
     
    
      set @mesaj=''
      select @mesaj='Slipler İçinde Bankaya Aktarılmış Slipler Bulunmakta...!'
      RAISERROR (@mesaj, 16,1)
      ROLLBACK TRANSACTION
      RETURN
     
    end
    
   
   
   
   
   select @TopTutar=sum(giren) from poshrk
   where ana_id=@Ana_id and sil=0
   
   
   
   update poshrk set giren=@TopTutar,Ana_id=0 where 
   poshrkid=@Ana_id
   
   
   delete from poshrk where ana_id=@Ana_id
   
END

================================================================================
