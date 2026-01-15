-- View: dbo.Cari_Kart_Listesi
-- Tarih: 2026-01-14 20:06:08.468040
================================================================================

CREATE VIEW [dbo].[Cari_Kart_Listesi] AS
CREATE VIEW Cari_Kart_Listesi
AS
  SELECT k.id,k.TurId,tur.Ad as TurAd,
  k.grp1,k.grp2,k.grp3,k.firmano,k.sil,
  k.kod,k.ad,k.soyad,
  k.unvan,k.fisadet,k.fisakadet,
  k.fisaktut,k.actutar,k.limit_tip,
  k.ilgili,(g.ad) as Grup,k.perIDIN,k.per_id,
  k.fat_car_sec,k.fat_car_kod,k.fat_car_id,
  k.tel,k.fax,k.cep,k.muhonkod,k.muhkod,
  k.hesapno,k.Oto_FisVadeFark,k.AdresPostaKod,
  k.drm,k.resim,k.adres,k.evil,k.evilce,K.DBS_RefNo,
  k.vergidaire,k.vergino,k.vergikimlikno,k.EFatura,
  k.EfaturaTip,K.TicSicilNo,K.webadres,
  k.VergiEposta,k.mail,k.tcno,k.kulkod,
  k.kulsif,k.fatvadtip,k.TTS_OdeTip,
  k.fisvadtip,k.fatvadsur,k.fisvadsur,
  k.fatisk,k.fisvadfark,k.fatvadfark,k.fisisk,
  k.Ttsbayisk,k.Ttsdagisk,k.Ttsbayvadfark,k.Ttsdagvadfark,
  k.olususer,k.olustarsaat,k.deguser,k.degtarsaat,
  k.parabrm,k.otofisak,k.fatunvan,
  k.toplamteminat,k.toplamlimit,k.Risk_Limit,
  k.adres2,k.notack,k.epostagonder,k.webextre,
  k.ykt_alm_def_no,k.Arac_Ad,k.Epdk_LisansNo,
  isnull(Ars.Arac_Sayi,0) Arac_Sayi,k.AvansTakip,
  K.WebAvans,K.WebFatura,K.WebCariHrk,k.WebCariBakiye,
  K.WebFisOdendi,K.WebFaturaOdendi,K.WebPos,K.WebFisIskontoluTahsil,
  K.Web,K.WebFaturaTahsil,K.WebFaturaIskontoluTahsil,K.WebFis,
  K.WebFisTahsil,K.Remote_id,
  case
  when (fatvadtip<>'') and (fatvadtip<>'islemtar') then fatvadsur
  when (fisvadtip<>'') and (fisvadtip<>'islemtar') then fisvadsur
  when ((fatvadtip<>'') and (fisvadtip<>'')) and
  ((fatvadtip<>'islemtar') or (fisvadtip<>'islemtar')) then
  fatvadsur
  when (fatvadtip='') and (fisvadtip='') then
  1
  when (fatvadtip='islemtar') or (fisvadtip='islemtar') then
  1
  end Valor_Gun,
  bak.borc+bak.fis_brcbakiye+bak.irs_brcbakiye+bak.Avans_brcBakiye  as brc_bakiye,
  bak.alacak+bak.fis_alcbakiye+bak.irs_alcbakiye+bak.Avans_alcBakiye  as alc_bakiye,
  
  case when 
  (bak.borc+bak.fis_brcbakiye+bak.irs_brcbakiye+bak.Avans_brcBakiye)-
  (bak.alacak+bak.fis_alcbakiye+bak.irs_alcbakiye+bak.Avans_alcBakiye)>0 then
   ((bak.borc+bak.fis_brcbakiye+bak.irs_brcbakiye+bak.Avans_brcBakiye)-
  (bak.alacak+bak.fis_alcbakiye+bak.irs_alcbakiye+bak.Avans_alcBakiye))
  else 0 end brc_top_bakiye,
  
  case when 
  (bak.borc+bak.fis_brcbakiye+bak.irs_brcbakiye+bak.Avans_brcBakiye)-
  (bak.alacak+bak.fis_alcbakiye+bak.irs_alcbakiye+bak.Avans_alcBakiye)<0 then
  -1*( (bak.borc+bak.fis_brcbakiye+bak.irs_brcbakiye+bak.Avans_brcBakiye)-
  (bak.alacak+bak.fis_alcbakiye+bak.irs_alcbakiye+bak.Avans_alcBakiye))
  else 0 end alc_top_bakiye,
  
   
  
  bak.Avans_bakiye as avans_bakiye,
  bak.fis_bakiye as fis_bakiye,
  bak.car_bakiye as car_bakiye,
  bak.irs_bakiye as irs_bakiye,
  bak.cir_bakiye as cir_bakiye,
  
  round((bak.fis_bakiye+bak.irs_bakiye+bak.car_bakiye+bak.avans_bakiye),2) top_bakiye,
  bak.cek_bakiye  as cek_bakiye,
  ((bak.fis_bakiye+bak.irs_bakiye+bak.car_bakiye+bak.avans_bakiye)-bak.cek_bakiye) 
  as cekharc_bakiye,
  bak.sonhrk_tarih,
  bak.sonalc_tarih,
  bak.sonbrc_tarih,
  bak.sonbrc_tutar,
  bak.sonalc_tutar,
  bak.son_fis_tarih,
  bak.son_fis_tutar,
  bak.fis_adet,
  bak.irs_adet,
  
  
  
  ctm.tutar as teminat_tutar,
  ctm.ack as teminat_ack,
  isnull(pk.lttutar,0) as kul_tut_limit,
  k.toplamlimit-
  case when k.toplamlimit>0 then 
  round((bak.fis_bakiye+bak.irs_bakiye+bak.car_bakiye+bak.avans_bakiye),2)
  else
  0 end
  /*(isnull(pk.lttutar,0))  */
  as Kalan_limit,
  bak.FisOtoVadeFarkTutar,k.BankaKod,
  k.BankaDbs,bk.Ad as bankaAd

  from carikart as k WITH (NOLOCK)
  left join grup as g on g.id=case when k.grp3>0 then k.grp3
  when k.grp2>0 then k.grp2
  when k.grp1>0 then k.grp1 end
  left join Cari_Tur as tur WITH (NOLOCK) on tur.Id=k.TurId
  left join _Plaka_Limit_Cari_Miktar as pk WITH (NOLOCK) on k.kod=pk.carkod
  and pk.cartip='carikart'
  left join bankakart as bk with (nolock) on bk.Kod=k.BankaKod
  left join _Cari_AracSayi as ArS WITH (NOLOCK) on k.kod=ArS.kod and ArS.cartip='carikart'
  left join _Cari_Teminat as ctm WITH (NOLOCK) on k.kod=ctm.kod
  left join Bakiye_Cari as bak WITH (NOLOCK) on bak.kod=k.kod and bak.grp1=k.grp1
  and bak.grp2=k.grp2 and bak.grp3=k.grp3

================================================================================
