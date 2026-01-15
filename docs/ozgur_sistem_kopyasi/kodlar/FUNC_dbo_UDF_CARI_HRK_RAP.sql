-- Function: dbo.UDF_CARI_HRK_RAP
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.695817
================================================================================

CREATE FUNCTION [dbo].[UDF_CARI_HRK_RAP] (
@firmano		int,
@HRK_KRITER     VARCHAR(4000),
@CARI_TIP 		VARCHAR(20),
@CARI_KOD 		VARCHAR(4000),
@TARIH1 		DATETIME,
@TARIH2 		DATETIME)
RETURNS
  @TB_CARI_EKSTRE TABLE (
    Firmano     int,
    CARI_TIP    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(50) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    TARIH       DATETIME,
    SAAT        VARCHAR(8)  COLLATE Turkish_CI_AS,
    BELGENO     VARCHAR(50)  COLLATE Turkish_CI_AS,
    PLAKA       VARCHAR(50)  COLLATE Turkish_CI_AS,
    ACIKLAMA    VARCHAR(200) COLLATE Turkish_CI_AS,
    ISLTIPAD    VARCHAR(50)  COLLATE Turkish_CI_AS,
    ISLHRKAD    VARCHAR(50)  COLLATE Turkish_CI_AS,
    YERTIP      VARCHAR(30)  COLLATE Turkish_CI_AS,
    YERAD       VARCHAR(50)  COLLATE Turkish_CI_AS,
    KULAD       VARCHAR(70)  COLLATE Turkish_CI_AS,
    ISLTIP      VARCHAR(50)  COLLATE Turkish_CI_AS,
    ISLHRK      VARCHAR(70)  COLLATE Turkish_CI_AS,
    VADETAR     DATETIME,
    VARNO       FLOAT,
    VAROK		INT,
    RAPID		INT,
    HRKID       FLOAT,
    MASID       FLOAT,
    BORC        FLOAT,
    ALACAK      FLOAT,
    BAKIYE      FLOAT,
    FAT_ID      INT,
    FIS_ID      INT,
    IRS_ID      INT,
    MARSAT_ID	INT,
    SAYIM_ID    INT,
    REMOTE_ID	INT,
    KASAHRK_ID  INT,
    POSHRK_ID   INT,
    BANKAHRK_ID INT,
    CEK_ID		INT,
    ISTHRK_ID   INT,
    DEVIR		INT)
AS
BEGIN


  DECLARE @KUM_BAKIYE      FLOAT

  
  DECLARE @ONDA_HANE       INT

  SET @KUM_BAKIYE = 0
  
  
  select @ONDA_HANE=Para_Ondalik from sistemtanim



 if @CARI_KOD<>''
   INSERT @TB_CARI_EKSTRE
   (Firmano,CARI_TIP,CARI_KOD,
    CARI_UNVAN,TARIH,SAAT,BELGENO,
    PLAKA,ACIKLAMA,
    ISLTIPAD,ISLHRKAD,YERTIP,YERAD,
    KULAD,ISLTIP,ISLHRK,VADETAR,
    VARNO,VAROK,RAPID,HRKID,
    MASID,BORC,ALACAK,BAKIYE,
    FAT_ID,FIS_ID,IRS_ID,
    MARSAT_ID,SAYIM_ID,REMOTE_ID,
    KASAHRK_ID,POSHRK_ID,BANKAHRK_ID,
    CEK_ID,ISTHRK_ID,DEVIR)
    SELECT
      h.firmano,
      h.cartip,h.carkod,'',
      tarih,saat,belno,
      plaka, /*PLAKA */
      ack, /* AÇIKLAMA, */
      islmtipad,islmhrkad,yertip,yerad,
      olususer,islmtip,islmhrk,vadetar,varno,
      varok,belrap_id,
      carhrkid,masterid,
      round(borc,@ONDA_HANE),
      round(alacak,@ONDA_HANE),
      ROUND(ISNULL(borc-alacak,0),@ONDA_HANE) AS BAKIYE,
      h.fatid,h.fisid,h.irsid,
      h.marsatid,h.say_id,h.remote_id,
      h.kasahrk_id,h.Poshrk_id,h.Bankahrk_id,
      h.Cek_id,h.isthrk_id,0
    FROM carihrk as h 
    WHERE cartip=@CARI_TIP
    and carkod in (select * from CsvToSTR(@CARI_KOD)) 
     and sil=0 
     and islmtip+'_'+islmhrk not in 
     (select * FROM CsvToSTR(@HRK_KRITER))
     AND (tarih >= @TARIH1 )
     AND (tarih <= @TARIH2)
    ORDER BY tarih,saat
 

  if @CARI_KOD=''
   INSERT @TB_CARI_EKSTRE
   (Firmano,CARI_TIP,CARI_KOD,
    CARI_UNVAN,TARIH,SAAT,BELGENO,
    PLAKA,ACIKLAMA,
    ISLTIPAD,ISLHRKAD,YERTIP,YERAD,
    KULAD,ISLTIP,ISLHRK,VADETAR,
    VARNO,VAROK,RAPID,HRKID,
    MASID,BORC,ALACAK,BAKIYE,
    FAT_ID,FIS_ID,IRS_ID,
    MARSAT_ID,SAYIM_ID,REMOTE_ID,
    KASAHRK_ID,POSHRK_ID,BANKAHRK_ID,
    CEK_ID,ISTHRK_ID,DEVIR)
    SELECT
      h.firmano,
      h.cartip,h.carkod,'',
      tarih,saat,belno,
      plaka, /*PLAKA */
      ack, /* AÇIKLAMA, */
      islmtipad,islmhrkad,yertip,yerad,
      olususer,islmtip,islmhrk,vadetar,varno,
      varok,belrap_id,
      carhrkid,masterid,
      round(borc,@ONDA_HANE),
      round(alacak,@ONDA_HANE),
      ROUND(ISNULL(borc-alacak,0),@ONDA_HANE) AS BAKIYE,
      h.fatid,h.fisid,h.irsid,
      h.marsatid,h.say_id,h.remote_id,
      h.kasahrk_id,h.Poshrk_id,h.Bankahrk_id,
      h.Cek_id,h.isthrk_id,0
    FROM carihrk as h 
    WHERE cartip=@CARI_TIP
      and sil=0 
     and islmtip+'_'+islmhrk not in 
     (select * FROM CsvToSTR(@HRK_KRITER))
     AND (tarih >= @TARIH1 )
     AND (tarih <= @TARIH2)
    ORDER BY tarih,saat
  
  
  UPDATE @TB_CARI_EKSTRE 
  SET CARI_UNVAN=dt.ad from  @TB_CARI_EKSTRE  T 
  join (select gk.kod,gk.ad from Genel_Kart as gk
   where gk.cartp=@CARI_TIP) DT
   ON dt.kod=t.CARI_KOD
  
  


   RETURN

END

================================================================================
