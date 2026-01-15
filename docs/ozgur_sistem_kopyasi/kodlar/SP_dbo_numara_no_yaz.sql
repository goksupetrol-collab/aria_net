-- Stored Procedure: dbo.numara_no_yaz
-- Tarih: 2026-01-14 20:06:08.349476
================================================================================

CREATE PROCEDURE [dbo].numara_no_yaz (@tip VARCHAR(20),@DEGER VARCHAR(20))
AS
BEGIN
  DECLARE @I INT
  DECLARE @NUMARA FLOAT
  DECLARE @SERI   VARCHAR(10)
  DECLARE @UZUNLUK     INT

  IF CHARINDEX (',',@DEGER)>0
   RETURN

  IF CHARINDEX (' ',@DEGER)>0
   RETURN

 /* if LEN(@DEGER)>10 */
  /*  RETURN */


  SET @SERI = ''
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

  UPDATE numarator SET
    seri = @SERI,
    numara = @NUMARA,
    uzunluk=@UZUNLUK
  WHERE tip = @tip

END

================================================================================
