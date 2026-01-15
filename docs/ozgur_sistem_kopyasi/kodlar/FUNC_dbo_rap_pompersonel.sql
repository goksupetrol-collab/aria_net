-- Function: dbo.rap_pompersonel
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.669680
================================================================================

CREATE FUNCTION dbo.rap_pompersonel (@VARNIN VARCHAR(8000))
RETURNS
@TB_POMPERSONEL_EKSTRE TABLE (
    PER_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    PER_AD     VARCHAR(50) COLLATE Turkish_CI_AS,
    NAKIT       FLOAT,
    VERESIYE    FLOAT,
    POS         FLOAT,
    GIDER		FLOAT,
    ACIKFAZLA   FLOAT,
    TOPTUTAR    FLOAT)
AS
BEGIN
  DECLARE @POMPERSONEL_TEMP TABLE (
    PER_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    PER_AD     VARCHAR(50) COLLATE Turkish_CI_AS,
    NAKIT       FLOAT,
    VERESIYE    FLOAT,
    POS         FLOAT,
    GIDER		FLOAT,
    ACIKFAZLA   FLOAT,
    TOPTUTAR    FLOAT)

  DECLARE @HRK_PER_KOD    VARCHAR(20)
  DECLARE @HRK_PER_AD     VARCHAR(50)
  DECLARE @HRK_NAKIT       FLOAT
  DECLARE @HRK_VERESIYE    FLOAT
  DECLARE @HRK_POS         FLOAT
  DECLARE @HRK_ACIKFAZLA   FLOAT
  DECLARE @HRK_TOPTUTAR    FLOAT


INSERT @POMPERSONEL_TEMP (PER_KOD,PER_AD,NAKIT,VERESIYE,POS,GIDER,ACIKFAZLA,TOPTUTAR)
      SELECT P.per,P.perad,0,0,0,0,p.perackfaz,0 FROM pomvardiper AS P with (nolock) 
      WHERE isnull(p.sil,0)=0 and p.varno in (select * from CsvToInt(@VARNIN))


/*---NAKIT nakit toplam */
update @POMPERSONEL_TEMP set NAKIT=dt.nak from @POMPERSONEL_TEMP t join
(select perkod,isnull(sum(kur*(giren-cikan)),0) as nak from kasahrk  with (nolock) 
where kasahrk.varno in (select * from CsvToInt(@VARNIN))
and yertip='pomvardimas' and islmhrk='TES' 
and sil=0 group by perkod) dt on t.PER_KOD=dt.perkod


/*---VERESIYE  toplam */
update @POMPERSONEL_TEMP set VERESIYE=dt.ver from @POMPERSONEL_TEMP t join
(select perkod,isnull(sum(toptut),0) as ver from veresimas with (nolock)  
where veresimas.varno in (select * from CsvToInt(@VARNIN))
and yertip='pomvardimas' and sil=0 group by perkod) dt on t.PER_KOD=dt.perkod

/*---POS toplam */
update @POMPERSONEL_TEMP set POS=dt.pos from @POMPERSONEL_TEMP t join
(select perkod,isnull(sum(kur*(giren-cikan)),0) as pos from poshrk  with (nolock) 
where poshrk.varno in (select * from CsvToInt(@VARNIN))
and yertip='pomvardimas' and sil=0 group by perkod) dt on t.PER_KOD=dt.perkod


/*---GIDER nakit toplam */
update @POMPERSONEL_TEMP set GIDER=dt.nak from @POMPERSONEL_TEMP t join
(select perkod,isnull(sum(kur*(cikan)),0) as nak from kasahrk  with (nolock) 
where kasahrk.varno in (select * from CsvToInt(@VARNIN))
and yertip='pomvardimas' and islmtip='ODE'  and islmhrk='NAK'
and cartip='gelgidkart' 
and sil=0 group by perkod) dt on t.PER_KOD=dt.perkod




update @POMPERSONEL_TEMP set TOPTUTAR=(NAKIT+VERESIYE+POS+GIDER)


INSERT @TB_POMPERSONEL_EKSTRE
    SELECT PER_KOD,PER_AD,NAKIT,VERESIYE,POS,GIDER,ACIKFAZLA,TOPTUTAR
     FROM @POMPERSONEL_TEMP



  RETURN

END

================================================================================
