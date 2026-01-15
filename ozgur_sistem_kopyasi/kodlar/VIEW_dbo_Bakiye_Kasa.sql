-- View: dbo.Bakiye_Kasa
-- Tarih: 2026-01-14 20:06:08.464011
================================================================================

CREATE VIEW [dbo].[Bakiye_Kasa] AS
CREATE VIEW [dbo].Bakiye_Kasa
AS
  SELECT k.kod,
  ISNULL(SUM(h.giren),0) as giren,
  ISNULL(SUM(h.cikan),0) as cikan
  FROM kasakart as k left join kasahrk as h on h.kaskod=k.kod
  and h.sil=0 group by k.kod

================================================================================
