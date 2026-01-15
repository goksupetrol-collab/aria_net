-- Function: dbo.kdvoranver
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.663945
================================================================================

CREATE FUNCTION [dbo].kdvoranver (@kdvoran float)
RETURNS float
AS
BEGIN
declare @sonuc float
 
 if @kdvoran=0 
 set @sonuc=1
 else
 set @sonuc=1+(@kdvoran/100)


 RETURN @sonuc
 
END

================================================================================
