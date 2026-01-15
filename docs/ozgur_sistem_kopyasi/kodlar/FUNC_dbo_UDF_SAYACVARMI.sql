-- Function: dbo.UDF_SAYACVARMI
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.768027
================================================================================

CREATE FUNCTION UDF_SAYACVARMI ()
RETURNS
   @TB_BOS_SAYAC TABLE (
    FIRMANO     INT,
    SAYACKOD    VARCHAR(20) COLLATE Turkish_CI_AS,
    ADAID       FLOAT,
    ADAAD       VARCHAR(50)  COLLATE Turkish_CI_AS)
AS
BEGIN

/*(@firmano int) */



   DECLARE @TABLE_TEMP TABLE (
   id					int,
   SAYACKOD			    VARCHAR(50) COLLATE Turkish_CI_AS
   )

insert into @TABLE_TEMP (SAYACKOD)
select t.sayackod from pomvardisayac t with (NOLOCK)
 inner join pomvardimas as m with (NOLOCK) on m.varno=t.varno
where t.varok=0 and t.sil=0 and m.sil=0  group by t.sayackod

 insert into @TB_BOS_SAYAC (FIRMANO,SAYACKOD,ADAID,ADAAD)
 select s.firmano,s.kod,g.id,g.ad from sayackart as s with (NOLOCK) 
 inner join grup as g with (NOLOCK) on
 s.grp1=g.id where s.drm='Aktif' and s.sil=0




 delete from @TB_BOS_SAYAC 
 where SAYACKOD in (Select SAYACKOD FROM @TABLE_TEMP )



RETURN



END

================================================================================
