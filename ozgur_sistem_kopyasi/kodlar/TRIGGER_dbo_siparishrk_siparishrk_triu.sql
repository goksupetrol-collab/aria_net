-- Trigger: dbo.siparishrk_triu
-- Tablo: dbo.siparishrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.023667
================================================================================

CREATE TRIGGER [dbo].[siparishrk_triu] ON [dbo].[siparishrk]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN
declare @sipid float;
declare @kdvtop float,@siptop float;
declare @kalmik float

select @sipid=sipid from inserted;

select @kalmik=isnull(sum(mik-tesmik),0),@siptop=isnull(sum((brmfiy*mik)),0),
@kdvtop=isnull(sum(kdvtut),0) from siparishrk
where sipid=@sipid and sil=0;

update siparismas set kaltop=@kalmik,siptop=@siptop,kdvtop=@kdvtop where sipid=@sipid;


END

================================================================================
