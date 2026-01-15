-- View: dbo.Bakiye_Rehber
-- Tarih: 2026-01-14 20:06:08.466307
================================================================================

CREATE VIEW [dbo].[Bakiye_Rehber] AS
CREATE VIEW [dbo].Bakiye_Rehber
AS
 select k.kod,
 isnull(h.borc,0) borc,
 isnull(h.alacak,0) alacak,
 isnull(h.bakiye,0) car_bakiye,
 h.sonhrk_tarih as sonhrk_tarih,
 f.fis_tarih as son_fis_tarih,
 isnull(f.fis_tutar,0) as son_fis_tutar,
 isnull(fisbak.fis_adet,0) fis_adet,
 isnull(fisbak.fis_bakiye,0) fis_bakiye
 from rehberkart as k with (nolock) 
 left join _Cari_Hrk_Bakiye as h with (nolock) on h.carkod=k.kod
 and h.cartip='rehberkart'
 LEFT join _Cari_Son_Fis as f with (nolock) on
 f.carkod=k.kod and f.cartip='rehberkart'
 left join _Cari_Fis_Bakiye as fisbak with (nolock)
 on fisbak.carkod=k.kod and fisbak.cartip='rehberkart'

================================================================================
