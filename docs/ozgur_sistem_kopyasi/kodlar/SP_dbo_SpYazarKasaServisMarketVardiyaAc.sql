-- Stored Procedure: dbo.SpYazarKasaServisMarketVardiyaAc
-- Tarih: 2026-01-14 20:06:08.381251
================================================================================

CREATE PROCEDURE dbo.SpYazarKasaServisMarketVardiyaAc
@Firmano         int,
@Tarih           Datetime,
@Saat            varchar(20),
@OlusUser        varchar(50),
@DepoKod         Varchar(30),
@PersonelKod Varchar(30),
@ZNo			 int,
@YazKNo		     int,
@VardiyaNo       int
AS
BEGIN

   Declare @KasaKod Varchar(20)
   Declare @VardiyaAd Varchar(100)
   Declare @ParaBirim Varchar(20)
   Declare @ReturnId      int
   Declare @Kur			float
   Declare @YeniVarNo   int
       
   
   
     select top 1 @YeniVarNo=
     CONVERT(int,SUBSTRING(varad,1,CHARINDEX('.',varad)-1)) from marvardimas with (nolock) 
       where ISNUMERIC(SUBSTRING(varad,1,case when CHARINDEX('.',varad)=0 
       then 1 else CHARINDEX('.',varad) end))=1 
       and CHARINDEX('.',varad)>0 and sil=0 and firmano=@Firmano
       order by id desc
   
   
    /*- select @YeniVarNo= max(CONVERT(int,SUBSTRING(varad,1,CHARINDEX('.',varad)-1)))   */
    /*   from marvardimas with (nolock)  */
      /* where ISNUMERIC(SUBSTRING(varad,1,case when CHARINDEX('.',varad)=0 then 1 else CHARINDEX('.',varad) end))=1  */
     /*   and CHARINDEX('.',varad)>0 and sil=0 and firmano=@Firmano */
        
     if isnull(@YeniVarNo,0)=0  
       set @VardiyaAd='1. VARDİYA' 
      else
       set @VardiyaAd=cast(@YeniVarNo+1 as varchar(10))+'. VARDİYA'  
     
   
      
   insert into marvardimas 
   (firmano,tarih,saat,olususer,olustarsaat,
   kas_kod,bozukpara,varad,varno,depkod,perkod,parabrm,kur,
   ZNo,Yaz_KNo,Kaptar,kapsaat,YazarKasaServis,YazarKasaVardiyaNo)
   values 
   (@Firmano,@Tarih,@Saat,@OlusUser,GetDate(),
   @KasaKod,0,@VardiyaAd,0,@DepoKod,@PersonelKod,@ParaBirim,@Kur,
   @ZNo,@YazKNo,null,null,1,@VardiyaNo)
   
   select @ReturnId=SCOPE_IDENTITY() 

    update marvardimas Set varno=@ReturnId Where id=@ReturnId


   return @ReturnId

END

================================================================================
