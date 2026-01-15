-- Trigger: dbo.carihrk_trd
-- Tablo: dbo.carihrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.926436
================================================================================

CREATE TRIGGER [dbo].[carihrk_trd] ON [dbo].[carihrk]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @cartur 	varchar(30)
declare @carkod 	varchar(30)
declare @islmtip 	varchar(30)
declare @yertip 	varchar(30)
declare @cartip 	varchar(30)
declare @islmhrk 	varchar(20)
declare @pro 		int
declare @id 		float
declare @masterid 	float
declare @carbak 	float
declare @permasmasid float
declare @fisfatid 	float
declare @varno 		float
declare @marsatid 	float
declare @carhrkid 	float


declare @borc 	float
declare @alacak float
declare @fisbak float
declare @kur 	float


 DECLARE carihrksilcur CURSOR LOCAL FAST_FORWARD  FOR SELECT id,islmtip,islmhrk,
 masterid,carhrkid,yertip,borc,alacak,kur,cartip,
 carkod,permasmasid,fisfatid,varno,marsatid from deleted
 OPEN carihrksilcur
  FETCH NEXT FROM carihrksilcur INTO  @id,@islmtip,@islmhrk,@masterid,@carhrkid,
  @yertip,@borc,@alacak,
  @kur,@cartip,@carkod,@permasmasid,@fisfatid,@varno,@marsatid
  WHILE @@FETCH_STATUS = 0
  BEGIN


 if @yertip='faturamas' and @islmtip='FAT' and @islmhrk='GID'
  exec faturahrkgiris @fisfatid,1,1


if (@yertip='marvardimas') 
begin

  update marsatmas set indtop=dt.indtop
    from marsatmas t join
   (select marsatid,isnull((borc*kur),0) as indtop from carihrk where varno=@varno and sil=0
   and islmtip='GLG' and islmhrk='IND' and marsatid=@marsatid )
   dt on dt.marsatid=t.marsatid and t.sil=0


 /*gider */
 update marsatmas set cartip=dt.cartip,carkod=dt.carkod,
    islmhrk=dt.islmhrk,islmhrkad=dt.islmhrkad,gidertop=dt.gidertop
    from marsatmas t join
   (select  marsatid,cartip,carkod,islmhrk,islmhrkad,
   isnull((borc*kur),0) as gidertop from carihrk where varno=@varno and sil=0
   and islmtip='GLG' and islmhrk='MAR' and marsatid=@marsatid )
   dt on dt.marsatid=t.marsatid and t.sil=0
   
 update marvardimas set gidertop=
   (select isnull(sum(borc*kur),0) from carihrk where varno=@varno and sil=0
   and ( (islmtip='ODE') OR (islmhrk='IND') and (islmtip='GLG') OR (islmhrk='MAR') )
    and cartip='gelgidkart' and yertip=@yertip )
 where varno=@varno
end

 if @yertip='permaas'
   exec personelmaas @permasmasid,1
   
 if  @islmtip='VAD' and @islmhrk='CVF'
    exec Cari_Vade_Gelir_Hrk @carhrkid,1


 FETCH NEXT FROM carihrksilcur INTO  @id,@islmtip,@islmhrk,@masterid,@carhrkid,
 @yertip,@borc,@alacak,@kur,@cartip,@carkod,@permasmasid,@fisfatid,@varno,
 @marsatid
END
CLOSE carihrksilcur
DEALLOCATE carihrksilcur

END

================================================================================
