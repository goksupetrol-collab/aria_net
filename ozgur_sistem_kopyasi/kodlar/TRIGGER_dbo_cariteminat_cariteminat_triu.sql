-- Trigger: dbo.cariteminat_triu
-- Tablo: dbo.cariteminat
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.930942
================================================================================

CREATE TRIGGER [dbo].[cariteminat_triu] ON [dbo].[cariteminat]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN

declare @kod varchar(20);

select @kod=kod from inserted;

update carikart set toplamteminat=
  (select isnull(sum(tutar),0) from cariteminat
   where kod=@kod) where kod=@kod

END

================================================================================
