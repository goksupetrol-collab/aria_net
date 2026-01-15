-- Stored Procedure: dbo.SpFaturaFisIkontoKontrol
-- Tarih: 2026-01-14 20:06:08.372206
================================================================================

CREATE PROCEDURE dbo.SpFaturaFisIkontoKontrol
@FatId     int,
@Sil       bit
AS
BEGIN
 

   
 

   if @Sil=1 
    begin
     /*yansımada iptal */
      update veresihrk set Fat_IskYuz=0,iskyuz=0 where 
         verid in (Select verid from veresimas 
         with (nolock) where fatid=@FatId )
   
     end


   if @Sil=0
    begin

    declare @GenelIskTop    float
    declare @FatFisIskYansit bit


     select top 1 @FatFisIskYansit=FaturaFisIskonto from sistemtanim 


    
          
    set @GenelIskTop=0
    
    Select @GenelIskTop=genel_isk_top from faturamas with (nolock)
    where fatid=@FatId
    
     if @GenelIskTop>=0
     begin  
     
     
       if @FatFisIskYansit=0 /*sadece Fat_IskYuz */
         update veresihrk set 
         Fat_IskYuz=dt.FatSatIskYuz
         from veresihrk as t 
         join (
         Select v.verid,h.stktip,h.stkod,
         case when (h.brmfiy*h.mik) > 0 then  
         ROUND( (h.top_isk_tut/(h.brmfiy*h.mik))*100,4) else 0 end as FatSatIskYuz   
         from veresimas as v with (nolock) 
         inner join faturahrk as h with (nolock) on h.fatid=@FatId and h.sil=0
         where v.fatid=@FatId ) dt on dt.verid=t.verid 
         and dt.stkod=t.stkod and dt.stktip=t.stktip
        
              
        if @FatFisIskYansit=1 
         update veresihrk set 
         Fat_IskYuz=dt.FatSatIskYuz,
         iskyuz=dt.FatSatIskYuz
         from veresihrk as t 
         join (
         Select v.verid,h.stktip,h.stkod,
         case when (h.brmfiy*h.mik) > 0 then  
         ROUND( (h.top_isk_tut/(h.brmfiy*h.mik))*100,4) else 0 end as FatSatIskYuz   
         from veresimas as v with (nolock) 
         inner join faturahrk as h with (nolock) on h.fatid=@FatId and h.sil=0
         where v.fatid=@FatId ) dt on dt.verid=t.verid 
         and dt.stkod=t.stkod and dt.stktip=t.stktip
         
         
         
         
         
  
    end

  end


END

================================================================================
