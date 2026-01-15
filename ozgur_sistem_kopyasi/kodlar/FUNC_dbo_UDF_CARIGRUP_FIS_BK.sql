-- Function: dbo.UDF_CARIGRUP_FIS_BK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.700136
================================================================================

CREATE FUNCTION [dbo].UDF_CARIGRUP_FIS_BK
(
@CARI_TIP   VARCHAR(20),
@CARI_KODIN VARCHAR(8000),
@RAP_ID      INT,
@AK_TIP     VARCHAR(6),/*FT,CH,TEK_CH */
@TARTIP     VARCHAR(20),
@BASTAR     DATETIME,
@BITTAR     DATETIME)
RETURNS
    @TB_CARI_FIS_EKSTRE TABLE (
    CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    FAT_TIP     VARCHAR(10) COLLATE Turkish_CI_AS,
    RAPID      INT,
    VERID       FLOAT,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)  COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(30) COLLATE Turkish_CI_AS,
    YKNO        VARCHAR(20) COLLATE Turkish_CI_AS,
    PLAKA       VARCHAR(50) COLLATE Turkish_CI_AS,
    TUTAR       FLOAT,
    ISK_TUTAR  FLOAT)
AS
BEGIN

    DECLARE    @TB_CARI_FIS_TEMP TABLE (
    CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    FAT_TIP     VARCHAR(10) COLLATE Turkish_CI_AS,
    VERID       FLOAT,
    RAPID      INT,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)  COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(30) COLLATE Turkish_CI_AS,
    YKNO        VARCHAR(20) COLLATE Turkish_CI_AS,
    PLAKA       VARCHAR(50) COLLATE Turkish_CI_AS,
    TUTAR       FLOAT,
    ISK_FATTUT  FLOAT,
    ISK_FISTUT  FLOAT)


 
     IF @TARTIP='tarih'
     BEGIN
     INSERT @TB_CARI_FIS_TEMP
      (CARI_TIP,CARI_KOD,CARI_UNVAN,FAT_TIP,VERID,RAPID,TARIH,SAAT,BELGENO,YKNO,
      PLAKA,TUTAR,ISK_FATTUT,ISK_FISTUT)
     SELECT
      @CARI_TIP,ck.kod,ck.ad,fistip,
       verid,fisrap_id,tarih,saat,
       seri+cast([no] as varchar),
       v.ykno,/*YKNO */
       plaka, /*PLAKA */
       CASE WHEN fistip='FISVERSAT' THEN  toptut else -1*toptut end,
       CASE WHEN fistip='FISVERSAT' THEN  toptut*(ck.fat_iskonto/100) else 0 end,
       CASE WHEN fistip='FISVERSAT' THEN  toptut*(ck.fis_iskonto/100) else 0 end
       FROM veresimas as v
       inner join genel_kart ck on ck.cartp=v.cartip
       and ck.kod=v.carkod and ck.sl=0
       where cartip=@CARI_TIP
       and ck.kod in (select * from dbo.CsvToSTR(@CARI_KODIN))
       and v.sil=0
       and v.tarih>=@BASTAR and v.tarih<=@BITTAR
       and v.aktip in ('BK','BL')
       and  v.varok=1
       ORDER BY tarih
      END
      
      
     IF @TARTIP='vadetar'
     BEGIN
      INSERT @TB_CARI_FIS_TEMP
      (CARI_TIP,CARI_KOD,CARI_UNVAN,FAT_TIP,VERID,RAPID,TARIH,SAAT,BELGENO,YKNO,
      PLAKA,TUTAR,ISK_FATTUT,ISK_FISTUT)
     SELECT
      @CARI_TIP,ck.kod,ck.ad,fistip,
       verid,fisrap_id,tarih,saat,
       seri+cast([no] as varchar),
       v.ykno,/*YKNO */
       plaka, /*PLAKA */
       CASE WHEN fistip='FISVERSAT' THEN  toptut else -1*toptut end,
       CASE WHEN fistip='FISVERSAT' THEN  toptut*(ck.fat_iskonto/100) else 0 end,
       CASE WHEN fistip='FISVERSAT' THEN  toptut*(ck.fis_iskonto/100) else 0 end
       FROM veresimas as v
       inner join genel_kart ck on ck.cartp=v.cartip
       and ck.kod=v.carkod and ck.sl=0
       where cartip=@CARI_TIP
       and ck.kod in (select * from dbo.CsvToSTR(@CARI_KODIN))
       and v.sil=0
       and v.vadtar<=@BITTAR
       and v.aktip in ('BK','BL')
       and  v.varok=1
       ORDER BY tarih
      END
      
     IF (@AK_TIP='CH') OR (@AK_TIP='TEK_CH')
      INSERT @TB_CARI_FIS_EKSTRE
      (CARI_TIP,CARI_KOD,CARI_UNVAN,VERID,RAPID,TARIH,SAAT,BELGENO,YKNO,
      PLAKA,TUTAR,ISK_TUTAR)
      SELECT
      CARI_TIP,CARI_KOD,CARI_UNVAN,VERID,RAPID,TARIH,SAAT,BELGENO,YKNO,
      PLAKA,TUTAR,ISK_FISTUT FROM @TB_CARI_FIS_TEMP
      
      IF @AK_TIP='FT'
      INSERT @TB_CARI_FIS_EKSTRE
      (CARI_TIP,CARI_KOD,CARI_UNVAN,VERID,RAPID,TARIH,SAAT,BELGENO,YKNO,
      PLAKA,TUTAR,ISK_TUTAR)
      SELECT
      CARI_TIP,CARI_KOD,CARI_UNVAN,VERID,RAPID,TARIH,SAAT,BELGENO,YKNO,
      PLAKA,TUTAR,ISK_FATTUT FROM @TB_CARI_FIS_TEMP
      WHERE FAT_TIP='FISVERSAT'
      
     
     
     if @RAP_ID>0
      Delete from @TB_CARI_FIS_EKSTRE where RAPID !=@RAP_ID
      


  RETURN

END

================================================================================
