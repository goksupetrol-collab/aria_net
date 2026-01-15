-- Stored Procedure: dbo.sp_DizinKontrol
-- Tarih: 2026-01-14 20:06:08.366467
================================================================================

CREATE PROCEDURE [dbo].sp_DizinKontrol
@Dizin VARCHAR(255),
@Klasor VARCHAR(255)
AS
BEGIN
DECLARE @ANSW BIT

CREATE TABLE #Tmp(Dir varchar(255))

INSERT INTO #Tmp
EXEC master..xp_subdirs @Dizin

if @Klasor=''
  set @ANSW=1
 else
  begin
   IF EXISTS (Select * from #Tmp WHERE Dir = @Klasor)
   SET @ANSW = 1 ELSE SET @ANSW = 0
   end

DROP TABLE #Tmp
RETURN @ANSW
END

================================================================================
