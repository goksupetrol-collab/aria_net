-- Function: dbo.Depo_Stok_Miktar
-- Tip: SQL_SCALAR_FUNCTION
-- Tarih: 2026-01-14 20:06:08.651551
================================================================================

CREATE FUNCTION dbo.[Depo_Stok_Miktar] 
(
@Depo_id 			int,
@Depo_Kod 			varchar(30),
@Stk_id 			int,
@Stk_Kod 			varchar(30),
@StkTip_id			int,
@StkTip				varchar(20)
)
RETURNS Float
AS
BEGIN
  declare @Miktar float

  select @Miktar=sum(giren-cikan) from stkhrk as h
  where h.Depkod=@Depo_kod and h.stktip=@StkTip
  and h.stkod=@Stk_Kod  and h.sil=0


 if @Miktar is null
  set @Miktar=0

 return @Miktar

END

================================================================================
