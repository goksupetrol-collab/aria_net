-- Stored Procedure: dbo.Pom_Vardi_Hesapla
-- Tarih: 2026-01-14 20:06:08.353508
================================================================================

CREATE PROCEDURE [dbo].Pom_Vardi_Hesapla (@VARNIN varchar(4000),@tip varchar(20))
AS
BEGIN
  
declare @varno int
  
if object_id( 'tempdb..#EKSTRE_TEMP' ) is null
CREATE TABLE [dbo].[#EKSTRE_TEMP] (
    VARNO      FLOAT)
  
 TRUNCATE TABLE #EKSTRE_TEMP
    
 declare @separator char(1)
 set @separator = ','

 declare @separator_position int
 declare @array_value varchar(1000)

 IF (LEN(RTRIM(@VARNIN)) > 0)
 BEGIN
  set @VARNIN = @VARNIN + ','
 END

 while patindex('%,%' , @VARNIN) <> 0
 begin

   select @separator_position =  patindex('%,%' , @VARNIN)
   select @array_value = left(@VARNIN, @separator_position - 1)

  Insert #EKSTRE_TEMP
  Values (Cast(@array_value as float))
  select @VARNIN = stuff(@VARNIN, 1, @separator_position, '')
 end


   DECLARE CRS_VARNO_STOK_HRK CURSOR FAST_FORWARD FOR
    SELECT VARNO FROM #EKSTRE_TEMP

    OPEN CRS_VARNO_STOK_HRK
     FETCH NEXT FROM CRS_VARNO_STOK_HRK INTO
       @varno
       WHILE @@FETCH_STATUS = 0
       BEGIN
       if @tip='pomvardimas'
       begin
       /*exec pomstoktankac @varno */
       exec pomvarditopduz @varno
       exec GENEL_GECVAROZETOLUSTUR @tip,@varno
       end

       if @tip='marvardimas'
       begin
       exec GENEL_GECVAROZETOLUSTUR @tip,@varno
       end
       
      FETCH NEXT FROM CRS_VARNO_STOK_HRK INTO
     @varno
     END

   CLOSE CRS_VARNO_STOK_HRK
   DEALLOCATE CRS_VARNO_STOK_HRK


  
  
  
  
  
  
  
END

================================================================================
