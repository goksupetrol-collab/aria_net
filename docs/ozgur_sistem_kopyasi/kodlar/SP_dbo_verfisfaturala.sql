-- Stored Procedure: dbo.verfisfaturala
-- Tarih: 2026-01-14 20:06:08.388614
================================================================================

CREATE PROCEDURE [dbo].verfisfaturala (@cartip varchar(20),
@carkod varchar(20),@vadtar datetime,@VERIDIN VARCHAR(8000))
AS
BEGIN
 BEGIN TRAN VERFAT1
  

 DECLARE @EKSTRE_TEMP TABLE (
    VARNO      FLOAT)
 declare @separator char(1)
 set @separator = ','

 declare @separator_position int
 declare @array_value varchar(1000)

 IF (LEN(RTRIM(@VERIDIN)) > 0)
 BEGIN
  set @VERIDIN = @VERIDIN + ','
 END

 while patindex('%,%' , @VERIDIN) <> 0
 begin

   select @separator_position =  patindex('%,%' , @VERIDIN)
   select @array_value = left(@VERIDIN, @separator_position - 1)

  Insert @EKSTRE_TEMP
  Values (Cast(@array_value as float))
  select @VERIDIN = stuff(@VERIDIN, 1, @separator_position, '')
 end


/*-----------DECLARE */
/*
SET @fattip='veresi'
SET @fattur:='satis'
SELECT @parabrm=sistem_ytlstr,@kur=sistem_kasakur
FROM sistemtanim

  IF (SELECT COUNT(*) FROM TB_BANKA WHERE BANKA_KOD = @BANKA_KOD AND TB_BANKA_ID <> @TB_BANKA_ID) > 0
    BEGIN
      SELECT @MESAJ = '"'+@BANKA_KOD + '" Kodu farklı bir banka hesabında kullanılmıştır.'
      RAISERROR (@MESAJ, 16,1)
      ROLLBACK TRANSACTION
    END
    ELSE
    BEGIN
      EXEC SP_YAZ_FIS_NO 'BANKA', @BANKA_KOD
    END

*/

 	IF @@ERROR > 0
		ROLLBACK TRAN VERFAT1
	ELSE
	   COMMIT TRAN VERFAT1
  
  
END

================================================================================
