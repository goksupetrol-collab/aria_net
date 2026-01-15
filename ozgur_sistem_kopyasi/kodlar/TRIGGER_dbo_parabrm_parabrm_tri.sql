-- Trigger: dbo.parabrm_tri
-- Tablo: dbo.parabrm
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.987392
================================================================================

CREATE TRIGGER [dbo].[parabrm_tri] ON [dbo].[parabrm]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN
declare @ad varchar(20);
declare @pbrm varchar(10);

select @pbrm=kod,@ad=ad FROM INSERTED

 insert into vardikasa (kod,AD,parabrm)
 VALUES (@pbrm,'VARDIYA KASASI',@pbrm)


/*EXECUTE parabrimkasa @prbrm */

END

================================================================================
