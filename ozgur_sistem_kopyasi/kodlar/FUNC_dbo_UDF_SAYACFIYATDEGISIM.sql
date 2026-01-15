-- Function: dbo.UDF_SAYACFIYATDEGISIM
-- Tip: SQL_INLINE_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.766980
================================================================================

CREATE FUNCTION [dbo].UDF_SAYACFIYATDEGISIM (
@SAYACKODIN        	VARCHAR(8000),
@TARIH1 			DATETIME,
@TARIH2 			DATETIME)
RETURNS TABLE AS
RETURN
(
select ps.sayackod as SAYACKOD,ps.stkod AS STOK_KOD,st.ad AS STOK_AD,
convert(varchar,min(kaptar),104)+' - '+convert(varchar,max(kaptar),104) as TARIH,
sum(ps.satmik) AS MIKTAR,st.brim AS BRIM,max(kaptar) AS KAPTARIH,
ps.brimfiy as BRIMFIYAT,(ps.brimfiy*sum(ps.satmik)) AS TUTAR
 FROM pomvardisayac as ps
 inner join stokkart as st on ps.stkod=st.kod and st.tip=ps.stktip
 inner join sayackart as sy on sy.kod=ps.sayackod
 inner join pomvardimas as pom on ps.varno=pom.varno and pom.sil=0
 AND kaptar>=@TARIH1  AND kaptar<=@TARIH2
 where PS.sayackod in (select * from CsvToSTR(@SAYACKODIN)) 
 and ps.satmik>0 and ps.varok=1
 group by ps.sayackod,ps.stkod,st.ad,st.brim,ps.brimfiy


)

================================================================================
