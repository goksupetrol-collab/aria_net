-- Function: dbo.UDF_BORC_YASLANDIRMA
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.689573
================================================================================

CREATE FUNCTION [dbo].[UDF_BORC_YASLANDIRMA] (
@FirmaNo 		int,
@CarKodIn       Varchar(1000),
@RefTarih		Datetime,
@VadeGun        int)
RETURNS
   
   @TABLE_BAKIYE_BORC TABLE (
   id					int ,
   Cari_Tip			    VARCHAR(20) COLLATE Turkish_CI_AS,
   Cari_Tip_Id			int,
   Cari_Kod					VARCHAR(30) COLLATE Turkish_CI_AS,
   Cari_Unvan				VARCHAR(200) COLLATE Turkish_CI_AS,
   Islem_Ad				VARCHAR(200) COLLATE Turkish_CI_AS,
   Grup 				VARCHAR(100) COLLATE Turkish_CI_AS,
   Borc      			Float,
   Alacak				Float,
   Bakiye				Float,
   Vade_Tarih			DateTime,
   Vade_Gun				int)
AS
BEGIN
 
 
   declare @CariTip Varchar(20)
   declare @CariTipId  int
   
   set @CariTip='carikart'
   set @CariTipId=1 



    insert into @TABLE_BAKIYE_BORC (id,Cari_Tip,Cari_Tip_Id,
    Cari_Kod,Islem_Ad,
    Borc,Alacak,Bakiye,Vade_Tarih,Vade_Gun)
    select h.id,@CariTip,@CariTipId,carkod,
    islmhrkad,Borc,0,0,VadeTar,0 From carihrk as h with (NOLOCK)
 
    Where carTip=@CariTip
    and H.Carkod in (Select * from  dbo.CsvToSTR(@CarKodIn))
    and h.Sil=0 and h.Borc>0 and h.firmano in (0,@FirmaNo) 
    Order By h.carkod,h.Tarih
    
    
    declare @id int
    declare @Say int
    declare @Kod varchar(50)
    declare @Alacak  Float
    declare @Bakiye  Float
    declare @Tarih  Datetime
    
     declare pom_var CURSOR FAST_FORWARD  FOR 
      select carkod,Alacak,Tarih From carihrk with (NOLOCK) Where carTip=@CariTip
      and Carkod in (Select * from  dbo.CsvToSTR(@CarKodIn))
      and Sil=0 and Alacak>0 and firmano in (0,@FirmaNo)
      Order By carkod,Tarih
      open pom_var
     fetch next from  pom_var into @Kod,@Alacak,@Tarih
      while @@FETCH_STATUS=0
      begin
    
      Select Top 1 @id=id,@Bakiye=Borc-Alacak From @TABLE_BAKIYE_BORC 
      Where  Cari_Kod=@Kod and Borc-Alacak>0 order by id

      while (@Bakiye>0.1)             
      begin


        if @Bakiye>= @Alacak
         begin
            Update @TABLE_BAKIYE_BORC Set Alacak=Alacak+@Alacak 
            Where id=@id 
            set  @Bakiye=0
         end
        
          if (@Bakiye <= @Alacak) and (@Bakiye>0.1)
          begin
   
           Update @TABLE_BAKIYE_BORC Set Alacak=Alacak+@Bakiye Where id=@id
            set @Alacak=@Alacak-@Bakiye       
            
            select @Say=Count(id) From @TABLE_BAKIYE_BORC 
            Where  Cari_Kod=@Kod and (Borc-Alacak)>0 

            if @Say>0
             begin
               Select Top 1 @id=id,@Bakiye=isnull(Borc-Alacak,0) From @TABLE_BAKIYE_BORC 
               Where  Cari_Kod=@Kod and Borc-Alacak>0 order by id 
             end  

            if @Say=0 
             begin
                /* Alacak Bakiye Var ise */
               if @Alacak>0 
                insert into @TABLE_BAKIYE_BORC (id,Cari_Tip,Cari_Tip_Id,Cari_Kod,
                Islem_Ad,Borc,Alacak,Vade_Tarih,Vade_Gun)
                select 0,@CariTip,@CariTipId,@Kod,'ALACAK BAKİYE',0,@Alacak,@Tarih,0 
             
                set @Bakiye=0
             
             end
             
   
         end 
         
         
         
         
       end /*while */
      


      FETCH next from  pom_var into @Kod,@Alacak,@Tarih
     end
    close Pom_Var
    deallocate pom_var


  Update @TABLE_BAKIYE_BORC Set Bakiye=Borc-Alacak

   Update @TABLE_BAKIYE_BORC Set Vade_Gun=CONVERT(float, Getdate() - Vade_Tarih)
   Where Borc-Alacak>0
   
   
   Update @TABLE_BAKIYE_BORC Set Vade_Gun=CONVERT(float, Vade_Tarih-Getdate())
   Where Borc-Alacak<0


   update @TABLE_BAKIYE_BORC set Grup=GrupAd, 
   Cari_Unvan=Dt.Unvan From @TABLE_BAKIYE_BORC as t 
   join (Select k.Kod,Unvan,G.ad GrupAd From carikart as k 
    left join grup as g on g.id=case when k.grp3>0 then k.grp3
    when k.grp2>0 then k.grp2
    when k.grp1>0 then k.grp1 end ) dt 
    on dt.kod=t.Cari_Kod
   
   
    if @VadeGun>0
     delete From @TABLE_BAKIYE_BORC Where Vade_Gun<@VadeGun
   


 RETURN


END

================================================================================
