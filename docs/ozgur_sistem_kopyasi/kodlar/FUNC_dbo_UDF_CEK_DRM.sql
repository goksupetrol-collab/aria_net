-- Function: dbo.UDF_CEK_DRM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.707636
================================================================================

CREATE FUNCTION [dbo].UDF_CEK_DRM (
@FIRMANO    INT,
@TARIH_TIP INT,
@TARIH1 DATETIME,
@TARIH2 DATETIME,
@REFNO  VARCHAR(30),
@CEKIDIN VARCHAR(8000))
RETURNS
  @TB_CARI_EKSTRE TABLE (
    FIRMANO     INT,
    CEKID       FLOAT,
    CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    ISLEMTARIH  DATETIME,
    VADETARIH   DATETIME,
    CEKNO       VARCHAR(30) COLLATE Turkish_CI_AS,
    REFNO       VARCHAR(20) COLLATE Turkish_CI_AS,
    CEKBANKAAD  VARCHAR(100) COLLATE Turkish_CI_AS,
    CEKTURU     VARCHAR(30) COLLATE Turkish_CI_AS,
    DRMTIP      VARCHAR(20) COLLATE Turkish_CI_AS,
    DURUM       VARCHAR(30) COLLATE Turkish_CI_AS,
    BANKA_KOD   VARCHAR(30) COLLATE Turkish_CI_AS,
    BANKA_AD    VARCHAR(100) COLLATE Turkish_CI_AS,
    NERTUR      VARCHAR(30) COLLATE Turkish_CI_AS,
    NERDEAD     VARCHAR(150) COLLATE Turkish_CI_AS,
    BRIM        VARCHAR(20) COLLATE Turkish_CI_AS,
    TUTAR       DECIMAL(18,8))
    AS
