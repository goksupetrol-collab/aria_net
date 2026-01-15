-- Function: dbo.VERESIYE_BASLIK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.800470
================================================================================

CREATE FUNCTION dbo.VERESIYE_BASLIK (@verid float)
RETURNS
 @TB_VERESIYE_BASLIK TABLE (
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
    CARI_FISBAKIYE   FLOAT,
    CARI_CARBAKIYE   FLOAT,
    CARI_TOPBAKIYE   FLOAT,
    CARI_TOPLIMITTUT FLOAT,
    CARI_KALLIMITTUT FLOAT,
    ARA_TOPLAM       FLOAT,
    ISKONTOTOPLAMI   FLOAT,
    ISKONTOLUTOPLAM  FLOAT,
    KDV_TOPLAM       FLOAT,
    YUVARLAMATOP     FLOAT,
    KDVSIZ_TOPLAM    FLOAT,
    KDVLI_TOPLAM     FLOAT,
    FIS_TOPLAM       FLOAT,
    TOPLAM_YAZI      VARCHAR(150) COLLATE Turkish_CI_AS,
    ISK1_YUZDE       FLOAT,
    KDV0_TOPLAM      FLOAT,
    KDV1_TOPLAM      FLOAT,
    KDV8_TOPLAM      FLOAT,
    KDV18_TOPLAM     FLOAT,
    KDV26_TOPLAM     FLOAT,
    KDV0_MATRAH      FLOAT,
    KDV1_MATRAH      FLOAT,
    KDV8_MATRAH      FLOAT,
    KDV18_MATRAH     FLOAT,
    KDV26_MATRAH     FLOAT)

