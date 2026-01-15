-- Trigger: dbo.veresimas_tri
-- Tablo: dbo.veresimas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.044741
================================================================================

CREATE TRIGGER [dbo].[veresimas_tri] ON [dbo].[veresimas]
WITH EXECUTE AS CALLER
FOR INSERT
AS
BEGIN
 
 Declare @idx 		float
 Declare @firmano 		float
 Declare @verIdcount 		float
 
 DECLARE veresimasin 
 CURSOR LOCAL FOR SELECT ins.id,ins.firmano
 FROM inserted as ins 
 OPEN veresimasin
 FETCH NEXT FROM veresimasin INTO  @idx,@firmano
 WHILE @@FETCH_STATUS = 0
 BEGIN
 
      update veresimas set verid=id where id=@idx and verid=0

      select @verIdcount=count(*) from veresimas with (nolock)
      where isnull(verid,0)=0 and firmano=@firmano 


     if @verIdcount>1
     begin
       RAISERROR ('verId Hatası', 16,1) 
       ROLLBACK TRANSACTION
       RETURN
     end

       

 FETCH NEXT FROM veresimasin INTO  @idx,@firmano
END
CLOSE veresimasin
DEALLOCATE veresimasin




END

================================================================================
