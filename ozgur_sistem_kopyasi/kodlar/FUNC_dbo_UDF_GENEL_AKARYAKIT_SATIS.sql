-- Function: dbo.UDF_GENEL_AKARYAKIT_SATIS
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.717414
================================================================================

CREATE FUNCTION [dbo].UDF_GENEL_AKARYAKIT_SATIS (
@FIRMANO  INT,
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
  @TB_AKARYAKIT_SATIS TABLE (
    STOK_KOD    VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_AD     VARCHAR(50)  COLLATE Turkish_CI_AS,
    DONEMBASMIKTAR      FLOAT,
    DONEMBASTUTAR       FLOAT,
    ALISMIKTAR          FLOAT,
    ALISTUTAR           FLOAT,
    SATISMIKTAR         FLOAT,
    SATISTUTAR          FLOAT,
    DONEMSONMIKTAR      FLOAT,
    DONEMSONTUTAR       FLOAT)
AS
BEGIN



 IF @FIRMANO>0
  INSERT @TB_AKARYAKIT_SATIS (STOK_KOD,STOK_AD,
  ALISMIKTAR,ALISTUTAR,
  SATISMIKTAR,SATISTUTAR,
  DONEMSONMIKTAR,DONEMSONTUTAR)
  select st.kod,st.ad,
  isnull(sum(h.giren),0),
  isnull(sum(h.giren*h.brmfiykdvli),0),
  isnull(sum(h.cikan),0),
  isnull(sum(h.cikan*h.brmfiykdvli),0),
  isnull(sum(h.giren-h.cikan),0),
  isnull(sum((h.giren-h.cikan)*h.brmfiykdvli),0)
  FROM  stokkart as st with (nolock)
  inner join stkhrk as h with (nolock) 
  on st.kod=h.stkod and h.stktip=st.tip
  and h.sil=0 and st.sil=0 and h.firmano=@FIRMANO
  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2
  where st.tip='akykt'
  group by st.kod,st.ad
  ELSE
  INSERT @TB_AKARYAKIT_SATIS (STOK_KOD,STOK_AD,
  ALISMIKTAR,ALISTUTAR,
  SATISMIKTAR,SATISTUTAR,
  DONEMSONMIKTAR,DONEMSONTUTAR)
  select st.kod,st.ad,
  isnull(sum(h.giren),0),
  isnull(sum(h.giren*h.brmfiykdvli),0),
  isnull(sum(h.cikan),0),
  isnull(sum(h.cikan*h.brmfiykdvli),0),
  isnull(sum(h.giren-h.cikan),0),
  isnull(sum((h.giren-h.cikan)*h.brmfiykdvli),0)
  FROM  stokkart as st with (nolock)
  inner join stkhrk as h with (nolock) 
  on st.kod=h.stkod and h.stktip=st.tip
  and h.sil=0 and st.sil=0
  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2
  where st.tip='akykt'
  group by st.kod,st.ad


  IF @FIRMANO>0
   update @TB_AKARYAKIT_SATIS set
   DONEMBASMIKTAR=DT.DONBASMIK,
   DONEMBASTUTAR=DT.DONBASTUT*DT.DONBASMIK,
   DONEMSONMIKTAR=DT.DONBASMIK+(ALISMIKTAR-SATISMIKTAR),
   DONEMSONTUTAR=(DT.DONBASMIK+(ALISMIKTAR-SATISMIKTAR))*DT.DONBASTUT
   FROM @TB_AKARYAKIT_SATIS
   t join (
   select h.stkod,
   isnull(sum(h.giren-h.cikan),0) as DONBASMIK,
   isnull(case when sum(h.giren)>0 then
   (sum(h.giren*h.brmfiykdvli)/sum(h.giren)) else 0 end,0) as DONBASTUT
   from stkhrk as h with (nolock)
   where h.firmano=@FIRMANO and h.stktip='akykt' and h.sil=0 and H.tarih<@TARIH1
   group by h.stkod ) dt on dt.stkod=t.STOK_KOD
   else
   update @TB_AKARYAKIT_SATIS set
   DONEMBASMIKTAR=DT.DONBASMIK,
   DONEMBASTUTAR=DT.DONBASTUT*DT.DONBASMIK,
   DONEMSONMIKTAR=DT.DONBASMIK+(ALISMIKTAR-SATISMIKTAR),
   DONEMSONTUTAR=(DT.DONBASMIK+(ALISMIKTAR-SATISMIKTAR))*DT.DONBASTUT
   FROM @TB_AKARYAKIT_SATIS
   t join (
   select h.stkod,
   isnull(sum(h.giren-h.cikan),0) as DONBASMIK,
   isnull(case when sum(h.giren)>0 then
   (sum(h.giren*h.brmfiykdvli)/sum(h.giren)) else 0 end,0) as DONBASTUT
   from stkhrk as h with (nolock)
   where h.stktip='akykt' and h.sil=0 and H.tarih<@TARIH1
   group by h.stkod ) dt on dt.stkod=t.STOK_KOD 









  RETURN

end

================================================================================
