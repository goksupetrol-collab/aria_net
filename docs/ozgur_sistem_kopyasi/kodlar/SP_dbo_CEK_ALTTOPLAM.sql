-- Stored Procedure: dbo.CEK_ALTTOPLAM
-- Tarih: 2026-01-14 20:06:08.320034
================================================================================

CREATE PROCEDURE [dbo].CEK_ALTTOPLAM 
@DRMIN VARCHAR(4000)
AS
BEGIN

  if object_id( 'tempdb..#TB_CEK_ALTTOP' ) is null
  CREATE TABLE [dbo].[#TB_CEK_ALTTOP] (id int IDENTITY,
  ACIKLAMA  VARCHAR(50) COLLATE Turkish_CI_AS,
  TUTAR     FLOAT,
  GCTIP     INT)

     execute ('insert into #TB_CEK_ALTTOP 
     (ACIKLAMA,TUTAR,GCTIP)
     SELECT d.ad,
     sum(case when islmhrk=''ALN'' then giren
     else cikan end),
     case when islmhrk=''ALN'' then 1
     else -1 end from cekkart 
     left join cektip as d on d.kod=cekkart.drm
     where '+@DRMIN+' group by d.ad,cekkart.islmhrk')
     
     
     
     execute ('insert into #TB_CEK_ALTTOP 
     (ACIKLAMA,TUTAR,GCTIP)
     SELECT ''ALT TOPLAM FARKI'',
     sum(TUTAR*GCTIP),0  from #TB_CEK_ALTTOP')  
     
     
     
     
     
     

     select * FROM #TB_CEK_ALTTOP

END

================================================================================
