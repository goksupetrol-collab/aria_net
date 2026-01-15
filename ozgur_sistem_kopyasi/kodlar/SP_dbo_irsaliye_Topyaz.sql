-- Stored Procedure: dbo.irsaliye_Topyaz
-- Tarih: 2026-01-14 20:06:08.336688
================================================================================

CREATE PROCEDURE [dbo].irsaliye_Topyaz (@Fatid float) 
 AS
 BEGIN

  declare @irid int
  
   select @irid=irid from irsaliyemas where akid=@Fatid 
  
  
   update irsaliyemas set 
   Genel_Net_Top=Kdvsiz_top+Kdv_top,
   irtop=Kdvsiz_top,
   Genel_Kdv_Top=Kdv_top,
   genel_top=Kdvsiz_top+Kdv_top
   from irsaliyemas as t join 
   (select round (sum(brmfiy*mik),2) as Kdvsiz_top,
   round( sum((brmfiy*(1+kdvyuz)*mik)-(brmfiy*mik)),2 ) Kdv_top
     From irsaliyehrk 
   where irid=@irid and sil=0 )
   dt on t.irid=@irid
   
   update irsaliyemas set kayok=1 where irid=@irid

  
  END

================================================================================
