-- Trigger: dbo.irsaliyehrk_triu
-- Tablo: dbo.irsaliyehrk
-- Disabled: True
-- Tarih: 2026-01-14 20:06:08.954198
================================================================================

CREATE TRIGGER [dbo].[irsaliyehrk_triu] ON [dbo].[irsaliyehrk]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN
declare @irid float;
declare @id float;
declare @kdvtop float,@irtop float;
declare @kayok int,@sil int

select @id=id,@irid=irid,@kayok=kayok,@sil=sil from inserted;

select @irtop=sum((brmfiy*mik)),@kdvtop=sum(kdvtut*mik) from irsaliyehrk
where irid=@irid

update irsaliyemas set irtop=@irtop,kdvtop=@kdvtop where irid=@irid

 if (update(kayok) or (@sil=1)) and @kayok=1
 begin

 DECLARE irsaliyehrkgun CURSOR LOCAL FOR SELECT id,kayok,sil FROM inserted
 OPEN irsaliyehrkgun
 FETCH NEXT FROM irsaliyehrkgun INTO  @id,@kayok,@sil
 WHILE @@FETCH_STATUS = 0
 BEGIN

  exec stokhrkisle @id,'irsaliyehrk','',@kayok,@sil,@irid

 FETCH NEXT FROM irsaliyehrkgun INTO @id,@kayok,@sil
 END
 CLOSE irsaliyehrkgun
 DEALLOCATE irsaliyehrkgun
 end



END

================================================================================
