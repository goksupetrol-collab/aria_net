-- View: dbo.Stok_Kart_Birim
-- Tarih: 2026-01-14 20:06:08.481998
================================================================================

CREATE VIEW [dbo].[Stok_Kart_Birim] AS
CREATE VIEW [dbo].Stok_Kart_Birim
AS
  SELECT  k.tip,k.kod,k.brim as brm_kod,1 as brm_carpan from stokkart as k with (nolock)
  union 
  SELECT  k.tip,k.kod,k.brmust as brm_kod,k.brmcarp as brm_carpan from stokkart as k with (nolock)
  where k.brmust<>''
  union
  SELECT  k.tip,k.kod,k.brmust2 as brm_kod,k.brmcarp2 as brm_carpan
  from stokkart as k with (nolock) where k.brmust2<>''

================================================================================
