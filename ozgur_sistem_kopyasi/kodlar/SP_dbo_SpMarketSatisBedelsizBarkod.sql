-- Stored Procedure: dbo.SpMarketSatisBedelsizBarkod
-- Tarih: 2026-01-14 20:06:08.376543
================================================================================

CREATE PROCEDURE dbo.SpMarketSatisBedelsizBarkod
@MarSatId     int
AS
BEGIN
  
    
    update BarkodBedelsiz set Aktif=0
    where barkod in (Select barkod from marsathrk where marsatid=@MarSatId 
    and Sil=0 and Bedelsiz=1)
    
    update BarkodBedelsiz set Aktif=1
    where barkod in (Select barkod from marsathrk where marsatid=@MarSatId 
    and  Sil=1 and Bedelsiz=1) 
    


END

================================================================================
