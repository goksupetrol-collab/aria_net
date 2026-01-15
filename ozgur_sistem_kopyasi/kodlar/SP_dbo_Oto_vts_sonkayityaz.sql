-- Stored Procedure: dbo.Oto_vts_sonkayityaz
-- Tarih: 2026-01-14 20:06:08.351003
================================================================================

CREATE PROCEDURE [dbo].Oto_vts_sonkayityaz(
@firmano int,@otomasad varchar(50))
AS
BEGIN
 declare @sonsatir float
 declare @sontarih datetime
 declare @sondosya  varchar(30)
  
  select top 1 @sonsatir=otomasid,
  @sondosya=dosya,
  @sontarih=tarih from otomasonlineoku
  where firmano=@firmano and otomasad=@otomasad
  order by id desc

  update oto_onl_param
  set sonsatirno=@sonsatir,sontarih=@sontarih,
  sondosya=@sondosya where
  firmano=@firmano and otomasad=@otomasad
  
  
END

================================================================================
