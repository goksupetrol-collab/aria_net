-- Stored Procedure: dbo.Fatura_Genel_indirim
-- Tarih: 2026-01-14 20:06:08.324793
================================================================================

CREATE PROCEDURE [dbo].Fatura_Genel_indirim
@fatid           float,
@tip             tinyint,
@deger           float
AS
BEGIN

declare  @isk_yuzde   float
declare  @isk_tutar   float
declare  @ara_toplam  float

    select @ara_toplam=fattop from faturamas  with (nolock) where fatid=@fatid
  

  if @tip=0 /*YUZDE BAZINDA */
   begin
    if @ara_toplam>0
     update faturamas set gen_ind_tip=@tip,
     geniskyuz=@deger
     ,genisktop=@ara_toplam*(@deger/100)
      where fatid=@fatid
    end


  if @tip=1 /*TUTAR BAZINDA */
   begin
    if @ara_toplam>0
     update faturamas set gen_ind_tip=@tip,
     geniskyuz=(@deger*100)/@ara_toplam
     ,genisktop=@deger  where fatid=@fatid
    end
  


  
END

================================================================================
