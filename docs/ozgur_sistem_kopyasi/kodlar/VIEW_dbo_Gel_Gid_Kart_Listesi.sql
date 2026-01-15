-- View: dbo.Gel_Gid_Kart_Listesi
-- Tarih: 2026-01-14 20:06:08.471001
================================================================================

CREATE VIEW [dbo].[Gel_Gid_Kart_Listesi] AS
CREATE VIEW [dbo].Gel_Gid_Kart_Listesi
AS
  SELECT k.[id],k.[firmano],f.ad as firmaad,k.[sil],k.[kod],
  k.[ad],k.[drm],k.[grp1],k.[grp2],k.[grp3],
  k.[fisbak],k.[carbak],k.[muhkod],k.[muhonkod],
  k.[olususer],k.[olustarsaat],
  k.[deguser],k.[degtarsaat],k.[fiyat],k.[toplim],k.limit_tip,
  k.[kdvtip],k.[kdv],k.[brim],k.[parabrm],
  k.[fisaktut],k.[fisadet],[fisakadet],[actutar],[gizli],
  bak.fis_bakiye as fis_bakiye,
  bak.car_bakiye as car_bakiye,
  round((bak.fis_bakiye+bak.car_bakiye),2) top_bakiye,
  ((bak.fis_bakiye-bak.car_bakiye)-bak.cek_bakiye) as cekharc_bakiye,
  bak.sonhrk_tarih,
  bak.son_fis_tarih,
  bak.son_fis_tutar,
  bak.fis_adet,
  (g.ad) grup,(k.fisbak+k.carbak) topbak from gelgidkart as k with (nolock)
  left join grup as g on g.id=case when k.grp3>0 then k.grp3
  when k.grp2>0 then k.grp2
  when k.grp1>0 then k.grp1 end
  inner join Bakiye_Gel_Gid as bak on bak.kod=k.kod
  left join firma as f with (nolock) on k.firmano=f.id

================================================================================
