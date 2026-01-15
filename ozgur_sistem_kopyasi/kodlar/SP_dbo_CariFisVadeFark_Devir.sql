-- Stored Procedure: dbo.CariFisVadeFark_Devir
-- Tarih: 2026-01-14 20:06:08.318168
================================================================================

CREATE PROCEDURE [dbo].[CariFisVadeFark_Devir]
@CariKod  varchar(50),
@DevirTarih     datetime
AS
BEGIN


 


   declare @TABLE_BAKIYE_BORC TABLE (
   Id					int IDENTITY(1, 1) NOT NULL,
   TId					int ,
   CariTip			    VARCHAR(20) COLLATE Turkish_CI_AS,
   CariTip_Id			int,
   CariId				int,
   CariKod				VARCHAR(30) COLLATE Turkish_CI_AS,
   Bolundu              int default 0,
   KTip                 int,
   Borc      			Float,
   Alacak				Float,
   Odenen				Float default 0,
   VadeTarih			DateTime,
   DevirliVadeTarih	    DateTime,
   VadeOran			    float,
   VadeGun				int,
   OdemeTarih			DateTime,
   VadeTutar			float)
   
   
   
   
   /*Vade Fark Tutarlar Sil */
   
  if @CariKod<>''
  begin 
     delete From carihrk where islmtip='VAD' and islmhrk='OFD' 
     and cartip='carikart' and carkod=@CariKod and belno=YEAR(@DevirTarih)
     
     update veresimas Set DevirliVadeTarih=null 
     Where cartip='carikart' and carkod=@CariKod and Sil=0  and DevirliVadeTarih=@DevirTarih
     and carkod in (select Kod From Carikart with (nolock) Where Kod=@CariKod and Sil=0 and Oto_FisVadeFark=1)
  end  
  else
   begin
     delete From carihrk where islmtip='VAD' and islmhrk='OFD' and belno=YEAR(@DevirTarih)
    
     update veresimas Set DevirliVadeTarih=null 
     Where cartip='carikart' and Sil=0  and DevirliVadeTarih=@DevirTarih
     and carkod in (select Kod From Carikart with (nolock) Where Sil=0 and Oto_FisVadeFark=1)
    
   end 


  



 if @CariKod<>'' 
  insert into @TABLE_BAKIYE_BORC (TId,KTip,CariTip,CariKod,VadeTarih,DevirliVadeTarih,OdemeTarih,Borc,Alacak)
  Select id,1 KTip,cartip,carkod,Tarih,null,null,Round(Borc,2),Round(Alacak,2) From CariHrk with (nolock) 
  Where cartip='carikart' and carkod=@CariKod
  and Sil=0 and islmhrk not in ('FATVERSAT') and 
  carkod in (select Kod From Carikart with (nolock) Where Kod=@CariKod 
  and Sil=0 and Oto_FisVadeFark=1)
  union all 
  /*if @TarihYon=1  */
  /*insert into @Temp (TId,Tip,CariTip,CariKod,VadeTarih,DevirliVadeTarih,Borc,Alacak) */
  Select id,2 KTip,cartip,carkod,case when DevirliVadeTarih is not null then DevirliVadeTarih else VadTar end,
  DevirliVadeTarih,@DevirTarih,Round(toptut,2) Borc,0 Alacak From veresimas with (nolock) 
  Where cartip='carikart' and carkod=@CariKod and Sil=0 /*and VadTar<=@DevirTarih */
  and carkod in (select Kod From Carikart with (nolock) Where Kod=@CariKod and Sil=0 and Oto_FisVadeFark=1)
  order By Carkod
  else
  insert into @TABLE_BAKIYE_BORC (TId,KTip,CariTip,CariKod,VadeTarih,DevirliVadeTarih,OdemeTarih,Borc,Alacak)
  Select id,1 KTip,cartip,carkod,Tarih,null,null,Round(Borc,2),Round(Alacak,2) From CariHrk with (nolock) 
  Where cartip='carikart' and Sil=0 and islmhrk not in ('FATVERSAT') and 
  carkod in (select Kod From Carikart with (nolock) Where Sil=0 and Oto_FisVadeFark=1)
  union all 
  Select id,2 KTip,cartip,carkod,case when DevirliVadeTarih is not null then DevirliVadeTarih else VadTar end,
  DevirliVadeTarih,@DevirTarih,Round(toptut,2) Borc,0 Alacak From veresimas with (nolock)
  Where cartip='carikart' and Sil=0 /*and VadTar<=@DevirTarih */
  and carkod in (select Kod From Carikart with (nolock) Where Sil=0 and Oto_FisVadeFark=1)
  order By Carkod
  
  
  
  
   
    
    
    /* declare @T_Kod  varchar(50)
     Set @T_Kod=''
     set @Cari_Tip='carikart'
     
     ---- Bakiye Hesapla
    
     declare pom_var CURSOR FAST_FORWARD  FOR 
     select TId,KTip,CariKod,VadeTarih,DevirliVadeTarih,Borc,Alacak from @Temp order by CariKod,VadeTarih 
     open pom_var
     fetch next from  pom_var into @TId,@KTip,@Kod,@Tarih,@DevirliVadeTarih,@Borc,@Alacak
      while @@FETCH_STATUS=0
      begin
  
      if @T_Kod<>@Kod 
      begin
       set @Bakiye=@Borc-@Alacak
      end
       else
        set @Bakiye=@Bakiye+@Borc-@Alacak
      
      
       Set @Tip=1 
      if  @Alacak>0 
        Set @Tip=2 
       
       
      insert into @TABLE_BAKIYE_BORC (TId,KTip,Tip,CariTip,CariKod,VadeTarih,DevirliVadeTarih,Borc,Alacak,Bakiye)
      values (@TId,@KTip,@Tip,@Cari_Tip,@Kod,@Tarih,@DevirliVadeTarih,@Borc,@Alacak,@Bakiye)
   
      Set @T_Kod=@Kod 
  
  
      FETCH next from  pom_var into @TId,@KTip,@Kod,@Tarih,@DevirliVadeTarih,@Borc,@Alacak
     end
    close Pom_Var
    deallocate pom_var
    
    
  
  --- Vade Fark Hesapla
    Set @T_Kod=''
    Declare @STarih Datetime
    declare pom_var CURSOR FAST_FORWARD  FOR 
     select Id,CariKod,Bakiye from @TABLE_BAKIYE_BORC where Tip=1 order by Id 
     open pom_var
     fetch next from  pom_var into @Id,@Kod,@Bakiye
      while @@FETCH_STATUS=0
      begin
  
      
      
       if @Bakiye>0
       begin   
        Set @STarih=null
        
        Select top 1 @STarih=VadeTarih From @TABLE_BAKIYE_BORC Where CariKod=@Kod and ID>@Id and Tip=2
       
         if @STarih is null
         set  @STarih=@DevirTarih--DATEADD(day, DATEDIFF(day, 0, GetDate()), 0)
        
         --if @STarih<=@BitTarih
           update @TABLE_BAKIYE_BORC set OdemeTarih=@STarih where Id=@Id
       
       
       end
      
      
           
    
  
  
      FETCH next from  pom_var into @Id,@Kod,@Bakiye
     end
    close Pom_Var
    deallocate pom_var
    */
    
    
    declare @Id int,@TId int,@Say int,@KTip int
    declare @Kod varchar(50),@Cari_Tip  varchar(30)
    declare @Borc Float,@Alacak  Float
    declare @Bakiye  Float
    declare @Tarih  Datetime
    declare @DevirliVadeTarih Datetime
    
    Declare @Odenen  float  /*Hem Fiş Hemde Alacaktan Düşecek */
    Declare @FisBorc  float
    Declare @FisBakiye  float
    Declare @AlacakBakiye  float
    
    Declare @TempId	  float
    Declare @Sayac  int,@MaxSayac int
    Declare @OdemeTarih  Datetime
    
     
    /*- Vade Fark Hesapla */
 
    Declare @STarih Datetime
    declare pom_var CURSOR FAST_FORWARD  FOR 
     select Id,CariKod,Round(Alacak,2),VadeTarih as OdemeTarih from @TABLE_BAKIYE_BORC 
     where  Round(Alacak,2)>0  /* and KTip=1 */
     order by CariKod,VadeTarih
     open pom_var
     fetch next from  pom_var into @Id,@Kod,@Alacak,@OdemeTarih
      while @@FETCH_STATUS=0
      begin
  
  
       set @AlacakBakiye=@Alacak
       
       set @Sayac=1
       set @MaxSayac=50
      
        
      
      
       while @Sayac<@MaxSayac 
       begin
       
        Set @TempId=null
        
        
        
        /* Borc ve Vade Tarihi Bilgileri */
         Select top 1 @TempId=Id,@FisBorc=Round(Borc,2) From @TABLE_BAKIYE_BORC 
         Where CariKod=@Kod and round(Borc-Odenen,2)>0 and Bolundu=0  /*and KTip=2 */
         order by VadeTarih,TId
       
       
         /* print('Id='+cast(@Id as  varchar(20))+' TempId='+cast(@TempId as  varchar(20)) ) */
       
          if @TempId is null  /*Bakiye Yoksa */
          begin
            set @sayac=@MaxSayac
            /*set  @OdemeTarih=@DevirTarih--DATEADD(day, DATEDIFF(day, 0, GetDate()), 0) */
            
          end  
         else 
          begin
             /*Borc Bakiyesi Alacaktan Buyukse İse */
             /* Kalan Borc Kadar Yeni Fis Hrk Olustur */
                     
             
             
             if @AlacakBakiye<@FisBorc
              begin
               set @FisBakiye=(@FisBorc-@AlacakBakiye)
               
                insert into @TABLE_BAKIYE_BORC (TId,KTip,CariTip,CariKod,VadeTarih,DevirliVadeTarih,Borc,Alacak)
                select TId,KTip,CariTip,CariKod,VadeTarih,DevirliVadeTarih,@FisBakiye,0  from @TABLE_BAKIYE_BORC
                where Id=@TempId
                 
                /*Borc İcin    */
                update @TABLE_BAKIYE_BORC set OdemeTarih=@OdemeTarih,Odenen=@AlacakBakiye,Bolundu=1 where Id=@TempId 
              
                 /*Odeme İşlemi İçin  */
                 update @TABLE_BAKIYE_BORC set Odenen=Odenen+@AlacakBakiye where Id=@Id 
              
               set @AlacakBakiye=0
               set @sayac=@MaxSayac
               
               /* print('BREAK Id='+cast(@Id as  varchar(20))+' TempId='+cast(@TempId as  varchar(20)) ) */
                
                BREAK
               
              end
             /*Borc Bakiyesi Alacaktan Kücük İse  */
                          
              if @AlacakBakiye>=@FisBorc
              begin
                 
                /*Borc İçin                  */
                update @TABLE_BAKIYE_BORC set OdemeTarih=@OdemeTarih,Odenen=@FisBorc where Id=@TempId 
        
                 /*Odeme İşlemi İçin  */
                 update @TABLE_BAKIYE_BORC set Odenen=Odenen+@FisBorc where Id=@Id 
        
        
                set @AlacakBakiye=@AlacakBakiye-@FisBorc
                
                set @sayac=@sayac+1
              end
             
             
             
          end 
       
       
          
       end
  
  
      FETCH next from  pom_var into @Id,@Kod,@Alacak,@OdemeTarih
     end
    close Pom_Var
    deallocate pom_var
    
    
    update @TABLE_BAKIYE_BORC Set CariId=dt.id,VadeOran=Dt.fisvadfark 
    From @TABLE_BAKIYE_BORC as t
    join (select id,kod,fisvadfark from carikart) dt on dt.Kod=t.CariKod
  
    Update @TABLE_BAKIYE_BORC Set VadeTutar=0,VadeGun=0
   
    
    Update @TABLE_BAKIYE_BORC Set VadeGun=
    case when CONVERT(float, OdemeTarih - VadeTarih)>0 then 
    CONVERT(float, OdemeTarih - VadeTarih)  else 0 end
    Where Ktip=2  /*Sadece Fis İslemine */

   
    Update @TABLE_BAKIYE_BORC Set VadeTutar= Borc*(VadeGun*(VadeOran/30)/100)
    
    
    /*if @GunTarih>@DevirTarih */
    /*Update @TABLE_BAKIYE_BORC Set Vade_Tutar=0 where Odeme_Tarih<=@DevirTarih */
    
    /*if @GunTarih=@DevirTarih */
    Update @TABLE_BAKIYE_BORC Set VadeTutar=0 where OdemeTarih>=@DevirTarih
    
    
   /*  Declare @Tarih Datetime */
     Declare @Saat varchar(10)
  
     Set @Tarih=@DevirTarih
     Set @Saat='00:00:00'
    
    
    if @CariKod<>''
     delete From VeresiVadeFarkHrk where Tarih=@Tarih 
     and CarId in (Select id from carikart Where kod=@CariKod)
    else
     delete From VeresiVadeFarkHrk where Tarih=@Tarih 
 

    
     insert into VeresiVadeFarkHrk (CarTip,CarId,Tarih,VadeOran,Borc,Alacak,VadeFark,
      olususer,olustarsaat)
      select 1,CariId,@Tarih,
      max(VadeOran),Sum(Borc) Borc,Sum(Alacak) Alacak,
      sum(VadeTutar),'SERVIS',GetDate() from @TABLE_BAKIYE_BORC group by CariId


     
     insert into carihrk (carhrkid,gctip,yerad,yertip,
     islmtip,islmhrk,islmtipad,islmhrkad,cartip,cartip_id,carkod,car_id,
     borc,alacak,bakiye,vadetar,tarih,saat,ack,olususer,olustarsaat,masterid,varno,belno) 
     select 0,'G','CARİ KART','carikart','VAD','OFD',
     'VADE','CARİ OTO. FİŞ VADE DEVİR','carikart',1,CariKod,CariId,
     sum(ISNULL(VadeTutar,0)),
     0,0,@Tarih,@Tarih,
     @Saat,'OTOMATİK FİŞ VADE DEVİR','SERVIS',GetDate(),0,0,YEAR(@DevirTarih) 
     from @TABLE_BAKIYE_BORC group by 
     CariKod,CariId
     
     
     update carihrk set carhrkid=id where tarih=@Tarih 
     and islmtip='VAD' and islmhrk='OFD' and belno=YEAR(@DevirTarih)
    
     update veresimas set DevirliVadeTarih=@DevirTarih where 
     DevirliVadeTarih is null and id in 
     (Select TId From @TABLE_BAKIYE_BORC 
     Where KTip=2 and OdemeTarih<@DevirTarih and VadeTarih<@DevirTarih ) 
    
    select * from @TABLE_BAKIYE_BORC order by VadeTarih

    select CariKod,Sum(isnull(VadeTutar,0)) from @TABLE_BAKIYE_BORC    Group By CariKod


END

================================================================================
