-- Function: dbo.Depo_Kodin_Str
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.651203
================================================================================

CREATE FUNCTION [dbo].Depo_Kodin_Str 
(@KOD         VARCHAR(50))
returns @KodTable table
 (STRValue varchar(50) COLLATE Turkish_CI_AS)
AS
BEGIN

    if @KOD=''
      Insert @KodTable
       select kod from Depo_Kart_Listesi
  
    if @KOD<>''
      Insert @KodTable
       Values (@KOD)
  
    RETURN

END

================================================================================
