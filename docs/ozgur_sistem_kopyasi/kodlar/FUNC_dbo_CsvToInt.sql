-- Function: dbo.CsvToInt
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.649017
================================================================================

CREATE Function dbo.CsvToInt ( @Array  varchar(8000))
returns @IntTable table
 (IntValue int)
AS
begin

 declare @separator char(1)
 set @separator = ','

 declare @separator_position int
 declare @array_value varchar(1000)

 IF (LEN(RTRIM(@array)) > 0)
 BEGIN
  set @array = @array + ','
 END

 while patindex('%,%' , @array) <> 0
 begin

   select @separator_position =  patindex('%,%' , @array)
   select @array_value = left(@array, @separator_position - 1)

  Insert @IntTable
  Values (Cast(@array_value as int))

   select @array = stuff(@array, 1, @separator_position, '')
 end

 return
end

================================================================================
