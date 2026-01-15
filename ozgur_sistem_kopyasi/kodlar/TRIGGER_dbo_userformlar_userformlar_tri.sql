-- Trigger: dbo.userformlar_tri
-- Tablo: dbo.userformlar
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.038096
================================================================================

CREATE TRIGGER [dbo].[userformlar_tri] ON [dbo].[userformlar]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN

declare @formkod varchar(30);
declare @say int;

select @formkod=formkod from inserted;

select @say=count(*) from userformhak where formkod=@formkod
if @say=0
insert into userformhak (userkod,formkod)
select kod,@formkod from users










END

================================================================================
