-- Trigger: dbo.Stkdeptrsmas_trd
-- Tablo: dbo.Stkdeptrsmas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.029257
================================================================================

CREATE TRIGGER [dbo].[Stkdeptrsmas_trd] ON [dbo].[Stkdeptrsmas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN


declare @trs_id    float

 select @trs_id=trs_id from deleted

 delete from  stkdeptrs where trs_id=@trs_id  



END

================================================================================
