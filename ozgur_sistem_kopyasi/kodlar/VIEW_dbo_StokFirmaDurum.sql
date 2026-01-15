-- View: dbo.StokFirmaDurum
-- Tarih: 2026-01-14 20:06:08.484079
================================================================================

CREATE VIEW [dbo].[StokFirmaDurum] AS
CREATE VIEW dbo.StokFirmaDurum 
AS
   select TOP 100 PERCENT 
      stktip,stkod,Firmano,
      isnull(Sum(case when islmtip='HARGIRCIK' then 
      round((giren-cikan),2) else 0 end),0) as har_miktar,
      isnull(sum(giren),0) gir_miktar,
      isnull(sum(cikan),0) cik_miktar,
      isnull(sum(giren*brmfiykdvli),0) gir_topkdvli,
      isnull(sum(giren*(brmfiykdvli/(1+kdvyuz))),0) as gir_topkdvsiz,
      isnull(sum(cikan*brmfiykdvli),0) as cik_topkdvli,
      isnull(sum(cikan*(brmfiykdvli/(1+kdvyuz))),0) as cik_topkdvsiz,
      isnull(sum(giren-cikan),0) mev_miktar,
      
      isnull(sum(round(aiademik,2)),0) as alsiade_mik,
      isnull(sum(aiademik*brmfiykdvli),0) alsiade_topkdvli,
      isnull(sum(round(siademik,2)),0) as satiade_mik,
      isnull(sum(siademik*brmfiykdvli),0) as satiade_topkdvli,
     
      isnull( case when sum(giren)>0 then
      (sum(giren*brmfiykdvli)) / sum(giren)
      else 0 end , 0)  ortals_fiykdvli,
      isnull(case when sum(giren)>0 then
      (sum(giren*(brmfiykdvli / (1+kdvyuz)) )) / sum(giren)
      else 0 end , 0)  ortals_fiykdvsiz
      from  stkhrk as mk WITH (NOLOCK, INDEX = stkhrk_idx5)
      where  mk.sil=0  
      group by stktip,stkod,firmano,depkod
      ORDER BY firmano

================================================================================
