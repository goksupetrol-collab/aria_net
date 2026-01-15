-- Stored Procedure: dbo.SpVeresiFisKmKontrol
-- Tarih: 2026-01-14 20:06:08.380292
================================================================================

CREATE PROCEDURE dbo.SpVeresiFisKmKontrol
AS
BEGIN

  update veresimas set OncekiKm=0 where OncekiKm is null

  declare @id int
  declare @sayac int
  declare @cartip varchar(30)
  declare @carkod varchar(30)
  declare @plaka varchar(30)
  declare @TarihSaat datetime
  declare @km float
  declare @oncekikm float
  
  
  
  declare @varno int
  declare pom_varx CURSOR FAST_FORWARD  FOR 
  SELECT plaka from veresimas where Sil=0 and isnull(Km,0)>0
  and plaka<>''
  group by plaka
   open pom_varx
  fetch next from  pom_varx into @plaka
  while @@FETCH_STATUS=0
   begin
  

       set @sayac=0
       
        declare pom_var CURSOR FAST_FORWARD  FOR 
        SELECT id,cartip,carkod,km,tarih+isnull(saat,'00:00:00') TarihSaat 
         from veresimas where Sil=0
         and isnull(Km,0)>0 and plaka=@plaka
         /*and isnull(OncekiKm,0)=0 */
         order by TarihSaat asc
         open pom_var
        fetch next from  pom_var into @id,@cartip,@carkod,@km,@TarihSaat
        while @@FETCH_STATUS=0
         begin
        
        if @sayac>0 
         update veresimas set oncekikm=@oncekikm where id=@id  
          
         
         set @oncekikm=@km 
         
        set @sayac=@sayac+1 



        FETCH next from  pom_var into @id,@cartip,@carkod,@km,@TarihSaat
        end
       close Pom_Var
       deallocate pom_var
       
 
 
 
 
  FETCH next from  pom_varx into @plaka
  end
 close Pom_Varx
 deallocate pom_varx
 
 
END

================================================================================
