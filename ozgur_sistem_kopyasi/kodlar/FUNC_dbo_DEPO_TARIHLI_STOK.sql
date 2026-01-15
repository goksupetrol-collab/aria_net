-- Function: dbo.DEPO_TARIHLI_STOK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.652686
================================================================================

CREATE FUNCTION dbo.DEPO_TARIHLI_STOK(@depkod varchar(20),@stktip varchar(20),
@stkod varchar(20),@TARIH1 datetime,@SAAT1 VARCHAR(8))
RETURNS
  @TB_DEP_TARIH TABLE (
    MIKTAR     FLOAT,
    TUTAR      FLOAT)
BEGIN
DECLARE @MIKTAR FLOAT
DECLARE @TUTAR FLOAT
DECLARE @BRMFIYAT FLOAT

/*
select @BRMFIYAT=case when alskdvtip='Dahil' then alsfiy else
(case when alskdv=0 then alsfiy else alsfiy*(1+(alsfiy/100)) end)
end from stokkart where tip=@stktip and kod=@stkod
*/

if @depkod<>''
select @MIKTAR=ISNULL(SUM(h.giren-h.cikan),0),
@TUTAR=ISNULL(SUM((h.giren-h.cikan)*h.brmfiykdvli),0) from stkhrk as h
where depkod=@depkod and stktip=@stktip and stkod=@stkod and sil=0
 AND (tarih+cast(saat as datetime)) <= (@TARIH1+cast(@SAAT1 as datetime))


if @depkod=''
select @MIKTAR=ISNULL(SUM(h.giren-h.cikan),0),
@TUTAR=ISNULL(SUM((h.giren-h.cikan)*h.brmfiykdvli),0) from stkhrk as h
where stktip=@stktip and stkod=@stkod and sil=0
 AND (tarih+cast(saat as datetime)) <= (@TARIH1+cast(@SAAT1 as datetime))

  INSERT @TB_DEP_TARIH (MIKTAR,TUTAR)
   VALUES (@MIKTAR,@TUTAR)

  RETURN

END

================================================================================
