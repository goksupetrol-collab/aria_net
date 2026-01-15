-- Stored Procedure: dbo.stokkartacilis
-- Tarih: 2026-01-14 20:06:08.384109
================================================================================

CREATE PROCEDURE [dbo].stokkartacilis @tip varchar(20),@depkod varchar(20),@stkod varchar(20)
AS
BEGIN
declare @acmik       float
declare @firmano     float
declare @giren       float
declare @cikan       float
declare @alskdvtip   varchar(10)
declare @brmfiy      float
declare @kdvyuz      float
declare @idx         float
declare @olustar     datetime
declare @tarx        datetime;
declare @saatx       varchar(8)
declare @user        varchar(50)


declare @islmtip varchar(20)
declare @islmtipad varchar(20)

set @giren=0
set @cikan=0

  select @islmtip=kod,@islmtipad=ad from stkhrktip where kod='KARTAC'


 select @idx=id,@firmano=firmano,@acmik=acmik,@alskdvtip=alskdvtip,@kdvyuz=alskdv,@brmfiy=alsfiy,
 @olustar=olustarsaat,@user=olususer from stokkart where 
 tip=@tip and kod=@stkod

 set @kdvyuz=@kdvyuz/100
 if @alskdvtip='Hariç'
 set @brmfiy=@brmfiy*(1+@kdvyuz)

/*--------------market stokları-------- */
if (@acmik<>0 and @tip='markt')
begin
if @acmik>0
set @giren=@acmik

if @acmik<0
set @cikan=-1*@acmik


if @tip='markt'
select @depkod=mardepo from sistemtanim

set @tarx=convert(varchar,getdate(),101)
set @saatx=convert(varchar,getdate(),108)

 update stkhrk set sil=1 where stkhrkid=@idx and islmtip=@islmtip  
 and yertip='marketkart'

insert into stkhrk (firmano,stkhrkid,stkod,tarih,saat,belno,giren,cikan,brmfiykdvli,
kdvyuz,ack,olususer,olustarsaat,islmtip,islmtipad,depkod,stktip,tabload,yertip,yerad,dataok)
values
(@firmano,@idx,@stkod,@tarx,@saatx,'',@giren,@cikan,@brmfiy,@kdvyuz,'',@user,@olustar,@islmtip,@islmtipad,
@depkod,@tip,'marketkart','marketkart','MARKET STOK KARTI',0)
end
/*--------------------------------------------- */

/*-----------tankkartı------------- */
if @tip='akykt'
begin
select @firmano=firmano,@idx=id,@acmik=acmik,@olustar=olustarsaat,@user=olususer 
from tankkart where kod=@depkod

set @tarx=convert(varchar,@olustar,101)
set @saatx=convert(varchar,@olustar,108)

if @acmik<>0
begin

if @acmik>0
set @giren=@acmik

if @acmik<0
set @cikan=-1*@acmik

 update stkhrk set sil=1 where stkhrkid=@idx and islmtip=@islmtip and yertip='tankkart' 

insert into stkhrk (firmano,stkhrkid,stkod,tarih,saat,belno,giren,cikan,brmfiykdvli,
kdvyuz,ack,olususer,olustarsaat,islmtip,islmtipad,depkod,stktip,tabload,yertip,yerad,dataok)
values
(@firmano,@idx,@stkod,@tarx,@saatx,'',@giren,@cikan,@brmfiy,@kdvyuz,'',@user,@olustar,@islmtip,@islmtipad,
@depkod,@tip,'tankkart','tankkart','TANK KARTI',0);

end
end
/*----------------------------- */

END

================================================================================
