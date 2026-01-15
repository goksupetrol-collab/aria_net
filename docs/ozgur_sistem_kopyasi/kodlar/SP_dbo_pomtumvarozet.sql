-- Stored Procedure: dbo.pomtumvarozet
-- Tarih: 2026-01-14 20:06:08.355548
================================================================================

CREATE PROCEDURE [dbo].pomtumvarozet @varno float
AS
BEGIN

declare @sql nvarchar(50);
declare @acik float,@fazla float;

if object_id( 'tempdb..#tumvarozet' ) is null
CREATE TABLE [dbo].[#tumvarozet] (id int IDENTITY,
kod varchar(50),ad varchar(50),grs float,cks float);


insert into #tumvarozet (kod,ad,grs,cks) select 'aksattut','Akaryakıt Sayaçlı Satış Tutarı',aksattut,0 from vardimas  where varno=@varno ;



select * from #tumvarozet;




END

================================================================================
