-- View: dbo._Cari_Son_Alc_Hrk
-- Tarih: 2026-01-14 20:06:08.457382
================================================================================

CREATE VIEW [dbo].[_Cari_Son_Alc_Hrk] AS
CREATE VIEW [dbo]._Cari_Son_Alc_Hrk
AS
  SELECT v.carkod,
  v.cartip,
  (case when alacak>0 then v.tarih else null end ) sonalc_tarih,
  ISNULL((case when alacak>0 then v.alacak
  else 0 end),0) as sonalc_tutar FROM carihrk as v
  inner join ___Son_Car_Alc_Hrk as h
  on v.sil=0 and v.carkod=h.carkod and v.cartip=h.cartip
  and v.id=h.son_id

================================================================================
