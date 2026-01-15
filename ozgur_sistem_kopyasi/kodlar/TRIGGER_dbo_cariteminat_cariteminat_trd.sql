-- Trigger: dbo.cariteminat_trd
-- Tablo: dbo.cariteminat
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.930578
================================================================================

CREATE TRIGGER [dbo].[cariteminat_trd] ON [dbo].[cariteminat]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @kod varchar(20);

select @kod=kod from deleted;

update carikart set toplamteminat=
  (select isnull(sum(tutar),0) from cariteminat
   where kod=@kod) where kod=@kod
END

================================================================================
