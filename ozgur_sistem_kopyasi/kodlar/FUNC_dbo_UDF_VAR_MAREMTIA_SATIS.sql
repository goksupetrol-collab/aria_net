-- Function: dbo.UDF_VAR_MAREMTIA_SATIS
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.783830
================================================================================

CREATE FUNCTION [dbo].UDF_VAR_MAREMTIA_SATIS
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
  select em.stkod,st.ad,
  isnull(sum(case when em.islmtip='satis' then em.mik else 0 end),0),
  isnull(sum(case when em.islmtip='satis' then em.mik*em.brmfiy*em.kur else 0 end),0),
  isnull(sum(case when em.islmtip='iade' then em.mik else 0 end),0),
  isnull(sum(case when em.islmtip='iade' then em.mik*em.brmfiy*em.kur else 0 end),0),
  (st.sat1kdv),
  sum( ( ((case when em.islmtip='satis' then em.mik else -1*em.mik end)*em.brmfiy*em.kur) / (1+em.kdvyuz) )*em.kdvyuz),em.brmfiy
  FROM  marsathrk as em with (nolock)
  inner join stokkart as st with (nolock) on st.kod=em.stkod and st.tip=em.stktip
  where em.varno in (select * from @EKSTRE_TEMP) and em.sil=0 
  group by em.stkod,st.ad,st.sat1kdv,em.brmfiy

  RETURN

end

================================================================================
