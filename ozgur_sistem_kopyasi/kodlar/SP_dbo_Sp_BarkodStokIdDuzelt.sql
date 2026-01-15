-- Stored Procedure: dbo.Sp_BarkodStokIdDuzelt
-- Tarih: 2026-01-14 20:06:08.366219
================================================================================

CREATE PROCEDURE [dbo].[Sp_BarkodStokIdDuzelt] 
@firmano int,
@tip varchar(50),
@kod varchar(50)
AS
BEGIN

      update barkod set stk_id=(select id from stokkart where kod=@kod and firmano IN(@firmano,0) and tip=@tip)
      where kod=@kod and firmano IN(@firmano,0) and tip=@tip
            
END

================================================================================
