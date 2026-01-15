-- Stored Procedure: dbo.sayacacilis
-- Tarih: 2026-01-14 20:06:08.363186
================================================================================

CREATE PROCEDURE [dbo].sayacacilis @sayackod varchar(20)
AS
BEGIN

declare @kod varchar(20);
declare @acendks float
declare @acmekendks float
declare @idx float;
declare @borc float,@alacak float,@sayachrkid float;
declare @olustar datetime,@tarx datetime;
declare @saatx varchar(8);
declare @user varchar(50);

declare @islmtip varchar(20);
declare @islmtipad varchar(20);

select @islmtip=kod,@islmtipad=ad from stkhrktip where kod='KARTAC'


select @idx=id,@kod=kod,@acendks=acendks,@acmekendks=acmekendks,
@olustar=olustarsaat,@user=olususer from sayackart
where kod=@sayackod


if  (@acendks>0) or (@acmekendks>0) begin
set @tarx=convert(varchar,@olustar,101);
set @saatx=convert(varchar,@olustar,108);


select @sayachrkid=isnull(max(sayachrkid),1) from sayachrk;

insert into sayachrk (sayachrkid,sayackod,tarih,saat,
ilkendks,sonendks,ilkmekendks,sonmekendks,
islmtip,islmtipad,
olususer,olustarsaat,yertip,yerad,dataok) values
(@sayachrkid,@kod,@tarx,@saatx,0,@acendks,0,@acmekendks,
@islmtip,@islmtipad,
@user,@olustar,'sayackart','SAYAÇ KARTI',0);
end;




END

================================================================================
