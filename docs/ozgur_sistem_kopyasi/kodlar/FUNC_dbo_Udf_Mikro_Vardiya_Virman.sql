-- Function: dbo.Udf_Mikro_Vardiya_Virman
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.756792
================================================================================

CREATE FUNCTION [dbo].[Udf_Mikro_Vardiya_Virman]
(@Tip Varchar(30),@Bastar DATETIME,@Bittar DATETIME)
RETURNS
  @TB_MIKRO_VIRMAN TABLE (
  fat_id                 int,
  cha_satir_no			 int,
  cha_tarihi             datetime,
  cha_tip                int,
  cha_cinsi              int,
  cha_normal_Iade        int,
  cha_evrak_tip          int,
  cha_evrakno_seri       Varchar(20),
  cha_evrakno_sira       int,
  cha_belge_no           Varchar(50),
  cha_belge_tarih        datetime,
  cha_cari_cins          int,
  cha_kod                Varchar(30),
  cha_kasa_hizmet		 int,
  cha_kasa_hizkod		 Varchar(25),
  cha_miktari			 float,
  cha_ft_iskonto1		 float,
  cha_vergipntr			 int,
  cha_d_kurtar           datetime,
  cha_d_cins             int,
  cha_d_kur              float,
  cha_grupno             int,
  cha_meblag             float,
  cha_fis_tarih          datetime,
  cha_fis_sirano         Int,
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

/*http://yardim.mye.com.tr/Library/Diger/DBYapisi_V12/Tablolar/stok_hareketleri.htm */

  declare  @TB_MIKRO_TEMP TABLE (
  fat_id                 int,
  cha_satir_no			 int,
  cha_tarihi             datetime,
  cha_tip                int,
  cha_cinsi              int,
  cha_normal_Iade        int,
  cha_evrak_tip          int,
  cha_evrakno_seri       Varchar(20),
  cha_evrakno_sira       int,
  cha_belge_no           Varchar(50),
  cha_belge_tarih        datetime,
  cha_cari_cins          int,
  cha_kod                Varchar(30),
  cha_kasa_hizmet		 int,
  cha_kasa_hizkod		 Varchar(25),
  cha_miktari			 float,
  cha_ft_iskonto1		 float,
  cha_vergipntr			 int,
  cha_d_kurtar           datetime,
  cha_d_cins             int,
  cha_d_kur              float,
  cha_grupno             int,
  cha_meblag             float,
  cha_fis_tarih          datetime,
  cha_fis_sirano         Int,
  cha_tpoz               int,
  cha_aciklama           Varchar(100),
  cha_sntck_poz          int,
  cha_reftarihi          datetime,
  cha_aratoplam          float,
  cha_pos_hareketi       int,
  cha_ciro_cari_kodu     Varchar(30)
  )




 declare @CAR_KOD  varchar(50) 

 /*if @firmano=0   */
  SELECT @CAR_KOD=zrap_carkod FROM sistemtanim


 /*-- kasa hrkleri */
    
  insert into @TB_MIKRO_TEMP
  (fat_id,cha_satir_no,cha_tarihi,cha_tip,cha_cinsi,
  cha_normal_Iade,cha_evrak_tip,
  cha_evrakno_seri,cha_evrakno_sira,cha_belge_no,
  cha_belge_tarih,cha_cari_cins,cha_kod,cha_d_kurtar,
  cha_d_cins,cha_d_kur,cha_grupno,cha_meblag,
  cha_fis_sirano,
  cha_tpoz,cha_aciklama,cha_sntck_poz,cha_reftarihi,
  cha_aratoplam,cha_pos_hareketi,cha_ciro_cari_kodu,
  cha_kasa_hizmet,cha_kasa_hizkod,cha_miktari,
  cha_ft_iskonto1,cha_vergipntr )

  select m.varno,1,m.tarih as cha_tarihi,
  1 as cha_tip,/*0 borc 1 alacak  */
  5  cha_cinsi,
  0 cha_normal_Iade, /*0:Normal 1:İade */
  cha_evrak_tip=33, /*33:virman  */
  cha_evrakno_seri='PVV',  /*Varchar(4) */
  cha_evrakno_sira=m.varno,  /*integer */
  cha_belge_no='PVV'+cast(m.varno as varchar),
  cha_belge_tarih=m.tarih,
  cha_cari_cins=2,   /*0:Carimiz 1:Cari Personelimiz 2:kasa 4 :banka */
  cha_kod= ck.muhonkod,  /*Varchar(25) */
  cha_d_kurtar=m.tarih,    /*datetime */
  cha_d_cins=1,     /*1 tl ... */
  cha_d_kur=1,      /*  1 */
  cha_grupno=0,    /*-**** 0 */
  cha_meblag=sum(giren),/*kdv genel tutar */
  cha_fis_sirano=0,   /*Integer */
  cha_tpoz=0,          /*0:Açık 1:Kapalı */
  cha_aciklama='',      /*Varchar(40) */
  cha_sntck_poz=0,     /*0 olucak */
  cha_reftarihi=m.tarih,   /* */
  cha_aratoplam=0,
  cha_pos_hareketi=0,  /* Bit pos harektimi */
  cha_ciro_cari_kodu=ck.muhonkod,  /*Varchar(25) aynı Ciro Cari Kodu */
  cha_kasa_hizmet=0,
  cha_kasa_hizkod='',
  cha_miktari=0,
  cha_ft_iskonto1=0,
  cha_vergipntr=0
   
  from kasahrk  as m 
  left join Genel_Kart as ck on ck.cartp='kasakart' 
  and ck.kod=m.kaskod
  where m.sil=0 and m.varno in 
  (select varno from pomvardimas where sil=0 and varok=1
  and m.tarih>=@Bastar and m.tarih<=@Bittar)
  and m.giren>0 
  group by m.varno,m.tarih,m.kaskod,
  ck.kod,ck.muhonkod,ck.muhkod,ck.ad     
  order by m.varno
    
  
  
  
  /*-- pos hrkleri */
    
  insert into @TB_MIKRO_TEMP
  (fat_id,cha_satir_no,cha_tarihi,cha_tip,cha_cinsi,
  cha_normal_Iade,cha_evrak_tip,
  cha_evrakno_seri,cha_evrakno_sira,cha_belge_no,
  cha_belge_tarih,cha_cari_cins,cha_kod,cha_d_kurtar,
  cha_d_cins,cha_d_kur,cha_grupno,cha_meblag,
  cha_fis_sirano,
  cha_tpoz,cha_aciklama,cha_sntck_poz,cha_reftarihi,
  cha_aratoplam,cha_pos_hareketi,cha_ciro_cari_kodu,
  cha_kasa_hizmet,cha_kasa_hizkod,cha_miktari,
  cha_ft_iskonto1,cha_vergipntr )

  select m.varno,2,m.tarih as cha_tarihi,
  1 as cha_tip,/*0 borc 1 alacak  */
  5  cha_cinsi,
  0 cha_normal_Iade, /*0:Normal 1:İade */
  cha_evrak_tip=33, /*33:virman  */
  cha_evrakno_seri='PVV',  /*Varchar(4) */
  cha_evrakno_sira=m.varno,  /*integer */
  cha_belge_no='PVV'+cast(m.varno as varchar),
  cha_belge_tarih=m.tarih,
  cha_cari_cins=4,   /*0:Carimiz 1:Cari Personelimiz 2:kasa 4 :banka */
  cha_kod= ck.muhonkod,  /*Varchar(25) */
  cha_d_kurtar=m.tarih,    /*datetime */
  cha_d_cins=1,     /*1 tl ... */
  cha_d_kur=1,      /*  1 */
  cha_grupno=0,    /*-**** 0 */
  cha_meblag=sum(giren),/*kdv genel tutar */
  cha_fis_sirano=0,   /*Integer */
  cha_tpoz=0,          /*0:Açık 1:Kapalı */
  cha_aciklama='',      /*Varchar(40) */
  cha_sntck_poz=0,     /*0 olucak */
  cha_reftarihi=m.tarih,   /* */
  cha_aratoplam=0,
  cha_pos_hareketi=0,  /* Bit pos harektimi */
  cha_ciro_cari_kodu=ck.muhonkod,  /*Varchar(25) aynı Ciro Cari Kodu */
  cha_kasa_hizmet=0,
  cha_kasa_hizkod='',
  cha_miktari=0,
  cha_ft_iskonto1=0,
  cha_vergipntr=0
   
  from poshrk  as m 
  left join Genel_Kart as ck on ck.cartp='poskart' 
  and ck.kod=m.poskod
  where m.sil=0 and m.varno in 
  (select varno from pomvardimas where sil=0 and varok=1
  and m.tarih>=@Bastar and m.tarih<=@Bittar)
  and m.giren>0 
    group by m.varno,m.tarih,m.poskod,
  ck.kod,ck.muhonkod,ck.muhkod,ck.ad     
  order by m.varno
  
  
  
  
  
  
  
  
  
  /*-cari hrk  */
  insert into @TB_MIKRO_TEMP
  (fat_id,cha_satir_no,cha_tarihi,cha_tip,cha_cinsi,
  cha_normal_Iade,cha_evrak_tip,
  cha_evrakno_seri,cha_evrakno_sira,cha_belge_no,
  cha_belge_tarih,cha_cari_cins,cha_kod,cha_d_kurtar,
  cha_d_cins,cha_d_kur,cha_grupno,cha_meblag,
  cha_fis_sirano,
  cha_tpoz,cha_aciklama,cha_sntck_poz,cha_reftarihi,
  cha_aratoplam,cha_pos_hareketi,cha_ciro_cari_kodu,
  cha_kasa_hizmet,cha_kasa_hizkod,cha_miktari,
  cha_ft_iskonto1,cha_vergipntr )
  
  select m.fat_id,0,m.cha_tarihi,
  0 as cha_tip,/*0 borc 1 alacak  */
  5  cha_cinsi,
  0 cha_normal_Iade, /*0:Normal 1:İade */
  cha_evrak_tip=33, /*33:virman  */
  cha_evrakno_seri='PVV',  /*Varchar(4) */
  cha_evrakno_sira=m.fat_id,  /*integer */
  cha_belge_no='PVV'+cast(m.fat_id as varchar),
  cha_belge_tarih=m.cha_tarihi,
  cha_cari_cins=0,   /*0:Carimiz 1:Cari Personelimiz 2:kasa 4 :banka */
  cha_kod= ck.muhonkod,  /*Varchar(25) */
  cha_d_kurtar=m.cha_tarihi,    /*datetime */
  cha_d_cins=1,     /*1 tl ... */
  cha_d_kur=1,      /*  1 */
  cha_grupno=0,    /*-**** 0 */
  cha_meblag=sum(cha_meblag),/*kdv genel tutar */
  cha_fis_sirano=0,   /*Integer */
  cha_tpoz=0,          /*0:Açık 1:Kapalı */
  cha_aciklama='',/*SUBSTRING(m.ack,1,100),      --Varchar(40) */
  cha_sntck_poz=0,     /*0 olucak */
  cha_reftarihi=m.cha_tarihi,   /* */
  cha_aratoplam=0,
  cha_pos_hareketi=0,  /* Bit pos harektimi */
  cha_ciro_cari_kodu=ck.muhonkod,  /*Varchar(25) aynı Ciro Cari Kodu */
  cha_kasa_hizmet=0,
  cha_kasa_hizkod='',
  cha_miktari=0,
  cha_ft_iskonto1=0,
  cha_vergipntr=0
  
  from @TB_MIKRO_TEMP  as m 
  left join Genel_Kart as ck on ck.cartp='carikart' 
  and ck.kod=@CAR_KOD
  group by m.fat_id,m.cha_tarihi,
  ck.kod,ck.muhonkod,ck.muhkod,ck.ad     
  order by m.fat_id 
  
  
  insert into @TB_MIKRO_VIRMAN
  (fat_id,cha_satir_no,cha_tarihi,cha_tip,cha_cinsi,
  cha_normal_Iade,cha_evrak_tip,
  cha_evrakno_seri,cha_evrakno_sira,cha_belge_no,
  cha_belge_tarih,cha_cari_cins,cha_kod,cha_d_kurtar,
  cha_d_cins,cha_d_kur,cha_grupno,cha_meblag,
  cha_fis_sirano,
  cha_tpoz,cha_aciklama,cha_sntck_poz,cha_reftarihi,
  cha_aratoplam,cha_pos_hareketi,cha_ciro_cari_kodu,
  cha_kasa_hizmet,cha_kasa_hizkod,cha_miktari,
  cha_ft_iskonto1,cha_vergipntr )
 
  select fat_id,cha_satir_no,cha_tarihi,cha_tip,cha_cinsi,
  cha_normal_Iade,cha_evrak_tip,
  cha_evrakno_seri,cha_evrakno_sira,cha_belge_no,
  cha_belge_tarih,cha_cari_cins,cha_kod,cha_d_kurtar,
  cha_d_cins,cha_d_kur,cha_grupno,cha_meblag,
  cha_fis_sirano,
  cha_tpoz,cha_aciklama,cha_sntck_poz,cha_reftarihi,
  cha_aratoplam,cha_pos_hareketi,cha_ciro_cari_kodu,
  cha_kasa_hizmet,cha_kasa_hizkod,cha_miktari,
  cha_ft_iskonto1,cha_vergipntr from @TB_MIKRO_TEMP
  order by cha_satir_no
  
   
  
  

  
 return


END

================================================================================
