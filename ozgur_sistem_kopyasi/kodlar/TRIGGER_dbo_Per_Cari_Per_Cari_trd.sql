-- Trigger: dbo.Per_Cari_trd
-- Tablo: dbo.Per_Cari
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.989023
================================================================================

CREATE TRIGGER [dbo].[Per_Cari_trd] ON [dbo].[Per_Cari]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
  
  update carikart set Per_id=0
  from carikart as t join 
  (select car_id,per_id from inserted) dt on
  dt.car_id=t.id



END

================================================================================
