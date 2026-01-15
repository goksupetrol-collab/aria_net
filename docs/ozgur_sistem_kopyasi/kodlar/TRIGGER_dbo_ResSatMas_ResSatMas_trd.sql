-- Trigger: dbo.ResSatMas_trd
-- Tablo: dbo.ResSatMas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.009379
================================================================================

CREATE TRIGGER [dbo].[ResSatMas_trd] ON [dbo].[ResSatMas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
BEGIN
declare @varno 		float
declare @sattop 	float
declare @iadetop 	float
declare @kayok 		int
declare @sil 		int
declare @id 		float


SET NOCOUNT ON


DECLARE Cur_Marsat_Up CURSOR LOCAL FOR 
 SELECT d.Id,d.sil,d.kayok,d.VarNo
 FROM deleted as d  
 OPEN Cur_Marsat_Up
  FETCH NEXT FROM Cur_Marsat_Up INTO  
  @id,@sil,@kayok,@varno
  WHILE @@FETCH_STATUS = 0
  BEGIN

    exec stokhrkisle @id,'ResSatHrk','',1,1,@id

 
       update Ressathrk set sil=1  where ResSatId=@id
       update ResSatkasahrk set sil=1 where ResSatId=@id
       update poshrk set sil=1 where varno=@varno and ResSatId=@id
      /*  update carihrk set sil=1 where varno=@varno and ResSatId=@id */
      /*update veresimas set sil=1 where varno=@varno and ResSatId=@id */
     

   
      update Resvardimas set 
       SatisTop=dt.satistop,
       IadeTop=dt.iadetop,
       naksattop=dt.naktop,
       postop=dt.postop,
      /* veresitop=dt.veresitop, */
       IndTop=dt.indtop
       from Resvardimas t join
       (select 
       isnull(sum(SatisTop),0) as satistop,
       isnull(sum(IadeTop),0) as iadetop,
       isnull(sum(NakitTop),0) as naktop,
       isnull(sum(PosTop),0) as postop,
      /* isnull(sum(veresitop),0) as veresitop, */
       isnull(sum(IndTop),0) as indtop
       from  Ressatmas where 
       varno=@varno and sil=0 )
       dt on t.varno=@varno and t.sil=0


   FETCH NEXT FROM Cur_Marsat_Up INTO  
   @id,@sil,@kayok,@varno
  END
  CLOSE Cur_Marsat_Up
  DEALLOCATE Cur_Marsat_Up


SET NOCOUNT OFF
END

================================================================================
