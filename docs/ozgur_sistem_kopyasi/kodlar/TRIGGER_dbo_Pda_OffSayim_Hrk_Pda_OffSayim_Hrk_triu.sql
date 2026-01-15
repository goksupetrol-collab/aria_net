-- Trigger: dbo.Pda_OffSayim_Hrk_triu
-- Tablo: dbo.Pda_OffSayim_Hrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.988145
================================================================================

CREATE TRIGGER [dbo].[Pda_OffSayim_Hrk_triu] ON [dbo].[Pda_OffSayim_Hrk]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN

declare @offsayid int

 select @offsayid=offsayid from inserted

  update Pda_OffSayim_Mas set
  stk_top_mik=isnull((select sum(miktar) from Pda_OffSayim_Hrk
  where offsayid=@offsayid and sil=0),0) where id=@offsayid


END

================================================================================
