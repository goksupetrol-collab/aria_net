-- Function: dbo.FirmaList_Ver
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.657298
================================================================================

CREATE FUNCTION dbo.FirmaList_Ver 
(@No int)
RETURNS
    @TB_FIRMA_NO TABLE (
     No         FLOAT)
AS
BEGIN


    if @No=0
     insert into @TB_FIRMA_NO (NO)
     select 0 union all SELECT id from firma
   
     if @No>0
     insert into @TB_FIRMA_NO (NO)
     select 0 union all SELECT id from firma where id in (@No)

    return
END

================================================================================
