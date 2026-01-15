-- Function: dbo.UDF_GENEL_CARIKART_ODETAHBAKIYE
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.719202
================================================================================

CREATE FUNCTION [dbo].UDF_GENEL_CARIKART_ODETAHBAKIYE (
@FIRMANO  INT,
@TIP    VARCHAR(20),
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
  @TB_GENEL_CARIKART TABLE (
    KOD               VARCHAR(20)  COLLATE Turkish_CI_AS,
    AD                VARCHAR(150)  COLLATE Turkish_CI_AS,
    BAKIYE            FLOAT)
AS
BEGIN
  /*--işletmenin odemeleri */
  IF @TIP='ODE'
  begin
  if @FIRMANO>0 
  INSERT @TB_GENEL_CARIKART (KOD,AD,BAKIYE)
  select k.kod,k.unvan,
  isnull(sum(h.borc),0)
  FROM carikart as k with (nolock)
  inner join carihrk as h with (nolock) on k.kod=h.carkod and h.cartip='carikart'
  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0 and k.sil=0
  and h.borc>0 and h.firmano=@FIRMANO
  and ( (h.islmtip='ODE' and h.islmhrk='NAK')
  or (h.islmtip='CEK' and h.islmhrk='KSN')
  or (h.islmtip='ODE' and h.islmhrk='IKK')
  or (h.islmtip='CEK' and h.islmhrk='CIR')
  )
  group by k.kod,k.unvan
  else
  INSERT @TB_GENEL_CARIKART (KOD,AD,BAKIYE)
  select k.kod,k.unvan,
  isnull(sum(h.borc),0)
  FROM carikart as k with (nolock)
  inner join carihrk as h with (nolock) on k.kod=h.carkod and h.cartip='carikart'
  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0 and k.sil=0
  and h.borc>0 
  and ( (h.islmtip='ODE' and h.islmhrk='NAK')
  or (h.islmtip='CEK' and h.islmhrk='KSN')
  or (h.islmtip='ODE' and h.islmhrk='IKK')
  or (h.islmtip='CEK' and h.islmhrk='CIR')
  )
  group by k.kod,k.unvan
  
  end
  
  
  /*--cari kartların işletmeden tahsilatları */
  IF @TIP='TAH'
  begin
  if @FIRMANO>0 
  INSERT @TB_GENEL_CARIKART (KOD,AD,BAKIYE)
  select k.kod,k.unvan,
  isnull(sum(h.alacak),0)
  FROM carikart as k with (nolock)
  inner join carihrk as h with (nolock) on k.kod=h.carkod and h.cartip='carikart'
  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0 and k.sil=0
  and h.alacak>0 and h.firmano=@FIRMANO
  and
  ( (h.islmtip='TAH' and h.islmhrk='NAK')
  or (h.islmtip='CEK' and h.islmhrk='POR')
  or (h.islmtip='TAH' and h.islmhrk='POS')
  )
  group by k.kod,k.unvan
  else
  INSERT @TB_GENEL_CARIKART (KOD,AD,BAKIYE)
  select k.kod,k.unvan,
  isnull(sum(h.alacak),0)
  FROM carikart as k with (nolock)
  inner join carihrk as h with (nolock) on k.kod=h.carkod and h.cartip='carikart'
  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 and h.sil=0 and k.sil=0
 and h.alacak>0
  and
  ( (h.islmtip='TAH' and h.islmhrk='NAK')
  or (h.islmtip='CEK' and h.islmhrk='POR')
  or (h.islmtip='TAH' and h.islmhrk='POS')
  )
  group by k.kod,k.unvan
  
  end
  
  



  RETURN

end

================================================================================
