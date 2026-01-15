-- Function: dbo.UDF_CARI_FIS_STOK_GRP
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.693662
================================================================================

CREATE FUNCTION [dbo].UDF_CARI_FIS_STOK_GRP (
@FIRMANO		INT,
@CARI_TIP 		VARCHAR(20),
@CARIKODIN 		VARCHAR(8000),
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
    @TB_STOKLITRE_EKSTRE TABLE (
    CARI_TIP    	VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD    	VARCHAR(50)  COLLATE Turkish_CI_AS,
    CARI_UNVAN     	VARCHAR(150)  COLLATE Turkish_CI_AS,
    STOK_GRUP_ID   	INT,
    STOK_GRUP_AD	VARCHAR(50)  COLLATE Turkish_CI_AS,
    MIKTAR			FLOAT,
    TUTAR			FLOAT)
AS
BEGIN

    DECLARE @EKSTRE_TEMP TABLE (
    STOK_GRUP_ID   	INT,
    STOK_GRUP_AD	VARCHAR(50)  COLLATE Turkish_CI_AS,
    CARI_TIP    	VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD    	VARCHAR(50)  COLLATE Turkish_CI_AS,
    CARI_UNVAN     	VARCHAR(150)  COLLATE Turkish_CI_AS,
    STOK_TIP    	VARCHAR(20)    COLLATE Turkish_CI_AS,
    STOK_KOD    	VARCHAR(50)    COLLATE Turkish_CI_AS,
    STOK_AD     	VARCHAR(100)    COLLATE Turkish_CI_AS,
    MIKTAR			FLOAT,
    TUTAR			FLOAT)




   if @CARIKODIN<>''
    insert into @EKSTRE_TEMP (CARI_TIP,CARI_KOD,
    STOK_TIP,STOK_KOD,MIKTAR,TUTAR)
    SELECT M.cartip,m.carkod,h.stktip,h.stkod,
    sum(mik),sum(h.brmfiy*h.mik) from 
    veresimas as m inner join veresihrk as h
    on h.verid=m.verid and h.sil=0 and m.sil=0
    where m.fistip='FISVERSAT'
    and m.cartip=@CARI_TIP 
    and m.carkod in (select * from CsvToSTR(@CARIKODIN))
    and m.tarih>=@TARIH1 and m.tarih<=@TARIH2 
    group by m.cartip,m.carkod,h.stktip,h.stkod

   if @CARIKODIN=''
    insert into @EKSTRE_TEMP (CARI_TIP,CARI_KOD,
    STOK_TIP,STOK_KOD,MIKTAR,TUTAR)
    SELECT M.cartip,m.carkod,h.stktip,h.stkod,
    sum(mik),sum(h.brmfiy*h.mik) from 
    veresimas as m inner join veresihrk as h
    on h.verid=m.verid and h.sil=0 and m.sil=0
    where m.fistip='FISVERSAT'
    and m.cartip=@CARI_TIP 
    and m.tarih>=@TARIH1 and m.tarih<=@TARIH2 
    group by m.cartip,m.carkod,h.stktip,h.stkod



   update @EKSTRE_TEMP set STOK_GRUP_AD='GELİR-GİDER'

    update @EKSTRE_TEMP set STOK_GRUP_ID=dt.grp1 
    from @EKSTRE_TEMP as t join 
    (select tip,kod,grp1 from stokkart ) dt 
    on dt.tip=t.STOK_TIP and dt.kod=t.STOK_KOD 

    update @EKSTRE_TEMP set STOK_GRUP_AD=dt.AD
    from @EKSTRE_TEMP as t join 
    (select id,ad from GRUP ) dt 
    on dt.id=t.STOK_GRUP_ID 

    update @EKSTRE_TEMP set CARI_UNVAN=dt.ad 
    from @EKSTRE_TEMP as t join 
    (select cartp,kod,ad from Genel_Kart ) dt 
    on dt.cartp=t.CARI_TIP and dt.kod=t.CARI_KOD 



    insert into @TB_STOKLITRE_EKSTRE
    (CARI_TIP,CARI_KOD,CARI_UNVAN,
    STOK_GRUP_ID,STOK_GRUP_AD,MIKTAR,TUTAR)
    SELECT CARI_TIP,CARI_KOD,CARI_UNVAN,
    STOK_GRUP_ID,STOK_GRUP_AD,MIKTAR,TUTAR 
    from @EKSTRE_TEMP 



  RETURN

  
END

================================================================================
