-- Trigger: dbo.marsatmas_trd
-- Tablo: dbo.marsatmas
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.976619
================================================================================

CREATE TRIGGER [dbo].[marsatmas_trd] ON [dbo].[marsatmas]
WITH EXECUTE AS CALLER
FOR DELETE
AS
begin
declare @varno float,
@sattop float,@marsatid float
SET NOCOUNT ON
  

  select @varno=varno,@marsatid=marsatid from deleted


   if @marsatid=0
    return


  exec stokhrkisle 0,'marsathrk','',1,1,@marsatid
  
  delete from marsathrk where varno=@varno and marsatid=@marsatid
  
  exec SpRehberMarketSatisKomisyon @marsatid
  
  update marvardimas set 
   satistop=dt.satistop,
   iadetop=dt.iadetop,
   naksattop=dt.naktop,
   postop=dt.postop,
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
  
 
  /*update from marvardimas set */

SET NOCOUNT OFF
end

================================================================================
