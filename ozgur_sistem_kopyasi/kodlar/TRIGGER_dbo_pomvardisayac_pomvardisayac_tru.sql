-- Trigger: dbo.pomvardisayac_tru
-- Tablo: dbo.pomvardisayac
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.002683
================================================================================

CREATE TRIGGER [dbo].[pomvardisayac_tru] ON [dbo].[pomvardisayac]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN

 SET NOCOUNT ON
 SET XACT_ABORT ON

declare @perkod varchar(30)
declare @sayckod varchar(50)
declare @akstok varchar(50)
declare @stktip varchar(10)
declare @enktur varchar(10)
declare @tankkod varchar(50)
declare @satmik float
declare @varno float
declare @testmik float
declare @transfermik float
declare @perdigmik float
declare @sonendk float
declare @ilkendk float
declare @aksatmik float
declare @aksattut float
declare @brimfiy float
declare @varok int
declare @sil int
declare @sperkod varchar(30)


if UPDATE(varok)
  return
  

if UPDATE(TransferStopId)
   return  

 
  
 select @sil=sil from inserted  
   if UPDATE(sil) and (@sil=1)
     return  


 IF UPDATE(satmik) or UPDATE(transfermik) or UPDATE(transfertank)
  or UPDATE(testmik) or UPDATE(brimfiy) or UPDATE(sil)
 BEGIN

 DECLARE vardisayacinst CURSOR FORWARD_ONLY READ_ONLY LOCAL FOR 
 SELECT perkod,varno,sayackod,satmik,testmik,transfermik,digermik,
 ilkendk,tankod,stkod,stktip,brimfiy,varok,enktur
 FROM inserted
 OPEN vardisayacinst
 FETCH NEXT FROM vardisayacinst INTO  
 @perkod,@varno,@sayckod,@satmik,@testmik,@transfermik,@perdigmik,
 @ilkendk,@tankkod,@akstok,@stktip,@brimfiy,@varok,@enktur
 WHILE @@FETCH_STATUS = 0
 BEGIN

 update pomvardimas set
 aksatmik=dt.aksatmikf,aksattop=dt.aksattopf from pomvardimas t join
 (select varno,isnull(sum(satmik),0) as aksatmikf,
 isnull(round(sum(satmik*brimfiy),2),0) as aksattopf from 
 pomvardisayac with (nolock)  where varno=@varno and sil=0 
 group by varno) dt on dt.varno=t.varno 



update pomvardistok set
 satmik=dt.satmikf,testmik=dt.testmikf,
 brimfiy=dt.brimfiyf,
 transfer_cks_mik=dt.transfermikf,
 transfer_grs_mik=dt.transfermikf,
 kalan=t.acmik-dt.kalanf
from pomvardistok t join
(select varno,stkod,stktip,isnull(sum(satmik),0) as satmikf,
isnull(sum(testmik),0) as testmikf,
case when sum(satmik)>0 then sum(satmik*brimfiy)/sum(satmik)
else avg(brimfiy) end brimfiyf,
isnull(sum(transfermik),0) as transfermikf,
isnull(sum((satmik+testmik+transfermik)),0) as kalanf
from pomvardisayac with (nolock)  where varno=@varno and sil=0 
 group by varno,stkod,stktip)
dt on dt.varno=t.varno 
and dt.stkod=t.kod and dt.stktip=t.stktip and t.Sil=0


update pomvarditank set
satmik=dt.satmikf,
testmik=dt.testmikf,
brimfiy=dt.brimfiyf,
transfer_cks_mik=dt.transfermikf,
kalan=t.acmik-dt.kalanf
from pomvarditank t join
(select varno,tankod,isnull(sum(satmik),0) as satmikf,
isnull(sum(testmik),0) as testmikf,
case when sum(satmik)>0 then sum(satmik*brimfiy)/sum(satmik)
else avg(brimfiy) end brimfiyf,
isnull(sum(transfermik),0) as transfermikf,
isnull(sum((satmik+testmik+transfermik)),0) as kalanf
from pomvardisayac with (nolock)  where varno=@varno and sil=0  
group by varno,tankod)
dt on dt.varno=t.varno and dt.tankod=t.kod and t.Sil=0

/*- transfer grs miktari */
update pomvarditank set
transfer_grs_mik=dt.transfermikf,
kalan=(t.acmik+dt.transfermikf)-
(t.transfer_cks_mik+t.satmik)
from pomvarditank t join
(select varno,transfertank,
isnull(sum(transfermik),0) as transfermikf
from pomvardisayac with (nolock) where varno=@varno and sil=0  
and transfertank<>'' and transfermik>0
group by varno,transfertank)
dt on dt.varno=t.varno and dt.transfertank=t.kod and t.Sil=0



 DECLARE digertoplamcur CURSOR FOR 
 SELECT per FROM pomvardiper where varno=@varno 
 and sil=0
 OPEN digertoplamcur
 FETCH NEXT FROM digertoplamcur INTO  @sperkod
 WHILE @@FETCH_STATUS = 0
 BEGIN

 update pomvardisayac set digermik=
 isnull((select sum(satmik+testmik+transfermik) from pomvardisayac with (nolock)
 where  varno=@varno and sil=0 and sayackod=@sayckod and perkod<>@sperkod),0)
 where varno=@varno and sayackod=@sayckod and perkod=@sperkod
 and sil=0 

 FETCH NEXT FROM digertoplamcur INTO  @sperkod
 END
 CLOSE digertoplamcur
 DEALLOCATE digertoplamcur


if @enktur='Artan'
update pomvardisayac set sonendk=ilkendk+(satmik+testmik+transfermik+digermik) where sayackod=@sayckod
and varno=@varno and sil=0 
if @enktur='Azalan'
update pomvardisayac set sonendk=ilkendk-(satmik+testmik+transfermik+digermik) where sayackod=@sayckod
and varno=@varno and sil=0 


 FETCH NEXT FROM vardisayacinst INTO  @perkod,@varno,@sayckod,@satmik,@testmik,@transfermik,@perdigmik,
 @ilkendk,@tankkod,@akstok,@stktip,@brimfiy,@varok,@enktur
END
CLOSE vardisayacinst
DEALLOCATE vardisayacinst

end

SET NOCOUNT OFF


END

================================================================================
