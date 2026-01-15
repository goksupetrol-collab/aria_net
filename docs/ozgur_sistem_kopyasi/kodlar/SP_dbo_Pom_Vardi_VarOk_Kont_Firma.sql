-- Stored Procedure: dbo.Pom_Vardi_VarOk_Kont_Firma
-- Tarih: 2026-01-14 20:06:08.354631
================================================================================

Create PROCEDURE [dbo].[Pom_Vardi_VarOk_Kont_Firma]
@Firmano int
AS
BEGIN

  update pomvardisayac set Varok=1 
  where sil=0 and varok=0 and Firmano=@Firmano
  and varno in 
  (select varno from pomvardimas with (nolock) where 
  varok=1 and sil=0 and Firmano=@Firmano group by varno)



  update pomvardiper set Varok=1 
  where sil=0 and varok=0 and Firmano=@Firmano
  and varno in 
  (select varno from pomvardimas with (nolock) where 
  varok=1 and sil=0 and Firmano=@Firmano group by varno)
  

  update pomvardiperada set Varok=1 
  where sil=0 and varok=0  and Firmano=@Firmano
  and varno in 
  (select varno from pomvardimas with (nolock) where 
  varok=1 and sil=0 and Firmano=@Firmano group by varno)
  
  /* 
  update pomvardistok set Varok=1 
  where sil=0 and varok=0  and Firmano=@Firmano
  and varno in 
  (select varno from pomvardimas with (nolock) where 
  varok=1 and sil=0 and Firmano=@Firmano group by varno)  
  
  
  update pomvarditank set Varok=1 
  where sil=0 and varok=0  and Firmano=@Firmano
  and varno in 
  (select varno from pomvardimas with (nolock) where 
  varok=1 and sil=0 and Firmano=@Firmano group by varno) 
  */
  
  /*ters işlem   */
  update pomvardisayac set sil=1 
  where  Firmano=@Firmano and varno not in 
  (select varno from pomvardimas with (nolock) where Firmano=@Firmano )
  
   update pomvardiper set sil=1 
   where Firmano=@Firmano and varno not in 
   (select varno from pomvardimas with (nolock) where Firmano=@Firmano )

   update pomvardiperada set sil=1 
   where Firmano=@Firmano and varno not in 
   (select varno from pomvardimas with (nolock) where Firmano=@Firmano )
  

END

================================================================================
