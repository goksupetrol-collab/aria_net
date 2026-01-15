-- Stored Procedure: dbo.SpAppRafEtiketHrkAl
-- Tarih: 2026-01-14 20:06:08.369186
================================================================================

CREATE PROCEDURE dbo.[SpAppRafEtiketHrkAl]
@DeviceId  varchar(50),
@AppRafEtiketId  int,
@SiraNo       int,
@TarihSaat  datetime,
@BarkodNo   varchar(30),
@UserId     int
AS
BEGIN
  
   Declare @Id     int 
   Declare @Firmano  int
   Declare @OlusturmaUnvan   varchar(150)
   
   select @OlusturmaUnvan=ad from  users where id=@UserId
   


   select @Id=Id from AppRafEitketHrk with (nolock) Where DeviceId=@DeviceId
   and AppRafEtiketId=@AppRafEtiketId and SiraNo=@SiraNo

   if isnull(@Id,0)=0
   insert into AppRafEitketHrk (DeviceId,AppRafEtiketId,SiraNo,TarihSaat,BarkodNo,
   OlusturmaTarihSaat,OlusturmaUnvan)
   select @DeviceId,@AppRafEtiketId,@SiraNo,@TarihSaat,@BarkodNo,
   GetDate(),@OlusturmaUnvan

  

END

================================================================================
