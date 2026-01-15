-- Trigger: dbo.marsathrk_trd
-- Tablo: dbo.marsathrk
-- Disabled: True
-- Tarih: 2026-01-14 20:06:08.973221
================================================================================

CREATE TRIGGER [dbo].[marsathrk_trd] ON [dbo].[marsathrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @id float,@varno float,
@sattop float,@marsatid float
declare @kayok int,@say int
declare @yertip varchar(30)
SET NOCOUNT ON

DECLARE marsathrksil CURSOR FAST_FORWARD FOR SELECT id,yertip,kayok,
varno,marsatid FROM deleted

 OPEN marsathrksil
  FETCH NEXT FROM marsathrksil INTO  @id,@yertip,@kayok,@varno,@marsatid
  WHILE @@FETCH_STATUS = 0
  BEGIN

  exec stokhrkisle @id,'marsathrk','',@kayok,1,@marsatid


select @say=count(*),@sattop=sum(mik*(brmfiy*kur)) from marsathrk where varno=@varno
and marsatid=@marsatid and sil=0;

if @sattop is NULL
  set @sattop=0 
  if @say>0
  update marsatmas set satistop=@sattop where varno=@varno and marsatid=@marsatid;
  else
  begin
  update marsatmas set satistop=0,iadetop=0,indtop=0 where varno=@varno and marsatid=@marsatid;
  exec marketsatodesil @marsatid
  end

 FETCH NEXT FROM marsathrksil INTO  @id,@yertip,@kayok,@varno,@marsatid
  END
  CLOSE marsathrksil
  DEALLOCATE marsathrksil



SET NOCOUNT OFF
END

================================================================================
