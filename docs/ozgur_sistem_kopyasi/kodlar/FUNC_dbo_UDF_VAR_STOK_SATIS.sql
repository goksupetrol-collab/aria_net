-- Function: dbo.UDF_VAR_STOK_SATIS
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.793806
================================================================================

create FUNCTION [dbo].[UDF_VAR_STOK_SATIS] 
(@VARNIN VARCHAR(8000),@TIP VARCHAR(30))
RETURNS
  @TB_TANK_STOK TABLE (
    FIRMANO			    INT, 
    FIRMAUNVAN			VARCHAR(100) COLLATE Turkish_CI_AS,
    STOKKTIP            VARCHAR(30) COLLATE Turkish_CI_AS,
    STOKKOD     		VARCHAR(30) COLLATE Turkish_CI_AS,
    STOKAD     			VARCHAR(100) COLLATE Turkish_CI_AS,
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
    SELECT P.firmano,'',P.stktip AS STOKKTIP,P.kod AS STOKKOD,
    S.ad as STOKAD,p.acmik AS ONCEKIMIKTAR,0,0,
    P.satmik AS SATISMIKTAR,(P.satmik*P.brimfiy) as SATISTUTAR,
    P.brimfiy AS BRIMFIYAT,
    P.transfer_cks_mik AS TRANSFER_CKS_MIKTAR,P.transfer_grs_mik AS TRANSFER_GRS_MIKTAR,
    P.testmik AS TESTMIKTAR,
    P.kalan AS SONMIKTAR FROM  pomvardistok AS P 
     inner JOIN stokkart AS S ON 
     (P.kod=S.kod and p.stktip=s.tip and isnull(p.sil,0)=0 and p.varno in (select * from CsvToInt(@VARNIN))) 
     order by P.stktip,P.kod

    UPDATE @TB_TANK_STOK SET FIRMAUNVAN=DT.AD FROM @TB_TANK_STOK AS T 
    join (SELECT id,ad from firma ) dt
    on dt.id=t.FIRMANO



  RETURN

end

================================================================================
