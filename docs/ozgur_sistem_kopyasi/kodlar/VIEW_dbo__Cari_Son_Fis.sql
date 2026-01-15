-- View: dbo._Cari_Son_Fis
-- Tarih: 2026-01-14 20:06:08.458145
================================================================================

CREATE VIEW [dbo].[_Cari_Son_Fis] AS
CREATE VIEW [dbo]._Cari_Son_Fis
AS
  SELECT v.carkod,v.cartip,
  v.tarih as fis_tarih,
  ISNULL((case when v.fistip='FISVERSAT' then v.toptut
  else -v.toptut end),0) as fis_tutar FROM veresimas as v
  WITH (NOLOCK) 
  inner join ___Son_Fis_Hrk as h WITH (NOLOCK)
  on v.sil=0 and v.carkod=h.carkod and v.cartip=h.cartip
  and v.id=h.son_id

================================================================================
