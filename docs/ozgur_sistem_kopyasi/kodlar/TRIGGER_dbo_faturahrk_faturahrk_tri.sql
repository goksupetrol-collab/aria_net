-- Trigger: dbo.faturahrk_tri
-- Tablo: dbo.faturahrk
-- Disabled: True
-- Tarih: 2026-01-14 20:06:08.942279
================================================================================

CREATE TRIGGER [dbo].[faturahrk_tri] ON [dbo].[faturahrk]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN
declare @fatid float,@id float;
declare @kdvtop float,@otvtop float,@iskyuz float,
@isktop float,@fattop float,@kayok int,@sil int
declare @hrk_stk_pro bit

 select @id=id,@fatid=fatid,@kayok=kayok,@sil=sil from inserted;


  if update(mik)
   exec faturahrkgiris @fatid,@kayok,@sil

 if (update(kayok) or (@sil=1)) and @kayok=1
 begin
 
 DECLARE faturahrkgun CURSOR LOCAL FOR SELECT id,kayok,sil,hrk_stk_pro FROM inserted
 OPEN faturahrkgun
 FETCH NEXT FROM faturahrkgun INTO  @id,@kayok,@sil,@hrk_stk_pro
 WHILE @@FETCH_STATUS = 0
 BEGIN

   if @hrk_stk_pro=0
   exec stokhrkisle @id,'faturahrk','',@kayok,1
   if @hrk_stk_pro=1
   exec stokhrkisle @id,'faturahrk','',@kayok,@sil

 FETCH NEXT FROM faturahrkgun INTO @id,@kayok,@sil,@hrk_stk_pro
 END
 CLOSE faturahrkgun
 DEALLOCATE faturahrkgun
 end
END

================================================================================
