-- Trigger: dbo.emtiasat_tri
-- Tablo: dbo.emtiasat
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.939005
================================================================================

CREATE TRIGGER [dbo].[emtiasat_tri] ON [dbo].[emtiasat]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN
declare @varno float
declare @varok float
declare @malsat float
declare @id float
declare @emtid float
declare @sil int

  select @sil=sil,@id=id,@emtid=emtid,@varno=varno,@varok=varok from inserted

  if isnull(@emtid,0)=0
   return
  
   exec stokhrkisle @id,'emtiasat','',1,@sil,@id

  update pomvardimas set malsattop=(select isnull(sum(tutar),0) from emtiasat
   where varno=@varno and sil=0) where varno=@varno

END

================================================================================
