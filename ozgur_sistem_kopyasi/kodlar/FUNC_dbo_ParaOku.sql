-- Function: dbo.ParaOku
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.665453
================================================================================

CREATE FUNCTION [dbo].ParaOku (@Sayi float)
RETURNS nvarchar(300)
AS
BEGIN
  DECLARE @Tam nvarchar(20),@Ondalik nvarchar(20),@SONUC nvarchar(300),
  @TamSayi bigint,@OndSayi int
  SET @Tam='TL'
  SET @Ondalik='Kr'
  SET @TamSayi=@Sayi
  SET @SONUC=dbo.RakamOku(@TamSayi)+' '+@Tam
  SET @TamSayi=Round((@Sayi-@TamSayi)*100,2)
  SET @SONUC=@SONUC+' '+dbo.RakamOku(@TamSayi)+' '+@Ondalik
  RETURN @SONUC
END

================================================================================
