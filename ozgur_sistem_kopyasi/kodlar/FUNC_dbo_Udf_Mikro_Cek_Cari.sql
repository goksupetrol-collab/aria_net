-- Function: dbo.Udf_Mikro_Cek_Cari
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.753789
================================================================================

CREATE FUNCTION [dbo].[Udf_Mikro_Cek_Cari](
@bastar datetime,
@bittar datetime)
RETURNS
  @TB_MIKRO_CEK TABLE (
  cek_id                 int,
  hrk_id                 int,
  cek_drm                varchar(5),
  hrk_tarih              DateTime,
  sck_iptal              int,/* */
  sck_tip                Tinyint,
  sck_refno              Varchar(25),/* Senet Çek Referans No */
  sck_ilk_evrak_seri     Varchar(4),
  sck_ilk_evrak_sira_no  int,
  sck_ilk_evrak_satir_no int,
  sck_bankano            Varchar(25),/* Banka No Bkz. BANKALAR */
  sck_borclu             Varchar(30),/* Borçlu Adı */
  sck_vdaire_no          Varchar(40),/* Vergi Daire Numarası */
  sck_hesapno_sehir      Varchar(20),/*hesap no */
  sck_vade               DateTime,/* Vade Tarihi */
  sck_tutar              Float,/* Tutar */
  sck_doviz              Tinyint,/* Döviz Cinsi Bkz. DOVIZ_KURLARI */
  sck_banka_adres1       Varchar(50),/* Banka Adresi */
  sck_sube_adres2        Varchar(50),/* Şube Adresi */
  sck_duzen_tarih        DateTime,/* Düzenlenme Tarihi */
  sck_sahip_cari_cins    Tinyint,/* Senet-Çek Sahibi Cari Cinsi */
  sck_sahip_cari_kodu    Varchar(25),/* Senet-Çek Sahibi Cari Kodu Bkz. CARI_HESAPLAR */
  sck_sahip_cari_grupno  Tinyint,/* Senet-Çek Sahibi Grup No */
  sck_nerede_cari_cins   Tinyint,/* Nerede Cari Cinsi 0:Carimiz 1:Cari Personelimiz 2:Bankamız 3:Hizmetimiz 4:Kasamız 5:Giderimiz 6:Muhasebe Hesabımız 7:Personelimiz 8:Demirbaşımız 9:İthalat Dosyamız 10:Finansal Sözleşmemiz */
  sck_nerede_cari_kodu   Varchar(25),/* Nerede Cari Kodu */
  sck_nerede_cari_grupno Tinyint,/* Nerede Grup No */
  evrak_cari_cins        Tinyint,/* evrak Cari Cinsi 0:Carimiz 1:Cari Personelimiz 2:Bankamız 3:Hizmetimiz 4:Kasamız 5:Giderimiz 6:Muhasebe Hesabımız 7:Personelimiz 8:Demirbaşımız 9:İthalat Dosyamız 10:Finansal Sözleşmemiz */
  evrak_cari_kodu        Varchar(25),/*evrak Cari Kodu */
  evrak_cari_grupno      Tinyint,/*evrak Grup No */
  sck_no                 Varchar(25),/* Senet Çek No */
  sck_doviz_kur          Float,/* Döviz Kuru Bkz. DOVIZ_KURLARI */
  sck_sonpoz             Tinyint,/* Senet Çek Pozisyonu 0:Portföyde 1:Ciro 2:Tahsilde 3:Teminatta 4:İade Edilen 5:Diğer3 6:Ödenmedi Portföyde 7:Ödenmedi İade 8:İcrada 9:Kısmen Ödendi 10:Ödendi */
  sck_masraf1            Float,/* Masraf1 */
  sck_imza               Tinyint
  )
  
  
AS
BEGIN

/*http://yardim.mye.com.tr/Library/Diger/DBYapisi_V12/Tablolar/odeme_emirleri.htm */

