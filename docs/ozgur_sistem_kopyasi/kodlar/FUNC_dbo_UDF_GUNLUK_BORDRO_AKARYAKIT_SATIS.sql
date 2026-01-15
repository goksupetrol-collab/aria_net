-- Function: dbo.UDF_GUNLUK_BORDRO_AKARYAKIT_SATIS
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.724187
================================================================================

CREATE FUNCTION [dbo].[UDF_GUNLUK_BORDRO_AKARYAKIT_SATIS] (
@FIRMANO INT,
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
  @TB_AKARYAKIT_SATIS TABLE (
    STOK_KOD    VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_AD     VARCHAR(50)  COLLATE Turkish_CI_AS,
    SATISMIKTAR         FLOAT,
    BIRIMFIYAT			FLOAT,
    KDVYUZDE			FLOAT,
    SATISTUTAR          FLOAT,
    KDVTUTAR            FLOAT)
AS
BEGIN

  INSERT @TB_AKARYAKIT_SATIS (STOK_KOD,STOK_AD,
  SATISMIKTAR,BIRIMFIYAT,KDVYUZDE,SATISTUTAR,KDVTUTAR)
  select st.kod,st.ad,
  isnull(sum(h.cikan),0),
  isnull(sum((h.cikan*h.brmfiykdvli)/h.cikan),0),
  max(h.kdvyuz*100),
  isnull(sum(h.cikan*h.brmfiykdvli),0),
  0 
  FROM  stokkart as st with (nolock)
  inner join stkhrk as h with (nolock) on st.kod=h.stkod and h.stktip=st.tip
  and h.sil=0 and st.sil=0 and h.firmano=@FIRMANO
  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2
  where st.tip='akykt' and h.cikan>0 and h.islmtip='POMSAYSAT'
  group by st.kod,st.ad



   update @TB_AKARYAKIT_SATIS set
   KDVTUTAR=SATISTUTAR-(SATISTUTAR/(1+ case when KDVYUZDE>0 then KDVYUZDE/100 else 0 end ) )


  RETURN

end

================================================================================
