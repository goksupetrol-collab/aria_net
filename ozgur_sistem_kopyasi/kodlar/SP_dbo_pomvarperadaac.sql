-- Stored Procedure: dbo.pomvarperadaac
-- Tarih: 2026-01-14 20:06:08.358522
================================================================================

CREATE PROCEDURE [dbo].pomvarperadaac
@firmano int,
@varno float,
@tip varchar(30)
AS
BEGIN
/*@firmano int */

declare @perkod varchar(50)
declare @perad varchar(50)
declare @adad varchar(30)
declare @adaid int
declare @adabag int
SET NOCOUNT ON

select @adabag=adabag from pomvardimas with (nolock) where varno=@varno

/*sadece personele gore */
if @tip='per'
begin
 DECLARE vardiadapercac CURSOR LOCAL FOR SELECT per,perad
 FROM pomvardiper with (nolock) where varno=@varno and firmano=@firmano
 and Sil=0
 OPEN vardiadapercac
 FETCH NEXT FROM vardiadapercac INTO  @perkod,@perad
 WHILE @@FETCH_STATUS <> -1
 BEGIN

      EXEC pomvarpersayac  @firmano,@varno,@perkod,@perad,0,'Tum'
 
 
   FETCH NEXT FROM vardiadapercac INTO  @perkod,@perad

  END
  CLOSE vardiadapercac
  DEALLOCATE vardiadapercac
  
end;

if @tip='ada'
begin
 DECLARE vardiadapercac CURSOR LOCAL FOR 
 SELECT per,adaid,adad
 FROM pomvardiperada with (nolock)
  where varno=@varno and firmano=@firmano and Sil=0 and per<>''
 OPEN vardiadapercac
 FETCH NEXT FROM vardiadapercac INTO  @perkod,@adaid,@adad
 WHILE @@FETCH_STATUS <> -1
 BEGIN

 select @perad=ad from perkart as p  with (nolock)
 where firmano=@firmano and kod=@perkod and p.sil=0 and p.drm='Aktif' 

 EXEC pomvarpersayac @firmano,@varno,@perkod,@perad,@adaid,@adad
 
 if @adabag=1
  EXEC pomvarpersayac @firmano,@varno,'Diger','Diğer',@adaid,@adad

 

 FETCH NEXT FROM vardiadapercac INTO  @perkod,@adaid,@adad



  END
  CLOSE vardiadapercac
  DEALLOCATE vardiadapercac

 if @adabag=0
  EXEC pomvarpersayac @firmano,@varno,'Diger','Diğer',0,'Tum';

end

SET NOCOUNT OFF



END

================================================================================
