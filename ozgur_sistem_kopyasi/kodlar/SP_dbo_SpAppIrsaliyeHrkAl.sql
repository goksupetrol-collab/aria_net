-- Stored Procedure: dbo.SpAppIrsaliyeHrkAl
-- Tarih: 2026-01-14 20:06:08.368489
================================================================================

CREATE PROCEDURE dbo.[SpAppIrsaliyeHrkAl]
@DeviceId  varchar(50),
@AppIrsaliyeId  int,
@BackIrsaliyeId  int,
@SiraNo      int,
@TarihSaat  datetime,
@BarkodNo   varchar(30),
@Miktar   float ,
@Fiyat   float ,
@UserId     int
AS
BEGIN
  
   Declare @Id     int 
   Declare @IrsaliyeHrkId  int
   Declare @Firmano  int
   Declare @Tarih  Datetime
   Declare @DepoId   int
   Declare @DepoKod   varchar(50)
   Declare @StokId     int 
   Declare @StokTipId     int 
   Declare @StokTip   varchar(10)
   Declare @StokKod   varchar(50)
   Declare @StokKdv   float
   Declare @OlusturmaUnvan   varchar(150)
   
   select @OlusturmaUnvan=ad from  users where id=@UserId
   
   
   select @Firmano=firmano,@Tarih=TarihSaat,@DepoKod=DepoKod 
   from AppIrsaliyeMas with (nolock) Where Id=@AppIrsaliyeId
   
   
   select @DepoId=id from depokart with (nolock) where kod=@DepoKod and Sil=0 
   

   select @StokTip=tip,@StokKod=kod from barkod as b with (nolock)
   where b.barkod=@BarkodNo and b.sil=0
   
   select @StokId=id,@StokKdv=sat1kdv,@StokTipId=2 /*tip_id  */
   from stokkart as k with (nolock)
   where k.tip=@StokTip and k.kod=@StokKod and k.sil=0
  


   select @Id=Id from AppIrsaliyeHrk with (nolock) Where DeviceId=@DeviceId
   and AppIrsaliyeId=@AppIrsaliyeId and SiraNo=@SiraNo

   if isnull(@Id,0)=0
   insert into AppIrsaliyeHrk (DeviceId,AppIrsaliyeId,SiraNo,TarihSaat,BarkodNo,
   Miktar,Fiyat,StokTip,StokKod,OlusturmaTarihSaat,OlusturmaUnvan)
   select @DeviceId,@AppIrsaliyeId,@SiraNo,@TarihSaat,@BarkodNo,
   @Miktar,@Fiyat,@StokTip,@StokKod,GetDate(),@OlusturmaUnvan
   

   select @IrsaliyeHrkId=id from irsaliyehrk with (nolock) Where irid=@BackIrsaliyeId
   and AppSiraNo=@SiraNo and Sil=0 
   
   if isnull(@IrsaliyeHrkId,0)=0
   begin  
   
    insert into irsaliyehrk (AppSiraNo,irid,firmano,kdvtip,
    stktip,stkod,mik,carpan,brim,ustbrim,kdvyuz,kdvtut,
    depkod,dataok,grupid,olususer,olustarsaat,brmfiy,sil,sipid,kayok,parabrim,kur,
    stktip_id,stk_id,dep_id,Kart_ParaBrm,Kart_Kur,Islem_ParaBrm,Islem_Kur,
    kesafet,barkod,remote_id,satiskyuz,satisktut,geniskyuz,genisktut)
    select @SiraNo,@BackIrsaliyeId,@Firmano,'' kdvtip,
     @StokTip stktip,@StokKod,@Miktar,1 carpan,'AD' brim,'' ustbrim,(@StokKdv/100) kdvyuz,0 kdvtut,
     @DepoKod,0 dataok,
     0 grupid,@OlusturmaUnvan,GetDate(),@Fiyat,0 sil,0 sipid,1 kayok,'TL',1,
     @StokTipId,@StokId,@DepoId,'TL' Kart_ParaBrm,1 Kart_Kur,'TL' Islem_ParaBrm,1 Islem_Kur,
     1 kesafet,@BarkodNo,0 remote_id,0 satiskyuz,0 satisktut,0 geniskyuz,0 genisktut 
   
 
  end
  
  
 
  
  

END

================================================================================
