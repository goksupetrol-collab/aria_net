-- Function: dbo.UDF_KART_HRK_SAY
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.731688
================================================================================

CREATE FUNCTION [dbo].UDF_KART_HRK_SAY (
@CARTIP		VARCHAR(30),
@CARKOD		VARCHAR(30)
)
  RETURNS float
AS
BEGIN
  declare @sonuc   float  
  
  set  @sonuc=0
  
  
  select @sonuc=count(id) from carihrk 
   where cartip=@CARTIP and carkod=@CARKOD 
  


  RETURN @sonuc


END

================================================================================
