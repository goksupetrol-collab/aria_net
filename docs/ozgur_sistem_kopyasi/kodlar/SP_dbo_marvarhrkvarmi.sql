-- Stored Procedure: dbo.marvarhrkvarmi
-- Tarih: 2026-01-14 20:06:08.347358
================================================================================

CREATE PROCEDURE [dbo].marvarhrkvarmi @varno float,@artip varchar(50),@inx nvarchar(200)
AS
BEGIN
declare @perkod varchar(50),@perad varchar(50);
declare @say int;

SET NOCOUNT ON


/*set @inx = replace(@inx, '''', '''''' ) */
if object_id( 'tempdb..#marickhrk' ) is null
create table #marickhrk (kod varchar(30))
truncate table #marickhrk;
insert #ickhrk (kod) exec('select kod from perkart where kod in ('+@inx+')' );

if object_id( 'tempdb..#marvarhrkvarmi' ) is null
CREATE TABLE [dbo].[#marvarhrkvarmi] ([id] numeric(18, 0) IDENTITY(1, 1) NOT NULL,
ickad varchar(100),tablo varchar(30),kod varchar(50),ad varchar(50),tutar float,atper varchar(50) default '');

truncate table #marvarhrkvarmi;


DECLARE marvarhrkvarmix CURSOR LOCAL FOR SELECT per,perad FROM marvardiper where varno=@varno
and per in (select kod from #marickhrk)

 OPEN marvarhrkvarmix
 FETCH NEXT FROM marvarhrkvarmix INTO  @perkod,@perad
 WHILE @@FETCH_STATUS <> -1
 BEGIN
/*
 insert into #marvarhrkvarmi (ickad,tablo,kod,ad,tutar)
 select 'Akaryakıt Sayaçlı Satış Tutarı','vardisayac',@perkod,@perad,isnull(sum(tutar),0) from vardisayac where varno=@varno
 and ipt=0 and perkod=@perkod;
 

 insert into #varhrkvarmi (ickad,tablo,kod,ad,tutar)
 select 'Veresiye Satış Tutarı','veresihrk',@perkod,@perad,isnull(sum(toptut),0) from veresimas
 where varno=@varno and ipt=0 and perkod=@perkod;


 insert into #varhrkvarmi (ickad,tablo,kod,ad,tutar)
 select 'Pos Satış Tutarı','possat',@perkod,@perad,isnull(sum(tutar),0) from possat
 where varno=@varno and ipt=0 and perkod=@perkod ;

 insert into #varhrkvarmi (ickad,tablo,kod,ad,tutar)
 select 'Yağ - Emtia Satış Tutarı','Emtiasat',@perkod,@perad,isnull(sum(tutar),0) from Emtiasat
 where varno=@varno and ipt=0 and perkod=@perkod;


 insert into #varhrkvarmi (ickad,tablo,kod,ad,tutar)
 select 'Nakit Teslimat Tutarı','nakitteslim',@perkod,@perad,isnull(sum(tutar*kur),0) from kasahrk
 where varno=@varno and ipt=0 and perkod=@perkod;

 insert into #varhrkvarmi (ickad,tablo,kod,ad,tutar)
 select 'Ödeme Tutarı','odeme',@perkod,@perad,isnull(sum(tutar*kur),0) from finans
 where varno=@varno and tip='Ödeme' and ipt=0 and perkod=@perkod


insert into #varhrkvarmi (ickad,tablo,kod,ad,tutar)
select 'Tahsilat Tutarı','tahilat',@perkod,@perad,isnull(sum(tutar*kur),0) from finans
where varno=@varno and tip='Tahsilat' and ipt=0 and perkod=@perkod

insert into #varhrkvarmi (ickad,tablo,kod,ad,tutar)
select 'Mahsup Tutarı','mahsup',@perkod,@perad,isnull(sum(tutar*kur),0) from finans
where varno=@varno and islmtur='Mahsup Giriş' and ipt=0 and perkod=@perkod


insert into #varhrkvarmi (ickad,tablo,kod,ad,tutar)
select 'Çek-Senet','cek-senet',@perkod,@perad,isnull(sum(tutar*kur),0) from finans where varno=@varno
and tip='Çek-Senet' and ipt=0 and perkod=@perkod
 
insert into #varhrkvarmi (ickad,tablo,kod,ad,tutar)
select 'Banka İşlem','banka',@perkod,@perad,isnull(sum(tutar*kur),0) from finans where varno=@varno
and tip='Banka' and ipt=0 and perkod=@perkod;

*/
  FETCH NEXT FROM marvarhrkvarmix INTO  @perkod,@perad
  END
  CLOSE marvarhrkvarmix
  DEALLOCATE marvarhrkvarmix


select * from #marvarhrkvarmi where tutar>0


SET NOCOUNT OFF


END

================================================================================