AS
BEGIN

 insert into @TB_VERESIYE_BASLIK (FIS_TIP,FIS_AD,FIS_YKNO,FIS_TARIH,
 FIS_VAD_TARIH,FIS_SAAT,FIS_SERINO,
 FIS_SERI,FIS_NO,FIS_PLAKA,FIS_SURUCU,FIS_KM,FIS_ACIKLAMA,PER_AD,
 CARI_GRUP,CARI_KOD,CARI_UNVAN,CARI_FAT_UNVAN,CARI_ADRES,CARI_ADRES2,CARI_IL,
 CARI_ILCE,CARI_VERGIDAIRE,CARI_VERGINO,CARI_TCNO,
 CARI_FISBAKIYE,CARI_CARBAKIYE,CARI_TOPBAKIYE,CARI_TOPLIMITTUT,CARI_KALLIMITTUT,
 ARA_TOPLAM,ISKONTOTOPLAMI,
 ISKONTOLUTOPLAM,KDV_TOPLAM,YUVARLAMATOP,KDVSIZ_TOPLAM,KDVLI_TOPLAM,FIS_TOPLAM,TOPLAM_YAZI,
 KDV0_TOPLAM,KDV1_TOPLAM,KDV8_TOPLAM,KDV18_TOPLAM,KDV26_TOPLAM,
 KDV0_MATRAH,KDV1_MATRAH,KDV8_MATRAH,KDV18_MATRAH,KDV26_MATRAH,
 ISK1_YUZDE)
 SELECT ver.fistip,ver.fisad,ver.ykno,ver.tarih,
 ver.vadtar,ver.saat,(ver.seri+' '+ver.no),(ver.seri),(ver.no),
 (ver.plaka),(ver.surucu),(ver.km),ver.ack,pk.ad+' '+pk.soyad,
 ck.Grup_Ad,CK.KOD, ck.ad,ck.fatunvan,ck.adres,ck.adres2,
 ck.evil,ck.evilce,ck.vergidaire,ck.vergino,
 ck.tcno,ck.fisbak,ck.carbak,ck.topbak,ck.Toplimit,
 ck.toplimit-
  case when ck.toplimit>0 then 
  round((ck.fisbak+ck.carbak),2)
  else
  0 end,
 (select isnull(
 sum(((h.mik*h.brmfiy)/(1+h.kdvyuz)) ),0)
 from veresihrk as h WITH (NOLOCK) 
 where h.verid=ver.verid and h.sil=0), /* ARA_TOPLAM, */
 0,/*ISKONTOTOPLAMI */
 0,/*ISKONTOLUTOPLAM */
  (select isnull(
 sum( (h.mik*h.brmfiy) - ((h.mik*h.brmfiy)/(1+h.kdvyuz)) ),0)
 from veresihrk as h WITH (NOLOCK) 
 where h.verid=ver.verid and h.sil=0),/* KDV_TOPLAM, */
 0,/*YUVARLAMATOP */
 0,/*KDVSIZ_TOPLAM */
 0,/*KDVLI_TOPLAM, */
 round(toptut,2) ,/*FIS_TOPLAM */
 DBO.ParaOku(round(toptut,2)),/* as TOPLAM_YAZI */
 KDV0_TOPLAM=isnull((select sum( (h.mik*h.brmfiy) - ((h.mik*h.brmfiy)/(1+h.kdvyuz)) ) from veresihrk as h WITH (NOLOCK)  where h.verid=ver.verid and h.sil=0 and h.kdvyuz=0),0),
 KDV1_TOPLAM=isnull((select sum( (h.mik*h.brmfiy) - ((h.mik*h.brmfiy)/(1+h.kdvyuz)) ) from veresihrk as h WITH (NOLOCK) where h.verid=ver.verid and h.sil=0 and h.kdvyuz=0.01),0),
 KDV8_TOPLAM=isnull((select sum( (h.mik*h.brmfiy) - ((h.mik*h.brmfiy)/(1+h.kdvyuz)) ) from veresihrk as h WITH (NOLOCK) where h.verid=ver.verid and h.sil=0 and h.kdvyuz=0.08),0),
 KDV18_TOPLAM=isnull((select sum( (h.mik*h.brmfiy) - ((h.mik*h.brmfiy)/(1+h.kdvyuz)) ) from veresihrk as h WITH (NOLOCK) where h.verid=ver.verid and h.sil=0 and h.kdvyuz=0.18),0),
 KDV26_TOPLAM=isnull((select sum( (h.mik*h.brmfiy) - ((h.mik*h.brmfiy)/(1+h.kdvyuz)) ) from veresihrk as h WITH (NOLOCK) where h.verid=ver.verid and h.sil=0 and h.kdvyuz=0.26),0),
 KDV0_MATRAH=isnull((select sum( ((h.mik*h.brmfiy)/(1+h.kdvyuz)) ) from veresihrk as h WITH (NOLOCK) where h.verid=ver.verid and h.sil=0 and h.kdvyuz=0),0),
 KDV1_MATRAH=isnull((select sum(  ((h.mik*h.brmfiy)/(1+h.kdvyuz)) ) from veresihrk as h WITH (NOLOCK) where h.verid=ver.verid and h.sil=0 and h.kdvyuz=0.01),0),
 KDV8_MATRAH=isnull((select sum(  ((h.mik*h.brmfiy)/(1+h.kdvyuz)) ) from veresihrk as h WITH (NOLOCK) where h.verid=ver.verid and h.sil=0 and h.kdvyuz=0.08),0),
 KDV18_MATRAH=isnull((select sum(  ((h.mik*h.brmfiy)/(1+h.kdvyuz)) ) from veresihrk as h WITH (NOLOCK) where h.verid=ver.verid and h.sil=0 and h.kdvyuz=0.18),0),
 KDV26_MATRAH=isnull((select sum( ((h.mik*h.brmfiy)/(1+h.kdvyuz)) ) from veresihrk as h WITH (NOLOCK) where h.verid=ver.verid and h.sil=0 and h.kdvyuz=0.26),0), 
 0/*ISK1_YUZDE */
FROM  veresimas AS ver WITH (NOLOCK) 
INNER JOIN View_Cariler_Kart_Bakiye as ck
ON ck.kod=ver.carkod and ck.cartp=ver.cartip
LEFT JOIN Perkart as pk on
pk.kod=ver.perkod 
where verid=@verid

 update @TB_VERESIYE_BASLIK set 
     KDVSIZ_TOPLAM=FIS_TOPLAM-KDV_TOPLAM,
     KDVLI_TOPLAM=FIS_TOPLAM

 return

end

================================================================================
