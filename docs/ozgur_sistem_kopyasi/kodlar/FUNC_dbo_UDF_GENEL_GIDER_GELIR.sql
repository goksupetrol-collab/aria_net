-- Function: dbo.UDF_GENEL_GIDER_GELIR
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.720361
================================================================================

CREATE FUNCTION [dbo].UDF_GENEL_GIDER_GELIR (
@FIRMANO   INT,
@TIP   VARCHAR(10),
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
  @TB_GENEL_GIDER_GELIR TABLE (
    GRUP_AD			  VARCHAR(70)  COLLATE Turkish_CI_AS,	
    KOD               VARCHAR(30)  COLLATE Turkish_CI_AS,
    AD                VARCHAR(150)  COLLATE Turkish_CI_AS,
    BAKIYE            FLOAT)
AS
BEGIN

  IF @TIP='GIDER'
  Begin
  IF @FIRMANO>0
  INSERT @TB_GENEL_GIDER_GELIR (GRUP_AD,KOD,AD,BAKIYE)
  select g.ad,k.kod,k.ad,
  isnull(sum(h.borc),0)
  FROM carihrk as h with (nolock) 
  inner join gelgidkart as k with (nolock) 
  on k.kod=h.carkod and h.cartip='gelgidkart'
  and k.sil=0 and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0
  and h.borc>0 and h.firmano=@FIRMANO
  left join grup g with (nolock) on g.id=
  case when (k.grp3>0) then k.grp3 
  when k.grp2>0 then k.grp2
  when k.grp1>0 then k.grp1 end
  group by 
  g.ad,k.kod,k.ad
  else
  INSERT @TB_GENEL_GIDER_GELIR (GRUP_AD,KOD,AD,BAKIYE)
  select g.ad,k.kod,k.ad,
  isnull(sum(h.borc),0)
  FROM carihrk as h with (nolock) 
  inner join gelgidkart as k with (nolock) 
  on k.kod=h.carkod and h.cartip='gelgidkart'
  and k.sil=0 and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0
  and h.borc>0 
  left join grup g with (nolock) on g.id=
  case when (k.grp3>0) then k.grp3 
  when k.grp2>0 then k.grp2
  when k.grp1>0 then k.grp1 end
  group by 
  g.ad,k.kod,k.ad
  
  end
  
  IF @TIP='GELIR'
  begin
  IF @FIRMANO>0
  INSERT @TB_GENEL_GIDER_GELIR (GRUP_AD,KOD,AD,BAKIYE)
  select g.ad,k.kod,k.ad,
  isnull(sum(h.alacak),0)
  FROM gelgidkart as k with (nolock)
  inner join carihrk as h with (nolock) on k.kod=h.carkod and h.cartip='gelgidkart'
  and h.sil=0 and k.sil=0 and h.tarih>=@TARIH1 and h.tarih<=@TARIH2
  and h.alacak>0 and h.firmano=@FIRMANO
  left join grup g with (nolock) on g.id=
  case when (k.grp3>0) then k.grp3 
  when k.grp2>0 then k.grp2
  when k.grp1>0 then k.grp1 end
  group by  g.ad,k.kod,k.ad
  else
  INSERT @TB_GENEL_GIDER_GELIR (GRUP_AD,KOD,AD,BAKIYE)
  select g.ad,k.kod,k.ad,
  isnull(sum(h.alacak),0)
  FROM gelgidkart as k with (nolock)
  inner join carihrk as h with (nolock) on k.kod=h.carkod and h.cartip='gelgidkart'
  and h.sil=0 and k.sil=0 and h.tarih>=@TARIH1 and h.tarih<=@TARIH2
  and h.alacak>0
  left join grup g with (nolock) on g.id=
  case when (k.grp3>0) then k.grp3 
  when k.grp2>0 then k.grp2
  when k.grp1>0 then k.grp1 end
  group by  g.ad,k.kod,k.ad
  
  
  end

  RETURN

end

================================================================================
