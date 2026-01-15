-- Trigger: dbo.veresiyenfiyhrk_tri
-- Tablo: dbo.veresiyenfiyhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.046543
================================================================================

CREATE TRIGGER [dbo].[veresiyenfiyhrk_tri] ON [dbo].[veresiyenfiyhrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN
 update veresihrk set
  brmfiy=brmfiy+farktutar,
  fiyfarktop=fiyfarktop+farktutar
  from veresihrk t join
  (select verhrkid,(yeni_fiyat-eski_fiyat) as farktutar
  from inserted )
  dt on dt.verhrkid=t.id

  update veresimas set vadtar=dt.yeni_vadetar from veresimas t
  join (select verid,yeni_vadetar from inserted ) dt
  on dt.verid=t.verid


  /*--- gelir gider yansıması */
   declare @masid      int
   select @masid=masterid from inserted
   exec Yeni_Fiyat_Fark @masid,0


END

================================================================================
