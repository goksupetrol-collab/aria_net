-- Function: dbo.UDF_VAR_RESEMTIA_SATIS
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.789135
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_RESEMTIA_SATIS]
(@VARNIN VARCHAR(4000),@TIP VARCHAR(30))
RETURNS
  @TB_EMTIA_SATIS TABLE (
    STOK_KOD    VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_AD     VARCHAR(150) COLLATE Turkish_CI_AS,
    SATISMIKTAR      FLOAT,
    SATISTUTAR        FLOAT,
    IADEMIKTAR        FLOAT,
    IADETUTAR         FLOAT,
    KDV               FLOAT,
    KDVTUTAR          FLOAT,
    BIRIMFIYAT        FLOAT)
AS
BEGIN
  DECLARE @EKSTRE_TEMP TABLE (
    VARNO      FLOAT)
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

  Insert @EKSTRE_TEMP
  Values (Cast(@array_value as float))
  select @VARNIN = stuff(@VARNIN, 1, @separator_position, '')
 end

  INSERT @TB_EMTIA_SATIS (STOK_KOD,STOK_AD,SATISMIKTAR,SATISTUTAR,
  IADEMIKTAR,IADETUTAR,KDV,KDVTUTAR,BIRIMFIYAT)
  select st.kod,st.ad,
  isnull(sum(case when m.Iade=0 then em.miktar else 0 end),0),
  isnull(sum(case when m.Iade=0 then em.miktar*em.birimfiyat*em.kur else 0 end),0),
  isnull(sum(case when m.Iade=1 then em.miktar else 0 end),0),
  isnull(sum(case when m.Iade=1 then em.miktar*em.birimfiyat*em.kur else 0 end),0),
  (em.kdvyuz*100),
  sum( ( ((case when m.Iade=0 then em.miktar else -1*em.miktar end)*em.birimfiyat*em.kur) / (1+em.kdvyuz) )*em.kdvyuz),
  em.birimfiyat
  FROM  ressathrk as em
  inner join ResSatMas as m on m.Id=em.RessatId and m.Sil=0 
  inner join stokkart as st on st.id=em.stkId and st.Tip_id=em.StkTipId
  where em.varno in (select * from @EKSTRE_TEMP) and em.sil=0 
  group by st.kod,st.ad,em.kdvyuz,em.birimfiyat

  RETURN

end

================================================================================
