-- View: dbo.RehberGrupDetayListesi
-- Tarih: 2026-01-14 20:06:08.478838
================================================================================

CREATE VIEW [dbo].[RehberGrupDetayListesi] AS
CREATE VIEW [dbo].[RehberGrupDetayListesi]
As 
  SELECT 
  g.Id GrupId,h.Id as GrupDetayId,h.StokGrupId,
  h.KomisyonYuzde,h.IndirimYuzde
  FROM  RehberGrup as g with (nolock) 
  inner join RehberGrupDetay as h with (nolock)  on g.Id=h.GrupId
  and g.sil=0 and h.sil=0

================================================================================
