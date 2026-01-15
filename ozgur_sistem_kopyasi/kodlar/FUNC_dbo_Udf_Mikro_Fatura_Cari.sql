-- Function: dbo.Udf_Mikro_Fatura_Cari
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.754248
================================================================================

CREATE FUNCTION [dbo].[Udf_Mikro_Fatura_Cari]
(@Bastar DATETIME,
@Bittar DATETIME)
RETURNS
  @TB_MIKRO_FATURA TABLE (
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

/*http://yardim.mye.com.tr/Library/Diger/DBYapisi_V12/Tablolar/stok_hareketleri.htm */

   declare @GEC_TEMP table
   (Fatid			int,
    Micro_Stktip	int
   )
   
   
   insert into @GEC_TEMP (Fatid,Micro_Stktip)
   select h.fatid,h.Micro_Stktip from faturamas as m 
   inner join faturahrklistesi as h
   on h.fatid=m.fatid and m.sil=0 and h.sil=0
   and m.tarih>=@bastar and m.tarih <=@bittar
   group by h.fatid,h.Micro_Stktip
 
  insert into @TB_MIKRO_FATURA
  (fat_id,cha_satir_no,cha_tarihi,cha_tip,cha_cinsi,cha_normal_Iade,cha_evrak_tip,
  cha_evrakno_seri,cha_evrakno_sira,cha_belge_no,
  cha_belge_tarih,cha_cari_cins,cha_kod,cha_d_kurtar,
  cha_d_cins,cha_d_kur,cha_grupno,cha_meblag,
  cha_fis_tarih,cha_fis_sirano,cha_vergi1,
  cha_vergi2,cha_vergi3,cha_vergi4,cha_vergi5,
  cha_tpoz,cha_aciklama,cha_sntck_poz,cha_reftarihi,
  cha_aratoplam,cha_pos_hareketi,cha_ciro_cari_kodu,
  cha_kasa_hizmet,cha_kasa_hizkod,cha_miktari,
  cha_ft_iskonto1,cha_vergipntr )

  select m.fatid,0,m.tarih as cha_tarihi,
  cha_tip=case
     when m.gctip=2 then  0
     when m.gctip=1 then  1 end, /*0 borc ,1 alacak */
     case  
     when m.fattip_id=3 then  8
     when m.fattip_id=6  then 8
     else 6 end cha_cinsi,
    
    cha_normal_Iade=case
     when (m.fattur_id<>3) then  0
     when (m.fattur_id=3) then 1
     end , /*0:Normal 1:İade */
  cha_evrak_tip= case
     when (m.gctip=1) then  0
     when (m.gctip=2)  then 63 end, /*0:Alış Faturası , 63:Satış Faturası */
  cha_evrakno_seri=m.fatseri,  /*Varchar(4) */
  cha_evrakno_sira=m.fatid, /*m.fatno,  --integer */
  cha_belge_no=m.fatseri+cast(m.fatno as varchar), /* Varchar(15) */
  cha_belge_tarih=m.tarih,
  cha_cari_cins=0,   /*0:Carimiz 1:Cari Personelimiz */
  cha_kod= ck.muhonkod,  /*Varchar(25) */
  cha_d_kurtar=m.tarih,    /*datetime */
  cha_d_cins=1,     /*1 ytl ... */
  cha_d_kur=1,      /* ytl 1 */
  cha_grupno=0,    /*-**** 0 */
  /*cha_meblag=(kdvtop+giderkdvtop),--kdv genel tutar */
  cha_meblag=(genel_top),/*kdv genel tutar */
  cha_fis_tarih=m.tarih,   /* */
  cha_fis_sirano=0,   /*Integer */
  cha_vergi1=0, /* 0 */
  cha_vergi2=
   isnull((select sum(kdvtut*(mik)) from faturahrklistesi as h
    where h.Micro_Stktip=1 and  h.fatid=m.fatid and h.sil=0 and h.kdvyuz=0.01),0),/* %1 olanlar kdv tutarı */
  cha_vergi3=
    isnull((select sum(kdvtut*(mik)) from faturahrklistesi as h
    where h.Micro_Stktip=1 and h.fatid=m.fatid and h.sil=0 and h.kdvyuz=0.08),0),/* %8 olanlar */
  cha_vergi4=
    isnull((select sum(kdvtut*(mik)) from faturahrklistesi as h
    where h.Micro_Stktip=1 and h.sil=0 and h.fatid=m.fatid  and h.kdvyuz=0.18),0),/* %18 olanlar */
  cha_vergi5=
     isnull((select sum(kdvtut*(mik)) from faturahrklistesi as h
    where h.Micro_Stktip=1 and h.sil=0 and h.fatid=m.fatid and h.kdvyuz=0.26),0),/* %26 olanlar */
  cha_tpoz=0,          /*0:Açık 1:Kapalı */
  cha_aciklama=SUBSTRING(m.ack,1,100),      /*Varchar(40) */
  cha_sntck_poz=0,     /*0 olucak */
  cha_reftarihi=m.tarih,   /* */
  cha_aratoplam=((fattop-(satisktop+genisktop))+(gidertop+yuvtop)),/* kdvsiz toplam */
  cha_pos_hareketi=0,  /* Bit pos harektimi */
  cha_ciro_cari_kodu=ck.muhonkod,  /*Varchar(25) aynı Ciro Cari Kodu */
  cha_kasa_hizmet=0,cha_kasa_hizkod='',
  cha_miktari=0,
  cha_ft_iskonto1=
  isnull((select sum(h.Top_isk_Tut) from faturahrklistesi as h
  where h.Micro_Stktip=1 and h.sil=0 and h.fatid=m.fatid),0),
  cha_vergipntr=0
  
  
  from faturamas as m 
  inner join Genel_Kart as ck 
  on ck.cartp=m.cartip and ck.kod=m.carkod   
  Where sil=0 and len(m.fatseri)<7
  and m.tarih>=@bastar and m.tarih <=@bittar
  and m.fatid in (select fatid from @GEC_TEMP where Micro_Stktip=1 )
  order by m.fatid
  
  /*gelgid */
  
  declare @Gelir_id int
  
  select @Gelir_id=id from grup where 
  tabload='gelgidkart' and ad='GELİR'
  

  
  insert into @TB_MIKRO_FATURA
  (fat_id,cha_satir_no,cha_tarihi,cha_tip,cha_cinsi,cha_normal_Iade,cha_evrak_tip,
  cha_evrakno_seri,cha_evrakno_sira,cha_belge_no,
  cha_belge_tarih,cha_cari_cins,cha_kod,cha_d_kurtar,
  cha_d_cins,cha_d_kur,cha_grupno,cha_meblag,
  cha_fis_tarih,cha_fis_sirano,cha_vergi1,
  cha_vergi2,cha_vergi3,cha_vergi4,cha_vergi5,
  cha_tpoz,cha_aciklama,cha_sntck_poz,cha_reftarihi,
  cha_aratoplam,cha_pos_hareketi,cha_ciro_cari_kodu,
  cha_kasa_hizmet,cha_kasa_hizkod,cha_miktari,cha_ft_iskonto1,
  cha_vergipntr )

  select m.fatid,fh.id,m.tarih as cha_tarihi,
  cha_tip=case
     when m.gctip=2 then  0
     when m.gctip=1 then  1 end, /*0 borc ,1 alacak */
     8 cha_cinsi,
    
    cha_normal_Iade=case
     when (m.fattur_id<>3) then  0
     when (m.fattur_id=3) then 1
     end , /*0:Normal 1:İade */
  cha_evrak_tip= case
     when (m.gctip=1) then  0
     when (m.gctip=2)  then 63 end, /*0:Alış Faturası , 63:Satış Faturası */
  cha_evrakno_seri=m.fatseri,  /*Varchar(4) */
  cha_evrakno_sira=m.fatid,  /*integer */
  cha_belge_no=m.fatseri+cast(m.fatno as varchar), /* Varchar(15) */
  cha_belge_tarih=m.tarih,
  cha_cari_cins=0,   /*0:Carimiz 1:Cari Personelimiz */
  cha_kod= ck.muhonkod,  /*Varchar(25) */
  cha_d_kurtar=m.tarih,    /*datetime */
  cha_d_cins=1,     /*1 tl ... */
  cha_d_kur=1,      /* tl 1 */
  cha_grupno=0,    /*-**** 0 */
  /*cha_meblag=(kdvtop+giderkdvtop),--kdv genel tutar */
  cha_meblag=
  (((fh.brmfiy-(fh.genisktut+fh.satisktut))+fh.kdvtut)*fh.mik),/*kdv genel tutar */
  cha_fis_tarih=m.tarih,   /* */
  cha_fis_sirano=fh.id,   /*Integer */
  cha_vergi1=0, /* 0 */
  cha_vergi2=
   isnull( case when fh.kdvyuz=0.01 then (kdvtut*(mik)) else 0 END,0),
  cha_vergi3=
    isnull( case when fh.kdvyuz=0.08 then (kdvtut*(mik)) else 0 END,0),
  cha_vergi4=
     isnull( case when fh.kdvyuz=0.18 then (kdvtut*(mik)) else 0 END,0),
   cha_vergi5=
    isnull( case when fh.kdvyuz=0.26 then (kdvtut*(mik)) else 0 END,0),
  cha_tpoz=0,          /*0:Açık 1:Kapalı */
  cha_aciklama=SUBSTRING(m.ack,1,100),      /*Varchar(40) */
  cha_sntck_poz=0,     /*0 olucak */
  cha_reftarihi=m.tarih,   /* */
  cha_aratoplam=(fh.brmfiy*fh.mik),/* kdvsiz toplam */
  cha_pos_hareketi=0,  /* Bit pos harektimi */
  cha_ciro_cari_kodu=ck.muhonkod,  /*Varchar(25) aynı Ciro Cari Kodu */
  cha_kasa_hizmet=case 
  when gk.grp1=@Gelir_id THEN 3 
  else 5 end, 
  cha_kasa_hizkod=Gk.muhonkod,
  cha_miktari=1,
  cha_ft_iskonto1=fh.Top_isk_Tut,
  cha_vergipntr=
  isnull(case 
  when fh.kdvyuz=0.00 then 1 
  when fh.kdvyuz=0.01 then 2 
  when fh.kdvyuz=0.08 then 3 
  when fh.kdvyuz=0.18 then 4
  when fh.kdvyuz=0.26 then 5 
  else 0 END,0)
  
  
  from faturamas as m 
  inner join Genel_Kart as ck 
  on ck.cartp=m.cartip and ck.kod=m.carkod 
  inner join  faturahrklistesi as fh on 
  fh.fatid=m.fatid and fh.sil=0 and Micro_Stktip=2
  
  inner join Genel_Kart as Gk 
  on Gk.Tip_id=3 and Gk.kod=fh.stkod
  
  Where m.sil=0 and len(m.fatseri)<7
  and m.tarih>=@bastar and m.tarih <=@bittar
  order by m.fatid
  
  
  update @TB_MIKRO_FATURA set cha_satir_no=0
  where cha_satir_no in (select min(cha_satir_no) from 
  @TB_MIKRO_FATURA 
  group by fat_id Having MIN(cha_satir_no)>0)
  
   


 return


END

================================================================================
