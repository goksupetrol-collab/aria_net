-- Function: dbo.Fn_Stok_Tip
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.659606
================================================================================

CREATE FUNCTION [dbo].[Fn_Stok_Tip] (
@id int
)
RETURNS varchar(50)
 AS
BEGIN
declare @SNC VARCHAR(50)

 SELECT @SNC=ack_Tr FROM Stk_Tip WHERE id=@id

 RETURN @SNC 
 
 
END

================================================================================
