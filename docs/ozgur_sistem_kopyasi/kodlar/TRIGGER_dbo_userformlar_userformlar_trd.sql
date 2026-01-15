-- Trigger: dbo.userformlar_trd
-- Tablo: dbo.userformlar
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.037757
================================================================================

CREATE TRIGGER [dbo].[userformlar_trd] ON [dbo].[userformlar]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN

declare @formkod varchar(30);


select @formkod=formkod from deleted;

delete from userformhak where formkod=@formkod;


END

================================================================================
