-- Stored Procedure: dbo.marketsatodesil
-- Tarih: 2026-01-14 20:06:08.345941
================================================================================

CREATE PROCEDURE [dbo].marketsatodesil @marsatid float
AS
BEGIN


  if isnull(@marsatid,0)=0 
   return


   update markasahrk set TransferStartId=isnull(TransferStartId,0)+1,sil=1 where marsatid=@marsatid
   update poshrk set TransferStartId=isnull(TransferStartId,0)+1,sil=1   where marsatid=@marsatid
   update veresimas set TransferStartId=isnull(TransferStartId,0)+1,sil=1 where marsatid=@marsatid
   update carihrk set TransferStartId=isnull(TransferStartId,0)+1,sil=1  where marsatid=@marsatid 
   and  islmtip='GLG' and islmhrk='MAR'
   
   
   update marsatmas set naktop=0,postop=0,veresitop=0,
   yuvtop=0 where marsatid=@marsatid
   

END

================================================================================
