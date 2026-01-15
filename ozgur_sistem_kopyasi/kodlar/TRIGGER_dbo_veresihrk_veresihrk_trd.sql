-- Trigger: dbo.veresihrk_trd
-- Tablo: dbo.veresihrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.040972
================================================================================

CREATE TRIGGER [dbo].[veresihrk_trd] ON [dbo].[veresihrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @id float,@varno float,@verid float
declare @vertop float
declare @varok int,@sil int,@ototag int,@kayok int
SET NOCOUNT ON

DECLARE veresihrkup CURSOR LOCAL FOR SELECT deleted.id,deleted.verid,veresimas.varno,
veresimas.varok,deleted.sil,veresimas.ototag,deleted.kayok from deleted
inner join  veresimas on veresimas.verid=deleted.verid
 OPEN veresihrkup
  FETCH NEXT FROM veresihrkup INTO  @id,@verid,@varno,@varok,@sil,@ototag,@kayok
  WHILE @@FETCH_STATUS = 0
  BEGIN


update veresimas set toptut=round(dt.fistop,2),isktop=dt.isktop,
fiyfarktop=dt.fiyfarktop,vadfarktop=dt.vadfarktop from veresimas as t
join (select isnull(sum(mik*brmfiy),0) as fistop,
 isnull(sum(mik*brmfiy*iskyuz),0) as isktop,
 isnull(sum(mik*fiyfarktop),0) as fiyfarktop,
 isnull(sum(mik*vadfarktop),0) as vadfarktop
 from veresihrk where verid=@verid and sil=0) dt
 on t.verid=@verid



if (@ototag=1) and (@varok=0)
update pomvardimas set otomastop=
(select isnull(sum(mik*(brmfiy-(fiyfarktop+vadfarktop))),0) from veresihrk where varno=@varno and sil=0)
where varno=@varno;

if (@varok=0) and (@ototag=0)
update pomvardimas set otomastop=
(select isnull(sum(mik*(brmfiy-(fiyfarktop+vadfarktop))),0) from veresihrk where varno=@varno and sil=0 )
where varno=@varno


FETCH NEXT FROM veresihrkup INTO  @id,@verid,@varno,@varok,@sil,@ototag,@kayok
END
CLOSE veresihrkup
DEALLOCATE veresihrkup




SET NOCOUNT OFF
END

================================================================================
