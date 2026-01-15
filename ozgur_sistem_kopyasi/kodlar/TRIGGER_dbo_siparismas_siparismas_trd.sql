-- Trigger: dbo.siparismas_trd
-- Tablo: dbo.siparismas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.025638
================================================================================

CREATE TRIGGER [dbo].[siparismas_trd] ON [dbo].[siparismas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @sipid float;
select @sipid=sipid from deleted;
delete from siparishrk where sipid=@sipid;
END

================================================================================
