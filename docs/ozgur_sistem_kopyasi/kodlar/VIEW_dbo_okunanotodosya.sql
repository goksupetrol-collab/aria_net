-- View: dbo.okunanotodosya
-- Tarih: 2026-01-14 20:06:08.474222
================================================================================

CREATE VIEW [dbo].[okunanotodosya] AS
CREATE VIEW [dbo].okunanotodosya
AS
  SELECT firmano,otomasad,dosya,
  min(tarih+cast(saat as datetime)) bastarih,
  max(tarih+cast(saat as datetime)) sontarih,
  count(*) topkayit,
  sum(cast(aktar as int)) as aktarkayit
  from otomasoku with (nolock)
  group by firmano,otomasad,dosya

================================================================================
