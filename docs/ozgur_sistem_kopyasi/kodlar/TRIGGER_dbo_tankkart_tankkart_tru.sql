-- Trigger: dbo.tankkart_tru
-- Tablo: dbo.tankkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.037379
================================================================================

CREATE TRIGGER [dbo].[tankkart_tru] ON [dbo].[tankkart]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @kod         varchar(20)
declare @bagakup     bit
DECLARE @id          float
declare @mesaj       varchar(255)

DECLARE tank_kart_up CURSOR FAST_FORWARD
FOR SELECT ins.id,ins.kod,case when del.bagak<>ins.bagak then 1 else 0 end
from inserted as ins inner join deleted as del on del.id=ins.id
OPEN tank_kart_up
FETCH NEXT FROM tank_kart_up INTO @id,@kod,@bagakup
WHILE @@FETCH_STATUS = 0
BEGIN

   if @bagakup=1
    begin
     IF (SELECT COUNT(*) FROM stkhrk WHERE stktip='akykt' and depkod=@kod and sil=0) > 0
      BEGIN
       SELECT @mesaj = '"'+@kod+ '" Kodunun Hareketi Var! Değiştiremezsiniz..!'
       RAISERROR (@mesaj, 16,1)
       ROLLBACK TRANSACTION
      END
     end


FETCH NEXT FROM tank_kart_up INTO @id,@kod,@bagakup
END
CLOSE tank_kart_up
DEALLOCATE tank_kart_up


END

================================================================================
