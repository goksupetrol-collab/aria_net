-- Trigger: dbo.otomasonlineoku_trd
-- Tablo: dbo.otomasonlineoku
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.986986
================================================================================

CREATE TRIGGER [dbo].[otomasonlineoku_trd] ON [dbo].[otomasonlineoku]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
 declare @firmano int
 declare @otomasad varchar(50)
 declare @sonsatir float
 declare @sontarih datetime
 declare @sondosya  varchar(30)

  select @firmano=firmano,@otomasad=otomasad from deleted
 
 
  select top 1 @sonsatir=isnull(otomasid,0),
  @sondosya=dosya,
  @sontarih=tarih from otomasonlineoku
  where otomasad=@otomasad
  order by id desc

  update oto_onl_param
  set sonsatirno=@sonsatir,sontarih=@sontarih,
  sondosya=@sondosya where
  firmano=@firmano and otomasad=@otomasad



END

================================================================================
