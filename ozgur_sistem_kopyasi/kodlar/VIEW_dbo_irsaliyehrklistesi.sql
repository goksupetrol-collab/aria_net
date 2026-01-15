-- View: dbo.irsaliyehrklistesi
-- Tarih: 2026-01-14 20:06:08.472712
================================================================================

CREATE VIEW [dbo].[irsaliyehrklistesi] AS
CREATE VIEW [dbo].irsaliyehrklistesi
AS
  SELECT id,irid,'S' as satirtip,sil,firmano,stktip,stkod,mik,
  brmfiy,depkod,kdvyuz,kdvtut,kdvtip,brim,
  ustbrim,carpan,parabrim,grupid,
  kayok from irsaliyehrk  with (nolock)

================================================================================
