-- View: dbo.Bakiye_Tank
-- Tarih: 2026-01-14 20:06:08.467312
================================================================================

CREATE VIEW [dbo].[Bakiye_Tank] AS
CREATE VIEW [dbo].Bakiye_Tank
AS
  SELECT k.kod,
  isnull(sum(h.giren-h.cikan),0) as mev_miktar,
  isnull(sum(h.giren),0) as gir_miktar,
  isnull(sum(giren*brmfiykdvli),0) gir_topkdvli,
  isnull(sum(giren*(brmfiykdvli/(1+h.kdvyuz))),0) as gir_topkdvsiz,
  isnull(sum(h.cikan),0) as cik_miktar,
  isnull(sum(cikan*brmfiykdvli),0) as cik_topkdvli,
  isnull(sum(cikan*(brmfiykdvli/(1+h.kdvyuz))),0) as cik_topkdvsiz
  
  
  
  from  tankkart as k WITH (NOLOCK)
  left join stkhrk as h WITH (NOLOCK) on
  h.depkod=k.kod and h.sil=0
  group by k.kod

================================================================================
