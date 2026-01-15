-- Stored Procedure: dbo.PomVardi_Evrak_Kont
-- Tarih: 2026-01-14 20:06:08.355930
================================================================================

CREATE PROCEDURE dbo.PomVardi_Evrak_Kont
AS
BEGIN
   
 /*veresiye fis kontrol */
  declare @varno int
  declare @min_varno int  
  declare @tarih    datetime   
  
   select @min_varno=Min(varno) from pomvardimas with (nolock)  where varno>0
   
   
  /*havuza geri al */
   update veresimas 
   set TransferStartId=isnull(TransferStartId,0)+1,
   sil=0,
   yertip=case when vtsid>0 then 'vts_islem' else 'havuzislem' end,
   yerad=case when vtsid>0 then
   (select ad from yertipad where kod='vts_islem')
   else (select ad from yertipad where kod='havuzislem') end,
   varno=0,kayok=1
   from veresimas v 
   with (nolock) where v.havuzfis=1 
   and v.varno>0 and v.varno>=isnull(@min_varno,1)
   and isnull(v.devir,0)=0
   and v.varno not in (select varno from pomvardimas 
   where varno>=isnull(@min_varno,1)) 

       
  
   update veresimas set sil=1 where 
   yertip='pomvardimas' and sil=0 and aktip='BK'
   and  varno >=isnull(@min_varno,1) and isnull(devir,0)=0
   and varno not in (select varno from pomvardimas 
   where varno>=isnull(@min_varno,1)   ) 
   
   
   
   update poshrk set sil=1 where 
   yertip='pomvardimas' and sil=0 and aktip='BK'
   and  varno >=isnull(@min_varno,1) and isnull(devir,0)=0
   and varno not in (select varno from pomvardimas 
   where varno>=isnull(@min_varno,1) )     

 
  



END

================================================================================
