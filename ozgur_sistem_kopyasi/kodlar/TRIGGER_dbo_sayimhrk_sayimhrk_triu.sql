-- Trigger: dbo.sayimhrk_triu
-- Tablo: dbo.sayimhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.016827
================================================================================

CREATE TRIGGER [dbo].[sayimhrk_triu] ON [dbo].[sayimhrk]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN
SET NOCOUNT ON


declare @sayid float;
declare @mevcutmik float,
@sayimmik float,
@sayimtutar float,
@mevcuttutar float;
declare @brmfiy float;

if update (drm)
begin
SET NOCOUNT OFF
RETURN
end

  select @sayid=sayid from inserted;


    update sayimmas set sayimmik=dt.sayimmik,sayimtut=dt.sayimtutar,
    mevcutmik=dt.mevcutmik,mevcuttut=dt.mevcuttutar from
   sayimmas as t join (
   select isnull(sum(sayimmik),0) as sayimmik,
         isnull(sum(sayimmik*brmfiy),0) as sayimtutar,
         isnull(sum(mevcutmik),0) as mevcutmik,
         isnull(sum(mevcutmik*brmfiy),0) as mevcuttutar
   from sayimhrk with (nolock) where sayid=@sayid and sil=0)
   dt on t.sayid=@sayid


SET NOCOUNT OFF

END

================================================================================
