-- Stored Procedure: dbo.faturagiris
-- Tarih: 2026-01-14 20:06:08.326591
================================================================================

CREATE PROCEDURE [dbo].faturagiris @fatid float
AS
BEGIN
declare @firmano    	float
declare @varno    	float
declare @baktop 	float
declare @newid 		float
declare @fattip  	varchar(15)
declare @borc    	float
declare @alacak 	float
declare @tutar   	float
declare @genisktop  float
declare @say 		int
declare @kapacik 	varchar(10)
declare @hrk_car_pro bit
declare @hrk_stk_pro  bit
declare @gidkod     varchar(30)
declare @gid_id     int

declare @islmtip 	varchar(20)
declare @islmhrk 	varchar(20)
declare @islmtipad 	varchar(30)
declare @islmhrkad 	varchar(30)
declare @yertip 	varchar(30)
declare @yertipad 	varchar(30)


declare @cartip 	varchar(20)
declare @fattur 	varchar(20)

declare @mesaj      varchar(500)
declare @gctip 		int

declare @Karsi_Cartip_id int
declare @Karsi_Car_id    int
declare @Hrk_Karsi_Pro   bit
declare @AvansTakip      bit


declare @karsi_cartip     varchar(20)
declare @karsi_carkod     varchar(50)

declare @carkod			   varchar(50)
declare @fatrapid         int

declare @karsi_ack     varchar(200)
declare @IskGiderHrkYansit  bit

 if @fatid=0 
  RETURN


select 
@firmano=firmano,
@fattur=fattip,
@fatrapid=fatrap_id,  
@gctip=gctip,
@tutar=genel_top,
@genisktop=genel_isk_top,
@cartip=cartip,
@carkod=carkod,
@hrk_stk_pro=hrk_stk_pro,
@hrk_car_pro=hrk_car_pro,
@Karsi_Cartip_id=Karsi_Cartip_id,
@Karsi_Car_id=Karsi_Car_id,
@Hrk_Karsi_Pro=Hrk_Karsi_Pro,
@AvansTakip=AvansTakip 

from faturamas  WITH (NOLOCK) where fatid=@fatid

  select @kapacik=kaptip,@IskGiderHrkYansit=IskGiderHrkYansit 
  from raporlar WITH (NOLOCK) where id=@fatrapid
  /*rapkod=@fattur */

 set @islmtip='FAT'
  SELECT @islmtipad=ad from islemturtip WITH (NOLOCK) where tip=@islmtip


  set @borc=0
  set @alacak=0

  if @gctip=1  
   set @alacak=@tutar


  if @gctip=2 
   set @borc=@tutar


   /* SELECT @mesaj = '"'+cast(@gctip as varchar(50))+ '" ' */
    /*   RAISERROR (@mesaj, 16,1) */




