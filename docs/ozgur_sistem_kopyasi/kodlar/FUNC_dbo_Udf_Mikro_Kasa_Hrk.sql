-- Function: dbo.Udf_Mikro_Kasa_Hrk
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.755043
================================================================================

CREATE FUNCTION [dbo].[Udf_Mikro_Kasa_Hrk]
(@Bastar DATETIME,
@Bittar DATETIME)
RETURNS
  @TB_MIKRO_FATURA TABLE (
  hrk_id                 int,
  cha_satir_no           int,
  cha_tarihi             datetime,
  cha_tip                int,
  cha_cinsi              int,
  cha_normal_Iade        int,
  cha_evrak_tip          int,
  cha_evrakno_seri       Varchar(20),
  cha_evrakno_sira       int,
  cha_belge_no           Varchar(50),
  cha_belge_tarih        datetime,
  cha_vade               datetime,
  cha_cari_cins          int,
  cha_kod                Varchar(30),
  cha_kasa_hizmet        int,/*0:Carimiz 1:Cari Personelimiz 2:Bankamız 3:Hizmetimiz 4:Kasamız 5:Giderimiz 6:Muhasebe Hesabımız 7:Personelimiz 8:Demirbaşımız 9:İthalat Dosyamız 10:Finansal Sözleşmemiz */
  cha_kasa_hizkod        Varchar(25),
  cha_d_kurtar           datetime,
  cha_d_cins             int,
  cha_d_kur              float,
  cha_grupno             int,
  cha_meblag             float,
  cha_fis_tarih          datetime,
  cha_fis_sirano         Int,
  cha_vergi1             float,
  cha_vergi2             float,
  cha_vergi3             float,
  cha_vergi4             float,
  cha_vergi5             float,
  cha_tpoz               int,
  cha_aciklama           Varchar(100),
  cha_sntck_poz          int,
  cha_reftarihi          datetime,
  cha_aratoplam          float,
  cha_pos_hareketi       int,
  cha_ciro_cari_kodu     Varchar(30)
  )
AS
BEGIN

/*http://yardim.mye.com.tr/Library/Diger/DBYapisi_V12/Tablolar/cari_hesap_hareketleri.htm */
/* islmtip TAH  TAHSILAT */
/*islmhrk  ODE  ODEME */



  insert into @TB_MIKRO_FATURA
  (hrk_id,cha_satir_no,cha_tarihi,cha_tip,cha_cinsi,cha_normal_Iade,cha_evrak_tip,
  cha_evrakno_seri,cha_evrakno_sira,cha_belge_no,
  cha_belge_tarih,cha_vade,
  cha_cari_cins,cha_kod,
  cha_kasa_hizmet,cha_kasa_hizkod,
  cha_d_kurtar,
  cha_d_cins,cha_d_kur,cha_grupno,cha_meblag,
  cha_fis_tarih,cha_fis_sirano,cha_vergi1,
  cha_vergi2,cha_vergi3,cha_vergi4,cha_vergi5,
  cha_tpoz,cha_aciklama,cha_sntck_poz,cha_reftarihi,
  cha_aratoplam,cha_pos_hareketi,cha_ciro_cari_kodu )

/*kasa için borc giren ,cikan alacak */
/*tahsilat dekontu borc */
/*tediye dekontu alacak */

  select m.id,
  m.id,m.tarih as cha_tarihi,
  cha_tip=case
     when (m.gctip='G' or m.gctip='A' ) then 1
     when (m.gctip='C' or m.gctip='B' ) then  0 end, /*0 borc ,1 alacak--cariye gore */
    cha_cinsi=case
    when (m.islmhrk='VRC') or (m.islmhrk='VRG')  then
    5
    else
    0 end,/*0:Nakit 1:Müşteri Çeki 2:Müşteri Senedi 3:Firma Çeki 4:Firma Senedi 5:Dekont */
    cha_normal_Iade=0, /*0:Normal 1:İade */
  cha_evrak_tip= case
      when (m.islmtip='TAH') then  1
     when (m.islmtip='ODE') then  64
     when (m.islmhrk='VRC') or (m.islmhrk='VRG')  then  33 /*58 */
     end,  /*1:tahsilat Faturası , 64:tediye odeme */
  cha_evrakno_seri='KAS',  /*Varchar(4) */
  cha_evrakno_sira=m.kashrkid,  /*integer */
  cha_belge_no=m.belno, /* Varchar(15) */
  cha_belge_tarih=m.tarih,
  cha_vade=m.tarih,
  cha_cari_cins=case
   when (m.islmtip='TAH') and (m.cartip='carikart') then  0
   when (m.islmtip='TAH') and (m.cartip='perkart') then  1
   when (m.islmtip='ODE') and (m.cartip='carikart') then 0
   when (m.islmtip='ODE') and (m.cartip='perkart') then  1
   when m.cartip='bankakart' then  2
   when (m.islmhrk='VRC') or (m.islmhrk='VRG')  then  4
   end,
   /*0:Carimiz 1:Cari Personelimiz 2:Bankamız 3:Hizmetimiz 4:Kasamız 5:Giderimiz 6:Muhasebe Hesabımız 7:Personelimiz 8:Demirbaşımız 9:İthalat Dosyamız 10:Finansal Sözleşmemiz */
  cha_kod=case
   when m.islmtip='TAH' then  m.carkod
   when m.islmtip='ODE' then  m.carkod
   when (m.islmhrk='VRC') or (m.islmhrk='VRG')  then m.kaskod
   end,/*Varchar(25) */
  cha_kasa_hizmet=case
   when m.islmtip='TAH' then  4
   when m.islmtip='ODE' then  4
   when (m.islmhrk='VRC') or (m.islmhrk='VRG')  then 0
   end,
  /*0:Carimiz 1:Cari Personelimiz 2:Bankamız 3:Hizmetimiz 4:Kasamız 5:Giderimiz 6:Muhasebe Hesabımız 7:Personelimiz 8:Demirbaşımız 9:İthalat Dosyamız 10:Finansal Sözleşmemiz */
  cha_kasa_hizkod=case
   when m.islmtip='TAH' then  m.kaskod
   when m.islmtip='ODE' then  m.kaskod
   when (m.islmhrk='VRC') or (m.islmhrk='VRG')  then ''
   end,
  cha_d_kurtar=m.tarih,    /*datetime */
  cha_d_cins=0,     /*0 ytl ... */
  cha_d_kur=1,      /* ytl 1 */
  cha_grupno=0,    /*-**** 0 */
  cha_meblag=abs(giren-cikan),/*kdv genel tutar */
  cha_fis_tarih=m.tarih,   /* */
  cha_fis_sirano=0,   /*Integer */
  cha_vergi1=0, /* 0 */
  cha_vergi2=0,
  cha_vergi3=0,
  cha_vergi4=0,
  cha_vergi5=0,
  cha_tpoz=0,          /*0:Açık 1:Kapalı */
  cha_aciklama=m.ack,      /*Varchar(40) */
  cha_sntck_poz=0,     /*0 olucak */
  cha_reftarihi=m.tarih,   /* */
  cha_aratoplam=abs(giren-cikan),/* toplam */
  cha_pos_hareketi=0,  /* Bit pos harektimi */
  cha_ciro_cari_kodu=m.carkod  /*Varchar(25) aynı Ciro Cari Kodu */
  from kasahrk as m Where sil=0
  and m.tarih>=@bastar and m.tarih <=@bittar
  and m.islmtip in ('TAH','ODE','VIR')
  order by m.id


 return


END

================================================================================
