-- Trigger: dbo.faturahrk_trd
-- Tablo: dbo.faturahrk
-- Disabled: True
-- Tarih: 2026-01-14 20:06:08.941653
================================================================================

CREATE TRIGGER [dbo].[faturahrk_trd] ON [dbo].[faturahrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @id float,@fatid float;
declare @kdvtop float,@otvtop float,@iskyuz float,
@isktop float,@fattop float;
declare @kayok int,@sil int;
declare @stktip varchar(10)
declare @MESAJ varchar(50)

 select @id=id,@kayok=kayok,@fatid=fatid from deleted;


 DECLARE faturahrkdel CURSOR LOCAL FOR SELECT id,kayok,sil,stktip FROM deleted
 OPEN faturahrkdel
 FETCH NEXT FROM faturahrkdel INTO  @id,@kayok,@sil,@stktip
 WHILE @@FETCH_STATUS = 0
 BEGIN

 if @stktip='gelgid'
 delete from carihrk where fatstkhrkid=@id
 else
 delete from stkhrk where tabload='faturahrk' and stkhrkid=@id
 
 FETCH NEXT FROM faturahrkdel INTO @id,@kayok,@sil,@stktip
 END
 CLOSE faturahrkdel
 DEALLOCATE faturahrkdel


  exec faturahrkgiris @fatid,@kayok,1

/* if isnull((select count(*) from faturahrk where fatid=@fatid and sil=0),0)=0 */
/* delete from faturamas where fatid=@fatid */

END

================================================================================
