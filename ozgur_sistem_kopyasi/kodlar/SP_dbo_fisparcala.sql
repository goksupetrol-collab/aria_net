-- Stored Procedure: dbo.fisparcala
-- Tarih: 2026-01-14 20:06:08.330371
================================================================================

CREATE PROCEDURE [dbo].fisparcala @verid float,@odentut float
AS
BEGIN
declare @topmastut 	float
declare @fishrktut 	float
declare @brmfiy 	float
declare @idxmas 	float
declare @idx 		float
declare @kalan 		float
declare @newverid 	float
declare @bolmiktar 	float

SET NOCOUNT ON

if @odentut=0
 RETURN

 select @idxmas=id,@topmastut=isnull(round((toptut-isktop),2),0) from 
 veresimas with (nolock) where verid=@verid
 and fistip='FISVERSAT' and aktip in ('BK','BL')

set @kalan=@odentut


if @odentut<@topmastut
begin

DECLARE fisparcalax CURSOR FAST_FORWARD FOR SELECT id,verid,
  round(( (brmfiy*(1-(iskyuz/100)))*mik),2),(brmfiy*(1-(iskyuz/100)))
   FROM
 veresihrk with (nolock) where verid=@verid
 OPEN fisparcalax
  FETCH NEXT FROM fisparcalax INTO  
  @idx,@verid,@fishrktut,@brmfiy
  WHILE @@FETCH_STATUS = 0
  BEGIN

set @kalan=@kalan-@fishrktut
if @kalan<0
begin


/* yeni fis olustuluyor */
  insert into veresimas (
  firmano,verid,varno,kayok,
  gctip,fistip_id,fistur_id,fisrap_id,
  hrk_car_pro,hrk_stk_pro,
  fisad,fistip,yertip,tarih,yerad,seri,[no],ykno,
  cartip,cartip_id,car_id,carkod,
  plaka,perkod,adaid,surucu,km,toptut,isktop,
  ack,kmsec,varok,sil,saat,
  ototag,olususer,degtarsaat,deguser,olustarsaat,dataok,aktip,fatbelno,
  aktar,vadtar,bagid,marsatid,parabrm,kur,akid,
  Kart_parabrm,Kart_kur,Islem_Parabrm,Islem_Kur) 
  select firmano,0,varno,0,
  gctip,fistip_id,fistur_id,fisrap_id,
  hrk_car_pro,hrk_stk_pro,
  fisad,fistip,yertip,tarih,yerad,seri,[no],ykno,
  cartip,cartip_id,car_id,carkod,plaka,perkod,adaid,surucu,
  km,0,0,'BÖLÜNEN FİŞ',kmsec,varok,sil,saat,
  ototag,olususer,degtarsaat,deguser,olustarsaat,0,aktip,fatbelno,
  aktar,vadtar,@idxmas,marsatid,parabrm,kur,akid,
  Kart_parabrm,Kart_kur,Islem_Parabrm,Islem_Kur 
  
  from veresimas with (nolock) where verid=@verid

   select @newverid=SCOPE_IDENTITY()

/* yeni fis olustuluyor */


/* yeni fis hrk olustuluyor */

  update veresihrk set 
  mik=((( (brmfiy*(1-iskyuz/100))*mik)+@kalan)/ (brmfiy*(1-(iskyuz/100)) ))
   where id=@idx

  set @bolmiktar=((-1*@kalan)/@brmfiy)

  insert into veresihrk (firmano,varno,verid,
  stktip_id,stktip,stk_id,stkod,
  mik,brmfiy,iskyuz,
  depkod,dep_id,kdvyuz,brim,sil,olususer,
  olustarsaat,deguser,degtarsaat,dataok,yenbrmfiyfark,kayok,akfiytip,
  Kart_parabrm,Kart_kur,Islem_Parabrm,Islem_Kur)
  select firmano,varno,@newverid,
  stktip_id,stktip,stk_id,stkod,
  @bolmiktar,brmfiy,iskyuz,depkod,dep_id,
  kdvyuz,brim,sil,olususer,
  olustarsaat,deguser,degtarsaat,0,
  yenbrmfiyfark,kayok,akfiytip,
  Kart_parabrm,Kart_kur,Islem_Parabrm,Islem_Kur  from veresihrk with (nolock)
  where id=@idx  and verid=@verid

/* yeni fis hrk olustuluyor */

/* diger fis hrk yeni fise tasınıyor */
  update veresihrk set verid=@newverid where id>@idx and verid=@verid
  
  
   update veresimas set verid=@newverid,
    kayok=1 where id=@newverid

break

end


  FETCH NEXT FROM fisparcalax INTO  @idx,@verid,@fishrktut,@brmfiy
  END
  CLOSE fisparcalax
  DEALLOCATE fisparcalax



end

SET NOCOUNT OFF


END

================================================================================
