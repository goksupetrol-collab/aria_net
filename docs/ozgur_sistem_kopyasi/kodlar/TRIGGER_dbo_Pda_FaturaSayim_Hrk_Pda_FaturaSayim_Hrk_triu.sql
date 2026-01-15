-- Trigger: dbo.Pda_FaturaSayim_Hrk_triu
-- Tablo: dbo.Pda_FaturaSayim_Hrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.987764
================================================================================

CREATE TRIGGER [dbo].[Pda_FaturaSayim_Hrk_triu] ON [dbo].[Pda_FaturaSayim_Hrk]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN

declare @fatsayid int

 select @fatsayid=fatsayid from inserted

  update Pda_faturasayim_mas set
  stk_top_mik=isnull((select sum(miktar) from pda_faturasayim_hrk
  where fatsayid=@fatsayid and sil=0),0) where id=@fatsayid


END

================================================================================