/*http://yardim.mye.com.tr/Library/Diger/DBYapisi_V12/Tablolar/cari_hesap_hareketleri.htm */


  insert into @TB_MIKRO_CEK
  (cek_id,hrk_id,cek_drm,hrk_tarih,sck_iptal,sck_tip,sck_refno,
  sck_ilk_evrak_seri,sck_ilk_evrak_sira_no,
  sck_ilk_evrak_satir_no,
  sck_bankano,sck_borclu,sck_vdaire_no,
  sck_hesapno_sehir,sck_vade,sck_tutar,sck_doviz,
  sck_banka_adres1,sck_sube_adres2,
  sck_duzen_tarih,
  sck_sahip_cari_cins,sck_sahip_cari_kodu,
  sck_sahip_cari_grupno,sck_nerede_cari_cins,
  sck_nerede_cari_kodu,sck_nerede_cari_grupno,
  evrak_cari_cins,evrak_cari_kodu,evrak_cari_grupno,
  sck_no,sck_doviz_kur,
  sck_sonpoz,sck_masraf1,
  sck_imza)

  select m.cekid,
  hrk_id=h.id,
  cek_drm=h.drm,
  hrk_tarih=h.tarih,
  sck_iptal=case
  when h.drm='PID' then 1
  when m.sil=1 then 1
  else 0 end,
  sck_tip=case
  when (m.islmhrk='ALN') then 0
  when (m.islmhrk='KSN') then 2
  end,

  /*0:Müşteri Çeki 1:Müşteri Senedi 2:Kendi Çekimiz */
  /*3:Kendi Senedimiz 4:Müşteri Havale Sözü 5:Müşteri Ödeme Sözü */
  /*6:Müşteri Kredi Kartı 7:Kendi Havale Emrimiz 8:Kendi Ödeme Emrimiz 9:Kendi Kredi Kartımız */
  m.refno as sck_refno,
  sck_ilk_evrak_seri='CEK',
  sck_ilk_evrak_sira_no=m.cekid,
  sck_ilk_evrak_satir_no=0,/*m.id, */
  sck_bankano=case
  when m.islmhrk='KSN' then m.bankod
  else '' end,
  sck_borclu=case
  when (m.islmhrk='ALN') and (m.cartip='carikart') then
  (select top 1 substring(unvan,1,30) from carikart where kod=m.carkod and sil=0)
  when (m.islmhrk='ALN') and (m.cartip='perkart') then
  (select top 1 substring(ad+' '+soyad,1,30)  from perkart where kod=m.carkod and sil=0)
  when (m.islmhrk='ALN') and (m.cartip='gelgidkart') then
  (select top 1 substring(ad,1,30) from gelgidkart where kod=m.carkod and sil=0)
  else
  'FIRMA'
  end,
  substring(m.ack,1,50) as sck_vdaire_no,/*aciklama */
  sck_hesapno_sehir=m.hesepno,
  m.vadetar as sck_vade,
  sck_tutar=case
  when m.islmhrk='KSN' then m.cikan
  when m.islmhrk='ALN' then m.giren
  end,
  0 as sck_doviz,
  /*0 as sck_odenen, */
  m.banka as sck_banka_adres1,
  m.banksub as sck_sube_adres2,
  m.tarih as sck_duzen_tarih,
  /*when (m.islmtip='ALN') and (cartip='carikart') then 0 */
  /* 0:Carimiz 1:Cari Personelimiz 2:Bankamız 3:Hizmetimiz 4:Kasamız 5:Giderimiz 6:Muhasebe Hesabımız 7:Personelimiz 8:Demirbaşımız 9:İthalat Dosyamız 10:Finansal Sözleşmemiz */
  sck_sahip_cari_cins=case
  when (m.islmhrk='ALN') and (m.cartip='carikart')  THEN 0 /*cari */
  when (m.islmhrk='ALN') and (m.cartip='perkart') then 1 /*personel */
  when (m.islmhrk='ALN') and (m.cartip='bankakart') then 2 /*banka */
  when (m.islmhrk='ALN') and (m.cartip='kasakart') then 4 /*kasa */
  when (m.islmhrk='ALN') and (m.cartip='gelgidkart') then 5 /* 5:Giderimiz */

  when (m.islmhrk='KSN') then 2 /* banka */
  end, /*0:Carimiz 1:Cari Personelimiz 2:Bankamız 3:Hizmetimiz 4:Kasamız */
  sck_sahip_cari_kodu=case
  when (m.islmhrk='ALN') then m.carkod
  when (m.islmhrk='KSN') then m.bankod
  end,

  sck_sahip_cari_grupno=case
  when (m.islmhrk='ALN') then 0
  when (m.islmhrk='KSN') then 2 /* */
  end,
  
  sck_nerede_cari_cins=case
  when (h.drm='POR') then 4 /* kasada */
  when (h.drm='KSN') then 0 /*caride */
  when (h.drm='TAK') then 2 /* bankada */
  when (h.drm='ODE') then 2 /* bankada */
  end,
  
  sck_nerede_cari_kodu=case
  when (h.drm='POR') then 'CEK' /* kasada */
  when (h.drm='KSN') then h.carkod /*musteride */
  when (h.drm='TAK') then h.carkod /*banka */
  when (h.drm='ODE') then h.carkod /*banka */
  
  end,
  0 as sck_nerede_cari_grupno,

  evrak_cari_cins=case
  /*takasa gonder cek kasasından cıkıyor */
  when (h.drm='TAK') then 4 /* kasada */
  when (h.drm='ODE') then 2 /* banka kesilen cek */
  end,
 
  evrak_cari_kodu=case
  when (h.drm='TAK') then 'CEK' /* kasada */
  when (h.drm='ODE') then h.carkod
  end,
  0 as evrak_cari_grupno,

  sck_no=m.ceksenno,
  kur as sck_doviz_kur,
  sck_sonpoz=case
  when h.drm='POR' THEN 0 /*0:Portföyde */
  when h.drm='KSN' THEN 1
  when h.drm='CIR' THEN 1 /*1:Ciro */
  when h.drm='TAK' THEN 2 /*2:Tahsilde */
  /*when drm='TEM' THEN 3 --3:Teminatta */
  when h.drm='PID' THEN 4 /*4:İade Edilen */
  when h.drm='TAK' THEN 5 /*5:Diğer3 */
  when h.drm='PKR' THEN 6 /*6:Ödenmedi Portföyde */
  when h.drm='PID' THEN 7 /*7:Ödenmedi İade */
  /*when drm='TAK' THEN 8 --8:İcrada */
  /*when drm='TAK' THEN 8 --8:Kısmen Ödendi */
  when h.drm='ODE' THEN 10 /*10:Ödendi kesilen cek odeme kasadan */
  when h.drm='ELT' THEN 10 /*alinan cek elden ödendi elden */
  when h.drm='TKT' THEN 10 /*kesilen cek ödendiii bankadan */
  end,
  sck_masraf1=h.gidtutar,
  sck_imza=case /* sahibi */
  when m.islmhrk='KSN' then 0 /*kendimiz */
  when m.islmhrk='ALN' then 0 /*müsteri */
  end
  from cekkart as m
  inner join cekhrk h on
  h.cekid=m.cekid where
  h.sil=0 and m.sil=0
  and m.tarih>=@bastar and m.tarih<=@bittar
  order by m.cekid,h.id

/*
  while not (select top 1 count(cek_drm) from @TB_MIKRO_CEK
  sub group by cek_id,cek_drm having count(cek_drm)>1)=0
  begin
  delete from @TB_MIKRO_CEK
  where hrk_id in (select min(hrk_id) from @TB_MIKRO_CEK
  sub group by cek_id,cek_drm having count(cek_drm)>1)
 
  end
 */

 return


END

================================================================================
