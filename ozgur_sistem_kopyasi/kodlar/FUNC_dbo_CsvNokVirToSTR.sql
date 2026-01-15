-- Function: dbo.CsvNokVirToSTR
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.648673
================================================================================

CREATE Function dbo.[CsvNokVirToSTR] ( @Array  varchar(8000))
returns @IntTable table (STRValue varchar(30) COLLATE Turkish_CI_AS)
AS
begin

 declare @separator char(1)
 set @separator = ';'

 declare @separator_position int
 declare @array_value varchar(1000)

 IF (LEN(RTRIM(@array)) > 0)
 BEGIN
  set @array = @array + ';'
 END

 while patindex('%;%' , @array) <> 0
 begin

   select @separator_position =  patindex('%;%' , @array)
   select @array_value = left(@array, @separator_position - 1)

  Insert @IntTable
  Values (@array_value)

   select @array = stuff(@array, 1, @separator_position, '')
 end

 return
end

================================================================================
