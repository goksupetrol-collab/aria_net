-- Trigger: dbo.poshrk_trd
-- Tablo: dbo.poshrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.004107
================================================================================

CREATE TRIGGER [dbo].[poshrk_trd] ON [dbo].[poshrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @id 		float
declare @masterid 	float
declare @pro 		int
declare @poshrkid 	float
declare @poskod 	varchar(30)
declare @sil 		int
declare @yertip 	varchar(30)
declare @varok 		int
declare @tahodeid	int
SET NOCOUNT ON


 DECLARE poshrksil CURSOR FAST_FORWARD FOR SELECT 
 id,poshrkid,poskod,masterid,sil,tahodeid
 FROM deleted
 OPEN poshrksil
 FETCH NEXT FROM poshrksil INTO  @id,@poshrkid,@poskod,@masterid,@sil,@tahodeid
 WHILE @@FETCH_STATUS = 0
 BEGIN

 delete from carihrk where masterid=@poshrkid and karsihestip='poskart'
 
 delete from TahsilatOdeme where id=@tahodeid


 FETCH NEXT FROM poshrksil INTO  @id,@poshrkid,@poskod,@masterid,@sil,@tahodeid
 END
 CLOSE poshrksil
 DEALLOCATE poshrksil


SET NOCOUNT OFF
END

================================================================================
