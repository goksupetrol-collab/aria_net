-- Stored Procedure: dbo.SpMarketVardiyaNcrFisNoKontrol
-- Tarih: 2026-01-14 20:06:08.376969
================================================================================

CREATE PROCEDURE dbo.SpMarketVardiyaNcrFisNoKontrol
@Varno int
AS
BEGIN

  declare @id int
  declare pom_varx CURSOR FAST_FORWARD  FOR 
  SELECT Max(id) from marsatmas with (NOLOCK)
  where varno=@Varno and sil=0 and varok=0
  group by fis_no having count(fis_no)>1
   open pom_varx
  fetch next from  pom_varx into @id
  while @@FETCH_STATUS=0
   begin
  
    /*print @id  */
    update marsatmas set sil=1,
    deguser='NcrFisNoKontrol',degtarsaat=getdate() 
    where id=@id


  FETCH next from  pom_varx into @id
  end
 close Pom_Varx
 deallocate pom_varx

END

================================================================================
