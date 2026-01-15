-- Stored Procedure: dbo.SpBulutTahsilat
-- Tarih: 2026-01-14 20:06:08.371204
================================================================================

CREATE PROCEDURE dbo.SpBulutTahsilat(
@Firmano    int,
@EntegratorId  int,
@TahsilatId int,
@TahsilatTipId int,
@TahsilatTipAd varchar(100),
@TarihSaat Datetime,
@BankKod   varchar(50),
@BankAd    varchar(50),
@BankIBAN  varchar(50),
@TCVKNNo   varchar(50),
@Unvan     varchar(500), 
@Tutar     float,
@Aciklama  varchar(1000) )
AS
BEGIN
  

   /*Firmano=@Firmano and */
   if not EXISTS(select Id from BulutTahsilat with (nolock) 
   where  TahsilatId=@TahsilatId and Sil=0 )  
    INSERT INTO dbo.BulutTahsilat(
      Firmano,TahsilatId,TahsilatTipId,TahsilatTipAd,EntegratorId,TarihSaat,BankKod,BankAd,BankIBAN,
       TCVKNNo,Unvan,Tutar,Aciklama,KayitTarihSaat) 
    select @FirmaNo,@TahsilatId,@TahsilatTipId,@TahsilatTipAd,@EntegratorId,@TarihSaat,@BankKod,@BankAd,@BankIBAN,
       @TCVKNNo,@Unvan,@Tutar,@Aciklama,GetDate() 
       


END

================================================================================
