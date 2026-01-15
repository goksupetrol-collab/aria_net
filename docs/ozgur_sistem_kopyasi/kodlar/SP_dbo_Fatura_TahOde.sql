-- Stored Procedure: dbo.Fatura_TahOde
-- Tarih: 2026-01-14 20:06:08.325693
================================================================================

CREATE PROCEDURE dbo.Fatura_TahOde
@id           int,
@grp_tip 	  varchar(30),
@Durum		  bit		  	
AS
BEGIN

      
     
    if @grp_tip='kasahrk'
    begin
     delete from kasahrk where tahodeid=@id
    
    if @Durum=1
     begin
    /*select @newid=isnull(max(kashrkid),0)+1 from kasahrk */
    insert into kasahrk (firmano,kaskod,kashrkid,gctip,varno,
    masterid,fisfattip,fisfatid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,
    yerad,perkod,adaid,giren,cikan,bakiye,carkod,cartip,vadetar,tarih,saat,belno,ack,
    kur,varok,sil,olususer,
    olustarsaat,deguser,degtarsaat,parabrm,karsihestip,karsiheskod,tahodeid,
    fatid,fisid)
    
    select firmano,karsi_carkod,0,'G',varno,0,
    case 
    when fatid>0 then 'FAT'
    when fisid>0 then 'FIS' end,
    case
    when fatid>0 then fatid
    when fisid>0 then fisid end,
   
    islmtip,islmtipad,islmhrk,islmhrkad,yertip,
    yerad,perkod,adaid,giren,cikan,0,carkod,cartip,
    vadetar,
    case when Vadeli=0 then tarih else vadetar end,
    saat,belno,ack+' / '+belno,kur,varok,sil,olususer,
    olustarsaat,deguser,degtarsaat,parabrm,'','',id,
    fatid,fisid from TahsilatOdeme  with (nolock)   
    Where id=@id and sil=0
    
    
    update kasahrk set kashrkid=h.id from 
    TahsilatOdeme as ins inner join kasahrk as h on 
    ins.id=@id and ins.id=h.tahodeid and  ins.sil=0
    
    end
   
    
  end
  
  
  
   if @grp_tip='poshrk'
   begin
   
    delete from poshrk where tahodeid=@id
    
    if @Durum=1
     begin
    insert into poshrk (firmano,poskod,bankod,poshrkid,gctip,varno,
    masterid,fisfattip,fisfatid,
    islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
    perkod,adaid,giren,cikan,extrakomyuz,bankomyuz,ekkomyuz,
    carslip,carkod,cartip,vadetar,tarih,saat,belno,ack,kur,varok,sil,
    krekartno,olususer,olustarsaat,deguser,degtarsaat,
    parabrm,tahodeid,fatid,fisid)
    
    select firmano,karsi_carkod,bankkod,0,'G',varno,0,
    case 
    when fatid>0 then 'FAT'
    when fisid>0 then 'FIS' end,
    case
    when fatid>0 then fatid
    when fisid>0 then fisid end,
    
    islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
    perkod,adaid,giren,cikan,extrakomyuz,bankomyuz,ekkomyuz,
    1,carkod,cartip,vadetar,
    case when Vadeli=0 then tarih else vadetar end,
    saat,belno,ack+' / '+belno,kur,varok,sil,
    krekartno,olususer,olustarsaat,deguser,degtarsaat,parabrm,id,
    fatid,fisid
    from TahsilatOdeme with (nolock) Where id=@id  and sil=0
    
    
    update poshrk set poshrkid=h.id from TahsilatOdeme as ins  with (nolock) 
    inner join poshrk as h on ins.id=h.tahodeid and ins.id=@id
    and  ins.sil=0
    
    end
    
    
    
  end
 
 
 if @grp_tip='cekhrk'
   begin
   
   delete from cekkart where tahodeid=@id
  
  if @Durum=1
     begin
   insert into cekkart (cekid,firmano,islmtip,islmtipad,
   ceksenno,CekSeriNo_id,sil,varno,varok,refno,cartip,carkod,
   vercartip,vercarkod,gctip,yertip,yerad,drm,drmad,
   islmhrk,islmhrkad,giren,cikan,
   tarih,saat,banka,banksub,hesepno,kesideci,
   parabrm,ack,vadetar,olususer,olustarsaat,
   deguser,degtarsaat,dataok,masterid,perkod,adaid,kur,
   fisfattip,fisfatid,belno,gidkod,gidtutar,bankod,
   fisid,fatid,tahodeid,cartip_id,car_id,
   vercartip_id,vercar_id)
   
   select 0,firmano,islmtip,islmtipad,ceksenno,CekSeriNo_id,0,
   varno,varok,refno,
   case when islmhrk='ALN' THEN cartip else '' end,
   case when islmhrk='ALN' THEN carkod else '' end,
   case when islmhrk='KSN' THEN cartip else '' end,
   case when islmhrk='KSN' THEN carkod else '' end,
   case when islmhrk='ALN' THEN 'G' else 'C' end, 
   yertip,yerad,drm,drmad,islmhrk,islmhrkad,
   giren,cikan,
   case when Vadeli=0 then tarih else vadetar end,
   saat,bankad,banksub,hesapno,
   kesideci,parabrm,ack+' / '+belno,vadetar,
   olususer,olustarsaat,
   deguser,degtarsaat,0,0,
   perkod,adaid,kur,
    case 
    when fatid>0 then 'FAT'
    when fisid>0 then 'FIS' end,
    case
    when fatid>0 then fatid
    when fisid>0 then fisid end,
    belno,gidkod,gidtutar,bankkod,
    fatid,fisid,id,
    case when islmhrk='ALN' then cartip_id else 0 end,
    case when islmhrk='ALN' then car_id else 0 end,  case when islmhrk='KSN' then cartip_id else 0 end,
    case when islmhrk='KSN' then car_id else 0 end
    from TahsilatOdeme with (nolock) Where id=@id 
    and  sil=0 
    
    update cekkart set cekid=h.id from  TahsilatOdeme as ins with (nolock) 
    inner join cekkart as h  with (nolock) on 
    ins.id=h.tahodeid and ins.id=@id and  ins.sil=0
    end
    
    
    
    
  end
  
  
  
  
  
  if @grp_tip='bankhrk'
   begin
  
   delete from bankahrk where tahodeid=@id
  
   if @Durum=1
    begin
    insert bankahrk 
    (firmano,gctip,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
    cartip,carkod,masterid,fisfattip,fisfatid,
    varno,varok,bankhrkid,perkod,adaid,vadetar,tarih,saat,
    bank_id,bankod,kaskod,
    belno,ack,borc,alacak,kur,parabrm,olususer,
    olustarsaat,gidkod,gidtutar,tahodeid,
    fatid,fisid) 
    
    select firmano,'-',islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
    cartip,carkod,0,
     case 
      when fatid>0 then 'FAT'
      when fisid>0 then 'FIS' end,
      case
      when fatid>0 then fatid
      when fisid>0 then fisid end,
      varno,varok,0,perkod,adaid,
      vadetar,
      case when Vadeli=0 then tarih else vadetar end,saat,
      karsi_car_id,karsi_carkod,'',
      belno,ack+' / '+belno,cikan,giren,kur,parabrm,
      olususer,olustarsaat,
      gidkod,gidtutar,id,
      fatid,fisid 
      from TahsilatOdeme with (nolock) where id=@id
      and  sil=0
      
    
      update bankahrk set bankhrkid=h.id from  TahsilatOdeme as ins with (nolock)
      inner join bankahrk as h with (nolock) on ins.id=h.tahodeid 
      and ins.id=@id and  ins.sil=0
  end
  
  
  end
  
  
  if @grp_tip='istkhrk'
   begin
  
   delete from istkhrk where tahodeid=@id
   
   if @Durum=1
   begin
     insert istkhrk 
     (firmano,gctip,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
     cartip,carkod,masterid,fisfattip,fisfatid,
     varno,varok,istkhrkid,perkod,adaid,vadetar,tarih,saat,
     istkk_id,istkkod,
     belno,ack,borc,alacak,kur,parabrm,olususer,
     olustarsaat,tahodeid,
     fatid,fisid) 
  
    select firmano,'-',islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
    cartip,carkod,0,
     case 
      when fatid>0 then 'FAT'
      when fisid>0 then 'FIS' end,
      case
      when fatid>0 then fatid
      when fisid>0 then fisid end,
      varno,varok,0,perkod,adaid,
      vadetar,
      case when Vadeli=0 then tarih else vadetar end,
      saat,
      karsi_car_id,karsi_carkod,
      belno,ack+' / '+belno,cikan,giren,kur,parabrm,
      olususer,olustarsaat,
      id,fatid,fisid  from TahsilatOdeme with (nolock) where id=@id
      and sil=0 
  
  
     update istkhrk set istkhrkid=h.id from  TahsilatOdeme as ins with (nolock)
     inner join istkhrk as h with (nolock) on ins.id=h.tahodeid and ins.id=@id
     and ins.sil=0 and  ins.sil=0
     
  
  end
   
   
   end 
 
END

================================================================================
