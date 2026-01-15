-- Trigger: dbo.ResSatMas_tru
-- Tablo: dbo.ResSatMas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:09.009982
================================================================================

CREATE TRIGGER [dbo].[ResSatMas_tru] ON [dbo].[ResSatMas]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @varno 		float
declare @sattop 	float
declare @iadetop 	float
declare @kayok 		int
declare @sil 		int
declare @id 		float
declare @d_sil		int
declare @d_kayok	int


SET NOCOUNT ON


DECLARE Cur_Marsat_Up CURSOR LOCAL FOR 
 SELECT i.Id,i.sil,i.kayok,i.VarNo,
 d.sil,d.kayok
 FROM inserted as i inner join deleted as d
 on d.Id=i.Id
 
 OPEN Cur_Marsat_Up
  FETCH NEXT FROM Cur_Marsat_Up INTO  
  @id,@sil,@kayok,@varno,
  @d_sil,@d_kayok
  WHILE @@FETCH_STATUS = 0
  BEGIN

    /* if (@kayok=1)  */
  
     if (@kayok=1) and ( (@sil<>@d_sil) or (@kayok<>@d_kayok) )
     begin 
       exec ResSatRecHrkOlustur @id
       exec stokhrkisle @id,'ResSatHrk','',@kayok,@sil,@id
      end   
  


     if update(sil) 
      begin
      if @sil=1
      begin
       update Ressathrk set sil=1  where ResSatId=@id
       update ResSatkasahrk set sil=1 where ResSatId=@id
       update poshrk set sil=1 where varno=@varno and ResSatId=@id
      /*  update carihrk set sil=1 where varno=@varno and ResSatId=@id */
      /*update veresimas set sil=1 where varno=@varno and ResSatId=@id */
      end
     end

   if (@kayok=1)
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
   @id,@sil,@kayok,@varno,
   @d_sil,@d_kayok
  END
  CLOSE Cur_Marsat_Up
  DEALLOCATE Cur_Marsat_Up


SET NOCOUNT OFF

END

================================================================================
