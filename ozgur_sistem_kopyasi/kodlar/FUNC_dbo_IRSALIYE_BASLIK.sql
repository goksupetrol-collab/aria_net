-- Function: dbo.IRSALIYE_BASLIK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.662723
================================================================================

CREATE FUNCTION dbo.IRSALIYE_BASLIK(@irid float)
RETURNS
 @TB_IRSALIYE_BASLIK TABLE (
    IRSALIYE_TIP     VARCHAR(30) COLLATE Turkish_CI_AS,
    IRSALIYE_TUR     VARCHAR(30) COLLATE Turkish_CI_AS,
    IRSALIYE_TARIH   DATETIME,
    IRSALIYE_SAAT    VARCHAR(10) COLLATE Turkish_CI_AS,
    IRSALIYE_SERI    VARCHAR(20) COLLATE Turkish_CI_AS,
    IRSALIYE_ACIK    VARCHAR(100) COLLATE Turkish_CI_AS,
    CARI_UNVAN       VARCHAR(150) COLLATE Turkish_CI_AS,
    CARI_ADRES       VARCHAR(100) COLLATE Turkish_CI_AS,
    CARI_ADRES2      VARCHAR(100) COLLATE Turkish_CI_AS,
    CARI_IL          VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_ILCE        VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_VERGIDAIRE  VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_VERGINO     VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_TEL 		 VARCHAR(50) COLLATE Turkish_CI_AS,
    PLAKA			 VARCHAR(50) COLLATE Turkish_CI_AS,
    SOFOR			 VARCHAR(50) COLLATE Turkish_CI_AS,
    ACIKLAMA		 VARCHAR(150) COLLATE Turkish_CI_AS,
    ARATOPLAM        FLOAT,
    ISKONTOTOPLAMI   FLOAT,
    ISKONTOLUTOPLAM  FLOAT,
    KDV_TOPLAM       FLOAT,
    YUVARLAMATOP     FLOAT,
    KDVSIZ_TOPLAM    FLOAT,
    KDVLI_TOPLAM     FLOAT,
    TOPLAM_YAZI      VARCHAR(150) COLLATE Turkish_CI_AS,
    KDV0_TOPLAM      FLOAT,
    KDV1_TOPLAM      FLOAT,
    KDV8_TOPLAM      FLOAT,
    KDV18_TOPLAM     FLOAT)
AS
BEGIN

 insert into @TB_IRSALIYE_BASLIK (IRSALIYE_TIP,IRSALIYE_TUR,IRSALIYE_TARIH,
 IRSALIYE_SAAT,IRSALIYE_SERI,IRSALIYE_ACIK,
 CARI_UNVAN,CARI_ADRES,CARI_ADRES2,CARI_IL,
 CARI_ILCE,CARI_VERGIDAIRE,CARI_VERGINO,CARI_TEL,PLAKA,SOFOR,
 ACIKLAMA,ARATOPLAM,
 ISKONTOTOPLAMI,ISKONTOLUTOPLAM,KDV_TOPLAM,YUVARLAMATOP,
 KDVSIZ_TOPLAM,KDVLI_TOPLAM,TOPLAM_YAZI,
 KDV0_TOPLAM,KDV1_TOPLAM,KDV8_TOPLAM,KDV18_TOPLAM)

 SELECT ft.irtip,ft.irtur,ft.tarih,ft.saat,
 (ft.irseri+ft.irno),ft.ack,ck.ad,ck.adres,ck.adres2,ck.evil,
 ck.evilce,ck.vergidaire,ck.vergino,ck.tel,
 ft.plaka,ft.Sofor,ft.ack,
 (irtop),
 0,/*(ft.satisktop+ft.genisktop), */
 0,/*(fattop-(ft.satisktop+ft.genisktop)), */
 (genel_kdv_top),
 0, /*(yuvtop), */
 (genel_top-genel_kdv_top),
 (genel_top),
 DBO.ParaOku(
 round( (genel_top),2)),
 isnull((select sum(kdvtut*(mik)) from irsaliyehrklistesi as h where h.irid=@irid and h.sil=0 and h.kdvyuz=0),0),
 isnull((select sum(kdvtut*(mik)) from irsaliyehrklistesi as h where h.irid=@irid and h.sil=0 and h.kdvyuz=0.01),0),
 isnull((select sum(kdvtut*(mik)) from irsaliyehrklistesi as h where h.irid=@irid and h.sil=0 and h.kdvyuz=0.08),0),
 isnull((select sum(kdvtut*(mik)) from irsaliyehrklistesi as h where h.irid=@irid and h.sil=0 and h.kdvyuz=0.18),0)
 
 FROM  irsaliyemas AS ft
 INNER JOIN Genel_Kart as ck
 ON ck.kod=ft.carkod and ck.cartp=ft.cartip
 where irid=@irid


RETURN

END

================================================================================
