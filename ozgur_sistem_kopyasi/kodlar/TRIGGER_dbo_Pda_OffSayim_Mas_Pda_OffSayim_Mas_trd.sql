-- Trigger: dbo.Pda_OffSayim_Mas_trd
-- Tablo: dbo.Pda_OffSayim_Mas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.988634
================================================================================

CREATE TRIGGER [dbo].[Pda_OffSayim_Mas_trd] ON [dbo].[Pda_OffSayim_Mas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN

declare @id int

 select @id=id from deleted

 delete from Pda_OffSayim_Hrk where offsayid=@id
 



END

================================================================================
