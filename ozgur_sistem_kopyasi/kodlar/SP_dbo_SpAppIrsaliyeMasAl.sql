-- Stored Procedure: dbo.SpAppIrsaliyeMasAl
-- Tarih: 2026-01-14 20:06:08.368718
================================================================================

CREATE PROCEDURE dbo.[SpAppIrsaliyeMasAl]
@DeviceId  varchar(50),
@FirmaNo     int,
@TarihSaat  datetime,
@Seri   varchar(10),
@SeriNo   varchar(20),
@CariKod   varchar(50),
@DepoKod   varchar(50),
@UserId     int
AS
BEGIN
  
   Declare @Id     int 
   Declare @IrsaliyeId     int 
   Declare @IrsaliyeRapId     int 
   Declare @IrsaliyeTipId     int 
   Declare @CariId     int 
   Declare @OlusturmaUnvan   varchar(150)
   
   select @OlusturmaUnvan=ad from  users with (nolock) where id=@UserId
   select @CariId=id from carikart with (nolock) Where Kod=@CariKod and Sil=0 

  
   select @Id=Id from AppIrsaliyeMas with (nolock) Where DeviceId=@DeviceId
   and TarihSaat=@TarihSaat and Seri=@Seri and SeriNo=@SeriNo
   
   select top 1 @IrsaliyeRapId=id,@IrsaliyeTipId=tip_id from raporlar where rapkod='IRSMRALS'
   
   

   if isnull(@Id,0)=0
   begin
     insert into AppIrsaliyeMas (DeviceId,Firmano,TarihSaat,Seri,SeriNo,
     CariKod,DepoKod,OlusturmaTarihSaat,OlusturmaUnvan)
     select @DeviceId,@FirmaNo,@TarihSaat,@Seri,@SeriNo,
     @CariKod,@DepoKod,GetDate(),@OlusturmaUnvan
     select @Id=SCOPE_IDENTITY()
   end
   
   
   select @IrsaliyeId=id from irsaliyemas with (nolock) Where FirmaNo=@FirmaNo
   and irseri=@Seri and irno=@SeriNo and Sil=0 
   
  
  if isnull(@IrsaliyeId,0)=0
   begin
    insert into irsaliyemas (irid,firmano,kayok, sil, irtip, irad,
    irturad,irtur,irseri,irno ,tarih,vadtar,kdvtip,ack,kdvtut,
     depo,dataok,olususer,olustarsaat,irtop,kdvtop,cartip,carkod,
    saat,aktip,akid,sevktar,yertip,yerad,gctip,irstip_id,irstur_id,
    irsrap_id,car_id,cartip_id,hrk_car_pro,hrk_stk_pro,Kart_ParaBrm,Kart_Kur,Islem_ParaBrm,
    Islem_Kur,genel_ara_top,genel_top,genel_kdv_top,yuvtop,remote_id,
    genel_net_top) 
    
    select 0,@FirmaNo,0,0,'IRSMRALS','MARKET ALIŞ İRSALİYESİ',
    '','',@Seri,@SeriNo,@TarihSaat,@TarihSaat,'Hariç','['+@Seri+@SeriNo + ' / MARKET ALIŞ İRSALİYE]',0,
    @DepoKod,0,@OlusturmaUnvan,GetDate(),0,0,'carikart',@Carikod,
    '00:00:00','BK',0,@TarihSaat,'AppIrsaliye','App Irsaliye',1,@IrsaliyeTipId,4,
    @IrsaliyeRapId,@CariId,1,0,1,'TL',1,'TL',
    1,0,0,0,0,0,0
    
    SELECT @IrsaliyeId=SCOPE_IDENTITY()
   end
   
   select @Id as Id,@IrsaliyeId IrsaliyeId
   

END

================================================================================
