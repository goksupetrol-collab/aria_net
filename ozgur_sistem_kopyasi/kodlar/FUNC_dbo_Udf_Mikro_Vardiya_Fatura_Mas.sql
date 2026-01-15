-- Function: dbo.Udf_Mikro_Vardiya_Fatura_Mas
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.756392
================================================================================

CREATE FUNCTION [dbo].[Udf_Mikro_Vardiya_Fatura_Mas]
(@Tip Varchar(30),@Bastar DATETIME,@Bittar DATETIME)
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

  select m.varno,0,m.TARIH as cha_tarihi,
  0 as cha_tip,6  cha_cinsi,
  0 cha_normal_Iade, /*0:Normal 1:İade */
  cha_evrak_tip=63, /*0:Alış Faturası , 63:Satış Faturası */
  cha_evrakno_seri=
  CASE when @tip='pomvardimas' then 'PVR' else 'MVR' END,  /*Varchar(4) */
  cha_evrakno_sira=m.varno,  /*integer */
  cha_belge_no=CASE when @tip='pomvardimas' then 'PVR' else 'MVR' END
  +cast(m.varno as varchar), /* Varchar(15) */
  cha_belge_tarih=m.TARIH,
  cha_cari_cins=0,   /*0:Carimiz 1:Cari Personelimiz */
  cha_kod= ck.muhonkod,  /*Varchar(25) */
  cha_d_kurtar=m.TARIH,    /*datetime */
  cha_d_cins=1,     /*1 ytl ... */
  cha_d_kur=1,      /* ytl 1 */
  cha_grupno=0,    /*-**** 0 */
  /*cha_meblag=(kdvtop+giderkdvtop),--kdv genel tutar */
  cha_meblag=sum(STOK_TUTARKDVLI),/*kdv genel tutar */
  cha_fis_tarih=m.TARIH,   /* */
  cha_fis_sirano=0,   /*Integer */
  cha_vergi1=0, /* 0 */
  cha_vergi2=
   isnull((select sum(STOK_TUTARKDVLI-STOK_TUTARKDVSIZ) from UDF_PomVarNakitStokhrk (0,'pomvardimas',@Bastar,@Bittar) as h 
    where h.varno=m.varno and h.STOK_KDVYUZ=0.01),0),/* %1 olanlar kdv tutarı */
  cha_vergi3=
    isnull((select sum(STOK_TUTARKDVLI-STOK_TUTARKDVSIZ) from UDF_PomVarNakitStokhrk (0,'pomvardimas',@Bastar,@Bittar) as h
    where h.varno=m.varno and h.STOK_KDVYUZ=0.08),0),/* %8 olanlar */
  cha_vergi4=
    isnull((select sum(STOK_TUTARKDVLI-STOK_TUTARKDVSIZ) from UDF_PomVarNakitStokhrk (0,'pomvardimas',@Bastar,@Bittar) as h
    where  h.varno=m.varno  and h.STOK_KDVYUZ=0.18),0),/* %18 olanlar */
  cha_vergi5=
     isnull((select sum(STOK_TUTARKDVLI-STOK_TUTARKDVSIZ) from UDF_PomVarNakitStokhrk (0,'pomvardimas',@Bastar,@Bittar) as h
    where h.varno=m.varno and h.STOK_KDVYUZ=0.26),0),/* %26 olanlar */
  cha_tpoz=0,          /*0:Açık 1:Kapalı */
  cha_aciklama=SUBSTRING(m.ack,1,100),      /*Varchar(40) */
  cha_sntck_poz=0,     /*0 olucak */
  cha_reftarihi=m.TARIH,   /* */
  cha_aratoplam=sum(m.STOK_TUTARKDVSIZ),/* kdvsiz toplam */
  cha_pos_hareketi=0,  /* Bit pos harektimi */
  cha_ciro_cari_kodu=ck.muhonkod,  /*Varchar(25) aynı Ciro Cari Kodu */
  cha_kasa_hizmet=0,cha_kasa_hizkod='',
  cha_miktari=0,
  cha_ft_iskonto1=0,
  cha_vergipntr=0
   
  from UDF_PomVarNakitStokhrk (0,@Tip,@Bastar,@Bittar)  as m
  left join Genel_Kart as ck on ck.cartp='carikart' 
  and ck.kod=m.CARKOD
  group by m.varno,m.SERINO,m.TARIH,m.SAAT,m.CARKOD,m.ACK,
  ck.kod,ck.muhonkod,ck.muhkod,ck.ad     
  order by m.varno
  
  /*gelgid */
  
  declare @Gelir_id int
  
  select @Gelir_id=id from grup where 
  tabload='gelgidkart' and ad='GELİR'
  

  
  update @TB_MIKRO_FATURA set cha_satir_no=0
  where cha_satir_no in (select min(cha_satir_no) from 
  @TB_MIKRO_FATURA 
  group by fat_id Having MIN(cha_satir_no)>0)
  
  
  
  
  


 return


END

================================================================================
