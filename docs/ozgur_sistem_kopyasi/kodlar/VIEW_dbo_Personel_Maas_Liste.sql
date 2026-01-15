-- View: dbo.Personel_Maas_Liste
-- Tarih: 2026-01-14 20:06:08.475859
================================================================================

CREATE VIEW [dbo].[Personel_Maas_Liste] AS
CREATE VIEW [dbo].Personel_Maas_Liste
AS
  SELECT h.id,h.firmano,h.carhrkid,h.permasmasid,h.islmtip,h.islmtipad,h.islmhrk,h.islmhrkad,
  h.yertip,h.yerad,h.tarih,h.saat,h.belno,h.cartip,h.carkod,k.ad+' '+k.soyad as unvan,
  alacak as tutar,ack,h.olususer,h.olustarsaat,h.deguser,h.degtarsaat,h.sil,h.devir
  from carihrk as h
  inner join perkart k on k.kod=h.carkod and k.gos=1 where
  h.permasmasid>0 AND h.cartip='perkart'

================================================================================
