-- View: dbo.Bakiye_Gel_Gid
-- Tarih: 2026-01-14 20:06:08.462997
================================================================================

CREATE VIEW [dbo].[Bakiye_Gel_Gid] AS
CREATE VIEW [dbo].Bakiye_Gel_Gid
AS
 select k.kod,
 isnull(h.borc,0) borc,
 isnull(h.alacak,0) alacak,
 isnull(h.bakiye,0) car_bakiye,
 h.sonhrk_tarih as sonhrk_tarih,
 f.fis_tarih as son_fis_tarih,
 isnull(f.fis_tutar,0) as son_fis_tutar,
 isnull(fisbak.fis_adet,0) fis_adet,
 isnull(fisbak.fis_bakiye,0) fis_bakiye,
 isnull(cek.cek_bakiye,0) as cek_bakiye
 from gelgidkart as k
 left join _Cari_Hrk_Bakiye as h on h.carkod=k.kod
 and h.cartip='gelgidkart'
 LEFT join _Cari_Son_Fis as f on
 f.carkod=k.kod and f.cartip='gelgidkart'
 left join _Cari_Fis_Bakiye as fisbak
 on fisbak.carkod=k.kod and fisbak.cartip='gelgidkart'
 left join _Cari_Cek_Bakiye as cek on
 cek.carkod=k.kod and cek.cartip='gelgidkart'

================================================================================
