-- Function: dbo.Fn_Prom_Urun_Sat_Tip
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.658862
================================================================================

CREATE FUNCTION [dbo].Fn_Prom_Urun_Sat_Tip (
@id int
)
RETURNS varchar(50)
 AS
BEGIN
declare @SNC VARCHAR(50)

 SELECT @SNC=AD_TR FROM Prom_Urun_Sat_Tip WHERE id=@id

 RETURN @SNC 
 
 
END

================================================================================
