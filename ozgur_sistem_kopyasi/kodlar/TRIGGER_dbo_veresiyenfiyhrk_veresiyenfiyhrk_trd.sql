-- Trigger: dbo.veresiyenfiyhrk_trd
-- Tablo: dbo.veresiyenfiyhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.045997
================================================================================

CREATE TRIGGER [dbo].[veresiyenfiyhrk_trd] ON [dbo].[veresiyenfiyhrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN

  update veresihrk set
  brmfiy=brmfiy-farktutar,
  fiyfarktop=fiyfarktop-farktutar
  from veresihrk t join
  (select verhrkid,(yeni_fiyat-eski_fiyat) as farktutar
  from deleted ) dt on dt.verhrkid=t.id

  update veresimas set vadtar=dt.eski_vadetar from veresimas t
  join (select verid,eski_vadetar from deleted ) dt
  on dt.verid=t.verid


    /*--- gelir gider yansıması */
   declare @masid      int
   select @masid=masterid from deleted
   exec Yeni_Fiyat_Fark @masid,1
END

================================================================================
