-- Trigger: dbo.emtiasat_trd
-- Tablo: dbo.emtiasat
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.938579
================================================================================

CREATE TRIGGER [dbo].[emtiasat_trd] ON [dbo].[emtiasat]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @varno float
declare @malsat float
declare @id float

SET NOCOUNT ON
select @id=id,@varno=varno from deleted;

select @malsat=sum(tutar) from emtiasat where varno=@varno and sil=0;

if @malsat is NULL
set @malsat=0;

exec stokhrkisle @id,'emtiasat','',1,1,@id

update pomvardimas set malsattop=@malsat where varno=@varno
SET NOCOUNT OFF
END

================================================================================
