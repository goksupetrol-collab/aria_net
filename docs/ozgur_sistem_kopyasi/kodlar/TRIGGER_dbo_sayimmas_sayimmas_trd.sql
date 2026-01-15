-- Trigger: dbo.sayimmas_trd
-- Tablo: dbo.sayimmas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.019279
================================================================================

CREATE TRIGGER [dbo].[sayimmas_trd] ON [dbo].[sayimmas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @sayid float;

/*if not update(drm) begin */

/*-deleted */
 DECLARE sayimasdel CURSOR FOR SELECT sayid
 from deleted
 OPEN sayimasdel
 FETCH NEXT FROM sayimasdel INTO  @sayid
 WHILE @@FETCH_STATUS = 0
 BEGIN

 exec sayimonayla @sayid,'B'
  
 delete from sayimhrk where sayid=@sayid
 delete from sayimstkgrp where sayid=@sayid


 
 delete from carihrk where islmtip='SAY' AND fisfatid=@sayid;


 FETCH NEXT FROM sayimasdel INTO  @sayid
 END
 CLOSE sayimasdel
 DEALLOCATE sayimasdel
END

================================================================================
