-- Trigger: dbo.stkhrk_tru
-- Tablo: dbo.stkhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.031947
================================================================================

CREATE TRIGGER [dbo].[stkhrk_tru] ON [dbo].[stkhrk]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN

declare @idx float

/*select @idx=id,@pro=pro from inserted */

DECLARE stok_cur_upins 
CURSOR LOCAL FOR SELECT ins.id from inserted as ins
 OPEN stok_cur_upins
 FETCH NEXT FROM stok_cur_upins INTO  @idx
 WHILE @@FETCH_STATUS = 0
 BEGIN

   EXEC stokisle @idx
  
 
 FETCH NEXT FROM stok_cur_upins INTO  @idx
END
CLOSE stok_cur_upins
DEALLOCATE stok_cur_upins

END

================================================================================
