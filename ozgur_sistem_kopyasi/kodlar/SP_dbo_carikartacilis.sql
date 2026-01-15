-- Stored Procedure: dbo.carikartacilis
-- Tarih: 2026-01-14 20:06:08.319444
================================================================================

CREATE PROCEDURE [dbo].carikartacilis @cartip varchar(20),@carkod varchar(20)
AS
BEGIN

declare @kod varchar(20);
declare @actutar float,@idx float;
declare @borc float,@alacak float,@carhrkid float;
declare @olustar datetime,@tarx datetime;
declare @saatx varchar(8),@gctip varchar(2);
declare @user varchar(50);


if @cartip='carikart'
select @idx=id,@kod=kod,@actutar=actutar,@olustar=olustarsaat,@user=olususer from carikart
where kod=@carkod

if @cartip='perkart'
select @idx=id,@kod=kod,@actutar=actutar,@olustar=olustarsaat,@user=olususer from perkart
where kod=@carkod

if @cartip='gelgidkart'
select @idx=id,@kod=kod,@actutar=actutar,@olustar=olustarsaat,@user=olususer from gelgidkart
where kod=@carkod

if @cartip='bankakart'
select @idx=id,@kod=kod,@actutar=actutar,@olustar=olustarsaat,@user=olususer from bankakart
where kod=@carkod

if @cartip='istkredikart'
select @idx=id,@kod=kod,@actutar=actutar,@olustar=olustarsaat,@user=olususer from istkart
where kod=@carkod



if @actutar<>0 begin
set @tarx=convert(varchar,@olustar,101);
set @saatx=convert(varchar,@olustar,108);

set @borc=0;
set @alacak=0;

if @actutar<0
begin
set @alacak=-@actutar;
set @gctip='B';
end;

if @actutar>0
begin
set @borc=@actutar;
set @gctip='A';
end;

if (@cartip='carikart') or (@cartip='perkart') or (@cartip='gelgidkart')
begin
select @carhrkid=isnull(max(carhrkid),0)+1 from carihrk;
insert into carihrk (carhrkid,gctip,yerad,yertip,islmtip,islmhrk,islmtipad,islmhrkad,cartip,
carkod,borc,alacak,bakiye,tarih,saat,olususer,olustarsaat,masterid,varno) values
(@carhrkid,@gctip,'Cari Kartlar','carikart','ISL','KAC','İŞLEM','KART AÇILIŞ',@cartip,
@kod,@borc,@alacak,(@borc-@alacak),@tarx,@saatx,
@user,@olustar,@idx,0);
end

if (@cartip='bankakart')
begin
select @carhrkid=isnull(max(bankhrkid),0)+1 from bankahrk;
insert into bankahrk (bankhrkid,gctip,yerad,yertip,islmtip,islmhrk,islmtipad,islmhrkad,cartip,
bankod,borc,alacak,tarih,saat,olususer,olustarsaat,masterid,varno) values
(@carhrkid,@gctip,'BANKA KARTLARI','bankakart','ISL','KAC','İŞLEM','KART AÇILIŞ',@cartip,
@kod,@borc,@alacak,@tarx,@saatx,
@user,@olustar,@idx,0);
end

if (@cartip='istkredikart')
begin
select @carhrkid=isnull(max(istkhrkid),0)+1 from istkhrk;
insert into istkhrk (istkhrkid,gctip,yerad,yertip,islmtip,islmhrk,islmtipad,islmhrkad,cartip,
carkod,borc,alacak,tarih,saat,olususer,olustarsaat,masterid,varno) values
(@carhrkid,@gctip,'İŞLETME KREDI KARTLARI','istkredikart','ISL','KAC','İŞLEM','KART AÇILIŞ',@cartip,
@kod,@borc,@alacak,@tarx,@saatx,
@user,@olustar,@idx,0);
end

end;


END

================================================================================
