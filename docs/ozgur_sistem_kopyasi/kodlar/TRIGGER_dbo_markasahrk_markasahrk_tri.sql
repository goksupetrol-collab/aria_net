-- Trigger: dbo.markasahrk_tri
-- Tablo: dbo.markasahrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.971461
================================================================================

CREATE TRIGGER [dbo].[markasahrk_tri] ON [dbo].[markasahrk]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @varno 		float
declare @idx 		float
declare @kaskod 	varchar(20)
declare @yertip 	varchar(20)
declare @naktop 	float
declare @kashrkid 	float
declare @marsatid 	float

declare @mesaj      nvarchar(50)

select @yertip=yertip,@kashrkid=kashrkid,
@idx=id,@marsatid=marsatid,@varno=varno from inserted

if @kashrkid=0 
 RETURN

 update marsatmas set naktop=
   (select isnull(sum((giren-cikan)*kur),0) from
   markasahrk where varno=@varno and marsatid=@marsatid and sil=0 )
 where marsatid=@marsatid and sil=0


  update marsatmas set cartip='vardikasa',carkod=kaskod,
   islmhrk=dt.islmhrk,islmhrkad=dt.islmhrkad
   from marsatmas as t join
   (select top 1 marsatid,kaskod,islmhrk,islmhrkad from
     markasahrk where varno=@varno and marsatid=@marsatid and sil=0
     order by id )
     dt on dt.marsatid=t.marsatid and t.sil=0

 update marvardimas set naksattop=
    (select isnull(sum(naktop),0) from marsatmas where
    varno=@varno and sil=0 ) where varno=@varno and sil=0


END

================================================================================