if (@cartip='carikart') or (@cartip='perkart') or (@cartip='gelgidkart') or
(@cartip='perakendekart')
begin

  delete from carihrk from carihrk with(nolock) 
  where masterid=@fatid and SUBSTRING(islmhrk,1,3)='FAT'
  
  if @hrk_car_pro=1
  begin
  /*select @newid=isnull(max(carhrkid),0)+1 from carihrk */
  
  select @newid=isnull(IDENT_CURRENT('carihrk'),0)+1 
  insert into carihrk (firmano,carhrkid,gctip,masterid,
  islmtip,islmtipad,
  islmhrk,islmhrkad,belrap_id,yertip,yerad,
  cartip,carkod,borc,alacak,tarih,saat,olususer,olustarsaat,vadetar,belno,
  ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,parabrm,
  fisfattip,fatid,car_id,cartip_id)
  select firmano,0,@gctip,@fatid,
  @islmtip,@islmtipad,
  fattip,fatad,fatrap_id,
  'faturamas','FATURA GİRİŞ',
  cartip,carkod,@borc,@alacak,
  tarih,saat,olususer,olustarsaat,vadtar,fatseri+cast([fatno] as varchar),
  ack,0,kur,dataok,1,1,'',0,deguser,degtarsaat,sil,parabrm,'FAT',fatid,
  car_id,cartip_id
  from faturamas WITH (NOLOCK) where fatid=@fatid
  select @newid=SCOPE_IDENTITY()
 
  update carihrk set carhrkid=@newid where id=@newid
  
 /* Karsi Hrk Aktar */
   if @Hrk_Karsi_Pro=1
   begin
   
   set @islmtip='FAT'  
    set @islmhrk='BCA'
  
    
    select @karsi_ack=cast(kod as Varchar(50))+' / '+
    unvan
    from Genel_Cari_Kart WITH (NOLOCK) 
    where CarTip_id=@Karsi_Cartip_id and id=@Karsi_Car_id  
    
   SELECT @islmtipad=ad from islemturtip WITH (NOLOCK) where tip=@islmtip
   SELECT @islmhrkad=ad from islemhrktip WITH (NOLOCK) where tip=@islmtip and hrk=@islmhrk;
     
    delete from carihrk where fatid=@fatid and 
    islmtip=@islmtip and islmhrk=@islmhrk

    insert into carihrk (firmano,carhrkid,gctip,masterid,
    islmtip,islmtipad,islmhrk,islmhrkad,
    belrap_id,yertip,yerad,
    cartip,carkod,borc,alacak,tarih,saat,olususer,olustarsaat,vadetar,belno,
    ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,parabrm,
    fisfattip,fatid,car_id,cartip_id,FatKapTip)
    select firmano,0,@gctip,@fatid,
    @islmtip,@islmtipad,@islmhrk,@islmhrkad,
    fatrap_id,
    'faturamas','FATURA GİRİŞ',
    cartip,carkod,@alacak,@borc,
    tarih,saat,olususer,olustarsaat,vadtar,fatseri+cast([fatno] as varchar),
    @karsi_ack,0,kur,dataok,1,1,'',0,deguser,degtarsaat,sil,parabrm,'FAT',fatid,
    car_id,cartip_id,KapTip
    from faturamas WITH (NOLOCK) where fatid=@fatid
    
    select @newid=SCOPE_IDENTITY() 
    
    update carihrk set carhrkid=@newid where id=@newid
    
    
     
    select @karsi_cartip='carikart'
    
    select @karsi_carkod=kod from carikart with (nolock)  where id=@Karsi_Car_id
    
    
    select @karsi_ack=cast(kod as Varchar(50))+' / '+
    unvan
    from Genel_Cari_Kart WITH (NOLOCK)  where cartip=@cartip and kod=@carkod
    
   
    insert into carihrk (firmano,carhrkid,gctip,masterid,
    islmtip,islmtipad,islmhrk,islmhrkad,
    belrap_id,yertip,yerad,
    cartip,carkod,borc,alacak,tarih,saat,olususer,olustarsaat,vadetar,belno,
    ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,parabrm,
    fisfattip,fatid,car_id,cartip_id,FatKapTip)
    select firmano,0,@gctip,@fatid,
    @islmtip,@islmtipad,@islmhrk,@islmhrkad,
    fatrap_id,
    'faturamas','FATURA GİRİŞ',
    @karsi_cartip,@karsi_carkod,@borc,@alacak,
    tarih,saat,olususer,olustarsaat,vadtar,fatseri+cast([fatno] as varchar),
    @karsi_ack,0,kur,dataok,1,1,'',0,deguser,degtarsaat,sil,parabrm,'FAT',fatid,
    @Karsi_Car_id,@Karsi_Cartip_id,KapTip
    from faturamas  WITH (NOLOCK) where fatid=@fatid
    
    select @newid=SCOPE_IDENTITY() 
    
    update carihrk set carhrkid=@newid where id=@newid
    
   end
   
   
   /*- Fatura Avans Takip Iskonto Tutarı Ekle */
   
    set @islmtip='FAT'  
    set @islmhrk='FIA'/* FATURA ISKONTO AVANS TAKIP */
   
   delete from carihrk from carihrk with(nolock) where fatid=@fatid and 
   islmtip=@islmtip and islmhrk=@islmhrk
   
   
  if  @AvansTakip=1
   begin
   /* select @gidkod=Fat_Avans_Kart from sistemtanim WITH (NOLOCK) */
   /* select @gid_id=id from gelgidkart WITH (NOLOCK) where kod=@gidkod */
   
     if  (@gctip=2) and (@genisktop>0) 
      begin
   
       SELECT @islmtipad=ad from islemturtip WITH (NOLOCK) where tip=@islmtip
       SELECT @islmhrkad=ad from islemhrktip WITH (NOLOCK) where tip=@islmtip and hrk=@islmhrk
    
    /* Fat Avans Kart Cari Kart Hrk   */
      insert into carihrk 
      (firmano,carhrkid,gctip,masterid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      cartip,carkod,borc,alacak,tarih,saat,olususer,olustarsaat,vadetar,belno,
      ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,parabrm,
      fisfattip,fatid,belrap_id,car_id,cartip_id,FatKapTip)
      select m.firmano,@newid,@gctip,@fatid,
      @islmtip,@islmtipad,@islmhrk,@islmhrkad,
      'faturamas','FATURA GİRİŞ',
      m.cartip,m.carkod,
      sum((h.Top_isk_Tut)*(1+(h.kdvyuz))),0,m.tarih,m.saat,max(m.olususer),max(m.olustarsaat),
      m.vadtar,m.fatseri+cast(m.fatno as varchar),
      ' KDV % '+cast(h.kdvyuz*100 as varchar)+' '+
      m.fatseri+cast(m.fatno as varchar)+' FATURA AVANS MAHSUP İŞLEMİ',
      0,max(m.kur),max(m.dataok),0,1,'',0,
      max(m.deguser),max(m.degtarsaat),max(m.sil),max(m.parabrm),'FAT',
      max(m.fatid),max(m.fatrap_id),max(car_id),max(cartip_id),Max(m.KapTip)
      from faturamas as m WITH (NOLOCK)
      inner join faturahrk as h WITH (NOLOCK) on
      m.fatid=h.fatid and h.sil=0
      left join Genel_Kart as k WITH (NOLOCK) on 
      m.cartip=k.cartp and m.carkod=k.kod
      where m.fatid=@fatid and m.sil=0
      and h.Top_isk_Tut>0
      Group By  m.firmano,m.cartip,m.carkod,m.tarih,m.saat,m.vadtar,
      m.fatseri,m.fatno,h.kdvyuz
      
      
      /* Fat Avans Kart Hrk   */
      insert into carihrk 
      (firmano,carhrkid,gctip,masterid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      cartip,carkod,borc,alacak,tarih,saat,olususer,olustarsaat,vadetar,belno,
      ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,parabrm,
      fisfattip,fatid,belrap_id,car_id,cartip_id,CariAvans,FatKapTip)
      select m.firmano,@newid,@gctip,@fatid,
      @islmtip,@islmtipad,@islmhrk,@islmhrkad,
      'faturamas','FATURA GİRİŞ',
      m.cartip,m.carkod,
      0,sum((h.Top_isk_Tut)*(1+(h.kdvyuz))),m.tarih,m.saat,max(m.olususer),max(m.olustarsaat),
      m.vadtar,m.fatseri+cast(m.fatno as varchar),
      ' KDV % '+cast(h.kdvyuz*100 as varchar)+' '+
      m.fatseri+cast(m.fatno as varchar)+'  FATURA AVANS MAHSUP İŞLEMİ',
      0,max(m.kur),max(m.dataok),0,1,'',0,
      max(m.deguser),max(m.degtarsaat),max(m.sil),max(m.parabrm),'FAT',
      max(m.fatid),max(m.fatrap_id),max(car_id),max(cartip_id),1,Max(m.KapTip)
      from faturamas as m WITH (NOLOCK)
      inner join faturahrk as h WITH (NOLOCK) on
      m.fatid=h.fatid and h.sil=0
      left join Genel_Kart as k WITH (NOLOCK) on 
      m.cartip=k.cartp and m.carkod=k.kod
      where m.fatid=@fatid and m.sil=0
      and h.Top_isk_Tut>0
      Group By  m.firmano,m.cartip,m.carkod,m.tarih,m.saat,m.vadtar,
      m.fatseri,m.fatno,h.kdvyuz
      
      end
    
   
   end
   
   
   
   
   
 
  
  /*-fatura iskonto gideri */

    set @islmtip='GLG'  
    set @islmhrk='FTI'
  
  
   delete from carihrk from carihrk with(nolock) where fatid=@fatid and 
   islmtip=@islmtip and islmhrk=@islmhrk

   delete from carihrk from carihrk with(nolock) where fatid=@fatid and 
   islmtip=@islmtip and islmhrk='FIK'

  if (@IskGiderHrkYansit=1) and (@hrk_stk_pro=0)
   begin

   select @gidkod=FatIskGiderKod from firma WITH (NOLOCK) where id=@firmano
 
 
   select @gid_id=id from gelgidkart WITH (NOLOCK) where kod=@gidkod
  
  if  (@gctip=2) and (@genisktop>0) and (ISNULL(@gidkod,'')<>'')
   begin
   
     
      /* 
     if (ISNULL(@gidkod,'')='') 
       begin
           set @mesaj='Fatura İskontoları İçin Sistem Tanımında Fatura İskonto Gider Kartı Seçiniz...!'+
           char(13)+char(10)+
           'İskonto Gider Yansıması Yapılamadı....!'
           RAISERROR (@mesaj, 16,1)
           ROLLBACK TRANSACTION
           RETURN
        end
      */

   
   
     SELECT @islmtipad=ad from islemturtip WITH (NOLOCK) where tip=@islmtip
     SELECT @islmhrkad=ad from islemhrktip WITH (NOLOCK) where tip=@islmtip and hrk=@islmhrk
    
    
      insert into carihrk 
      (firmano,carhrkid,gctip,masterid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      cartip,carkod,borc,alacak,tarih,saat,olususer,olustarsaat,vadetar,belno,
      ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,parabrm,
      fisfattip,fatid,belrap_id,car_id,cartip_id,FatKapTip)
      select m.firmano,@newid,@gctip,@fatid,
      @islmtip,@islmtipad,@islmhrk,@islmhrkad,
      'faturamas','FATURA GİRİŞ',
      'gelgidkart',@gidkod,
      h.Top_isk_Tut,0,m.tarih,m.saat,m.olususer,m.olustarsaat,
      m.vadtar,m.fatseri+cast(m.fatno as varchar),
      substring((sk.ad+
      ' / % '+cast(h.Top_isk_Yuz as varchar(20))+' ( '+
      cast( round((h.brmfiy*h.mik),2)  as varchar(20))+' ) / '+
      k.ad+' / '+m.ack),1,200)
      ,0,m.kur,m.dataok,0,1,'',0,
      m.deguser,m.degtarsaat,m.sil,m.parabrm,'FAT',
      m.fatid,m.fatrap_id,@gid_id,3,m.KapTip
      from faturamas as m WITH (NOLOCK)
      inner join faturahrk as h WITH (NOLOCK) on
      m.fatid=h.fatid and h.sil=0
      left join Genel_Kart as k WITH (NOLOCK) on 
      m.cartip=k.cartp and m.carkod=k.kod
      left join gelgidlistok as sk WITH (NOLOCK)  on 
      sk.tip=h.stktip and h.stkod=sk.kod
      where m.fatid=@fatid and m.sil=0
      and h.Top_isk_Tut>0
      
     
     
       set @islmtip='GLG'  
       set @islmhrk='FIK'/*FATURA ISKONTO KDV */
      
       SELECT @islmhrkad=ad from islemhrktip WITH (NOLOCK)
        where tip=@islmtip and hrk=@islmhrk
      
      
      insert into carihrk 
      (firmano,carhrkid,gctip,masterid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      cartip,carkod,borc,alacak,tarih,saat,olususer,olustarsaat,vadetar,belno,
      ack,varno,kur,dataok,pro,varok,perkod,adaid,deguser,degtarsaat,sil,parabrm,
      fisfattip,fatid,belrap_id,car_id,cartip_id,FatKapTip)
      select m.firmano,@newid,@gctip,@fatid,
      @islmtip,@islmtipad,
      @islmhrk,@islmhrkad,
      'faturamas','FATURA GİRİŞ',
      'gelgidkart',@gidkod,
      ((h.Top_isk_Tut)*(1+(h.kdvyuz)))-
      (h.Top_isk_Tut),
      0,m.tarih,m.saat,m.olususer,m.olustarsaat,
      m.vadtar,m.fatseri+cast(m.fatno as varchar),
      substring((sk.ad+
      ' / % '+cast(h.Top_isk_Yuz as varchar(20))+' ( '+
      cast( round((h.kdvyuz*100),2)  as varchar(20))+' ) / '+
      k.ad+' / KDV TUTARI'),1,200)
      ,0,m.kur,m.dataok,0,1,'',0,
      m.deguser,m.degtarsaat,m.sil,m.parabrm,'FAT',
      m.fatid,m.fatrap_id,@gid_id,3,m.KapTip
      from faturamas as m WITH (NOLOCK)
      inner join faturahrk as h WITH (NOLOCK) on
      m.fatid=h.fatid and h.sil=0
      left join Genel_Kart as k WITH (NOLOCK) on 
      m.cartip=k.cartp and m.carkod=k.kod
      left join gelgidlistok as sk WITH (NOLOCK) on 
      sk.tip=h.stktip and h.stkod=sk.kod
      where m.fatid=@fatid and m.sil=0
      and h.Top_isk_Tut>0
      
   
   
    end
   
   end   
  
  
  end


END

END

================================================================================
