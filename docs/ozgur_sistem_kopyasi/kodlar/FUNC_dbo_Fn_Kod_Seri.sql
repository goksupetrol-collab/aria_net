-- Function: dbo.Fn_Kod_Seri
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.657758
================================================================================

CREATE FUNCTION [dbo].Fn_Kod_Seri 
(
 @DEGER varchar(50) 
 )
 RETURNS   VARCHAR(50) 
AS
BEGIN
   
  DECLARE @I 		   INT
  DECLARE @NUMARA      FLOAT
  DECLARE @SERI        VARCHAR(30)
  DECLARE @UZUNLUK     INT
  DECLARE @SERI_NO     VARCHAR(50)
  
  SET @SERI = ''
  SET @SERI_NO =''
  

  IF CHARINDEX (',',@DEGER)>0
   RETURN @SERI_NO

  IF CHARINDEX (' ',@DEGER)>0
   RETURN @SERI_NO


  SET @I    = 1

  WHILE @I <= LEN(@DEGER)
  BEGIN
    IF ( (SELECT ISNUMERIC(SUBSTRING(@DEGER,@I,1))) = 0 )
    BEGIN
      SET @SERI = @SERI + ( SELECT SUBSTRING(@DEGER,@I,1) )
    END
    ELSE
    BEGIN
/*     PRINT RIGHT(@DEGER,LEN(@DEGER) - @I + 1) */
      IF ISNUMERIC(RIGHT(@DEGER,LEN(@DEGER) - @I + 1))=1
      AND RIGHT(@DEGER,LEN(@DEGER) -@I + 1)>'0'
      BEGIN
      SET @UZUNLUK=LEN(@DEGER) - @I + 1
      SELECT @NUMARA = CAST(RIGHT(@DEGER,LEN(@DEGER) - @I + 1) AS FLOAT)
      BREAK
      END
    END

    SET @I = @I + 1
  END

  set @NUMARA=isnull(@NUMARA,0)

  set @UZUNLUK=isnull(@UZUNLUK,5)

  SET @SERI_NO=@SERI+RIGHT('00000000000000000000' + CAST(@NUMARA + 1 AS VARCHAR(15)),@UZUNLUK) 

  RETURN @SERI_NO
  
END

================================================================================
