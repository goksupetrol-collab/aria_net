-- Function: dbo.UDF_VAR_STOK_SATIS_GRUP
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.794233
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_STOK_SATIS_GRUP] 
(@VARNIN VARCHAR(8000),@TIP VARCHAR(30))
RETURNS
  @TB_TANK_STOK TABLE (
    GRUP_AD     		VARCHAR(100) COLLATE Turkish_CI_AS,
    ONCEKIMIKTAR        FLOAT,
    MALALIM             FLOAT,
    MALALIMTUTAR        FLOAT,
    SATISMIKTAR         FLOAT,
    SATISTUTAR			FLOAT,
    BRIMFIYAT			FLOAT,
    TRANSFER_CKS_MIKTAR FLOAT,
    TRANSFER_GRS_MIKTAR FLOAT,
    TESTMIKTAR          FLOAT,
    SONMIKTAR           FLOAT)
AS
BEGIN
 
  
   insert into @TB_TANK_STOK 
    SELECT dbo.Genel_Grup_Ad_Ver(s.grp1,s.grp2,s.grp3) GRUP_AD,
    Sum(p.acmik) AS ONCEKIMIKTAR,
    0,0,
    sum(P.satmik) AS SATISMIKTAR,
    sum(P.satmik*P.brimfiy) as SATISTUTAR,
    case 
    when sum(P.satmik)>0 then
    sum(P.satmik*P.brimfiy)/sum(P.satmik)
    else 
    AVG(P.brimfiy) end BRIMFIYAT,
    sum(P.transfer_cks_mik) AS TRANSFER_CKS_MIKTAR,
    sum(P.transfer_grs_mik) AS TRANSFER_GRS_MIKTAR,
    sum(P.testmik) AS TESTMIKTAR,
    sum(P.kalan) AS SONMIKTAR FROM  
    pomvardistok AS P with (nolock) 
    inner JOIN stokkart AS S with (nolock)  ON 
    (P.kod=S.kod and p.sil=0 and p.varno in (select * from CsvToInt(@VARNIN))) 
    group by s.grp1,s.grp2,s.grp3
    





  RETURN

end

================================================================================
