-- Function: dbo.PROMOSYON_BASLIK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.667904
================================================================================

CREATE FUNCTION dbo.[PROMOSYON_BASLIK] (@promid float)
RETURNS
 @TB_PROMOSYON_BASLIK TABLE (
    FIS_TIP			 VARCHAR(10) COLLATE Turkish_CI_AS,
    FIS_AD           VARCHAR(30) COLLATE Turkish_CI_AS,
    FIS_YKNO         VARCHAR(30) COLLATE Turkish_CI_AS,
    FIS_TARIH        DATETIME,
    FIS_VAD_TARIH    DATETIME,
    FIS_SAAT         VARCHAR(10) COLLATE Turkish_CI_AS,
    FIS_SERINO       VARCHAR(50) COLLATE Turkish_CI_AS,
    FIS_SERI         VARCHAR(10) COLLATE Turkish_CI_AS,
    FIS_NO           VARCHAR(40) COLLATE Turkish_CI_AS,
    FIS_PLAKA        VARCHAR(50) COLLATE Turkish_CI_AS,
    FIS_SURUCU		 VARCHAR(50) COLLATE Turkish_CI_AS,
    FIS_KM           VARCHAR(20) COLLATE Turkish_CI_AS,
    FIS_ACIKLAMA     VARCHAR(100) COLLATE Turkish_CI_AS,
    PER_AD           VARCHAR(100) COLLATE Turkish_CI_AS,
    CARI_GRUP        VARCHAR(100) COLLATE Turkish_CI_AS, 
    CARI_KOD         VARCHAR(50) COLLATE Turkish_CI_AS, 
    CARI_UNVAN       VARCHAR(150) COLLATE Turkish_CI_AS,
    CARI_FAT_UNVAN   VARCHAR(150) COLLATE Turkish_CI_AS,
    CARI_ADRES       VARCHAR(100) COLLATE Turkish_CI_AS,
    CARI_ADRES2      VARCHAR(100) COLLATE Turkish_CI_AS,
    CARI_IL          VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_ILCE        VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_VERGIDAIRE  VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_VERGINO     VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_TCNO        VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_ONCE_PUAN   FLOAT,
    CARI_KAZ_PUAN    FLOAT,
    CARI_TOP_PUAN    FLOAT,
    ARA_TOPLAM       FLOAT,
    ISKONTOTOPLAMI   FLOAT,
    ISKONTOLUTOPLAM  FLOAT,
    KDV_TOPLAM       FLOAT,
    YUVARLAMATOP     FLOAT,
    KDVSIZ_TOPLAM    FLOAT,
    KDVLI_TOPLAM     FLOAT,
    FIS_TOPLAM       FLOAT,
    ODEMETIPAD       VARCHAR(50) COLLATE Turkish_CI_AS,
    TOPLAM_YAZI      VARCHAR(150) COLLATE Turkish_CI_AS)

AS
BEGIN

 insert into @TB_PROMOSYON_BASLIK (FIS_TIP,FIS_AD,FIS_YKNO,FIS_TARIH,
 FIS_VAD_TARIH,FIS_SAAT,FIS_SERINO,
 FIS_SERI,FIS_NO,FIS_PLAKA,FIS_SURUCU,FIS_KM,FIS_ACIKLAMA,PER_AD,
 CARI_GRUP,CARI_KOD,CARI_UNVAN,
 CARI_ONCE_PUAN,CARI_KAZ_PUAN,CARI_TOP_PUAN,
 ARA_TOPLAM,ISKONTOTOPLAMI,
 ISKONTOLUTOPLAM,KDV_TOPLAM,YUVARLAMATOP,KDVSIZ_TOPLAM,KDVLI_TOPLAM,
 FIS_TOPLAM,ODEMETIPAD,TOPLAM_YAZI)
 SELECT ver.fistip,ver.fisad,ver.ykno,ver.tarih,
 ver.vadtar,ver.saat,(ver.seri+' '+ver.no),(ver.seri),(ver.no),
 (ver.plaka),(ver.surucu),(ver.km),ver.ack,pk.ad+' '+pk.soyad,
 ck.Grup_Ad,CK.KOD, ck.unvan,
 ck.Mevcut_Puan-ver.Genel_Top_Puan,ver.Genel_Top_Puan,ck.Mevcut_Puan,
 ver.Genel_Top_Kdvsiz, /* ARA_TOPLAM, */
 0,/*ISKONTOTOPLAMI */
 0,/*ISKONTOLUTOPLAM */
 ver.Genel_Top_Kdv,/* KDV_TOPLAM, */
 0,/*YUVARLAMATOP */
 0,/*KDVSIZ_TOPLAM */
 0,/*KDVLI_TOPLAM, */
 round(ver.Genel_Top_Kdvli,2) ,/*FIS_TOPLAM */
 VER.OdeTip_Ad,
 DBO.ParaOku(round(Genel_Top_Kdvli,2))
FROM  Prom_Sat_Baslik AS ver
INNER JOIN Prom_Musteri_Listesi as ck
ON ck.kod=ver.carkod and ck.cartip=ver.cartip
and ck.KartId=ver.KartId
LEFT JOIN Perkart as pk on
pk.kod=ver.perkod 
where ver.promid=@promid

 update @TB_PROMOSYON_BASLIK set 
     KDVSIZ_TOPLAM=FIS_TOPLAM-KDV_TOPLAM,
     KDVLI_TOPLAM=FIS_TOPLAM

 return

end

================================================================================
