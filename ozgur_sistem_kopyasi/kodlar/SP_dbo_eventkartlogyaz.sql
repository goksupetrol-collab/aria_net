-- Stored Procedure: dbo.eventkartlogyaz
-- Tarih: 2026-01-14 20:06:08.322377
================================================================================

CREATE PROCEDURE [dbo].eventkartlogyaz (@tablename varchar(30),
@recid int,@user_id int,@islemint int,@eventrkid int)
AS
BEGIN
declare @tarih datetime
declare @user_ip varchar(20)
declare @user_pcad varchar(50)
declare @sonack varchar(8000);
declare @oncekiack varchar(8000);

set @sonack='';
set @oncekiack='';

declare @sil int;
declare @varok int;

set @tarih=convert(varchar,GETDATE(),120)


select @user_pcad=isnull(ip,''),@user_ip=isnull(pc,'') from users where id=@user_id

 if @tablename='pomvardimas'
 begin
  select @sonack=
  '|VARDIYA ADI='+CAST(varad AS VARCHAR)+
  '|TARIH='+convert(varchar,tarih,104)+
  '|AKAR.SAT.MIK='+CAST(aksatmik AS VARCHAR)+
  '|AKAR.SAT.TUT='+CAST(aksattop AS VARCHAR)+
  '|POS.SAT.TUT='+CAST(postop AS VARCHAR)+
  '|VER.SAT.TUT='+CAST(veresitop AS VARCHAR)+
  '|NAKİT.TES.TUT='+CAST(naktestop AS VARCHAR)+
  '|MAL.SAT.TUT='+CAST(malsattop AS VARCHAR)+
  '|ODEME.TUT='+CAST(odetop AS VARCHAR)+
  '|TAHSİLAT.TUT='+CAST(tahtop AS VARCHAR)+
  '|GELİR TUT='+CAST(gelirtop AS VARCHAR)+
  '|GİDER TUT='+CAST(gidertop AS VARCHAR)+
  '|OTOMASYON.TUT='+CAST(otomastop AS VARCHAR)+
  '|ACIK-FAZLA='+CAST(varackfaztip AS VARCHAR)
   from pomvardimas where varno=@recid;
  insert into eventhrklog (recid,tarih,userid,islemint,ip,pcadi,eventrkid,sonack,oncekiack)
  values (@recid,@tarih,@user_id,@islemint,@user_ip,@user_pcad,@eventrkid,@sonack,@oncekiack)
end;

END

================================================================================
