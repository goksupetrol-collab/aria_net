-- Function: dbo.FATURA_BASLIK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.653983
================================================================================

CREATE FUNCTION dbo.FATURA_BASLIK(@fatid float)
RETURNS
 @TB_FATURA_BASLIK TABLE (
    FIRMA_NO         int,
    FIRMA_UNVAN      VARCHAR(150) COLLATE Turkish_CI_AS,
    FATURA_TIP       VARCHAR(30) COLLATE Turkish_CI_AS,
    FATURA_TUR       VARCHAR(30) COLLATE Turkish_CI_AS,
    FATURA_TARIH     DATETIME,
    FATURA_TAR_GUN   INT,
    FATURA_TAR_AY    INT,
    FATURA_TAR_YIL   INT,
    FATURA_VADETAR   DATETIME,
    FATURA_SAAT      VARCHAR(10) COLLATE Turkish_CI_AS,
    FATURA_SERI      VARCHAR(20) COLLATE Turkish_CI_AS,
    FATURA_ACIK      VARCHAR(200) COLLATE Turkish_CI_AS,
    CARI_KOD         VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_UNVAN       VARCHAR(150) COLLATE Turkish_CI_AS,
    CARI_FAT_UNVAN   VARCHAR(150) COLLATE Turkish_CI_AS,
    CARI_ADRES       VARCHAR(100) COLLATE Turkish_CI_AS,
    CARI_ADRES2      VARCHAR(100) COLLATE Turkish_CI_AS,
    CARI_IL          VARCHAR(100) COLLATE Turkish_CI_AS,
    CARI_ILCE        VARCHAR(100) COLLATE Turkish_CI_AS,
    CARI_VERGIDAIRE  VARCHAR(100) COLLATE Turkish_CI_AS,
    CARI_VERGINO     VARCHAR(100) COLLATE Turkish_CI_AS,
    CARI_TEL		 VARCHAR(100) COLLATE Turkish_CI_AS,
    CARI_EMAIL       VARCHAR(100) COLLATE Turkish_CI_AS,
    CARI_TCNO        VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_PLAKA       VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_YKT_ALM_DEF VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_ARAC_AD     VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_FISBAKIYE   FLOAT,
    CARI_CARBAKIYE   FLOAT,
    CARI_TOPBAKIYE   FLOAT,
    ARATOPLAM        FLOAT,
    ISKONTOTOPLAMI   FLOAT,
    ISKONTOLUTOPLAM  FLOAT,
    KDV_TOPLAM       FLOAT,
    TEVKIFAT_TOPLAM  FLOAT,
    YUVARLAMATOP     FLOAT,
    MATRAH_AK        FLOAT,
    ISK_YUZDE_AK     FLOAT,
    ISK_TUTAR_AK     FLOAT,
    MATRAH_MR        FLOAT,
    ISK_YUZDE_MR     FLOAT,
    ISK_TUTAR_MR     FLOAT,
    MATRAH_GL        FLOAT,
    ISK_YUZDE_GL     FLOAT,
    ISK_TUTAR_GL     FLOAT,
    KDVSIZ_TOPLAM    FLOAT,
    KDVLI_TOPLAM     FLOAT,
    TOPLAM_YAZI      VARCHAR(150) COLLATE Turkish_CI_AS,
    ISK1_YUZDE       FLOAT,
    KDV0_TOPLAM      FLOAT,
    KDV1_TOPLAM      FLOAT,
    KDV8_TOPLAM      FLOAT,
    KDV18_TOPLAM     FLOAT,
    KDV26_TOPLAM     FLOAT,
    YKFIS_NO         VARCHAR(8000) COLLATE Turkish_CI_AS,
    IRSALIYE_NO      VARCHAR(8000) COLLATE Turkish_CI_AS,
    VERFIS_NO		 VARCHAR(8000) COLLATE Turkish_CI_AS,
    OTV_MIKTAR		 FLOAT,
    OTV_TUTAR        FLOAT)
