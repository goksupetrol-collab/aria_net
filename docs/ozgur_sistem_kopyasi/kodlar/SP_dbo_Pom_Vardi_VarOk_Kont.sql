-- Stored Procedure: dbo.Pom_Vardi_VarOk_Kont
-- Tarih: 2026-01-14 20:06:08.354247
================================================================================

CREATE PROCEDURE [dbo].Pom_Vardi_VarOk_Kont
AS
BEGIN

  update pomvardisayac set Varok=1 
  where sil=0 and varok=0 
  and varno in 
  (select varno from pomvardimas with (nolock) where 
  varok=1 and sil=0 group by varno)



  update pomvardiper set Varok=1 
  where sil=0 and varok=0 
  and varno in 
  (select varno from pomvardimas with (nolock) where 
  varok=1 and sil=0 group by varno)
  

  update pomvardiperada set Varok=1 
  where sil=0 and varok=0 
  and varno in 
  (select varno from pomvardimas with (nolock) where 
  varok=1 and sil=0 group by varno)
  
  
  update pomvardistok set Varok=1 
  where sil=0 and varok=0 
  and varno in 
  (select varno from pomvardimas with (nolock) where 
  varok=1 and sil=0 group by varno)  
  
  
  update pomvarditank set Varok=1 
  where sil=0 and varok=0 
  and varno in 
  (select varno from pomvardimas with (nolock) where 
  varok=1 and sil=0 group by varno) 
  
  
  /*ters işlem   */
  update pomvardisayac set sil=1 
  where varno not in 
  (select varno from pomvardimas with (nolock) )
  
   update pomvardiper set sil=1 
   where varno not in 
   (select varno from pomvardimas with (nolock) )

   update pomvardiperada set sil=1 
   where varno not in 
   (select varno from pomvardimas with (nolock))
  

END

================================================================================
