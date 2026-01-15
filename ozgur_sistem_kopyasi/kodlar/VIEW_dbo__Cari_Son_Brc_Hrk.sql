-- View: dbo._Cari_Son_Brc_Hrk
-- Tarih: 2026-01-14 20:06:08.457723
================================================================================

CREATE VIEW [dbo].[_Cari_Son_Brc_Hrk] AS
CREATE VIEW [dbo]._Cari_Son_Brc_Hrk
AS
  SELECT v.carkod,
  v.cartip,
  (case when borc>0 then v.tarih else null end ) sonbrc_tarih,
  ISNULL((case when borc>0 then v.borc
  else 0 end),0) as sonbrc_tutar
  FROM carihrk as v
  inner join ___Son_Car_Brc_Hrk as h
  on v.sil=0 and v.carkod=h.carkod and v.cartip=h.cartip
  and v.id=h.son_id

================================================================================
