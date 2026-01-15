-- Trigger: dbo.marvardimas_trd
-- Tablo: dbo.marvardimas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.980787
================================================================================

CREATE TRIGGER [dbo].[marvardimas_trd] ON [dbo].[marvardimas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN

declare @varno int
declare @firmano int
declare @yertipyaz varchar(20)
declare @yertip varchar(20)
set @yertip='marvardimas'
set @yertipyaz='yazarkasa'


select @firmano=firmano,@varno=varno from DELETED


update marsatmas set sil=1 where varno=@varno
and (yertip=@yertip or yertip=@yertipyaz) and sil=0;
update veresimas set sil=1 where varno=@varno
and (yertip=@yertip or yertip=@yertipyaz) and sil=0;

update carihrk set sil=1 where varno=@varno
and (yertip=@yertip or yertip=@yertipyaz) and sil=0;

update kasahrk set sil=1 where varno=@varno
and (yertip=@yertip or yertip=@yertipyaz) and sil=0;
update bankahrk set sil=1 where varno=@varno
and (yertip=@yertip or yertip=@yertipyaz) and sil=0;
update poshrk set sil=1 where varno=@varno
and (yertip=@yertip or yertip=@yertipyaz) and sil=0;
update cekkart set sil=1 where varno=@varno
and (yertip=@yertip or yertip=@yertipyaz) and sil=0;

 EXECUTE marvarkabul @varno,0,1
 
 EXECUTE  Market_BozukPara @firmano,@varno,1

END

================================================================================
