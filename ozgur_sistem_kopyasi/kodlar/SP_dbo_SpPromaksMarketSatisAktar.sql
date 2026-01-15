-- Stored Procedure: dbo.SpPromaksMarketSatisAktar
-- Tarih: 2026-01-14 20:06:08.379123
================================================================================

CREATE PROCEDURE dbo.[SpPromaksMarketSatisAktar]
@FirmaNo       int,
@VarNo         int,
@GuidId           varchar(40),
@OlusUser         varchar(100),
@FiyatGuncelle    bit
AS
BEGIN



     declare @KasaNo 		int
     declare @FisNo			int 
     declare @AcilisTarihSaat 	Datetime
     declare @KapanisTarihSaat 	Datetime
    /* declare @Tutar        	float */
     declare @FisTutar        	float
     declare @MarSatId      int
     declare @YazarKasaServisLogId       int
     declare @KasaHrkId         int
     
     
     declare @AcilisTarih Datetime
     declare @AcilisSaat  varchar(8)
     
     declare @OdemeTip   varchar(30)
     
     declare @FisTarihSaat Datetime
     declare @FisTarih Datetime
     declare @FisSaat  varchar(8)
     declare @YazarKasaVardiyaNo 		int

     
     
     declare @DepoKod      varchar(30) 
     declare @PersonelKod Varchar(30) 

     declare @KdvTip      varchar(30)
     declare @IslemTip      varchar(30)
     declare @IslemTipAd      varchar(30)
     declare @YerTip      varchar(30)
     declare @YerTipAd      varchar(50)
     Declare @ParaBirim Varchar(20)
     
     declare @Barkod  varchar(30)
     declare @StokKod  varchar(30)
     declare @StokTip  varchar(30)
     declare @StokTipAd  varchar(30)
     declare @Birim      varchar(20)
     declare @StokId      int
     declare @StokTipId      int
     declare @Miktar      Float
     declare @BirimFiyat      Float
     declare @KdvYuz      Float
     
     
     
     declare @Giren      Float
     declare @Cikan      Float
    
    declare @PosHrkId  int 
    declare @PosKod  varchar(30)
    declare @BankKod  varchar(30)
    declare @VarPosIsle  bit
     
    Set @KdvTip='Dahil'
    Set @Islemtip='satis'
    Set @IslemTipAd='SATIŞ'
    Set @YerTip='promakscsv'
    Set @YerTipAd='PROMAKS CSV'
    Set @ParaBirim='TL' 

   
    select top 1 @VarPosIsle=Var_Pos_Isle,@PosKod=marpossatkod from sistemtanim
    select @BankKod=pk.bankod from poskart as pk where pk.kod=@PosKod
    
    
    
    Select @DepoKod=Depkod,@PersonelKod=PerKod  
    From MarvardiMas Where varno=@Varno
    
    
    
    if @DepoKod=''
      set @DepoKod='M0001'
    
   if @PersonelKod='' 
    set @PersonelKod='P0001'
    
    
    set @StokTip='markt'
    set @StokTipAd='MARKET'
    set @StokTipId=2
    
    
     /*Nakit  */
           
      /*MarSatMas Kontrol ve Olustur  */ 

       declare CurMarSat CURSOR FAST_FORWARD  FOR 
       Select IslemTarih,IslemId,Sum(Tutar) Tutar,OdemeTip from PromaksMarketSatisLog with (nolock) 
       Where GuidId=@GuidId and Aktar=1 and StokId is not null
       Group By IslemTarih,IslemId,OdemeTip
       
	    
        open CurMarSat
       fetch next from  CurMarSat into @FisTarihSaat,@FisNo,@FisTutar,@OdemeTip
       while @@FETCH_STATUS=0
         begin
                  
         
         
         Set @MarSatId=0
         
         set @FisTarih=DATEADD(dd,0,DATEDIFF(dd,0,@FisTarihSaat))   
         set @FisSaat=CONVERT(VARCHAR(8),@FisTarihSaat,108) 
         
         Select @MarSatId=id From marsatmas with (nolock) 
         where Varno=@VarNo And Fis_No=@FisNo and Sil=0
   
         if isnull(@MarSatId,0)=0
          begin
            insert into marsatmas (Firmano,varno,marsatid,islmtip,islmtipad,yertip,yerad,
            tarih,saat,kayok,olususer,olustarsaat,yazarkasa_id,Fis_No,YazarKasaIslemId,
            parabrm,cartip,carkod,Zno)
            values (@Firmano,@VarNo,0,@IslemTip,@IslemTipAd,@YerTip,@YerTipAd,
            @FisTarih,@FisSaat,0,@OlusUser,GetDate(),0,@FisNo,0,
            @ParaBirim,'vardikasa','VRDKASA',0)

            select @MarSatId=SCOPE_IDENTITY() 
          
            update marsatmas set marsatid=id where id=@MarSatId
          end
          
         
         
          /* MarsatHrk Kontrol ve Olustur   */ 
         
           declare CurMarSatHrk CURSOR FAST_FORWARD  FOR 
           Select Id,StokId,StokKod,Barkod,Miktar,Fiyat,Kdv,Birim  
           from PromaksMarketSatisLog with (nolock) 
           Where GuidId=@GuidId and Aktar=1 and IslemId=@FisNo and StokId is not null
         
           
           open CurMarSatHrk
           fetch next from  CurMarSatHrk into @YazarKasaServisLogId,
           @StokId,@StokKod,@Barkod,@Miktar,@BirimFiyat,@KdvYuz,@Birim  
           while @@FETCH_STATUS=0
            begin 
               
           insert into marsathrk (Firmano,varno,islmtip,islmtipad,perkod,depkod,
            yertip,yerad,satfiyno,tarih,saat,marsatid,barkod,
            stk_id,stkod,stktip_id,stktip,stktipad,mik,brim,
            brmfiy,kdvtip,kdvyuz,olususer,olustarsaat,YazarKasaServisLogId)
           values (@Firmano,@VarNo,@IslemTip,@IslemTipAd,@PersonelKod,@DepoKod,
            @YerTip,@YerTipAd,1,@FisTarih,@FisSaat,@MarSatId,
            @Barkod,@StokId,@StokKod,@StokTipId,@StokTip,@StokTipAd,@Miktar,@Birim,
            @BirimFiyat,@KdvTip,@KdvYuz/100,@OlusUser,GetDate(),@YazarKasaServisLogId)

            update PromaksMarketSatisLog Set Transfer=1 Where Id=@YazarKasaServisLogId

               
           fetch next from  CurMarSatHrk into @YazarKasaServisLogId,
          @StokId,@StokKod,@Barkod,@Miktar,@BirimFiyat,@KdvYuz,@Birim
       end
       close CurMarSatHrk
       deallocate CurMarSatHrk
         
        
       /*Markart Kasa */
        set @Giren=0
        set @Cikan=0
        
        
        Select @FisTutar=Sum(mik*brmfiy) from marsathrk with (nolock)
         where  marsatid=@MarSatId
             
        if @FisTutar>0
          set @Giren=@FisTutar
        else
          set @Cikan=@FisTutar 
          
         
       set @PosHrkId=0   
       set @KasaHrkId=0   
         
      
       /*Nakit */
       
      if (@OdemeTip='Nakit') 
       begin    
            
         select @KasaHrkId=id From markasahrk with (nolock) Where marsatid=@MarSatId     
       
        if isnull(@KasaHrkId,0)=0
        begin
        insert into markasahrk (Firmano,varno,gctip,marsatid,kaskod,
         kashrkid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
         tarih,saat,olususer,olustarsaat,giren,cikan,kur,parabrm,perkod)
        values (@Firmano,@VarNo,'G',@MarSatId,'VRDKASA',
         0,'TAH','TAHSİLAT','NAK','NAKİT TAHSİLAT',@YerTip,@YerTipAd,
         @FisTarih,@FisSaat,@OlusUser,GetDate(),
         @Giren,abs(@Cikan),1,@ParaBirim,@PersonelKod)

         select @KasaHrkId=SCOPE_IDENTITY() 
          
         update markasahrk set kashrkid=id where id=@KasaHrkId

       end 
       else
        update markasahrk set giren=@Giren,cikan=abs(@Cikan) where marsatid=@MarSatId 
       
       end
       
       
       
       
      if (@OdemeTip='Kredi Kartı') 
       begin
       
             /*
         poshrk','poshrkid',['gctip','islmtip','islmtipad',
                        'islmhrk','islmhrkad','yertip','yerad','marsatid','perkod','adaid','tarih','saat','carslip',
                        'cartip_id','cartip','car_id','carkod',
                        'poskod','bankod',
                        'giren','cikan',
                        'ekkomyuz','extrakomyuz','bankomyuz','kur',
                        'ack','krekartno','olususer','olustarsaat','varno','vadetar','parabrm','PosIsle'
                        */
       
       
    
            
             select @PosHrkId=id From poshrk with (nolock) Where marsatid=@MarSatId     
           
            if isnull(@PosHrkId,0)=0
            begin
             insert into poshrk (Firmano,varno,gctip,marsatid,poskod,bankod,
             carslip,cartip_id,cartip,car_id,carkod,
             poshrkid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
             vadetar,tarih,saat,olususer,olustarsaat,
             giren,cikan,kur,
             ekkomyuz,extrakomyuz,bankomyuz,
             parabrm,perkod,PosIsle)
             values (@Firmano,@VarNo,'G',@MarSatId,@PosKod,@BankKod,
             0,0,'',0,'',
             0,'TAH','TAHSİLAT','POS','KREDİ KARTI TAHSİL',@YerTip,@YerTipAd,
             @FisTarih,@FisTarih,@FisSaat,@OlusUser,GetDate(),
             @Giren,abs(@Cikan),1,
             0,0,0,
             @ParaBirim,@PersonelKod,@VarPosIsle)

             select @PosHrkId=SCOPE_IDENTITY() 
              
             update poshrk set poshrkid=id where id=@PosHrkId

           end 
           else
            update poshrk set giren=@Giren,cikan=abs(@Cikan) where marsatid=@MarSatId 
       
       end
       
       
       
       
       
       
        /*satistop,iadetop,NakTop=satistop-iadetop, */
        update MarSatMas Set KayOk=1,
        NakTop=case When @KasaHrkId>0 then case when abs(@Cikan)>0 then @Cikan else abs(@FisTutar) end else 0 end,
        PosTop=case When @PosHrkId>0 then case when abs(@Cikan)>0 then @Cikan else abs(@FisTutar) end else 0 end,
        
        islmtipad=case When @PosHrkId>0 then 'POS' else islmtipad end,
        islmhrk=case When @PosHrkId>0 then 'KREDİ KARTI TAHSİL' else islmtipad end,
        satistop=@Giren,
        
        iadetop=abs(@Cikan)
        Where id=@MarSatId 
         
         
        fetch next from  CurMarSat into @FisTarihSaat,@FisNo,@FisTutar,@OdemeTip
       
     end
      close CurMarSat
      deallocate CurMarSat
  


    /*Kredi kartı */
    
  if @FiyatGuncelle=1
   begin   
    /*Satis Fiyat Update */
    declare @Market_Sube bit
    select @Market_Sube=Market_Sube from sistemtanim 
    
    if isnull(@Market_Sube,0)=0    
     begin 
     update stokkart set 
     Sat1Fiy=dt.Fiyat, 
     SatisFiyat1DegisimTarih=DATEADD(dd,0,DATEDIFF(dd,0,IslemTarih)) 
     from stokkart as t join 
     (Select StokId,Max(Fiyat) Fiyat,
     Max(IslemTarih) IslemTarih from PromaksMarketSatisLog with (nolock) 
     Where GuidId=@GuidId and StokId is not null
     group by StokId
     ) dt on dt.StokId=t.id and t.Sat1Fiy<>dt.Fiyat
    end 
    
    if isnull(@Market_Sube,0)=1
    begin
    
     update stok_fiyat set 
     Fiyat=dt.Fiyat, 
     FiyatDegisimTarih=DATEADD(dd,0,DATEDIFF(dd,0,IslemTarih)) 
     from stok_fiyat as t join 
     (Select StokId,Max(Fiyat) Fiyat,
     Max(IslemTarih) IslemTarih from PromaksMarketSatisLog with (nolock) 
     Where GuidId=@GuidId and StokId is not null
     group by StokId
     ) dt on dt.StokId=t.Stk_id and t.Stktip_id=2
     and t.FiyTip=2 and t.FiyNo=1 and t.Firmano=@Firmano 
     and t.Fiyat<>dt.Fiyat
    
    end  
  end    


     return



END

================================================================================
