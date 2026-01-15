-- View: dbo.Cari_Vadefark_Liste
-- Tarih: 2026-01-14 20:06:08.468402
================================================================================

CREATE VIEW [dbo].[Cari_Vadefark_Liste] AS
CREATE VIEW [dbo].Cari_Vadefark_Liste
AS
  SELECT h.id,h.carhrkid,h.carvardmasid,h.islmtip,h.islmtipad,h.islmhrk,h.islmhrkad,
  h.yertip,h.yerad,h.tarih,h.saat,h.belno,h.cartip,h.carkod,k.ad+' '+k.soyad as unvan,
  tutar=case when borc>0 then borc else alacak end,ack,h.olususer,h.olustarsaat,h.deguser,h.degtarsaat,h.sil from carihrk as h
  inner join carikart k on k.kod=h.carkod where
  h.carvardmasid>0 AND h.cartip='carikart'

================================================================================
