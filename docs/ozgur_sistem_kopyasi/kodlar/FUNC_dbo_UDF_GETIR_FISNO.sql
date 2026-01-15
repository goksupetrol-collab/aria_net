-- Function: dbo.UDF_GETIR_FISNO
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.723455
================================================================================

CREATE FUNCTION [dbo].UDF_GETIR_FISNO (@TIP varchar(40))
RETURNS VARCHAR(25) AS
BEGIN

  RETURN(
    SELECT
      seri + RIGHT('00000000000000000000' + CAST(numara + 1 AS VARCHAR(15)),uzunluk)
    FROM  NUMARATOR
    WHERE tip = @TIP
  )

END

================================================================================
