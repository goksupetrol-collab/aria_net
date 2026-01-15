-- Trigger: dbo.Per_Cari_triu
-- Tablo: dbo.Per_Cari
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.989391
================================================================================

CREATE TRIGGER [dbo].[Per_Cari_triu] ON [dbo].[Per_Cari]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN

  update carikart set Per_id=dt.per_id 
  from carikart as t join 
  (select car_id,per_id from inserted) dt on
  dt.car_id=t.id


END

================================================================================
