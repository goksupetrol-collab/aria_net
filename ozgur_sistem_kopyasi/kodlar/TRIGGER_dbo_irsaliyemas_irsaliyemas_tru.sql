-- Trigger: dbo.irsaliyemas_tru
-- Tablo: dbo.irsaliyemas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.956425
================================================================================

CREATE TRIGGER [dbo].[irsaliyemas_tru] ON [dbo].[irsaliyemas]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN


declare @irid float;
declare @kayok int,@sil int;

select @kayok=kayok,@sil=sil,@irid=irid from inserted;


if update(kayok) or  update(sil)
 begin

 update irsaliyehrk set sil=@sil where irid=@irid and sil=0


   exec stokhrkisle @irid,'irsaliyehrk','',@kayok,@sil,@irid 

 if @kayok=1
  update irsaliyehrk set kayok=@kayok where irid=@irid /*and kayok=0; */
  
  

 
 
 
end


END

================================================================================