AS
BEGIN

 insert into @TB_FATURA_BASLIK (FIRMA_NO,
 FATURA_TIP,FATURA_TUR,FATURA_TARIH,
  FATURA_TAR_GUN,FATURA_TAR_AY,FATURA_TAR_YIL,
  FATURA_VADETAR,FATURA_SAAT,FATURA_SERI,FATURA_ACIK,
  CARI_KOD,CARI_UNVAN,CARI_FAT_UNVAN,CARI_ADRES,CARI_ADRES2,CARI_IL,
  CARI_ILCE,CARI_VERGIDAIRE,CARI_VERGINO,CARI_TCNO,CARI_TEL,CARI_EMAIL,
  CARI_PLAKA,CARI_YKT_ALM_DEF,CARI_ARAC_AD,
  CARI_FISBAKIYE,CARI_CARBAKIYE,CARI_TOPBAKIYE,
  ARATOPLAM,ISKONTOTOPLAMI,
  ISKONTOLUTOPLAM,KDV_TOPLAM,TEVKIFAT_TOPLAM,YUVARLAMATOP,
  MATRAH_AK,ISK_YUZDE_AK,ISK_TUTAR_AK,
  MATRAH_MR,ISK_YUZDE_MR,ISK_TUTAR_MR,
  MATRAH_GL,ISK_YUZDE_GL,ISK_TUTAR_GL,
  KDVSIZ_TOPLAM,KDVLI_TOPLAM,TOPLAM_YAZI,
  KDV0_TOPLAM,KDV1_TOPLAM,KDV8_TOPLAM,KDV18_TOPLAM,KDV26_TOPLAM,ISK1_YUZDE,
  YKFIS_NO,IRSALIYE_NO,
  OTV_MIKTAR,OTV_TUTAR)

 SELECT ft.firmano,ft.fattip,ft.fattur,ft.tarih,
 DAY(ft.tarih),MONTH(ft.tarih),YEAR(ft.tarih),
 ft.vadtar,ft.saat,
 (ft.fatseri+ft.fatno),ft.ack,ck.kod,ck.ad,ck.fatunvan,ck.adres,ck.adres2,ck.evil,
 ck.evilce,ck.vergidaire,case when ck.vergino<>'' then ck.vergino else ck.tcno end,
 ck.tcno,ck.tel,ck.mail,
 ft.plaka,ck.ykt_alm_def_no,ck.Arac_Ad,
 ck.fisbak,ck.carbak,ck.topbak,
 (ft.genel_ara_top),
 (ft.genel_isk_top),(ft.genel_ara_top-(genel_isk_top)),
 (ft.kdvtop+ft.giderkdvtop),ft.genel_kdv_tevkifat_top,(ft.yuvtop),
 ft.ak_matrah,ft.ak_isk_yuz,ft.ak_isk_top,
 ft.mr_matrah,ft.mr_isk_yuz,ft.mr_isk_top,
 ft.gn_matrah,ft.geniskyuz,ft.genisktop,
 ((ft.genel_ara_top-(ft.genel_isk_top))+(ft.gidertop+yuvtop)),(ft.genel_top),
 DBO.ParaOku( ft.genel_top ),
 isnull((select sum(kdvtut*(mik)) from faturahrklistesi as h WITH (NOLOCK) where h.fatid=@fatid and h.sil=0 and h.kdvyuz=0),0),
 isnull((select sum(kdvtut*(mik)) from faturahrklistesi as h WITH (NOLOCK) where h.fatid=@fatid and h.sil=0 and h.kdvyuz=0.01),0),
 isnull((select sum(kdvtut*(mik)) from faturahrklistesi as h WITH (NOLOCK) where h.fatid=@fatid and h.sil=0 and h.kdvyuz=0.08),0),
 isnull((select sum(kdvtut*(mik)) from faturahrklistesi as h WITH (NOLOCK) where h.fatid=@fatid and h.sil=0 and h.kdvyuz=0.18),0),
 isnull((select sum(kdvtut*(mik)) from faturahrklistesi as h WITH (NOLOCK) where h.fatid=@fatid and h.sil=0 and h.kdvyuz=0.26),0),
 round((ft.genel_isk_top/ft.fattop)*100,2),
 ft.ykfisno,FT.irs_no,
 isnull((select sum((mik)) from faturahrklistesi as h WITH (NOLOCK) where h.fatid=@fatid and h.sil=0 and h.otv_carpan>0),0),
 isnull((select sum((mik*h.otv_carpan)) from faturahrklistesi as h WITH (NOLOCK) where h.fatid=@fatid and h.sil=0 and h.otv_carpan>0),0)
 FROM  faturamas AS ft WITH (NOLOCK)
 INNER JOIN View_Cariler_Kart_Bakiye as ck WITH (NOLOCK)
 ON ck.kod=ft.carkod and ck.cartp=ft.cartip
 where fatid=@fatid
 
 declare @VERFIS_NO  varchar(8000)
 
 if (select count(*) from veresimas WITH (NOLOCK) where sil=0 and fatid=@fatid)<=500
 select  @VERFIS_NO=COALESCE(@VERFIS_NO+',','')+
 (seri+' '+no)  from veresimas  WITH (NOLOCK) where sil=0 and fatid=@fatid
 
 /*declare @VERFIS_NO  varchar(8000) */
 /*select  @VERFIS_NO=COALESCE(@VERFIS_NO+',','')+ir.irseri+cast(ir.irno as varchar(50)) from irsaliyemas as ir where sil=0 and fatid=@fatid */

 
  update @TB_FATURA_BASLIK set FIRMA_UNVAN=dt.ad from @TB_FATURA_BASLIK as t 
  join (select id,ad from firma where sil=0 ) dt on dt.id=t.FIRMA_NO


  update @TB_FATURA_BASLIK set VERFIS_NO=@VERFIS_NO


RETURN

END

================================================================================
