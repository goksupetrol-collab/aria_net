-- Trigger: dbo.siparishrk_trd
-- Tablo: dbo.siparishrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.023325
================================================================================

CREATE TRIGGER [dbo].[siparishrk_trd] ON [dbo].[siparishrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @sipid float;
declare @kdvtop float,@siptop float;

select @sipid=sipid from deleted;


select @siptop=isnull(sum((brmfiy*mik)),0),
@kdvtop=isnull(sum(kdvtut),0) from siparishrk where sipid=@sipid;

update siparismas set siptop=@siptop,kdvtop=@kdvtop where sipid=@sipid;
END

================================================================================
