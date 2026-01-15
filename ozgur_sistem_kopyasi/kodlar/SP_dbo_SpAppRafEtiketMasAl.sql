-- Stored Procedure: dbo.SpAppRafEtiketMasAl
-- Tarih: 2026-01-14 20:06:08.369543
================================================================================

CREATE PROCEDURE dbo.[SpAppRafEtiketMasAl]
@DeviceId  varchar(50),
@FirmaNo     int,
@TarihSaat  datetime,
@Aciklama    varchar(100),
@UserId     int
AS
BEGIN
  
   Declare @Id     int 
   Declare @OlusturmaUnvan   varchar(150)
   
   select @OlusturmaUnvan=ad from  users with (nolock) where id=@UserId

  
   select @Id=Id from AppRafEtiketMas with (nolock) Where DeviceId=@DeviceId
   and TarihSaat=@TarihSaat 
   

   if isnull(@Id,0)=0
   begin
     insert into AppRafEtiketMas (DeviceId,Firmano,TarihSaat,Aciklama,
     OlusturmaTarihSaat,OlusturmaUnvan)
     select @DeviceId,@FirmaNo,@TarihSaat,@Aciklama,GetDate(),@OlusturmaUnvan
     select @Id=SCOPE_IDENTITY()
   end
   
   
  
   
   select @Id as Id
   

END

================================================================================
