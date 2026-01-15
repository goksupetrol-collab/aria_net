-- Trigger: dbo.cekkart_trd
-- Tablo: dbo.cekkart
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.934303
================================================================================

CREATE TRIGGER [dbo].[cekkart_trd] ON [dbo].[cekkart]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @cekid 		float
declare @id 		float
declare @tahodeid 	float

SET NOCOUNT ON

 DECLARE cekdel CURSOR LOCAL FOR SELECT id,cekid,tahodeid from deleted
 OPEN cekdel
  FETCH NEXT FROM cekdel INTO  @id,@cekid,@tahodeid
  WHILE @@FETCH_STATUS =0
  BEGIN
  delete from cekhrk where cekid=@cekid
  
  delete from bankahrk where masterid=@cekid and karsihestip='cekkart'
  delete from carihrk where  masterid=@cekid  and karsihestip='cekkart'

  delete from kasahrk where  masterid=@cekid  and karsihestip='cekkart'

  delete from TahsilatOdeme where id=@tahodeid


  FETCH NEXT FROM cekdel INTO  @id,@cekid,@tahodeid
  END
 CLOSE cekdel
 DEALLOCATE cekdel
  
 SET NOCOUNT OFF
  

END

================================================================================
