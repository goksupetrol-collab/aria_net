-- Function: dbo.Udf_Mikro_Stok_Hrk
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.755558
================================================================================

CREATE FUNCTION [dbo].Udf_Mikro_Stok_Hrk
(@Bastar DATETIME,
@Bittar DATETIME)
RETURNS
  @TB_MIKRO_STOK_HRK TABLE (
  fat_id                   int,
  Kap_Tip				   Varchar(10),
  sth_tarih                DateTime,
  sth_tip                  Tinyint, /*Hareket Tipi 0:Giriş 1:Çıkış 2:Depo Transfer */
  sth_cins                 Tinyint,/* Hareket Cinsi 0:Toptan 1:Perakende 2:Dış Ticaret 3:Stok Virman 4:Fire 5:Sarf 6:Transfer 7:Üretim 8:Fason 9:Değer Farkı 10:Sayım 11:Stok Açılış 12:İthalat-İhracat 13:Hal 14:Müstahsil 15:Müstahsil Değer Farkı 14:Kabzımal 15:Gider Pusulası */
  sth_normal_iade          Tinyint, /*Normal/Iade? 0:Normal 1:İade */
  sth_evraktip             Tinyint,/* Evrak Tipi 0:Depo Çıkış Fişi 1:Çıkış İrsaliyesi 2:Depo Transfer Fişi */
                           /*3:Giriş Faturası 4:Çıkış Faturası 5:Stoklara İthalat Masraf Yansıtma Dekontu 6:Stok Virman Fişi 7:Üretim Giriş Çıkış Fişi 8:İlave Enflasyon Maliyet Fişi 9:Stoklara İlave Maliyet Yedirme Fişi 10:Antrepolardan Mal Millileştirme Fişi 11:Antrepolar Arası Transfer Fişi 12:Depo Giriş Fişi 13:Giriş İrsaliyesi 14:Fason Giriş Çıkış Fişi 15:Depolar Arası Satış Fişi 16:Stok Gider Pusulası Fişi */
  sth_evrakno_seri         Varchar(6), /*Evrak Seri No */
  sth_evrakno_sira         int, /*Evrak Sıra No */
  sth_satirno              int, /*Hareket Satır No */
  sth_belge_no             Varchar(20), /*Hareket Belge No */
  sth_belge_tarih          DateTime, /*Hareket Belge Tarihi */
  sth_stok_kod             Varchar(25),
  sth_isk_mas1             Tinyint, /*İskonto Masraf Tipi */
  sth_sat_iskmas1          int, /*Satır İskonto Masraf mı? */
  sth_pos_satis            int, /*Pos Satışı mı? */
  sth_cari_cinsi           Tinyint, /*Cari Cinsi */
  sth_cari_kodu            Varchar(25),/* Cari Kodu */
  sth_cari_grup_no         Tinyint, /*Cari Grup No */
  sth_kur_tarihi           DateTime,/* Kur Tarihi */
  sth_stok_doviz_cinsi     Tinyint,/* Stok Döviz Cinsi Bkz. DOVIZ_KURLARI */
  sth_stok_doviz_kuru      Float,/* Stok Döviz Kuru */
  sth_miktar               Float,/* Hareket Miktarı */
  sth_birim_pntr           Tinyint,/*stok birirmi 0 olucak */
  sth_tutar                Float,/* Hareket Tutarı */
  sth_iskonto1             Float,/* 1.İskonto Miktarı */
  sth_masraf1              Float,/* 1.Masraf Miktarı */
  sth_vergi                Float,/* Hareket Vergi Oranı */
  sth_masraf_vergi         Float,/* Masraf Vergi Oranı */
  sth_aciklama             Varchar(50),/* Hareketle ilgili açıklama */
  sth_fis_tarihi           DateTime,/* Fiş Tarihi */
  sth_fis_sirano           int,/* Fiş Sıra No */
  sth_vergi_pntr		   int/*kdv oran id */
				
)
AS
BEGIN

