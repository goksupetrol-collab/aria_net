-- Trigger: dbo.istkhrk_trd
-- Tablo: dbo.istkhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.962185
================================================================================

CREATE TRIGGER [dbo].[istkhrk_trd] ON [dbo].[istkhrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN

declare @postut float,@varno float,@tut float
declare @varok int
declare @istkkod varchar(30)
declare @istkhrkid float
declare @belno varchar(20)
declare @sil     int
declare @tahodeid	int
declare @cartip		varchar(30)
declare @id 		int
declare @masid 		int


SET NOCOUNT ON


 DECLARE istkhrksil CURSOR FAST_FORWARD FOR SELECT 
 id,istkhrkid,istkkod,masterid,sil,tahodeid,cartip
 FROM deleted
 OPEN istkhrksil
 FETCH NEXT FROM istkhrksil INTO  @id,@istkhrkid,
 @istkkod,@masid,@sil,@tahodeid,@cartip
 WHILE @@FETCH_STATUS = 0
 BEGIN


  if (@cartip='carikart') or (@cartip='perkart') or (@cartip='gelgidkart')
  delete from carihrk where masterid=@istkhrkid and karsihestip='istkart'

  if @cartip='kasakart'
   delete from kasahrk where kashrkid=@masid



 FETCH NEXT FROM istkhrksil INTO  
 @id,@istkhrkid,@istkkod,@masid,@sil,@tahodeid,@cartip
 END
 CLOSE istkhrksil
 DEALLOCATE istkhrksil


SET NOCOUNT OFF 
  

  
  
  
  
  


END

================================================================================
