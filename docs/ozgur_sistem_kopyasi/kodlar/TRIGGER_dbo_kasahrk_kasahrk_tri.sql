-- Trigger: dbo.kasahrk_tri
-- Tablo: dbo.kasahrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.967087
================================================================================

CREATE TRIGGER [dbo].[kasahrk_tri] ON [dbo].[kasahrk]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN


SET NOCOUNT ON
SET XACT_ABORT ON

declare @varno float,@idx float
declare @kaskod varchar(20)
declare @yertip varchar(20)
declare @naktop float,@pro int
declare @kashrkid float,@masterid float
declare @giren float,@cikan float,@kur float
declare @islmtip varchar(10),@islmhrk varchar(10)
declare @fisfatid float
declare @fisfattip varchar(10)
declare @sil int
declare @varok int
declare @belno varchar(20)
declare @kashrkIdcount int
declare @firmano  int




select @yertip=yertip,@kashrkid=kashrkid,@idx=id,@firmano=firmano,
@kaskod=kaskod,@varno=varno,
@varok=varok,@pro=pro,
@islmtip=islmtip,@islmhrk=islmhrk,@masterid=masterid,@fisfatid=fisfatid,
@fisfattip=fisfattip,@giren=giren,@cikan=cikan,@kur=kur,@sil=sil,
@belno=belno from inserted


  if @islmtip not in ('VIR','DVA','DVS') 
   update kasahrk set kashrkid=id where id=@idx


  select @kashrkIdcount=count(*) from kasahrk with (nolock)
  where isnull(kashrkid,0)=0 and firmano=@firmano 


 if @kashrkIdcount>1
 begin
   RAISERROR ('KasahrkId Hatası', 16,1) 
   ROLLBACK TRANSACTION
   RETURN
 end


  if isnull(@kashrkid,0)=0
    return

 exec kasahrkgiris @kashrkid,@sil

 exec numara_no_yaz 'makbuz',@belno


if (@yertip='pomvardimas')
begin
 update pomvardimas set naktestop=
   (select isnull(sum(kur*giren),0) from kasahrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='TAH'
   and islmhrk='TES' and yertip=@yertip and masterid=0),
   tahtop=
   (select isnull(sum(giren*kur),0) from kasahrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='TAH'
   and islmhrk='NAK' and cartip<>'gelgidkart' and yertip=@yertip)
   +ISNULL((select isnull(sum(giren*kur),0) from kasahrk
   where varno=@varno and sil=0 and islmtip='BNK'
   and islmhrk='CKN' and cartip<>'gelgidkart' and yertip=@yertip),0),
   gelirtop=
   ISNULL((select isnull(sum(giren*kur),0) from kasahrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='TAH'
   and islmhrk='NAK' and cartip='gelgidkart' and yertip=@yertip),0)+
   (select isnull(sum(giren*kur),0) from poshrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='TAH'
   and islmhrk='POS' and cartip='gelgidkart' and yertip=@yertip),
   odetop=
   (select isnull(sum(cikan*kur),0) from kasahrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='ODE'
   and islmhrk='NAK' and cartip<>'gelgidkart' and yertip=@yertip)
   +ISNULL((select isnull(sum(cikan*kur),0) from kasahrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='BNK'
   and islmhrk='YTN' and cartip<>'gelgidkart' and yertip=@yertip),0),
   gidertop=
   isnull((select isnull(sum(cikan*kur),0) from kasahrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='ODE'
   and islmhrk='NAK' and cartip='gelgidkart' and yertip=@yertip),0)
   
   
  where varno=@varno
  

end

if (@yertip='marvardimas')
begin

update marvardimas set naktestop=
   (select isnull(sum(giren*kur),0) from kasahrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='TAH'
   and islmhrk='TES' and yertip=@yertip and masterid=0),
   tahtop=
   (select isnull(sum(giren*kur),0) from kasahrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='TAH'
   and islmhrk='NAK' and cartip<>'gelgidkart' and yertip=@yertip)
   +ISNULL((select isnull(sum(giren*kur),0) from kasahrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='BNK'
   and islmhrk='CKN' and cartip<>'gelgidkart' and yertip=@yertip),0),
   gelirtop=
   (select isnull(sum(giren*kur),0) from kasahrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='TAH'
   and islmhrk='NAK' and cartip='gelgidkart' and yertip=@yertip),
   odetop=
   (select isnull(sum(cikan*kur),0) from kasahrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='ODE'
   and islmhrk='NAK' and cartip<>'gelgidkart' and yertip=@yertip)
   +ISNULL((select isnull(sum(cikan*kur),0) from kasahrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='BNK'
   and islmhrk='YTN' and cartip<>'gelgidkart' and yertip=@yertip),0)
   
   
   
   /*
   gidertop=
   (select isnull(sum(cikan*kur),0) from kasahrk
   where varno=@varno and sil=0 and
   islmtip='ODE' and islmhrk='NAK'
   and cartip='gelgidkart' and yertip=@yertip)
   */
  where varno=@varno

end


if (@yertip='resvardimas')
begin

update resvardimas set naktestop=
   (select isnull(sum(giren*kur),0) from kasahrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='TAH'
   and islmhrk='TES' and yertip=@yertip and masterid=0),
   tahtop=
   (select isnull(sum(giren*kur),0) from kasahrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='TAH'
   and islmhrk='NAK' and cartip<>'gelgidkart' and yertip=@yertip)
   +ISNULL((select isnull(sum(giren*kur),0) from kasahrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='BNK'
   and islmhrk='CKN' and cartip<>'gelgidkart' and yertip=@yertip),0),
   gelirtop=
   (select isnull(sum(giren*kur),0) from kasahrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='TAH'
   and islmhrk='NAK' and cartip='gelgidkart' and yertip=@yertip),
   odetop=
   (select isnull(sum(cikan*kur),0) from kasahrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='ODE'
   and islmhrk='NAK' and cartip<>'gelgidkart' and yertip=@yertip)
   +ISNULL((select isnull(sum(cikan*kur),0) from kasahrk with (nolock) 
   where varno=@varno and sil=0 and islmtip='BNK'
   and islmhrk='YTN' and cartip<>'gelgidkart' and yertip=@yertip),0)
   
   
  where varno=@varno

end


if (@fisfattip='FAT')
begin
update faturamas set odemetop=
   (select isnull(sum(giren+cikan),0) from kasahrk with (nolock) 
   where sil=0 and fisfattip=@fisfattip and fisfatid=@fisfatid)
   where fatid=@fisfatid


SET NOCOUNT OFF


end

END

================================================================================
