-- Function: dbo.CARI_POM_VAR_MAIL_BASLIK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.646220
================================================================================

CREATE FUNCTION [dbo].CARI_POM_VAR_MAIL_BASLIK(
@VARNO FLOAT)
RETURNS
  @TB_CARI_VAR_MAIL_EKSTRE TABLE (
    CARI_TIP    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_KOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    CARI_UNVAN  VARCHAR(150) COLLATE Turkish_CI_AS,
    VARNO       FLOAT,
    FISBAKIYE   DECIMAL(18,8),
    CARIBAKIYE  DECIMAL(18,8),
    BAKIYE      DECIMAL(18,8))
AS
BEGIN


    INSERT @TB_CARI_VAR_MAIL_EKSTRE
    (CARI_TIP,CARI_KOD,CARI_UNVAN,VARNO,FISBAKIYE,CARIBAKIYE,BAKIYE)
    SELECT vs.cartip,vs.carkod,ck.unvan,@VARNO,ck.fisbak,ck.carbak,
    (ck.fisbak+ck.carbak) from veresimas as vs
    inner join carikart as ck on ck.kod=vs.carkod and
    vs.cartip='carikart' and ck.sil=0 and ck.epostagonder=1
    where vs.sil=0 and vs.varno=@VARNO
    group by vs.cartip,vs.carkod,ck.unvan,ck.fisbak,ck.carbak
    
    
 RETURN


 
END

================================================================================
