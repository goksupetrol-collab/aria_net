-- View: dbo.Personel_Kart_Listesi
-- Tarih: 2026-01-14 20:06:08.475243
================================================================================

CREATE VIEW [dbo].[Personel_Kart_Listesi] AS
CREATE VIEW [dbo].Personel_Kart_Listesi
AS
  SELECT k.[id],k.[drm],k.[sil],
  k.[firmano],f.ad as firmaad,
  k.[kod],k.[grp1],k.[grp2],k.[grp3],k.[ad],k.[soyad],
  k.[tel],k.[fax],k.[cep],k.[muhkod],k.muhonkod,
  k.[resim],k.[adres],k.[evil],[evilce],
  k.[vergidaire],k.[vergino],k.[mail],k.[tcno],k.[toplim],k.limit_tip,
  k.[maasgun],k.[maas],k.[prim],k.[isk],k.[isbastar],k.[isbittar],
  k.[fisbak],k.[carbak],k.[gos],
  k.[olususer],k.[olustarsaat],k.[deguser],k.[degtarsaat],
  k.[fisadet],k.[fisaktut],k.[fisakadet],k.[parabrm],k.[actutar],k.[adres2],
  k.ad+' '+k.soyad as unvan,
  k.sgkno,k.banka_ad,k.banka_sube,k.hesapno,
  bak.fis_bakiye as fis_bakiye,
  bak.car_bakiye as car_bakiye,
  round((bak.fis_bakiye+bak.car_bakiye),2) top_bakiye,
  ((bak.fis_bakiye-bak.car_bakiye)-bak.cek_bakiye) as cekharc_bakiye,
  bak.sonhrk_tarih,
  bak.son_fis_tarih,
  bak.son_fis_tutar,
  bak.fis_adet,
  (g.ad) grup,(k.fisbak+k.carbak) topbak from perkart as k
  left join grup as g on g.id=case when k.grp3>0 then k.grp3
  when k.grp2>0 then k.grp2
  when k.grp1>0 then k.grp1 end
  inner join Bakiye_Personel as bak on bak.kod=k.kod
  left join firma as f on k.firmano=f.id

================================================================================
