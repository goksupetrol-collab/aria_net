-- Function: dbo.UDF_GENEL_CARBAKIYE
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.718210
================================================================================

CREATE FUNCTION [dbo].UDF_GENEL_CARBAKIYE (
@FIRMANO     INT,
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
  @TB_GENEL_CARIKARTBAKIYE TABLE (
    KOD               VARCHAR(20)  COLLATE Turkish_CI_AS,
    AD                VARCHAR(150)  COLLATE Turkish_CI_AS,
    BAKIYE            FLOAT)
AS
BEGIN

    DECLARE @TB_GENEL_CARIKARTTEMP TABLE (
    KOD               VARCHAR(20)  COLLATE Turkish_CI_AS,
    AD                VARCHAR(150)  COLLATE Turkish_CI_AS,
    BAKIYE            FLOAT)

  /*--tum veresiye fişleri geliyor aktarılmıs ve aktarılmamıslar */
  if @FIRMANO>0 
  INSERT @TB_GENEL_CARIKARTTEMP (KOD,AD,BAKIYE)
  select k.kod,k.unvan,isnull(sum(v.toptut),0)
  FROM carikart as k with (nolock)
  inner join veresimas as v with (nolock) on 
  k.kod=v.carkod and v.cartip='carikart'
  and v.tarih>=@TARIH1 and v.tarih<=@TARIH2 
  and v.sil=0 and k.sil=0 and v.firmano=@FIRMANO
  group by k.kod,k.unvan
  else
  INSERT @TB_GENEL_CARIKARTTEMP (KOD,AD,BAKIYE)
  select k.kod,k.unvan,isnull(sum(v.toptut),0)
  FROM carikart as k with (nolock)
  inner join veresimas as v with (nolock) on k.kod=v.carkod and v.cartip='carikart'
  and v.tarih>=@TARIH1 and v.tarih<=@TARIH2 and v.sil=0 and k.sil=0
  group by k.kod,k.unvan
  
  
  
  if @FIRMANO>0  
  INSERT @TB_GENEL_CARIKARTTEMP (KOD,AD,BAKIYE)
  select k.kod,k.unvan,
  isnull(sum(h.borc),0)
  FROM carikart as k with (nolock)
  inner join carihrk as h with (nolock) on 
  k.kod=h.carkod and h.cartip='carikart'
  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 
  and h.sil=0 and k.sil=0 and h.firmano=@FIRMANO
  and h.borc>0
  and ( (h.islmtip='ODE' and h.islmhrk='NAK')
  or (h.islmtip='CEK' and h.islmhrk='KSN')
  or (h.islmtip='ODE' and h.islmhrk='IKK')
  or (h.islmtip='CEK' and h.islmhrk='CIR')
  )
  group by k.kod,k.unvan
  else
  INSERT @TB_GENEL_CARIKARTTEMP (KOD,AD,BAKIYE)
  select k.kod,k.unvan,
  isnull(sum(h.borc),0)
  FROM carikart as k with (nolock)
  inner join carihrk as h with (nolock) on 
  k.kod=h.carkod and h.cartip='carikart'
  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 
  and h.sil=0 and k.sil=0 
  and h.borc>0
  and ( (h.islmtip='ODE' and h.islmhrk='NAK')
  or (h.islmtip='CEK' and h.islmhrk='KSN')
  or (h.islmtip='ODE' and h.islmhrk='IKK')
  or (h.islmtip='CEK' and h.islmhrk='CIR')
  )
  group by k.kod,k.unvan


  /*--cari kartların işletmeden tahsilatları */
  if @FIRMANO>0  
  INSERT @TB_GENEL_CARIKARTTEMP (KOD,AD,BAKIYE)
  select k.kod,k.unvan,
  isnull(sum(-1*h.alacak),0)
  FROM carikart as k with (nolock)
  inner join carihrk as h with (nolock) on 
  k.kod=h.carkod and h.cartip='carikart'
  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2 
  and h.sil=0 and k.sil=0 and h.firmano=@FIRMANO
  and h.alacak>0
  and
  ( (h.islmtip='TAH' and h.islmhrk='NAK')
  or (h.islmtip='CEK' and h.islmhrk='POR')
  or (h.islmtip='TAH' and h.islmhrk='POS')
  )
  group by k.kod,k.unvan
  else
   INSERT @TB_GENEL_CARIKARTTEMP (KOD,AD,BAKIYE)
  select k.kod,k.unvan,
  isnull(sum(-1*h.alacak),0)
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
  
  
  

  INSERT @TB_GENEL_CARIKARTBAKIYE (KOD,AD,BAKIYE)
  select KOD,AD,isnull(sum(BAKIYE),0) from
  @TB_GENEL_CARIKARTTEMP group by KOD,AD





  RETURN

end

================================================================================
