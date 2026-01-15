-- Function: dbo.rap_pomsayac
-- Tip: SQL_INLINE_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.670342
================================================================================

CREATE FUNCTION dbo.rap_pomsayac(@varno float)
RETURNS TABLE AS
RETURN(SELECT  P.SAYACKOD,S.ad as SAYACAD,P.ADAD,P.ilkendk AS ILKENDKS,
P.sonendk AS SONENDKS,P.satmik AS SATISMIKTAR,
P.testmik AS TESTMIKTAR,P.brimfiy AS BRIMFIYAT,P.tutar AS TUTAR
FROM  pomvardisayac AS P
WITH(NOLOCK) INNER JOIN sayackart AS S
ON (P.sayackod=S.kod and p.varno=@varno)  )

================================================================================
