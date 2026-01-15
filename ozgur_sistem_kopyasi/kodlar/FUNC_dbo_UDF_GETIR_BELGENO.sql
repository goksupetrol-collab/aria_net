-- Function: dbo.UDF_GETIR_BELGENO
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.723107
================================================================================

CREATE FUNCTION [dbo].UDF_GETIR_BELGENO (@TIP varchar(40),@SERI varchar(10))
RETURNS VARCHAR(25) AS
BEGIN

  RETURN(
    SELECT
      seri + RIGHT('00000000000000000000' + CAST(numara + 1 AS VARCHAR(15)),uzunluk)
    FROM  NUMARATOR WHERE tip = @TIP and seri=@SERI
  )

END

================================================================================
