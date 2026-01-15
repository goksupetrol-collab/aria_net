-- Function: dbo.sayachrkvarmi
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.670879
================================================================================

CREATE FUNCTION [dbo].sayachrkvarmi (@sayackod varchar(20))
RETURNS bit
AS
BEGIN
declare @sonuc bit

if isnull((select count(*) from sayachrk with (NOLOCK) 
where sayackod=@sayackod and sil=0),0)=0
set @sonuc=0
else
set @sonuc=1


RETURN @sonuc


END

================================================================================
