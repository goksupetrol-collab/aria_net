-- View: dbo.Bakiye_Perakende
-- Tarih: 2026-01-14 20:06:08.464332
================================================================================

CREATE VIEW [dbo].[Bakiye_Perakende] AS
CREATE VIEW [dbo].Bakiye_Perakende
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
 from perakendekart as k
 left join _Cari_Hrk_Bakiye as h on h.carkod=k.kod
 and h.cartip='perakendekart'
 LEFT join _Cari_Son_Fis as f on
 f.carkod=k.kod and f.cartip='perakendekart'
 left join _Cari_Fis_Bakiye as fisbak
 on fisbak.carkod=k.kod and fisbak.cartip='perakendekart'

================================================================================
