-- Stored Procedure: dbo.Surucu_Kaydet
-- Tarih: 2026-01-14 20:06:08.384412
================================================================================

CREATE PROCEDURE [dbo].[Surucu_Kaydet]
(@firmano    int,
@cartip_id 	int,
@carkod 	varchar(30),
@Ad 		varchar(100),
@userad  	varchar(100))
AS
BEGIN


  if @Ad=''
    return
  

 
  declare @car_id      int

  
   select @car_id=id From 
   Genel_Cari_Kart where CarTip_id=@cartip_id and Kod=@carkod
  
   if (Select COUNT(*) From Cari_Surucu with (nolock) Where cartip_id=@cartip_id 
   and car_id=@car_id and Ad=@Ad)=0  
    insert into Cari_Surucu (firmano,cartip_id,car_id,car_kod,ad,olususer,olustarsaat)
    select @firmano,@cartip_id,@car_id,@carkod,@Ad,@userad,getdate()

END

================================================================================
