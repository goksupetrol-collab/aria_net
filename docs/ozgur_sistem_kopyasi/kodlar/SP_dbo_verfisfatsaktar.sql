-- Stored Procedure: dbo.verfisfatsaktar
-- Tarih: 2026-01-14 20:06:08.387873
================================================================================

CREATE PROCEDURE [dbo].verfisfatsaktar(
@firmano    int,
@fatrap_id   int,
@aktip      varchar(10),
@fistarih   bit,
@ortbrm     bit,
@tutar_sec  bit,
@cartip     varchar(10),
@carkod     varchar(30),
@veridin    varchar(8000),
@tutartl    float,
@bel_seri   varchar(50),
@bel_no     varchar(50),
@fattarih   datetime,
@userad     varchar(50),
@ack        varchar(200),
@isk_tip	tinyint,
@isk_oran	float)
AS
 BEGIN


  DECLARE @EKSTRE_TEMPAK TABLE (
  verid      varchar(30))

   declare @hrk_id        int
   declare @hrk_verid     int
   declare @fishrk_kaltut float
   declare @fishrktut     float
   declare @brmfiy        float
   declare @gctip         varchar(1)
   declare @giren         float
   declare @cikan         float
   declare @newid         int
   declare @islmtip       varchar(20)
   declare @islmhrk       varchar(20)
   declare @yertip        varchar(20)
   declare @yertipad      varchar(30)
   declare @islmtipad     varchar(30)
   declare @islmhrkad     varchar(30)
   declare @saatx         varchar(8)
   declare @tarx          datetime
   declare @parabrm       varchar(8)
   declare @parakur       float
   declare @say           int
   declare @mesaj         varchar(300)
   declare @fatvadtip     varchar(20)
   declare @fatvadsur     int
   declare @vadtarih      datetime
   declare @cartip_id	  int
   declare @car_id	  	  int
   declare @fattip_id  	  int
   declare @fattur_id     int
   declare @fattipad	  varchar(100)
   declare @fis_iskonto	  float
   declare @fis_isk_kart_kod   varchar(30)
   declare @cari_unvan   varchar(150)
   declare @kaptip		 varchar(30)
   declare @fattip		 varchar(30)
   
   declare @Hrk_Stk_Pro    bit
   
   declare   @AvansTakip  bit
   declare   @Karsi_Cartipid  int
   declare   @Karsi_Carid     int 
   
   declare   @Karsi_Hrk_Pro   bit  
   
  /* declare @fisno         int */
   
   declare @fatiskyuz     float
   
   select @car_id=id,@cartip_id=tip_id,
   @fis_iskonto=fis_iskonto,
   @cari_unvan=ad from 
   Genel_Kart as k with (nolock) where 
   k.cartp=@cartip and k.kod=@carkod
   

    if @isk_tip=1
    set @isk_oran=@fis_iskonto
   
   
   
   select @parabrm=sistem_parabrm,
   @fis_isk_kart_kod=fis_iskonto_kart from sistemtanim
   
   set @tarx=convert(varchar,getdate(),101);
   set @saatx=convert(varchar,getdate(),108);
   

   
   if (@tutar_sec=0) /*tutar girilmemissse */
    begin
       Insert @EKSTRE_TEMPAK
       select * from CsvToInt(@veridin)
       
       select @tutartl=sum(case when v.fistip='FISVERSAT' THEN 
       (v.toptut-v.isktop) else -1*(v.toptut-v.isktop) end ) from veresimas as v with (nolock)
        WHERE v.sil=0 and v.verid in (select * from @EKSTRE_TEMPAK)
    end
    
    
    set @tutartl=round(@tutartl,2)
    
   
   if (@tutartl>0) and (@tutar_sec=1)  /*tutar girilmisse */
   begin
    set @fishrk_kaltut=@tutartl

    DECLARE VERFF_HRK CURSOR FAST_FORWARD FOR
    SELECT  v.id,v.verid,Round((v.toptut-v.isktop),2) FROM veresimas as v with (nolock)
    WHERE v.sil=0 and v.verid in (select * from CsvToInt(@veridin))
    order by v.id
    OPEN VERFF_HRK
    
    FETCH NEXT FROM VERFF_HRK INTO
    @hrk_id,@hrk_verid,@fishrktut
    WHILE @@FETCH_STATUS = 0
    BEGIN


    if @fishrk_kaltut>0
     Insert @EKSTRE_TEMPAK Values (@hrk_verid)



     if round(@fishrk_kaltut,2)<round(@fishrktut,2)
     begin
      set @fishrk_kaltut=round(@fishrk_kaltut,2)
      if round(@fishrk_kaltut,2)>0  
       exec fisparcala @hrk_verid,@fishrk_kaltut
      break
     end

      set @fishrk_kaltut=Round(@fishrk_kaltut-@fishrktut,2)


    FETCH NEXT FROM VERFF_HRK INTO
    @hrk_id,@hrk_verid,@fishrktut
    END

    CLOSE VERFF_HRK
    DEALLOCATE VERFF_HRK
  end  /*tutar girilmisse */
  
  
    /*seçilen fişler içinde aktarılmıs varmı? */
     select @say=count(*) from veresimas as vs with (nolock) where 
     aktip not in ('BK','BL')
     and vs.verid in (select * from @EKSTRE_TEMPAK)

      if @say>0
           begin
           SELECT @MESAJ = 'Seçmiş Olduğunuz Fişler İçinde Aktarılmış Fişler Var..!'
           RAISERROR (@MESAJ, 16,1)
           RETURN
       end
   /*seçilen fişler */
  
  
  
  
  /*---------cari aktarim */
   if (@aktip='CH') or (@aktip='TEK_CH')
    begin
    
      if @tutartl>0
      begin
      set @cikan=0
      set @giren=@tutartl
      set @gctip='B'
      end
      
      if @tutartl<0
      begin
      set @cikan=@tutartl
      set @giren=0
      set @gctip='A'
      end
      
      set  @islmtip='FIS'
      set  @islmhrk='CAK'
      set  @yertip='carikart'
      select @yertipad=ad from yertipad where kod=@yertip
      select @islmtipad=ad from islemturtip where tip=@islmtip
      select @islmhrkad=ad from islemhrktip where tip=@islmtip and hrk=@islmhrk

     

       IF (@aktip='TEK_CH') /*--ch tek cari hrk işlenmesi */
       begin

         select @newid=0

        insert into carihrk (firmano,gctip,islmtip,islmtipad,
        islmhrk,islmhrkad,yertip,yerad,
        cartip_id,cartip,masterid,varno,carhrkid,perkod,
        adaid,tarih,vadetar,saat,
        car_id,carkod,
        belno,ack,borc,alacak,kur,parabrm,olususer,olustarsaat,
        fisfattip,fisaktip,fisid,plaka,surucu)
        select @firmano,@gctip,@islmtip,@islmtipad,@islmhrk,
        @islmhrkad,@yertip,@yertipad,
        @cartip_id,@cartip,@newid,0,@newid,'',0,
        case when @fistarih=0 then
        @fattarih else tarih end,
        vadtar,@saatx,
        @car_id,@carkod,(vs.seri+vs.no),@ack+' PLAKA :'+vs.plaka+' SURUCU :'+vs.surucu, /*@ackfatno */
        case when vs.fistip='FISVERSAT' THEN 
        (vs.toptut-vs.isktop)*(1-(@isk_oran/100)) else 0 end,
        case when fistip='FISALCSAT' THEN 
        toptut*(1-(@isk_oran/100)) else 0 end,1,
        @parabrm,@userad,getdate(),@islmhrk,
        'CT',vs.verid,vs.plaka,vs.surucu
        from veresimas as vs with (nolock) where 
        vs.verid in (select * from @EKSTRE_TEMPAK)
        
        select @newid=SCOPE_IDENTITY()
        update carihrk set masterid=@newid,carhrkid=@newid where fisid in (select * from @EKSTRE_TEMPAK)
        

        update veresimas  set aktip='CT',akid=@newid,aktar=@fattarih
         where verid in (select * from @EKSTRE_TEMPAK)
         
         
         /*- iskonto kartıı yansıttt */
         
         
         set @islmtip='GLG'  
         set @islmhrk='FSI'
         select @islmtipad=ad from islemturtip where tip=@islmtip
         select @islmhrkad=ad from islemhrktip where tip=@islmtip and hrk=@islmhrk

          
        if @isk_oran>0
        insert into carihrk (firmano,gctip,islmtip,islmtipad,
        islmhrk,islmhrkad,yertip,yerad,
        cartip_id,cartip,masterid,varno,carhrkid,perkod,
        adaid,tarih,vadetar,saat,
        car_id,carkod,
        belno,ack,borc,alacak,kur,parabrm,olususer,olustarsaat,
        fisfattip,fisaktip,fisid,plaka,surucu)
        select @firmano,@gctip,@islmtip,@islmtipad,@islmhrk,
        @islmhrkad,@yertip,@yertipad,
        3,'gelgidkart',@newid,0,@newid,'',0,
        case when @fistarih=0 then
        @fattarih else tarih end,
        vadtar,@saatx,
        0,@fis_isk_kart_kod,(vs.seri+vs.no),'FİŞ İSKONTO / CARI KOD '+
        @carkod+' CARI ÜNVANI '+@cari_unvan+' %'+
        cast(@isk_oran as varchar(20))+
        ' ( '+cast( round(((vs.toptut-vs.isktop)),2)  as varchar(20))+
        ' ) ',
        case when vs.fistip='FISVERSAT' THEN 
        (vs.toptut-vs.isktop)*(@isk_oran/100) else 0 end,
        case when fistip='FISALCSAT' THEN 
        toptut*(@isk_oran/100) else 0 end,1,
        @parabrm,@userad,getdate(),@islmhrk,'CT',vs.verid,'',''
        from veresimas as vs with (nolock) where  
        vs.verid in (select * from @EKSTRE_TEMPAK)
               
       
      end /*--ch tek cari hrk işlenmesi */

      if (@aktip='CH')/*ch toplu cari hrk işlenmesi */
      begin
      
       select @newid=0
      
      insert into carihrk (firmano,gctip,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      cartip_id,cartip,masterid,varno,carhrkid,perkod,adaid,tarih,vadetar,saat,
      car_id,carkod,
      belno,ack,borc,alacak,kur,parabrm,olususer,olustarsaat,
      fisfattip,fisaktip,fisid)
      select @firmano,@gctip,@islmtip,@islmtipad,@islmhrk,@islmhrkad,
      @yertip,@yertipad,
      @cartip_id,@cartip,@newid,0,@newid,'',0,
      @fattarih,@fattarih,@saatx,
      @car_id,@carkod,(@bel_seri+@bel_no),@ack,
      @giren*(1-(@isk_oran/100)),(-1*@cikan)*(1-(@isk_oran/100)),
      1,@parabrm,@userad,getdate(),@islmhrk,
      @aktip,0
      
       select @newid=SCOPE_IDENTITY()
       update carihrk set masterid=@newid,carhrkid=@newid where id=@newid
        

      update veresimas  set aktip='CH',akid=@newid,aktar=@fattarih
      where verid in (select * from @EKSTRE_TEMPAK)
         
         
      /*-iskonto yansıması   */
      
      if @isk_oran>0 
      insert into carihrk (firmano,gctip,islmtip,islmtipad,
        islmhrk,islmhrkad,yertip,yerad,
        cartip_id,cartip,masterid,varno,carhrkid,perkod,
        adaid,tarih,vadetar,saat,
        car_id,carkod,
        belno,ack,borc,alacak,kur,parabrm,olususer,olustarsaat,
        fisfattip,fisaktip,fisid,plaka,surucu)
        select @firmano,@gctip,@islmtip,@islmtipad,@islmhrk,
        @islmhrkad,@yertip,@yertipad,
        3,'gelgidkart',@newid,0,@newid,'',0,
        @fattarih,@fattarih,@saatx,
        0,@fis_isk_kart_kod,(@bel_seri+@bel_no),'FİŞ İSKONTO / CARI KOD '+
        @carkod+' CARI ÜNVANI '+@cari_unvan+' %'+
        cast(@isk_oran as varchar(20))+
        ' ( '+cast( round((( ABS(@giren+@cikan))),2)  as varchar(20))+
        ' ) ',
        @giren*(@isk_oran/100),(-1*@cikan)*(@isk_oran/100), 
        1,@parabrm,@userad,getdate(),@islmhrk,@aktip,0,'',''
              
       
         
         

      end/*---aktip ch */
      
      
      

    end

 /*------cari aktarim */

  if @aktip='FT'
   begin
   select @gctip=f.gctip,
   @fattip=r.rapkod,
   @fattip_id=tip_id,
   @fattur_id=tur_id,
   @fattipad=r.ack
  /* @Hrk_Stk_Pro=r.hrk_stk_pro */
   from raporlar r left join fattip f on f.kod=r.rapkod 
   where r.sil=0  and r.id=@fatrap_id
    /*'FATVERSAT' */
  
  
  
      set @Hrk_Stk_Pro=0
      set @kaptip='VER'
      if @fattip='FATTTSSAT'
      begin
       set @kaptip='FAT'
       set @Hrk_Stk_Pro=1
      end 
       
       
      set  @islmtip=@fattip
      /*'FATVERSAT' */
      set  @islmhrk='satis'
      set  @yertip='carikart'
      select @yertipad=ad from yertipad where kod=@yertip
      /*select @islmtipad=ad from fattip where kod=@islmtip */

    set @vadtarih=@fattarih
    
    if @cartip='carikart'
     begin
      select @fatvadtip=k.fatvadtip,@fatvadsur=k.fatvadsur,
      @fatiskyuz=k.fatisk,
      @Karsi_Cartipid=1,
      @Karsi_Carid=fat_car_id,
      @Karsi_Hrk_Pro=fat_car_sec,
      @AvansTakip=AvansTakip
      from carikart as k with (nolock) where
      k.kod=@carkod
      select @vadtarih=dbo.vadtarihver (@fatvadtip,@fatvadsur,@fattarih)
     end
     
     
      /*select @newid=isnull(max(fatid),0)+1 from faturamas */

      insert into faturamas (firmano,
      gctip,fatrap_id,fattip_id,fattur_id,
      fatad,fatid,tarih,vadtar,saat,yuvtop,
      gen_ind_tip,geniskyuz,genisktop,
      fattip,fattur,fatseri,fatno,
      cartip_id,cartip,car_id,carkod,kdvtip,ack,
      olususer,olustarsaat,deguser,degtarsaat,
      parabrm,kur,kaptip,kayok,hrk_car_pro,hrk_stk_pro,
      Karsi_Cartip_id,Karsi_Car_id,Hrk_Karsi_Pro,AvansTakip)
      select @firmano,@gctip,@fatrap_id,@fattip_id,@fattur_id,
      @fattipad,0,@fattarih,@vadtarih,@saatx,0,
      0,0,0,
      @islmtip,@islmhrk,@bel_seri,@bel_no,
      @cartip_id,@cartip,@car_id,@carkod,'Hariç',@ack,/*'TOPLU FATURALANDIRMA' */
      @userad,GETDATE(),'',null,@parabrm,1,@kaptip,0,1,@Hrk_Stk_Pro,
      @Karsi_Cartipid,@Karsi_Carid,@Karsi_Hrk_Pro,@AvansTakip
      
      select @newid=SCOPE_IDENTITY()
      update faturamas  set fatid=@newid where id=@newid
      
    
      if @ortbrm=1
        insert into faturahrk 
        (firmano,fatid,stktip_id,stktip,stk_id,stkod,mik,brim,ustbrim,carpan,
        brmfiy,depkod,kdvtip,
        kdvyuz,kdvtut,satiskyuz,satisktut,otvbrim,otvyuz,otvtut,olususer,olustarsaat,
        parabrim,Kart_ParaBrm,Kart_kur,OtoTag)
        
        select @firmano,@newid,stktip_id,stktip,stk_id,stkod,sum(mik),brim,
        brim,1, round(sum( ( ( (brmfiy*(1-(iskyuz/100)) ) / (1+kdvyuz) ) * mik )),12)
        / sum(mik),'','Hariç',Kdvyuz,
        0,
        0,0,0,0,0,@userad,getdate(),'TL','TL',1,OtoTag
        from veresihrk as h WITH (NOLOCK) 
        inner join veresimas as m WITH (NOLOCK)
        on m.verid=h.verid and m.sil=0 and h.sil=0 
        where m.verid in (select * from @EKSTRE_TEMPAK)
        group by stktip_id,stktip,stk_id,stkod,iskyuz,brim,kdvyuz,OtoTag
      else
        insert into faturahrk (firmano,fatid,stktip_id,stktip,stk_id,stkod,mik,brim,ustbrim,carpan,brmfiy,depkod,kdvtip,
        kdvyuz,kdvtut,satiskyuz,satisktut,otvbrim,otvyuz,otvtut,olususer,olustarsaat,
        parabrim,Kart_ParaBrm,Kart_kur,OtoTag)
        
        select @firmano,@newid,stktip_id,stktip,stk_id,stkod,sum(mik),brim,brim,1,
        round(cast((brmfiy*(1-(isnull(iskyuz,0)/100)))/(1+kdvyuz) as float),12),'','Dahil',
        kdvyuz,0,0,0,0,0,0,@userad,getdate(),'TL','TL',1,OtoTag
        from veresihrk h WITH (NOLOCK) 
        inner join veresimas as m WITH (NOLOCK)
        on m.verid=h.verid and m.sil=0 and h.sil=0 
        where m.verid in (select * from @EKSTRE_TEMPAK)
        group by stktip_id,stktip,stk_id,stkod,
        round(cast((brmfiy*(1-(isnull(iskyuz,0)/100)))/(1+kdvyuz) as float),12),
        iskyuz,brim,kdvyuz,OtoTag
        
        
        /*Depo Kart TTS ise */
        if @fattip='FATTTSSAT'
         update faturahrk set Depkod=dt.Kod,dep_id=dt.id From faturahrk as t join
         (select id,Kod,Bagak From tankkart as t with (nolock) where t.sil=0 ) dt
         on dt.Bagak=T.stkod and t.fatid=@newid
                 


        update veresimas  set aktip='FT',
        akid=@newid,
        fatid=@newid,aktar=@fattarih
        where verid in (select * from @EKSTRE_TEMPAK)
        
        update faturamas  set kayok=1 where fatid=@newid

        
        exec Fatura_Cari_Stok_Iskonto @newid
        
        
        exec Fatura_Genel_indirim @newid,0,@fatiskyuz
   
        
        update faturamas  set kayok=1 where fatid=@newid
    end

   select @newid as fatid

 END

================================================================================
