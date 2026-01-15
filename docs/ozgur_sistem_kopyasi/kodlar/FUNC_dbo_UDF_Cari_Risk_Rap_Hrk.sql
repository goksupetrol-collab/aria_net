-- Function: dbo.UDF_Cari_Risk_Rap_Hrk
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.703164
================================================================================

create FUNCTION [dbo].[UDF_Cari_Risk_Rap_Hrk] (
@firmano 		int,
@BasTar		Datetime,
@BitTar		Datetime,
@RefTar     Datetime)
RETURNS
   
   @TABLE_BAKIYE_SATIS TABLE (
   id					int IDENTITY(1, 1) NOT NULL,
   Cari_Tip				VARCHAR(30) COLLATE Turkish_CI_AS,
   Cari_Kod				VARCHAR(30) COLLATE Turkish_CI_AS,
   Cari_Unvan			VARCHAR(200) COLLATE Turkish_CI_AS,
   SrNo					int,
   Ack					VARCHAR(200) COLLATE Turkish_CI_AS,
   Tutar				float)
  
AS
BEGIN
 
   declare  @TABLE_BAKIYE TABLE (
   id					int IDENTITY(1, 1) NOT NULL,
   Cari_Tip				VARCHAR(30) COLLATE Turkish_CI_AS,
   Cari_Kod				VARCHAR(30) COLLATE Turkish_CI_AS,
   Cari_Unvan			VARCHAR(200) COLLATE Turkish_CI_AS,
   Tarih				Datetime,
   Vade_Tarih			Datetime,
   Islem_Ad				VARCHAR(50) COLLATE Turkish_CI_AS,
   Borc					float,
   Odeme				float,
   Alacak			    float,
   Ack					VARCHAR(200) COLLATE Turkish_CI_AS)


 /*borc */
  if @firmano=0
  insert into @TABLE_BAKIYE
  select k.cartip,k.kod,k.Unvan,
  h.tarih,h.vadetar,h.islmhrkad,
  Borc,0,Alacak,Ack  
  from carihrk as h  with (NOLOCK)
  inner join Genel_Cari_Kart as k 
  on h.cartip=k.cartip and h.carkod=k.kod
  and h.sil=0 and k.CarTip_id=1
  where h.tarih>=@BasTar
  and h.tarih<=@BitTar
  
  
  if @firmano>0
  insert into @TABLE_BAKIYE
  select k.cartip,k.kod,k.Unvan,
  h.tarih,h.vadetar,h.islmhrkad,
  Borc,0,Alacak,Ack  
  from carihrk as h with (NOLOCK)
  inner join Genel_Cari_Kart as k 
  on h.cartip=k.cartip and h.carkod=k.kod
  and h.sil=0 and k.CarTip_id=1
  and h.firmano in (0,@firmano)
  where h.tarih>=@BasTar
  and h.tarih<=@BitTar
  
  
  
    declare @id int
    declare @Say int
    declare @Kod varchar(50)
    declare @Alacak  Float
    declare @Bakiye  Float
    declare @Tarih  Datetime
    
     declare pom_var CURSOR FAST_FORWARD  FOR 
      select Cari_Kod,Alacak,Tarih From @TABLE_BAKIYE       
      where Alacak>0 Order By Cari_Kod,Vade_Tarih
      open pom_var
     fetch next from  pom_var into @Kod,@Alacak,@Tarih
      while @@FETCH_STATUS=0
      begin
    
     SET @Bakiye=0
    
      Select Top 1 @id=id,@Bakiye=Borc-Odeme From @TABLE_BAKIYE 
      Where  Cari_Kod=@Kod and Borc-Odeme>0 order by id


      while (@Bakiye>0.1)             
      begin

        if @Bakiye>= @Alacak
         begin
            Update @TABLE_BAKIYE Set Odeme=Odeme+@Alacak 
            Where id=@id 
            set  @Bakiye=0
         end
        
          if (@Bakiye <= @Alacak) and (@Bakiye>0.1)
          begin
   
           Update @TABLE_BAKIYE Set Odeme=Odeme+@Bakiye Where id=@id
            set @Alacak=@Alacak-@Bakiye       
            
            
             Select Top 1 @id=id,@Bakiye=isnull(Borc-Odeme,0) From @TABLE_BAKIYE 
              Where  Cari_Kod=@Kod and (Borc-Odeme)>0 order by id 
          end 
          
       end /*while */
      


      FETCH next from  pom_var into @Kod,@Alacak,@Tarih
     end
    close Pom_Var
    deallocate pom_var

  
  
  
  
  
  
  insert into @TABLE_BAKIYE_SATIS
  select Cari_Tip,Cari_Kod,Cari_Unvan,
  1,'YAPILAN ALIM',Sum(Borc) from  @TABLE_BAKIYE
  Group by  Cari_Tip,Cari_Kod,Cari_Unvan
  order by Cari_Tip,Cari_Kod,Cari_Unvan

  
  
  insert into @TABLE_BAKIYE_SATIS
   select Cari_Tip,Cari_Kod,Cari_Unvan,
   2,'YAPILAN ÖDEME',Sum(ALACAK) from @TABLE_BAKIYE
   Group by  Cari_Tip,Cari_Kod,Cari_Unvan
   order by Cari_Tip,Cari_Kod,Cari_Unvan 
   
   
   
   insert into @TABLE_BAKIYE_SATIS
   select Cari_Tip,Cari_Kod,Cari_Unvan,
   3,'VADESİ GEÇMİŞ BORÇ',Sum(borc-Odeme) from  @TABLE_BAKIYE
   Where Vade_Tarih<@RefTar
   Group by  Cari_Tip,Cari_Kod,Cari_Unvan
   order by Cari_Tip,Cari_Kod,Cari_Unvan 
   
   /* not in */
   insert into @TABLE_BAKIYE_SATIS
   select Cari_Tip,Cari_Kod,Cari_Unvan,
   3,'VADESİ GEÇMİŞ BORÇ',0 from  @TABLE_BAKIYE
   Where Cari_Kod not in (Select Cari_Kod From @TABLE_BAKIYE_SATIS Where SrNo=3)
   Group by  Cari_Tip,Cari_Kod,Cari_Unvan
   order by Cari_Tip,Cari_Kod,Cari_Unvan 
   

   
   insert into @TABLE_BAKIYE_SATIS
   select Cari_Tip,Cari_Kod,Cari_Unvan,
   4,'VADESİ GELECEK BORÇ',Sum(borc-Odeme) from  @TABLE_BAKIYE
   Where Vade_Tarih>=@RefTar
   Group by  Cari_Tip,Cari_Kod,Cari_Unvan
   order by Cari_Tip,Cari_Kod,Cari_Unvan 
   
   
   
   /* not in */
   insert into @TABLE_BAKIYE_SATIS
   select Cari_Tip,Cari_Kod,Cari_Unvan,
   4,'VADESİ GELECEK BORÇ',0 from  @TABLE_BAKIYE
   Where Cari_Kod not in (Select Cari_Kod From @TABLE_BAKIYE_SATIS Where SrNo=4)
   Group by  Cari_Tip,Cari_Kod,Cari_Unvan
   order by Cari_Tip,Cari_Kod,Cari_Unvan 
   
     
   insert into @TABLE_BAKIYE_SATIS
   select Cari_Tip,Cari_Kod,Cari_Unvan,
   5,'CARİ BORÇ', Sum(Tutar) from  @TABLE_BAKIYE_SATIS
   Where SrNo in (3,4)
   Group by  Cari_Tip,Cari_Kod,Cari_Unvan
   order by Cari_Tip,Cari_Kod,Cari_Unvan 
   
   
   insert into @TABLE_BAKIYE_SATIS
   select 'carikart',Kod,'',
   6,'TEMİNAT TUTAR', isnull(Sum(Tutar),0) from  cariteminat
   Where Kod in (Select Cari_Kod From @TABLE_BAKIYE_SATIS)
   Group by  Kod   order by Kod
  
  
   /* not in */
   insert into @TABLE_BAKIYE_SATIS
   select Cari_Tip,Cari_Kod,Cari_Unvan,
   6,'TEMİNAT TUTAR',0 from  @TABLE_BAKIYE
   Where Cari_Kod not in (Select Cari_Kod From @TABLE_BAKIYE_SATIS Where SrNo=6)
   Group by  Cari_Tip,Cari_Kod,Cari_Unvan
   order by Cari_Tip,Cari_Kod,Cari_Unvan 
   
   
  insert into @TABLE_BAKIYE_SATIS
   select 'carikart',carkod,'',
   7,'İLERİ VADELİ ÇEK',Sum(giren) from cekkart where cartip='carikart'
   and Sil=0 and vadetar>=@RefTar
   and carkod in (Select Cari_Kod From @TABLE_BAKIYE_SATIS)
   Group by  carkod  

   
   /* not in */
   insert into @TABLE_BAKIYE_SATIS
   select Cari_Tip,Cari_Kod,Cari_Unvan,
   7,'İLERİ VADELİ ÇEK',0 from  @TABLE_BAKIYE
   Where Cari_Kod not in (Select Cari_Kod From @TABLE_BAKIYE_SATIS Where SrNo=7)
   Group by  Cari_Tip,Cari_Kod,Cari_Unvan
   order by Cari_Tip,Cari_Kod,Cari_Unvan 



   insert into @TABLE_BAKIYE_SATIS
   select Cari_Tip,Cari_Kod,Cari_Unvan,
   8,'RİSK',Sum(Tutar) from  @TABLE_BAKIYE_SATIS
   Where SrNo in (5)
   Group by  Cari_Tip,Cari_Kod,Cari_Unvan
   order by Cari_Tip,Cari_Kod,Cari_Unvan 
   
   
   UPDATE @TABLE_BAKIYE_SATIS SET Tutar=Tutar+isnull(dt.Tutr,0) from  @TABLE_BAKIYE_SATIS
   as t join (Select Cari_Kod,Tutar as  Tutr From @TABLE_BAKIYE_SATIS where SrNo=7) dt 
   on Dt.Cari_Kod=t.Cari_Kod and T.Srno=8
   
   
   
   UPDATE @TABLE_BAKIYE_SATIS SET Tutar=Tutar-isnull(dt.Tutr,0) from  @TABLE_BAKIYE_SATIS
   as t join (Select Cari_Kod,Tutar as Tutr From @TABLE_BAKIYE_SATIS where SrNo=6) dt 
   on Dt.Cari_Kod=t.Cari_Kod and T.Srno=8
   
   
   
    UPDATE @TABLE_BAKIYE_SATIS SET Cari_Unvan=Unvan from  @TABLE_BAKIYE_SATIS
   as t join (Select kod,Unvan From Genel_Cari_Kart) dt 
   on Dt.Kod=t.Cari_Kod 
   


 RETURN


END

================================================================================
