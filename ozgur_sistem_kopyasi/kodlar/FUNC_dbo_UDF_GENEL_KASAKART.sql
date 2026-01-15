-- Function: dbo.UDF_GENEL_KASAKART
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.721921
================================================================================

CREATE FUNCTION [dbo].UDF_GENEL_KASAKART (
@FIRMANO   INT,
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
  @TB_GENEL_KASAKART TABLE (
    KOD               VARCHAR(20)  COLLATE Turkish_CI_AS,
    AD                VARCHAR(50)  COLLATE Turkish_CI_AS,
    DEVIR             FLOAT,
    BORC              FLOAT,
    ALACAK            FLOAT,
    BAKIYE            FLOAT)
AS
BEGIN

  IF @FIRMANO>0
  INSERT @TB_GENEL_KASAKART (KOD,AD,
  DEVIR,BORC,ALACAK,BAKIYE)
  select k.kod,k.ad,
  isnull((select sum(sh.giren-sh.cikan) from kasahrk as sh with (nolock)
  where sh.kaskod=k.kod and sh.tarih<@TARIH1 and sh.sil=0 and sh.firmano=@FIRMANO
  and ((sh.varno>0 and sh.varok=1) or (sh.varno=0)) ),0),
  isnull(sum(h.cikan),0),
  isnull(sum(h.giren),0),
  0
  /*isnull(sum(h.giren-h.cikan),0) */
  FROM kasakart as k with (nolock)
  inner join kasahrk as h with (nolock) on k.kod=h.kaskod
  and k.sil=0 and h.tarih >=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0
  and h.firmano=@FIRMANO and  ((h.varno>0 and h.varok=1) or (h.varno=0))
  group by k.kod,k.ad
  else
  INSERT @TB_GENEL_KASAKART (KOD,AD,
  DEVIR,BORC,ALACAK,BAKIYE)
  select k.kod,k.ad,
  isnull((select sum(sh.giren-sh.cikan) from kasahrk as sh with (nolock)
  where sh.kaskod=k.kod and sh.tarih<@TARIH1 and sh.sil=0
  and ((sh.varno>0 and sh.varok=1) or (sh.varno=0)) ),0),
  isnull(sum(h.cikan),0),
  isnull(sum(h.giren),0),
  0
  /*isnull(sum(h.giren-h.cikan),0) */
  FROM kasakart as k with (nolock)
  inner join kasahrk as h with (nolock) on k.kod=h.kaskod
  and k.sil=0 and h.tarih >=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0
  and  ((h.varno>0 and h.varok=1) or (h.varno=0))
  group by k.kod,k.ad
  
  
  
  update @TB_GENEL_KASAKART set BAKIYE=DEVIR+ALACAK-BORC
  
  

  RETURN

end

================================================================================
