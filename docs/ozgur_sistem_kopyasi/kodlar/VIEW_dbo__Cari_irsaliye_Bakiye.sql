-- View: dbo._Cari_irsaliye_Bakiye
-- Tarih: 2026-01-14 20:06:08.457050
================================================================================

CREATE VIEW [dbo].[_Cari_irsaliye_Bakiye] AS
CREATE VIEW [dbo]._Cari_irsaliye_Bakiye
AS
  SELECT v.carkod,v.cartip,
  COUNT(*) irs_adet,
  ISNULL(SUM(case when gctip=2 then genel_top else -(genel_top) end),0)
   as irs_bakiye,
  ISNULL(SUM(case when gctip=2 then genel_top else 0 end),0)
   as irs_brcbakiye,
  ISNULL(SUM(case when gctip=1 then genel_top else 0 end),0)
   as irs_alcbakiye
  from irsaliyemas as v
  where v.sil=0 and v.kayok=1 and v.aktip in ('BK')
  group by v.cartip,v.carkod

================================================================================