/* http://yardim.mye.com.tr/Library/Diger/DBYapisi_V12/Tablolar/stok_hareketleri.htm */

  insert into @TB_MIKRO_STOK_HRK
  (fat_id,Kap_Tip,sth_tarih,sth_tip,sth_cins,sth_normal_iade,sth_evraktip,
  sth_evrakno_seri,sth_evrakno_sira,sth_satirno,sth_belge_no,
  sth_belge_tarih,sth_stok_kod,sth_isk_mas1,sth_sat_iskmas1,
  sth_pos_satis,sth_cari_cinsi,sth_cari_kodu,sth_cari_grup_no,
  sth_kur_tarihi,sth_stok_doviz_cinsi,sth_stok_doviz_kuru,
  sth_miktar,sth_birim_pntr,sth_tutar,sth_iskonto1,
  sth_masraf1,sth_vergi,sth_masraf_vergi,sth_aciklama,
  sth_fis_tarihi,sth_fis_sirano,sth_vergi_pntr)
  
    select m.fatid,m.kaptip,
    m.tarih as sth_tarih,
    sth_tip=case
     when (m.gctip=2)  then  1
     when (m.gctip=1)  then   0 end, /*0:Giriş 1:Çıkış 2:Depo Transfer */
   0 as sth_cins,/*Cinsi 0:Toptan 1:Perakende */
    sth_normal_iade=case
     when (m.fattur_id=1) or (m.fattur_id=2) then  0
     when (m.fattur_id=3) then 1
     end , /*0:Normal 1:İade */
  sth_evraktip= case
     when (m.gctip=1)  then  3
     when (m.gctip=2)   then 4 end, /*3:Giriş Faturası 4:Çıkış Faturası */
  sth_evrakno_seri=m.fatseri,  /*Varchar(4) */
  sth_evrakno_sira=m.fatid,  /*integer */
  sth_satirno=h.id,
  sth_belge_no=m.fatseri+cast(m.fatno as varchar), /* Varchar(15) */
  sth_belge_tarih=m.tarih,
  sth_stok_kod=s.muhonkod,
  sth_isk_mas1=0,
  sth_sat_iskmas1=0, /*Satır İskonto Masraf mı? */
  sth_pos_satis=0, /*Pos Satışı mı? */
  sth_cari_cinsi=0, /*6 toptan fatura ,7 parakende faturası */
  sth_cari_kodu=car.muhonkod,/* Cari Kodu */
  sth_cari_grup_no=0,/*Cari Grup No */
  sth_kur_tarihi=m.tarih,/* Kur Tarihi */
  sth_stok_doviz_cinsi=0,/* Stok Döviz Cinsi Bkz. DOVIZ_KURLARI */
  sth_stok_doviz_kuru=1,
  sth_miktar=h.mik,/* Hareket Miktarı */
  sth_birim_pntr=0,/*stok birirmi 0 olucak */
  sth_tutar=h.mik*h.brmfiy,  /* Hareket Tutarı */
  sth_iskonto1=(h.Top_isk_Tut),/* 1.İskonto Miktarı */
  sth_masraf1=0,/* 1.Masraf Miktarı */
  sth_vergi=h.kdvtut*h.mik,/* Hareket Vergi tutar */
  sth_masraf_vergi=0,/* Masraf Vergi Oranı */
  sth_aciklama=SUBSTRING(s.ad,1,50),/* Hareketle ilgili açıklama */
  sth_fis_tarihi=m.tarih,/* Fiş Tarihi */
  sth_fis_sirano=0,
  sth_vergi_pntr=
  isnull(case 
  when h.kdvyuz=0.00 then 1 
  when h.kdvyuz=0.01 then 2 
  when h.kdvyuz=0.08 then 3 
  when h.kdvyuz=0.18 then 4
  when h.kdvyuz=0.26 then 5 
  else 0 END,0)
  
  
  

    from faturamas as m
    inner join faturahrk as h on
    h.fatid=m.fatid and h.sil=0
    inner join gelgidlistok as s on
    s.kod=h.stkod and s.tip=h.stktip
    inner join Genel_Cari_Kart as car on
    m.carkod=car.kod and m.cartip=car.cartip
     where m.sil=0 and s.tip_id<>3
     and len(m.fatseri)<7
    and m.tarih>=@Bastar and m.tarih<=@Bittar
    order by m.fatid




 RETURN


END

================================================================================
