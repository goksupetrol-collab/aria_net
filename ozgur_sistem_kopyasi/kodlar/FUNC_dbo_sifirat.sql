-- Function: dbo.sifirat
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.671922
================================================================================

CREATE FUNCTION [dbo].sifirat (@deger float,@tane int)
RETURNS varchar(10)
AS
BEGIN
declare @sonuc varchar(10)
declare @ii int

set @ii=LEN(@deger)

set @sonuc=''
while @tane>@ii begin
set @sonuc=@sonuc+'0'
set @ii=@ii+1
end;

set @sonuc=@sonuc+cast(@deger as varchar)

RETURN @sonuc
  
  
END

================================================================================
