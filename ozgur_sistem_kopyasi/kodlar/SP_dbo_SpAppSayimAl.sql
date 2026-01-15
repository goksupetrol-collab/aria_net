-- Stored Procedure: dbo.SpAppSayimAl
-- Tarih: 2026-01-14 20:06:08.370388
================================================================================

CREATE PROCEDURE dbo.SpAppSayimAl
@BackSayimId  int,
@DeviceId  varchar(50),
@AppSayimId  int,
@SiraNo      int,
@TarihSaat  datetime,
@BarkodNo   varchar(30),
@Miktar   float ,
@UserId     int
AS
BEGIN
  
   Declare @Id     int 
   Declare  @StokTip   varchar(10)
   Declare @StokKod   varchar(50)
   /*Declare @OlusturmaTarihSaat datetime */
   Declare @OlusturmaUnvan   varchar(150)
   
   select @OlusturmaUnvan=ad from  users where id=@UserId

   
   select @StokTip=tip,@StokKod=kod from barkod as b with (nolock)
   where b.barkod=@BarkodNo and b.sil=0
   
  
   select @Id=Id from AppSayim Where DeviceId=@DeviceId
   and AppSayimId=@AppSayimId and SiraNo=@SiraNo and BackSayimId=@BackSayimId

   if isnull(@Id,0)=0
   insert into AppSayim (BackSayimId,DeviceId,AppSayimId,SiraNo,TarihSaat,BarkodNo,
   Miktar,StokTip,StokKod,OlusturmaTarihSaat,OlusturmaUnvan)
   select @BackSayimId,@DeviceId,@AppSayimId,@SiraNo,@TarihSaat,@BarkodNo,
   @Miktar,@StokTip,@StokKod,GetDate(),@OlusturmaUnvan
   
   
   
   

END

================================================================================
