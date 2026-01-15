-- Stored Procedure: dbo.SpAppUrunFiyatDegistir
-- Tarih: 2026-01-14 20:06:08.370876
================================================================================

CREATE PROCEDURE dbo.[SpAppUrunFiyatDegistir]
@Kod   varchar(30),
@Fiyat float,
@UserId     int 
AS
BEGIN

  declare @id      int
  declare @UrunAd   varchar(150)
  declare @OlusturmaUnvan   varchar(150)
  select @OlusturmaUnvan=ad from  users where id=@UserId

  select @id=id,@UrunAd=ad from  stokkart where tip='markt' and kod=@Kod
 

  update stokkart set sat1fiy=@Fiyat,
  SatisFiyat1DegisimTarih=Getdate(),
  deguser=@OlusturmaUnvan,
  degtarsaat=Getdate()
  where id=@id
  
  select  @UrunAd urunad,@Fiyat yenifiyat,@OlusturmaUnvan userunvan 

END

================================================================================
