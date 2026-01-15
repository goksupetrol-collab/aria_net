-- Trigger: dbo.sayachrk_trd
-- Tablo: dbo.sayachrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.012593
================================================================================

CREATE TRIGGER [dbo].[sayachrk_trd] ON [dbo].[sayachrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN

declare @sayackod varchar(20);
declare @id int;


DECLARE sayachrksilx CURSOR LOCAL FOR SELECT id,sayackod
from deleted
 OPEN sayachrksilx
  FETCH NEXT FROM sayachrksilx INTO  @id,@sayackod
  WHILE @@FETCH_STATUS <> -1
  BEGIN

exec sayacsonendks @sayackod


FETCH NEXT FROM sayachrksilx INTO  @id,@sayackod
END
CLOSE sayachrksilx
DEALLOCATE sayachrksilx


END

================================================================================
