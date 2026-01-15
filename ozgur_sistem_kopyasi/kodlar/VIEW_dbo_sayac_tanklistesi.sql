-- View: dbo.sayac_tanklistesi
-- Tarih: 2026-01-14 20:06:08.479599
================================================================================

CREATE VIEW [dbo].[sayac_tanklistesi] AS
CREATE VIEW [dbo].sayac_tanklistesi
AS
  select k.id,k.kod sayac_kod,k.ad as sayac_ad,t.kod as tank_kod,t.ad as tank_ad,
  t.bagak from sayackart as k with (nolock) inner join tankkart as t with (nolock) on t.kod=k.tankod
  where t.sil=0 and k.sil=0 and k.drm='Aktif'

================================================================================
