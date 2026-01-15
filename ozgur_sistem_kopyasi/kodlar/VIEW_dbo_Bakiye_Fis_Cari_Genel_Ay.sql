-- View: dbo.Bakiye_Fis_Cari_Genel_Ay
-- Tarih: 2026-01-14 20:06:08.462327
================================================================================

CREATE VIEW [dbo].[Bakiye_Fis_Cari_Genel_Ay] AS
CREATE VIEW [dbo].Bakiye_Fis_Cari_Genel_Ay
AS
 select h.cartip,h.carkod,
 isnull(h.bakiye,0) bakiye,
 h.ay as Ay,h.Yil as Yil
 from _Cari_Hrk_Bakiye_Ay as h
 where  h.cartip in ('carikart','perkart','gelgidkart')
 union all
 select f.cartip,f.carkod,
 isnull(f.fis_bakiye,0) bakiye,
 f.ay as Ay,f.Yil as Yil
 from _Cari_Fis_Bakiye_Ay as f
 where  f.cartip in ('carikart','perkart','gelgidkart')

================================================================================
