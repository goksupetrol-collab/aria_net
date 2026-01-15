-- Trigger: dbo.emtiasat_tru
-- Tablo: dbo.emtiasat
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.939496
================================================================================

CREATE TRIGGER [dbo].[emtiasat_tru] ON [dbo].[emtiasat]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @varno float
declare @varok float
declare @malsat float
declare @id float
declare @sil int


 if UPDATE(varok)
   RETURN

 DECLARE Var_Emtia_Sat_Cur
  CURSOR FOR SELECT id,sil,varno,varok
 FROM inserted
 OPEN Var_Emtia_Sat_Cur
 FETCH NEXT FROM Var_Emtia_Sat_Cur 
   INTO  @id,@sil,@varno,@varok
 WHILE @@FETCH_STATUS = 0
 BEGIN

   exec stokhrkisle @id,'emtiasat','',1,@sil,@id

  update pomvardimas set malsattop=(select isnull(sum(tutar),0) from emtiasat
    where varno=@varno and sil=0) where varno=@varno 
    
    
  FETCH NEXT FROM Var_Emtia_Sat_Cur INTO  @id,@sil,@varno,@varok

END
CLOSE Var_Emtia_Sat_Cur
DEALLOCATE Var_Emtia_Sat_Cur

 
    
    
    
END

================================================================================
