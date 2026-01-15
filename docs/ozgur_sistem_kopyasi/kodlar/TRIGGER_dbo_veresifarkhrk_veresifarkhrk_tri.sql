-- Trigger: dbo.veresifarkhrk_tri
-- Tablo: dbo.veresifarkhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.039248
================================================================================

CREATE TRIGGER [dbo].[veresifarkhrk_tri] ON [dbo].[veresifarkhrk]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN

  update veresihrk set
  brmfiy=brmfiy+farktutar,
  fiyfarktop=case when tip='YFK' then
  fiyfarktop+farktutar else fiyfarktop end,
  vadfarktop=case when tip='VDF' then
  vadfarktop+farktutar else vadfarktop end
  from veresihrk t join
  (select verhrkid,tip,(yeni_fiyat-eski_fiyat) as farktutar
  from inserted )
  dt on dt.verhrkid=t.id

  update veresimas set vadtar=dt.yeni_vadetar from veresimas t
  join (select verid,yeni_vadetar from inserted ) dt
  on dt.verid=t.verid
  
  
  /*--- gelir gider yansıması */
   declare @tip        varchar(5)
   declare @masid      int
   select @tip=tip,@masid=masterid from inserted
   exec Fiyat_Fark_Yansıma @tip,@masid,0

  
  



END

================================================================================
