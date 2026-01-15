-- Stored Procedure: dbo.Fatura_Cari_Stok_Iskonto
-- Tarih: 2026-01-14 20:06:08.324076
================================================================================

CREATE PROCEDURE [dbo].[Fatura_Cari_Stok_Iskonto]
@fatid           float
AS
BEGIN

    declare  @isk_yuzde   float
    declare  @isk_tutar   float
    declare  @ara_toplam  float
    
    declare @carkod       varchar(50)
    declare @cartip_id    int
    
    
    declare  @fisisk  		 	float
    declare  @TtsDagisk   		float
    declare  @TtsBayisk  		float
    
   
    

    select @carkod=carkod,@cartip_id=cartip_id,
    @ara_toplam=fattop from faturamas with (nolock)  where fatid=@fatid
    
    
     select @fisisk=isnull(fisisk,0),@TtsDagisk=isnull(TtsDagisk,0),
    @TtsBayisk=isnull(TtsBayisk,0) from CariKart with (nolock) 
    Where Kod=@carkod 
    
  

     update faturahrk Set satiskyuz=dt.Iskonto_Oran
      From faturahrk as t with (nolock)  join 
      (Select * From Cari_Fat_Urun_Iskonto Where car_kod=@carkod and sil=0) dt
      on dt.car_kod=@carkod and cartip_id=@cartip_id 
      and t.stkod=dt.stk_kod and t.stktip=dt.stktip
    where fatid=@fatid
    
    if @fisisk>0  
      update faturahrk set satiskyuz=@fisisk where fatid=@fatid and OtoTag=0
 
    if @TtsDagisk>0  
      update faturahrk set satiskyuz=@TtsDagisk where fatid=@fatid and OtoTag=1

   if @TtsBayisk>0  
      update faturahrk set satiskyuz=@TtsBayisk where fatid=@fatid and OtoTag=2
   
    


  
END

================================================================================
