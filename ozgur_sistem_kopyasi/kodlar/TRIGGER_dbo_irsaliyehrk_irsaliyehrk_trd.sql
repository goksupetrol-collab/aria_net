-- Trigger: dbo.irsaliyehrk_trd
-- Tablo: dbo.irsaliyehrk
-- Disabled: True
-- Tarih: 2026-01-14 20:06:08.953722
================================================================================

CREATE TRIGGER [dbo].[irsaliyehrk_trd] ON [dbo].[irsaliyehrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @irid float;
declare @kdvtop float,@irtop float;

select @irid=irid from deleted;


select @irtop=isnull(sum((brmfiy*mik)),0),
@kdvtop=isnull(sum(kdvtut),0) from irsaliyehrk where irid=@irid;

update irsaliyemas set irtop=@irtop,kdvtop=@kdvtop where irid=@irid;
END

================================================================================
