-- Function: dbo.Udf_KdvMuhKodu
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.736093
================================================================================

CREATE FUNCTION  [dbo].[Udf_KdvMuhKodu](@tip tinyint,@kdv float)
RETURNS varchar(20)
AS
BEGIN
declare @val varchar(20)
select @val=(case
 when @tip=1 then
 (select top 1 isnull(deger,'') from entegre_muh_hes_kod where tip='als_kdv' and kdv_oran=@kdv)
 when @tip=2 then
 (select top 1 isnull(deger,'') from entegre_muh_hes_kod where tip='sat_kdv' and kdv_oran=@kdv)
 when @tip=3 then
 (select top 1 isnull(deger,'') from entegre_muh_hes_kod where tip='alsia_kdv' and kdv_oran=@kdv)
 when @tip=4 then
 (select top 1 isnull(deger,'') from entegre_muh_hes_kod where tip='satia_kdv' and kdv_oran=@kdv) end)
 return isnull(@val,'')
END

================================================================================
