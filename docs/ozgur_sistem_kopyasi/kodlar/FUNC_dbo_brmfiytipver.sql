-- Function: dbo.brmfiytipver
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.645595
================================================================================

CREATE FUNCTION dbo.brmfiytipver(@tip varchar(10))
RETURNS varchar(50)
AS
BEGIN
declare @sonuc varchar(50)

if @tip='alsfiy'
set @sonuc='Alış Fiyat';

if @tip='sat1fiy'
set @sonuc='Satis Fiyat - 1';

if @tip='sat2fiy'
set @sonuc='Satis Fiyat - 2';

if @tip='ortalsf'
set @sonuc='Ortalama Alış Fiyatı';

if @tip='siffiy'
set @sonuc='Sıfır Fiyatı';

RETURN @sonuc;



END

================================================================================
