-- Trigger: dbo.sayimstkgrp_trd
-- Tablo: dbo.sayimstkgrp
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.021133
================================================================================

CREATE TRIGGER [dbo].[sayimstkgrp_trd] ON [dbo].[sayimstkgrp]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @sayid float
declare @id    float
declare @drm   varchar(2)
declare @oncesayid float

 DECLARE sayim_grp_sil
 CURSOR FAST_FORWARD  FOR SELECT id,sayid
 from deleted
 OPEN sayim_grp_sil
  FETCH NEXT FROM sayim_grp_sil INTO  @id,@sayid
  WHILE @@FETCH_STATUS =0
  BEGIN
  

  delete from sayimhrk where sayid=@sayid
  and stkod in (select kod from stokkart as k
  inner join deleted as d on d.id=@id and
  k.grp1=d.stkgrp1 and k.grp2=d.stkgrp2
  and k.grp3=d.stkgrp3 )
  
  
  FETCH NEXT FROM sayim_grp_sil INTO  @id,@sayid
  END
  CLOSE sayim_grp_sil
  DEALLOCATE sayim_grp_sil


  
END

================================================================================
