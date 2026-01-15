-- Function: dbo.UDF_CariFisVadeFark_Tarih
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.706839
================================================================================

CREATE FUNCTION [dbo].[UDF_CariFisVadeFark_Tarih] 
(@CariKod  VARCHAR(50),
@BitTarih   Datetime)
RETURNS
    @TB_VADE_FARK TABLE (
    CARI_KOD    	VARCHAR(30) COLLATE Turkish_CI_AS,
    CARI_VADETUTAR  FLOAT)
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
   
   declare @Devirlimi int
   set @Devirlimi=0
   
   Declare @GunTarih Datetime
   Set @GunTarih=DATEADD(day, DATEDIFF(day, 0, @BitTarih),0)
   
  if @CariKod<>'' 
  insert into @TABLE_BAKIYE_BORC (TId,KTip,CariTip,CariKod,VadeTarih,DevirliVadeTarih,OdemeTarih,Borc,Alacak)
  Select id,1 KTip,cartip,carkod,Tarih,null,null,Round(Borc,2),Round(Alacak,2) From CariHrk with (nolock) 
  Where cartip='carikart' and carkod=@CariKod
  and Sil=0 and islmhrk not in ('FATVERSAT') and 
  carkod in (select Kod From Carikart with (nolock) Where Kod=@CariKod 
  and Sil=0 and Oto_FisVadeFark=1)
  union all 
  
  Select id,1 KTip,cartip,carkod,Tarih,
  DevirliVadeTarih,@GunTarih,0 Borc,Round(toptut,2) Alacak From veresimas with (nolock) 
  Where cartip='carikart' and carkod=@CariKod and Sil=0 and fistip = 'FISALCSAT'
  and carkod in (select Kod From Carikart with (nolock) Where Kod=@CariKod and Sil=0 and Oto_FisVadeFark=1)
  union all 
  
  Select id,2 KTip,cartip,carkod, 
  case 
  when @Devirlimi=0  and DevirliVadeTarih is not null then DevirliVadeTarih 
  when @Devirlimi=0  and DevirliVadeTarih is null then VadTar 
  when @Devirlimi=1  then  VadTar 
  end, 
  DevirliVadeTarih,@GunTarih,Round(toptut,2) Borc,0 Alacak From veresimas with (nolock) 
  Where cartip='carikart' and carkod=@CariKod and Sil=0 and fistip != 'FISALCSAT'
  and carkod in (select Kod From Carikart with (nolock) Where Kod=@CariKod and Sil=0 and Oto_FisVadeFark=1)
  order By Carkod
  
  else
  
  insert into @TABLE_BAKIYE_BORC (TId,KTip,CariTip,CariKod,VadeTarih,DevirliVadeTarih,OdemeTarih,Borc,Alacak)
  Select id,1 KTip,cartip,carkod,Tarih,null,null,Round(Borc,2),Round(Alacak,2) From CariHrk with (nolock) 
  Where cartip='carikart' and Sil=0 and islmhrk not in ('FATVERSAT') and 
  carkod in (select Kod From Carikart with (nolock) Where Sil=0 and Oto_FisVadeFark=1)
  union all 
  
  Select id,1 KTip,cartip,carkod,
  case 
  when @Devirlimi=0  and DevirliVadeTarih is not null then DevirliVadeTarih 
  when @Devirlimi=0  and DevirliVadeTarih is null then VadTar 
  when @Devirlimi=1  then  VadTar 
  end,
  DevirliVadeTarih,@GunTarih,0 Borc,Round(toptut,2) Alacak From veresimas with (nolock)
  Where cartip='carikart' and Sil=0 and fistip = 'FISALCSAT'
  and carkod in (select Kod From Carikart with (nolock)  Where Sil=0 and Oto_FisVadeFark=1)
  union all 
  
  
  Select id,2 KTip,cartip,carkod,
  case 
  when @Devirlimi=0  and DevirliVadeTarih is not null then DevirliVadeTarih 
  when @Devirlimi=0  and DevirliVadeTarih is null then VadTar 
  when @Devirlimi=1  then  VadTar  
  end,    
  DevirliVadeTarih,@GunTarih,Round(toptut,2) Borc,0 Alacak From veresimas with (nolock)
  Where cartip='carikart' and Sil=0 and fistip != 'FISALCSAT'
  and carkod in (select Kod From Carikart with (nolock)  Where Sil=0 and Oto_FisVadeFark=1)
  order By Carkod
  
  
  
  
  
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
    Declare @FisVadeTarih  Datetime
     
  /*- Vade Fark Hesapla */
 
    Declare @STarih Datetime
    declare pom_var CURSOR FAST_FORWARD  FOR 
     select Id,CariKod,Round(Alacak,2),VadeTarih as OdemeTarih from @TABLE_BAKIYE_BORC 
     where Round(Alacak,2)>0  /* and KTip=1  */
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
        set @FisVadeTarih=null
        
        
        
        /*Fiş Borç ve Vade Tarihi Bilgileri */
         Select top 1 @TempId=Id,@FisBorc=Round(Borc,2),@FisVadeTarih=VadeTarih From @TABLE_BAKIYE_BORC 
         Where CariKod=@Kod and round(Borc-Odenen,2)>0 and Bolundu=0 /*and KTip=2 */
         order by VadeTarih,TId
       
       
         /* print('Id='+cast(@Id as  varchar(20))+' TempId='+cast(@TempId as  varchar(20)) ) */
       
          if @TempId is null  /*Bakiye Yoksa */
          begin
            set @sayac=@MaxSayac
            break
            /*set  @OdemeTarih=@DevirTarih--DATEADD(day, DATEDIFF(day, 0, GetDate()), 0) */
            
          end  
         else 
          begin
             /*Fis Bakiyesi Alacaktan Buyukse İse */
             /* Kalan Borc Kadar Yeni Fis Hrk Olustur */
                     
             
             
             if @AlacakBakiye<@FisBorc
              begin
               set @FisBakiye=(@FisBorc-@AlacakBakiye)
               
                insert into @TABLE_BAKIYE_BORC (TId,KTip,CariTip,CariKod,VadeTarih,DevirliVadeTarih,Borc,Alacak)
                select TId,KTip,CariTip,CariKod,case when @FisVadeTarih>@OdemeTarih then @FisVadeTarih else @OdemeTarih end,
                DevirliVadeTarih,@FisBakiye,0  from @TABLE_BAKIYE_BORC
                where Id=@TempId               /*VadeTarih */
                 
                /*borc İcin    */
                update @TABLE_BAKIYE_BORC set OdemeTarih=@OdemeTarih,Odenen=@AlacakBakiye,Bolundu=1 where Id=@TempId 
              
                 /*Odeme İşlemi İçin  */
                 update @TABLE_BAKIYE_BORC set Odenen=Odenen+@AlacakBakiye where Id=@Id 
              
               set @AlacakBakiye=0
               set @sayac=@MaxSayac
               
               /* print('BREAK Id='+cast(@Id as  varchar(20))+' TempId='+cast(@TempId as  varchar(20)) ) */
                
                BREAK
               
              end
             /*borc Bakiyesi Alacaktan Kücük İse  */
                          
              if @AlacakBakiye>=@FisBorc
              begin
                 
                /*borc İçin                  */
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
    join (select id,kod,fisvadfark from carikart with (nolock) )
     dt on dt.Kod=t.CariKod
  
   Update @TABLE_BAKIYE_BORC Set VadeTutar=0,VadeGun=0
   
    
    update @TABLE_BAKIYE_BORC set  OdemeTarih=@GunTarih 
    where OdemeTarih is null and Ktip=2
  
    
    Update @TABLE_BAKIYE_BORC Set VadeGun=
    case when round(CONVERT(float, OdemeTarih - VadeTarih),0)>0 then 
    round(CONVERT(float, OdemeTarih - VadeTarih),0) else 0 end
    Where Ktip=2  /*Sadece Fis İslemine */

   
    Update @TABLE_BAKIYE_BORC Set VadeTutar=Borc*(VadeGun*(VadeOran/30)/100)
    


     Declare @Saat varchar(10)
  
     Set @Tarih=@GunTarih
     Set @Saat=CONVERT(VARCHAR(8),GETDATE(),108)
    
   
   if @CariKod<>''
       INSERT @TB_VADE_FARK
       select CariKod,Sum(isnull(VadeTutar,0)) AS VadeTutar from @TABLE_BAKIYE_BORC Group By CariKod

       

   RETURN


END

================================================================================
