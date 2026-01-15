-- View: dbo._Plaka_Limit_Miktar
-- Tarih: 2026-01-14 20:06:08.459840
================================================================================

CREATE VIEW [dbo].[_Plaka_Limit_Miktar] AS
CREATE VIEW [dbo]._Plaka_Limit_Miktar
AS
  SELECT v.cartip,v.carkod,v.plaka,
  h.stkod,
  isnull(sum(h.mik),0) as miktarlt,
  isnull(sum(h.mik*h.brmfiy),0) as lttutar
  from veresimas as v WITH (NOLOCK) 
  inner join veresihrk as h WITH (NOLOCK)
  on h.verid=v.verid and h.sil=0 and v.sil=0
  and h.stktip='akykt' and v.aktip='BK'
  group by v.cartip,v.carkod,h.stkod,
  v.plaka

================================================================================
