-- Function: dbo.DEPO_TARIHLI_ONCE_MIKTAR
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.652334
================================================================================

CREATE FUNCTION [dbo].DEPO_TARIHLI_ONCE_MIKTAR (
 @depkod varchar(20),
 @TARIH1 datetime)
RETURNS  FLOAT
BEGIN

  RETURN (select ISNULL(SUM(h.giren-h.cikan),0) from stkhrk as h
 where depkod=@depkod and sil=0
 AND tarih+cast(saat as datetime) <= @TARIH1)

END

================================================================================
