-- Trigger: dbo.marsathrk_tri
-- Tablo: dbo.marsathrk
-- Disabled: True
-- Tarih: 2026-01-14 20:06:08.973841
================================================================================

CREATE TRIGGER [dbo].[marsathrk_tri] ON [dbo].[marsathrk]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @id 		float
declare @varno 		float
declare @sattop 	float
declare @iadetop 	float
declare @marsatid 	float
declare @kayok 		int
declare @sil 		int
declare @yertip 	varchar(20)

SET NOCOUNT ON


DECLARE marsathrkduz CURSOR FAST_FORWARD FOR 
 SELECT inserted.id,yertip,inserted.sil,inserted.kayok,
inserted.varno,inserted.marsatid FROM inserted

 OPEN marsathrkduz
  FETCH NEXT FROM marsathrkduz INTO  @id,@yertip,@sil,@kayok,@varno,@marsatid
  WHILE @@FETCH_STATUS = 0
  BEGIN

  exec stokhrkisle @id,'marsathrk','',@kayok,@sil

  if @sil=1
   exec marketsatodesil @marsatid

   select @sattop=sum(case when islmtip='satis' then (mik*(brmfiy*kur)) else 0 end) ,
   @iadetop=sum(case when islmtip='iade' then (mik*(brmfiy*kur)) else 0 end)
   from marsathrk WITH(NOLOCK) where varno=@varno and marsatid=@marsatid and sil=0

   if @sattop is NULL
    set @sattop=0

   if @iadetop is NULL
   set @iadetop=0


  update marsatmas set 
  satistop=@sattop,iadetop=@iadetop where 
  varno=@varno and marsatid=@marsatid


  FETCH NEXT FROM marsathrkduz INTO  @id,@yertip,@sil,@kayok,@varno,@marsatid
  END
  CLOSE marsathrkduz
  DEALLOCATE marsathrkduz


SET NOCOUNT OFF
END

================================================================================
