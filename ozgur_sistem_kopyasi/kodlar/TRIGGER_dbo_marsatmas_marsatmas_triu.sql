-- Trigger: dbo.marsatmas_triu
-- Tablo: dbo.marsatmas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.977306
================================================================================

CREATE TRIGGER [dbo].[marsatmas_triu] ON [dbo].[marsatmas]
WITH EXECUTE AS CALLER
FOR UPDATE
AS
BEGIN
declare @varno 		float
declare @sattop 	float
declare @iadetop 	float
declare @marsatid 	float
declare @kayok 		int
declare @sil 		int
declare @varok 		int
declare @id 		float
declare @d_sil		int
declare @d_kayok	int

SET NOCOUNT ON


BEGIN TRY
    BEGIN TRAN

DECLARE Cur_Marsat_Up CURSOR LOCAL FOR 
 SELECT i.id,i.marsatid,i.sil,i.kayok,i.varno,i.varok,
 d.sil,d.kayok
 FROM inserted as i inner join deleted as d
 on d.id=i.id
 
 OPEN Cur_Marsat_Up
  FETCH NEXT FROM Cur_Marsat_Up INTO  
  @id,@marsatid,@sil,@kayok,@varno,@varok,
  @d_sil,@d_kayok
  WHILE @@FETCH_STATUS = 0
  BEGIN


   if @marsatid>0
    begin

   

     if update(sil) and (@sil<>@d_sil)
      begin
      if @sil=1
      begin
       if @marsatid> 0
        begin
         update marsathrk set sil=1 where varno=@varno and marsatid=@marsatid
         update markasahrk set sil=1 where varno=@varno and marsatid=@marsatid
         update poshrk set sil=1 where varno=@varno and marsatid=@marsatid  
         update carihrk set sil=1 where varno=@varno and marsatid=@marsatid
         update veresimas set sil=1 where varno=@varno and marsatid=@marsatid
       end  
      end
     end
     
     
     if (@kayok=1) and ( (@sil<>@d_sil) or (@kayok<>@d_kayok) )
     begin 
       exec MarSatRecHrkOlustur @marsatid
       exec stokhrkisle @id,'marsathrk','',@kayok,@sil,@marsatid
       exec SpRehberMarketSatisKomisyon @marsatid 
       exec SpMarketSatisBedelsizBarkod @marsatid
      end    
     

   if (@sil<>@d_sil) or (@kayok=1 and @varok=0)
      update marvardimas set 
       satistop=dt.satistop,
       iadetop=dt.iadetop,
       naksattop=dt.naktop,
       /*postop=dt.postop, */
       veresitop=dt.veresitop,
       indtop=dt.indtop
       from marvardimas t WITH (NOLOCK) join
       (select 
       isnull(sum(satistop),0) as satistop,
       isnull(sum(iadetop),0) as iadetop,
       isnull(sum(naktop),0) as naktop,
       isnull(sum(postop),0) as postop,
       isnull(sum(veresitop),0) as veresitop,
       isnull(sum(indtop),0) as indtop
       from  marsatmas WITH (NOLOCK) where 
       varno=@varno and sil=0 )
       dt on t.varno=@varno and t.sil=0
   end    
     

   FETCH NEXT FROM Cur_Marsat_Up INTO  
   @id,@marsatid,@sil,@kayok,@varno,@varok,
  @d_sil,@d_kayok
  END
  CLOSE Cur_Marsat_Up
  DEALLOCATE Cur_Marsat_Up



  COMMIT TRAN
    END TRY
    BEGIN CATCH
        RAISERROR('Errormessage', 18, 1)
        ROLLBACK TRAN
    END CATCH



SET NOCOUNT OFF

END

================================================================================
