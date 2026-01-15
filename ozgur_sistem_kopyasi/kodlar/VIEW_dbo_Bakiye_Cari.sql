-- View: dbo.Bakiye_Cari
-- Tarih: 2026-01-14 20:06:08.461826
================================================================================

CREATE VIEW [dbo].[Bakiye_Cari] AS
CREATE VIEW [dbo].Bakiye_Cari
AS
 select k.kod,
 k.grp1,k.grp2,k.grp3,
 isnull(h.borc,0) borc,
 isnull(h.alacak,0) alacak,
 isnull(h.bakiye,0) car_bakiye,
 h.sonhrk_tarih as sonhrk_tarih,
 chb.sonbrc_tarih as sonbrc_tarih,
 cha.sonalc_tarih as sonalc_tarih,
 
 isnull(cha.sonalc_tutar,0) as sonalc_tutar,
 isnull(chb.sonbrc_tutar,0) as sonbrc_tutar,
 
 f.fis_tarih as son_fis_tarih,
 isnull(fisbak.fis_alcbakiye,0) fis_alcbakiye,
 isnull(fisbak.fis_brcbakiye,0) fis_brcbakiye,
 
 isnull(irs.irs_alcbakiye,0) irs_alcbakiye,
 isnull(irs.irs_brcbakiye,0) irs_brcbakiye,
 isnull(irs.irs_adet,0) irs_adet,
 
 

  isnull(Avs.alacak,0) Avans_alcbakiye,
  isnull(Avs.borc,0) Avans_brcbakiye,
  isnull(Avs.bakiye,0) Avans_bakiye,
 
 isnull(f.fis_tutar,0) as son_fis_tutar,
 isnull(fisbak.fis_adet,0) fis_adet,
 isnull(fisbak.fis_bakiye,0) fis_bakiye,
 isnull(irs.irs_bakiye,0) irs_bakiye,
 isnull(cek.cek_bakiye,0)+isnull(cir.cek_bakiye,0)  as cek_bakiye,
 isnull(cir.cek_bakiye,0) as cir_bakiye,
 
 isnull(FisOtoVade.FisOtoVadeFarkTutar,0) as FisOtoVadeFarkTutar
 
 
 
 
 from carikart as k with (nolock)
 left join _Cari_Hrk_Bakiye as h on h.carkod=k.kod
 and h.cartip='carikart' 
 LEFT join _Cari_Son_Fis as f on
 f.carkod=k.kod and f.cartip='carikart'
 LEFT join _Cari_Son_Brc_Hrk as chb on
 chb.carkod=k.kod and chb.cartip='carikart'
 LEFT join _Cari_Son_Alc_Hrk as cha on
 cha.carkod=k.kod and cha.cartip='carikart'
 left join _Cari_Fis_Bakiye as fisbak
 on fisbak.carkod=k.kod and fisbak.cartip='carikart'
 left join _Cari_Cek_Bakiye as cek on
 cek.carkod=k.kod and cek.cartip='carikart'
 left join _Cari_Ciro_Bakiye as cir on
 cir.carkod=k.kod and cir.cartip='carikart'
 left join _Cari_irsaliye_Bakiye as irs on
 irs.carkod=k.kod and irs.cartip='carikart'
 left join _Cari_Avans_Bakiye as Avs on
 Avs.carkod=k.kod and Avs.cartip='carikart'
 left join __CariOtoFisVadeFarkTutar as FisOtoVade on
 FisOtoVade.car_id=k.id

================================================================================
