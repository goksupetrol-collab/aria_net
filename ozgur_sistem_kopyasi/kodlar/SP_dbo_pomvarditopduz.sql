-- Stored Procedure: dbo.pomvarditopduz
-- Tarih: 2026-01-14 20:06:08.356683
================================================================================

CREATE PROCEDURE [dbo].pomvarditopduz(@varno float)
AS
BEGIN

declare @yertip varchar(20)

set @yertip='pomvardimas'

 update pomvardimas set
    otomastop=(select isnull(sum(toptut),0) from veresimas
    where yertip=@yertip and ototag>0 and varno=@varno and sil=0 and kayok=1),
    veresitop=(select isnull(sum(toptut),0) from veresimas
    where yertip=@yertip and ototag=0 and varno=@varno and sil=0 and kayok=1)
  where varno=@varno

/*-tahsilat odeme nakit teslimat toplamı */
update pomvardimas set naktestop=
   (select isnull(sum(giren*kur),0) from kasahrk
   where varno=@varno and sil=0 and islmtip='TAH'
   and islmhrk='TES' and yertip=@yertip and masterid=0)
where varno=@varno

/*-tahsilat toplamı */
update pomvardimas set tahtop=
   (select isnull(sum(giren*kur),0) from kasahrk
   where varno=@varno and sil=0 and islmtip='TAH' and islmhrk='NAK' and cartip<>'gelgidkart' and yertip=@yertip)
where varno=@varno

/*-gelir toplamı */
update pomvardimas set gelirtop=
   (select isnull(sum(giren*kur),0) from kasahrk
   where varno=@varno and sil=0 and islmtip='TAH' and islmhrk='NAK' and cartip='gelgidkart' and yertip=@yertip)
where varno=@varno


/*-odeme toplamı */
update pomvardimas set odetop=
   (select isnull(sum(cikan*kur),0) from kasahrk
   where varno=@varno and sil=0 and islmtip='ODE' and islmhrk='NAK' and cartip<>'gelgidkart' and yertip=@yertip)
where varno=@varno

/*-gider toplamı */
update pomvardimas set gidertop=
   (select isnull(sum(cikan*kur),0) from kasahrk
   where varno=@varno and sil=0 and islmtip='ODE' and islmhrk='NAK' and cartip='gelgidkart' and yertip=@yertip)
where varno=@varno


/*-ak satis toplamı */
update pomvardimas set aksatmik=dt.aksatmikl,aksattop=dt.aksattopl from pomvardimas
t join (select isnull(sum(satmik),0) aksatmikl,
isnull(sum(satmik*brimfiy),0) as aksattopl from pomvardisayac 
 where varno=@varno and sil=0 ) dt on t.varno=@varno
 
/*veresiye toplam */
update pomvardimas set otomastop=(select isnull(sum(case when fistip='FISALCSAT' then
                                  -1*toptut else toptut end ),0)
                                  from veresimas where varno=@varno and ototag>=1 and sil=0)
                                  where varno=@varno

update pomvardimas set veresitop=(select isnull(sum(case when fistip='FISALCSAT' then
                                  -1*toptut else toptut end),0)
                                  from veresimas where varno=@varno and ototag=0 and sil=0)
                                  where varno=@varno


END

================================================================================
