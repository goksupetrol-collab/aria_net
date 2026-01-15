-- Trigger: dbo.carihrk_tri
-- Tablo: dbo.carihrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.926871
================================================================================

CREATE TRIGGER [dbo].[carihrk_tri] ON [dbo].[carihrk]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN

SET NOCOUNT ON
SET XACT_ABORT ON

declare @cartur           	varchar(30)
declare @carkod 			varchar(30)
declare @islmtip 			varchar(10)
declare @islmhrk 			varchar(10)
declare @yertip 			varchar(20)
declare @cartip 			varchar(30)
declare @belno 				varchar(20)
declare @pro 				int
declare @sil 				int
declare @varno 				float
declare @idx 				float
declare @carhrkid			float
declare @masterid           float
declare @carbak 			float
declare @permasmasid 		float
declare @fisfatid 			float
declare @marsatid 			float
declare @borc 				float
declare @alacak 			float
declare @fisbak 			float
declare @kur 				float



declare @del_cartip  varchar(30)
declare @del_carkod  varchar(30)


select @del_cartip=cartip,@del_carkod=carkod from deleted


select @varno=varno,@permasmasid=permasmasid,@marsatid=marsatid,
@islmtip=islmtip,@islmhrk=islmhrk,
@idx=id,@masterid=masterid,@carhrkid=carhrkid,
@fisfatid=fisfatid,@yertip=yertip,@borc=borc,@alacak=alacak,
@kur=kur,@cartip=cartip,@carkod=carkod,@pro=pro,@sil=sil,@belno=belno from inserted

 if isnull(@carhrkid,0)=0
  return


  exec numara_no_yaz 'makbuz',@belno





  if @yertip='faturamas' and @islmtip='FAT' and @islmhrk='GID'
    exec faturahrkgiris @fisfatid,1,0


if (@yertip='marvardimas') 
begin

  update marsatmas set indtop=dt.indtop
    from marsatmas t join
   (select marsatid,isnull((borc*kur),0) as indtop from carihrk with (nolock) where varno=@varno and sil=0
   and islmtip='GLG' and islmhrk='IND' and marsatid=@marsatid )
   dt on dt.marsatid=t.marsatid and t.sil=0


 /*gider */
 update marsatmas set cartip=dt.cartip,carkod=dt.carkod,
    islmhrk=dt.islmhrk,islmhrkad=dt.islmhrkad,gidertop=dt.gidertop
    from marsatmas t join
   (select  marsatid,cartip,carkod,islmhrk,islmhrkad,
   isnull((borc*kur),0) as gidertop from carihrk with (nolock) where varno=@varno and sil=0
   and islmtip='GLG' and islmhrk='MAR' and marsatid=@marsatid )
   dt on dt.marsatid=t.marsatid and t.sil=0
   
 update marvardimas set gidertop=
   (select isnull(sum(borc*kur),0) from carihrk with (nolock) where varno=@varno and sil=0
   and ( (islmtip='ODE') OR (islmhrk='IND') and (islmtip='GLG') OR (islmhrk='MAR') )
    and cartip='gelgidkart' and yertip=@yertip )
 where varno=@varno
end;

 if @yertip='permaas'
   exec personelmaas @permasmasid,@sil
   
 if  @islmtip='VAD' and @islmhrk='CVF'
    exec Cari_Vade_Gelir_Hrk @carhrkid,@sil


 SET NOCOUNT OFF

END

================================================================================
