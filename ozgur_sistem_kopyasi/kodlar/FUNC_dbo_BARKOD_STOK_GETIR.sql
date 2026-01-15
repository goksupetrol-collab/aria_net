-- Function: dbo.BARKOD_STOK_GETIR
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.644826
================================================================================

CREATE FUNCTION [dbo].BARKOD_STOK_GETIR
(@TIP varchar(10),@BARKOD VARCHAR(20))
RETURNS
   @TB_BARKOD_STOK TABLE (
    STOK_TIP             VARCHAR(10) COLLATE Turkish_CI_AS,
    STOK_BARKOD          VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_KOD             VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_AD              VARCHAR(150) COLLATE Turkish_CI_AS,
    STOK_ANABRIM         VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_BARKODBRIM      VARCHAR(20) COLLATE Turkish_CI_AS,
    BAR_BRMCARPAN        FLOAT,
    MEVCUT_MIKTAR        FLOAT)
AS
BEGIN

  if (select COUNT(*) from stokkart as k
  inner join barkod as b on b.barkod=@BARKOD
  and b.kod=k.kod and k.tip=@TIP and k.tip=b.tip and
  b.sil=0 and k.sil=0)>0
    begin
     insert into @TB_BARKOD_STOK (STOK_TIP,STOK_BARKOD,STOK_KOD,STOK_AD,
     STOK_ANABRIM,STOK_BARKODBRIM,BAR_BRMCARPAN,MEVCUT_MIKTAR)
     select k.tip,b.barkod,k.kod,k.ad,k.brim,b.brim,b.carpan,
     (k.alsmik-k.satmik) from stokkart as k
     inner join barkod as b on b.barkod=@BARKOD
     and b.kod=k.kod and k.tip=@TIP and k.tip=b.tip and
     b.sil=0 and k.sil=0
    end
  else
    begin
     insert into @TB_BARKOD_STOK (STOK_TIP,STOK_BARKOD,STOK_KOD,STOK_AD,
     STOK_ANABRIM,STOK_BARKODBRIM,BAR_BRMCARPAN,MEVCUT_MIKTAR)
     select @TIP,@BARKOD,@BARKOD,'YOK','-','-',1,0
    
    end

  
  
 RETURN
  
  
END

================================================================================
