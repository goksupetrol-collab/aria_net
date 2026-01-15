-- Trigger: dbo.sayachrk_tri
-- Tablo: dbo.sayachrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.012951
================================================================================

CREATE TRIGGER [dbo].[sayachrk_tri] ON [dbo].[sayachrk]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN
declare @sayackod varchar(20)

 declare sayac_hrk CURSOR FAST_FORWARD  
  FOR select sayackod from inserted 
   open sayac_hrk
  fetch next from  sayac_hrk into @sayackod
  while @@FETCH_STATUS=0
   begin
  
    exec sayacsonendks @sayackod
 
  FETCH next from  sayac_hrk into @sayackod
 end
 close sayac_hrk
 deallocate sayac_hrk


END

================================================================================
