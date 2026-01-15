-- Stored Procedure: dbo.slipparcala
-- Tarih: 2026-01-14 20:06:08.365735
================================================================================

CREATE PROCEDURE [dbo].slipparcala
@poshrkid float,
@odentut float,
@userad  varchar(100)
AS
BEGIN
declare @topmastut 		float
declare @poshrktut 		float
declare @brmfiy 		float
declare @idxmas 		float
declare @idx 			float
declare @kalan 			float
declare @newid 			float

 SET NOCOUNT ON


  select @idxmas=poshrkid,@topmastut=isnull(giren,0) from 
  poshrk with (nolock)  where poshrkid=@poshrkid
  and aktip='BK' and akid=0

  set @kalan=@odentut

  if @odentut<@topmastut
  begin

  DECLARE slipparcalax CURSOR FAST_FORWARD FOR SELECT 
   id,poshrkid,giren FROM poshrk with (nolock) where poshrkid=@poshrkid
    OPEN slipparcalax
    FETCH NEXT FROM slipparcalax INTO  @idx,@poshrkid,@poshrktut
    WHILE @@FETCH_STATUS = 0
     BEGIN

    set @kalan=@kalan-@poshrktut
     if @kalan<0
      begin

      /*select @newverid=max(poshrkid)+1 from poshrk */
      
      /* yeni fis olustuluyor */
      insert into poshrk (firmano,poshrkid,varno,perkod,adaid,islmtip,islmtipad,
      islmhrk,islmhrkad,yertip,yerad,masterid,gctip,tarih,saat,
      carslip,cartip_id,cartip,car_id,carkod,
      pos_id,poskod,bank_id,bankod,
      giren,cikan,extrakomyuz,bankomyuz,ack,vadetar,varok,
      sil,olususer,olustarsaat,deguser,degtarsaat,
      dataok,belno,kur,aktar,aktip,gerialtar,
      bagid,ana_id,parabrm,ekkomyuz,akid,devir)
      select firmano,0,varno,perkod,adaid,islmtip,islmtipad,
      islmhrk,islmhrkad,yertip,yerad,masterid,gctip,tarih,saat,
      carslip,cartip_id,cartip,car_id,carkod,
      pos_id,poskod,bank_id,bankod,-@kalan,0,extrakomyuz,bankomyuz,ack,vadetar,varok,
      sil,olususer,olustarsaat,deguser,degtarsaat,dataok,belno,kur,aktar,'BK',gerialtar,
      @idxmas,case when ana_id=0 then @idxmas else ana_id end,parabrm,ekkomyuz,akid,
      devir
      from poshrk with (nolock) where poshrkid=@poshrkid

      select @newid=SCOPE_IDENTITY()
      update poshrk set poshrkid=@newid where id=@newid
     
     /* ana slip islemi */
      update poshrk set giren=giren+@kalan,
      deguser=@userad,degtarsaat=getdate(),
      dataok=0,ana_id=case when ana_id=0 then poshrkid 
      else ana_id end
      where id=@idx

     /* diger fis hrk yeni fise tasınıyor */
     break
     end


   FETCH NEXT FROM slipparcalax INTO  @idx,@poshrkid,@poshrktut
  END
  CLOSE slipparcalax
  DEALLOCATE slipparcalax

end
  
SET NOCOUNT OFF
  
  
END

================================================================================
