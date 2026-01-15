-- Function: dbo.MALCIKIS_TARIHLI_STOK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.664642
================================================================================

CREATE FUNCTION dbo.MALCIKIS_TARIHLI_STOK (@depkod varchar(20),
@stktip varchar(20),@stkod varchar(20),@TARIH1 datetime,@TARIH2 datetime,
@SAAT1 VARCHAR(8), @SAAT2 VARCHAR(8) )
RETURNS
   @TB_MAL_SATIS TABLE (
    MIKTAR     FLOAT,
    TUTAR      FLOAT)
BEGIN

DECLARE @MIKTAR FLOAT
DECLARE @TUTAR FLOAT

if @depkod<>''
select @MIKTAR=ISNULL(SUM(giren-cikan),0),
@TUTAR=ISNULL(SUM((giren*brmfiykdvli)-(cikan*brmfiykdvli)),0) from stkhrk
where depkod=@depkod and stktip=@stktip and stkod=@stkod and islmtip='satis'
and tabload='faturahrk' and sil=0
 AND (tarih > @TARIH1 OR (tarih = @TARIH1 AND saat > @SAAT1))
 AND (tarih < @TARIH2 OR (tarih = @TARIH2 AND saat < @SAAT2))


if @depkod=''
select @MIKTAR=ISNULL(SUM(giren-cikan),0),
@TUTAR=ISNULL(SUM((giren*brmfiykdvli)-(cikan*brmfiykdvli)),0) from stkhrk
where stktip=@stktip and stkod=@stkod and islmtip='satis' and tabload='faturahrk'
and sil=0
 AND (tarih > @TARIH1 OR (tarih = @TARIH1 AND saat > @SAAT1))
 AND (tarih < @TARIH2 OR (tarih = @TARIH2 AND saat < @SAAT2))

  INSERT @TB_MAL_SATIS (MIKTAR,TUTAR)
   VALUES (@MIKTAR,@TUTAR)

  RETURN

END

================================================================================
