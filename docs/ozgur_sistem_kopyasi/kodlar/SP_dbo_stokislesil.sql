-- Stored Procedure: dbo.stokislesil
-- Tarih: 2026-01-14 20:06:08.383824
================================================================================

CREATE PROCEDURE [dbo].stokislesil @id float,@stkod varchar(30),@islmtip varchar(10),
@stktip varchar(20),@depkod varchar(30),
@giren float,@cikan float,@tarx datetime
AS
BEGIN
declare @say int


update stokkart set alsmik=dt.giren,satmik=dt.cikan from stokkart as t
JOIN (select isnull(sum(giren),0) as giren,isnull(sum(cikan),0) as cikan from stkhrk
where stkod=@stkod and stktip=@stktip and sil=0 ) dt
on t.kod=@stkod and tip=@stktip

if @stktip='akykt'
update tankkart set alsmik=dt.giren,satmik=dt.cikan from tankkart as t JOIN
(select isnull(sum(giren),0) as giren,isnull(sum(cikan),0) as cikan from stkhrk
where depkod=@depkod and stkod=@stkod and stktip=@stktip and sil=0 ) dt
on t.kod=@depkod




select @say=count(*) from stkdrm where depkod=@depkod and stkod=@stkod and stktip=@stktip
if @say>0
update stkdrm set girenmik=dt.giren,cikanmik=dt.cikan from stkdrm as t JOIN
(select isnull(sum(giren),0) as giren,isnull(sum(cikan),0) as cikan from stkhrk
where depkod=@depkod and stkod=@stkod and stktip=@stktip and sil=0 ) dt
on t.depkod=@depkod and t.stkod=@stkod and t.stktip=@stktip

if @say=0
insert into stkdrm  (girenmik,cikanmik,stktip,stkod,depkod)
values (@giren,@cikan,@stktip,@stkod,@depkod);




END

================================================================================
