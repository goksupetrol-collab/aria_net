-- View: dbo.RehberBarkodListesi
-- Tarih: 2026-01-14 20:06:08.478500
================================================================================

CREATE VIEW [dbo].[RehberBarkodListesi] AS
CREATE VIEW [dbo].[RehberBarkodListesi]
As 
  SELECT 
  r.Id RehberId,r.GrupId as RehberGrupId,b.Id as BarkodId,b.Barkod,
  r.Unvan as RehberUnvan
  FROM  RehberKart as r with (nolock) 
  inner join RehberBarkod as b with (nolock)  on B.RehberId=r.Id
  and r.sil=0 and b.sil=0

================================================================================
