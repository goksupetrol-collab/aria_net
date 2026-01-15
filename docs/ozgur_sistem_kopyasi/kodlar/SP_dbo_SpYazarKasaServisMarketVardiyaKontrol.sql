-- Stored Procedure: dbo.SpYazarKasaServisMarketVardiyaKontrol
-- Tarih: 2026-01-14 20:06:08.381640
================================================================================

CREATE PROCEDURE dbo.SpYazarKasaServisMarketVardiyaKontrol
@Firmano       int,
@DepoKod      varchar(30),
@PersonelKod      varchar(30),
@Tip              int   /*1 zno 2 vardiyaNo */
AS
BEGIN


    declare @T Table (
     MarSatId        int   
    
    )
    



     /*declare @Firmano       int */
     declare @VarNo 		int
     declare @Zno 			int
     declare @KasaNo 		int
     declare @FisNo			int 
     declare @AcilisTarihSaat 	Datetime
     declare @KapanisTarihSaat 	Datetime
    /* declare @Tutar        	float */
     declare @FisTutar        	float
     declare @MarSatId      int
     declare @OlusUser      varchar(100) 
     declare @YazarKasaServisLogId       int
     declare @KasaHrkId         int
     
     
     declare @AcilisTarih Datetime
     declare @AcilisSaat  varchar(8)
     
     
     declare @FisTarihSaat Datetime
     declare @FisTarih Datetime
     declare @FisSaat  varchar(8)
     declare @YazarKasaVardiyaNo 		int

     
     
     /*declare @DepoKod      varchar(30) */
     /*declare @PersonelKod Varchar(30) */

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
     
     
    Set @KdvTip='Dahil'
    Set @Islemtip='satis'
    Set @IslemTipAd='SATIÅ'
    Set @YerTip='yazarkasaservis'
    Set @YerTipAd='YAZAR SERVIS AKTARIM'
    Set @ParaBirim='TL' 
    Set @OlusUser='YAZARKASA SERVIS' 
    
    
    if @DepoKod=''
      set @DepoKod='M0001'
    
   if @PersonelKod='' 
    set @PersonelKod='P0001'
    
    
    set @StokTip='markt'
    set @StokTipAd='MARKET'
    set @StokTipId=2
    
    
     if @Tip=1 
     declare CurMarVar CURSOR FAST_FORWARD  FOR 
     Select top 1 Firmano,Zno,0 VardiyaNo,KasaNo,
     Min(Tarih) AcilisTarih,
     Max(Tarih) KapanisTarih
     from Yazarkasa_Satis with (nolock) 
     Where Trans=0 and Firmano=@Firmano and Zno is not null
	 group by Firmano,Zno,KasaNo
	 Order by Zno desc
    
    if @Tip=2 
     declare CurMarVar CURSOR FAST_FORWARD  FOR  
     Select top 1 Firmano,0 Zno,VardiyaNo,KasaNo,
     Min(Tarih) AcilisTarih,
     Max(Tarih) KapanisTarih
     from Yazarkasa_Satis with (nolock) 
     Where Trans=0 and Firmano=@Firmano and VardiyaNo is not null
	 group by Firmano,VardiyaNo,KasaNo
	 Order by VardiyaNo desc
    
    
     
     open CurMarVar
    fetch next from  CurMarVar into @Firmano,@Zno,@YazarKasaVardiyaNo,@KasaNo,
    @AcilisTarihSaat,@KapanisTarihSaat
     while @@FETCH_STATUS=0
      begin
  
      set @VarNo=0
      
      
      
      set @AcilisTarih=DATEADD(dd,0,DATEDIFF(dd,0,@AcilisTarihSaat))   
      set @AcilisSaat=CONVERT(VARCHAR(8),@AcilisTarihSaat,108) 


      /*MarVardiMas Kontrol ve Olustur  */ 
      
      if @Tip=1
      Select @VarNo=id From marvardimas with (nolock) 
        where firmano=@Firmano and Yaz_KNo=@KasaNo And Zno=@Zno and Sil=0 and isnull(Varok,0)=0
        
      if @Tip=2
       Select @VarNo=id From marvardimas with (nolock) 
         where firmano=@Firmano and Yaz_KNo=@KasaNo And YazarKasaVardiyaNo=@YazarKasaVardiyaNo and Sil=0 and isnull(Varok,0)=0   
        

       if isnull(@VarNo,0)=0
        exec @Varno=SpYazarKasaServisMarketVardiyaAc 
         @Firmano,@AcilisTarih,@AcilisSaat,@OlusUser,@DepoKod,@PersonelKod,
         @Zno,@KasaNo,@YazarKasaVardiyaNo
      
      /*MarSatMas Kontrol ve Olustur  */ 

       if @Tip=1
       declare CurMarSat CURSOR FAST_FORWARD  FOR 
       Select Tarih,FisNo,@Zno,Sum(Carpan*Tutar) Tutar from Yazarkasa_Satis with (nolock) 
       Where Trans=0 and Zno=@Zno and KasaNo=@KasaNo
       Group By Tarih,FisNo
       
       if @Tip=2
       declare CurMarSat CURSOR FAST_FORWARD  FOR 
       Select Tarih,FisNo,Zno,Sum(Carpan*Tutar) Tutar from Yazarkasa_Satis with (nolock) 
       Where Trans=0 and VardiyaNo=@YazarKasaVardiyaNo and KasaNo=@KasaNo
       Group By Tarih,FisNo,Zno
       
       
       
	    
        open CurMarSat
       fetch next from  CurMarSat into @FisTarihSaat,@FisNo,@Zno,@FisTutar
       while @@FETCH_STATUS=0
         begin
                  
         
         
         Set @MarSatId=0
         
         set @FisTarih=DATEADD(dd,0,DATEDIFF(dd,0,@FisTarihSaat))   
         set @FisSaat=CONVERT(VARCHAR(8),@FisTarihSaat,108) 
         
         Select @MarSatId=id From marsatmas with (nolock) 
         where Varno=@VarNo And Fis_No=@FisNo and Zno=@Zno and Sil=0
   
         if isnull(@MarSatId,0)=0
          begin
            insert into marsatmas (Firmano,varno,marsatid,islmtip,islmtipad,yertip,yerad,
            tarih,saat,kayok,olususer,olustarsaat,yazarkasa_id,Fis_No,YazarKasaIslemId,
            parabrm,cartip,carkod,Zno)
            values (@Firmano,@VarNo,0,@IslemTip,@IslemTipAd,@YerTip,@YerTipAd,
            @FisTarih,@FisSaat,0,@OlusUser,GetDate(),0,@FisNo,0,
            @ParaBirim,'vardikasa','VRDKASA',@Zno)

            select @MarSatId=SCOPE_IDENTITY()
            
            insert into @T (MarSatId) values (@MarSatId) 
          
            update marsatmas set marsatid=id where id=@MarSatId
          end
          
          
        /* 
         marsatmas,marsatid,
         Firmano,varno,islmtip,islmtipad,yertip,yerad,tarih,saat,
         kayok,olususer,olustarsaat,yazarkasa_id,Fis_No,YazarKasaIslemId],
         [DB_Ayar.Firmano,varno,islmtip,IslmTip_Ad,Yertip,Yertip_Ad,formatdatetime('yyyymmdd',Satis_Rec[0].TarihSaat),
         formatdatetime('hh:mm:ss',Satis_Rec[0].TarihSaat),0,'YKASA SERVIS',formatdatetime('yyyymmdd hh:mm:ss',now),
         Satis_Rec[0].Id,Satis_Rec[0].Fis_No,Satis_Rec[0].YazarKasaIslemId])
         */
         
         
         
         
          /* MarsatHrk Kontrol ve Olustur   */ 
          if @Tip=1
           declare CurMarSatHrk CURSOR FAST_FORWARD  FOR 
           Select id,StokId,StokKod,Barkod,Carpan*Miktar,BrimFiyat,Kdv,Brim  
           from Yazarkasa_Satis with (nolock) 
           Where Trans=0 and Zno=@Zno and KasaNo=@KasaNo and FisNo=@FisNo
           
           
           if @Tip=2 
           declare CurMarSatHrk CURSOR FAST_FORWARD  FOR 
           Select id,StokId,StokKod,Barkod,Carpan*Miktar,BrimFiyat,Kdv,Brim  
           from Yazarkasa_Satis with (nolock) 
           Where Trans=0 and VardiyaNo=@YazarKasaVardiyaNo and KasaNo=@KasaNo and FisNo=@FisNo
           and Zno=@Zno
           
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

            update YazarKasa_Satis Set Trans=1 Where id=@YazarKasaServisLogId

               
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
          
          
        set @KasaHrkId=0     
        select @KasaHrkId=id From markasahrk with (nolock) Where marsatid=@MarSatId     
       
       if isnull(@KasaHrkId,0)=0
        begin
        insert into markasahrk (Firmano,varno,gctip,marsatid,kaskod,
         kashrkid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
         tarih,saat,olususer,olustarsaat,giren,cikan,kur,parabrm,perkod)
        values (@Firmano,@VarNo,'G',@MarSatId,'VRDKASA',
         0,'TAH','TAHSÄ°LAT','NAK','NAKÄ°T TAHSÄ°LAT',@YerTip,@YerTipAd,
         @FisTarih,@FisSaat,@OlusUser,GetDate(),
         @Giren,@Cikan,1,@ParaBirim,@PersonelKod)

         select @KasaHrkId=SCOPE_IDENTITY() 
          
         update markasahrk set kashrkid=id where id=@KasaHrkId

       end 
       else
         update markasahrk set giren=@Giren,cikan=abs(@Cikan) where marsatid=@MarSatId 

       
       
        /*satistop,iadetop,NakTop=satistop-iadetop, */
        update MarSatMas Set KayOk=1,
        NakTop=case when abs(@Cikan)>0 then @Cikan else abs(@FisTutar) end,
        satistop=@Giren,iadetop=abs(@Cikan)
        Where id=@MarSatId
   
         
         
        fetch next from  CurMarSat into @FisTarihSaat,@FisNo,@Zno,@FisTutar
       
     end
      close CurMarSat
      deallocate CurMarSat
  
         

       fetch next from  CurMarVar into @Firmano,@Zno,@YazarKasaVardiyaNo,@KasaNo,
       @AcilisTarihSaat,@KapanisTarihSaat 
     end
      close CurMarVar
      deallocate CurMarVar




   /* oklenmemis kayit kontrolu  */
     update marsatmas set kayok=0 where 
     marsatid in (
     select marsatid 
     from marsathrk with (nolock)
     where sil=0 
     and varno=@VarNo and id not in 
     (select stkhrkid from stkhrk
     with (nolock)  where 
      varno=@VarNo and sil=0 
      and tabload='marsathrk') 
      group by marsatid  )
    
    
     update marsatmas set kayok=1 where 
     marsatid in (
     select marsatid 
     from marsathrk with (nolock) 
     where sil=0 
     and varno=@VarNo and id not in 
     (select stkhrkid  from stkhrk
     with (nolock) where 
      varno=@VarNo and sil=0 
      and tabload='marsathrk')
      group by marsatid )
    
    /*
     declare CurMarSatx CURSOR FAST_FORWARD  FOR 
       Select t.MarSatId  from @T as t 
       inner join marsatmas as m with (nolock) on m.id=t.MarSatId
       and m.KayOk=0
       
       open CurMarSatx
        fetch next from  CurMarSatx into @MarSatId  
         while @@FETCH_STATUS=0
            begin  

            update MarSatMas Set KayOk=1 Where id=@MarSatId
   
        fetch next from  CurMarSatx into @MarSatId
      end
      close CurMarSatx
      deallocate CurMarSatx
*/
     return



END

================================================================================