BEGIN
  DECLARE @EKSTRE_TEMP TABLE (
    FIRMANO     INT,
    CEKID       FLOAT,
    CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    ISLEMTARIH   DATETIME,
    VADETARIH   DATETIME,
    CEKNO       VARCHAR(30) COLLATE Turkish_CI_AS,
    REFNO       VARCHAR(20) COLLATE Turkish_CI_AS,
    CEKBANKAAD  VARCHAR(100) COLLATE Turkish_CI_AS,
    CEKTURU     VARCHAR(30) COLLATE Turkish_CI_AS,
    DRMTIP      VARCHAR(20) COLLATE Turkish_CI_AS,
    DURUM       VARCHAR(30) COLLATE Turkish_CI_AS,
    BANKA_KOD   VARCHAR(30) COLLATE Turkish_CI_AS,
    BANKA_AD    VARCHAR(100) COLLATE Turkish_CI_AS,
    NERTUR      VARCHAR(30) COLLATE Turkish_CI_AS,
    NERDEAD     VARCHAR(150) COLLATE Turkish_CI_AS,
    BRIM        VARCHAR(20) COLLATE Turkish_CI_AS,
    TUTAR       DECIMAL(18,8))

  DECLARE @HRK_CEKID       FLOAT
  DECLARE @HRK_CARI_TIP    VARCHAR(20)
  DECLARE @HRK_CARI_KOD    VARCHAR(30)
  DECLARE @HRK_CARI_UNVAN  VARCHAR(150)
  DECLARE @HRK_TARIH       DATETIME
  DECLARE @HRK_VADETAR       DATETIME
  DECLARE @HRK_CEKNO        VARCHAR(30)
  DECLARE @HRK_REFNO        VARCHAR(20)
  DECLARE @HRK_CEKBANKAAD   VARCHAR(100)
  DECLARE @HRK_DRMTIP       VARCHAR(20)
  DECLARE @HRK_DURUM        VARCHAR(30)
  DECLARE @HRK_BANKA_KOD    VARCHAR(20)
  DECLARE @HRK_BANKA_AD     VARCHAR(100)
  DECLARE @HRK_NERTUR      VARCHAR(30)
  DECLARE @HRK_NERDEAD     VARCHAR(150)
  DECLARE @HRK_BRIM        VARCHAR(30)
  DECLARE @HRK_TUTAR       FLOAT

  /*---------------------------------------------------------------------------- */
  if @REFNO=''
   begin
        IF @TARIH_TIP=0 /*ISLEMTARIHI */
        INSERT @EKSTRE_TEMP (FIRMANO,CEKID,CARI_TIP,CARI_KOD,CARI_UNVAN,CEKNO,
        REFNO,ISLEMTARIH,VADETARIH,
        DRMTIP,DURUM,CEKTURU,CEKBANKAAD,
        NERTUR,NERDEAD,TUTAR,BRIM)
          SELECT C.firmano,C.cekid,
          (case when islmhrk='ALN' THEN car.cartp else carver.cartp end),
          (case when islmhrk='ALN' then car.kod else carver.kod end),
          (case when islmhrk='ALN' then car.ad else carver.ad end),
          c.ceksenno,c.refno,c.tarih,c.vadetar,c.drm,c.drmad,c.islmhrkad,c.banka,
          hrkver.tip,hrkver.ad,
          (case when c.giren>0 then c.giren else c.cikan end),
          c.parabrm
         from cekkart as c inner join cekhrk as h on h.id=c.hrkid 
         left join Genel_Kart as car on (c.carkod=car.kod and c.cartip=car.cartp)
         left join Genel_Kart as carver on (c.vercarkod=carver.kod and c.vercartip=carver.cartp)
         left join Genel_Kart as hrkver on (h.carkod=hrkver.kod and h.cartip=hrkver.cartp)
         where c.sil=0 and c.tarih >= @TARIH1 and c.tarih <= @TARIH2

          IF @TARIH_TIP=1    /*--'VADETARIH' */
          INSERT @EKSTRE_TEMP (FIRMANO,CEKID,CARI_TIP,CARI_KOD,CARI_UNVAN,CEKNO,
          REFNO,ISLEMTARIH,VADETARIH,
          DRMTIP,DURUM,CEKTURU,CEKBANKAAD,
          NERTUR,NERDEAD,TUTAR,BRIM)
          SELECT C.firmano,C.cekid,
          (case when carver.cartp<>'' then carver.cartp else car.cartp end),
          (case when carver.kod<>'' then carver.kod else car.kod end),
          (case when carver.ad<>'' then carver.ad else car.ad end),
          c.ceksenno,c.refno,c.tarih,c.vadetar,
          c.drm,c.drmad,c.islmhrkad,c.banka,
          hrkver.tip,hrkver.ad,
          (case when c.giren>0 then c.giren else c.cikan end),
          c.parabrm
         from cekkart as c inner join cekhrk as h on h.id=c.hrkid
         left join Genel_Kart as car on (c.carkod=car.kod and c.cartip=car.cartp)
         left join Genel_Kart as carver on (c.vercarkod=carver.kod and c.vercartip=carver.cartp)
         left join Genel_Kart as hrkver on (h.carkod=hrkver.kod and h.cartip=hrkver.cartp)
         where c.sil=0 and c.vadetar >= @TARIH1 and c.vadetar <= @TARIH2
    end
    
    if @REFNO<>''
     Begin
          INSERT @EKSTRE_TEMP (FIRMANO,CEKID,CARI_TIP,CARI_KOD,CARI_UNVAN,CEKNO,
          REFNO,ISLEMTARIH,VADETARIH,
          DRMTIP,DURUM,CEKTURU,CEKBANKAAD,
          NERTUR,NERDEAD,TUTAR,BRIM)
          SELECT C.firmano,C.cekid,
          (case when carver.cartp<>'' then carver.cartp else car.cartp end),
          (case when carver.kod<>'' then carver.kod else car.kod end),
          (case when carver.ad<>'' then carver.ad else car.ad end),
          c.ceksenno,c.refno,c.tarih,c.vadetar,
          c.drm,c.drmad,c.islmhrkad,c.banka,
          hrkver.tip,hrkver.ad,
          (case when c.giren>0 then c.giren else c.cikan end),
          c.parabrm
         from cekkart as c inner join cekhrk as h on h.id=c.hrkid
         left join Genel_Kart as car on (c.carkod=car.kod and c.cartip=car.cartp)
         left join Genel_Kart as carver on (c.vercarkod=carver.kod and c.vercartip=carver.cartp)
         left join Genel_Kart as hrkver on (h.carkod=hrkver.kod and h.cartip=hrkver.cartp)
         where c.sil=0 and c.refno= @REFNO
     end
     
    if @CEKIDIN<>''
     Begin
          INSERT @EKSTRE_TEMP (FIRMANO,CEKID,CARI_TIP,CARI_KOD,CARI_UNVAN,CEKNO,
          REFNO,ISLEMTARIH,VADETARIH,
          DRMTIP,DURUM,CEKTURU,CEKBANKAAD,
          NERTUR,NERDEAD,TUTAR,BRIM)
          SELECT C.firmano,C.cekid,
          (case when carver.cartp<>'' then carver.cartp else car.cartp end),
          (case when carver.kod<>'' then carver.kod else car.kod end),
          (case when carver.ad<>'' then carver.ad else car.ad end),
          c.ceksenno,c.refno,c.tarih,c.vadetar,
          c.drm,c.drmad,c.islmhrkad,c.banka,
          hrkver.tip,hrkver.ad,
          (case when c.giren>0 then c.giren else c.cikan end),
          c.parabrm
         from cekkart as c inner join cekhrk as h on h.id=c.hrkid
         left join Genel_Kart as car on (c.carkod=car.kod and c.cartip=car.cartp)
         left join Genel_Kart as carver on (c.vercarkod=carver.kod and c.vercartip=carver.cartp)
         left join Genel_Kart as hrkver on (h.carkod=hrkver.kod and h.cartip=hrkver.cartp)
         where c.sil=0 and c.cekid in (select * from CsvToInt(@CEKIDIN))
     end  
  
  if @FIRMANO>0
   delete from @EKSTRE_TEMP where FIRMANO not in (@FIRMANO)  
    

  /*---------------------------------------------------------------------------- */
  if @TARIH_TIP=0
  INSERT @TB_CARI_EKSTRE
    SELECT * FROM @EKSTRE_TEMP ORDER BY ISLEMTARIH

  if @TARIH_TIP=1
  INSERT @TB_CARI_EKSTRE
    SELECT * FROM @EKSTRE_TEMP ORDER BY VADETARIH

  RETURN

END

================================================================================
