-- Function: dbo.UDF_VAR_SAYAC_ZRAPOR_HAZIRLA
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.792050
================================================================================

CREATE FUNCTION dbo.[UDF_VAR_SAYAC_ZRAPOR_HAZIRLA] 
(@VarNoIn varchar(500))
RETURNS
   
   @TABLE_SAYAC_ZRAPOR TABLE (
   Id					    int IDENTITY(1, 1), 
   Firmano                  int,  
   ZTip  					VARCHAR(20) COLLATE Turkish_CI_AS,
   CariKod					VARCHAR(50) COLLATE Turkish_CI_AS,
   Tarih					datetime,
   ZSeri					VARCHAR(50) COLLATE Turkish_CI_AS,
   ZNo		    			VARCHAR(50) COLLATE Turkish_CI_AS,
   YKKod     				VARCHAR(50) COLLATE Turkish_CI_AS,
   YkAd	                    Varchar(50) COLLATE Turkish_CI_AS,
   StokKod					VARCHAR(50) COLLATE Turkish_CI_AS,
   KdvYuzde					Float,
   Fiyat					Float,
   Litre					Float,
   Tutar					Float
   )
   
AS
BEGIN
  
    DECLARE @EKSTRE_TEMP TABLE (
    SayacKod      Varchar(30) COLLATE Turkish_CI_AS,
    StokKod	      Varchar(30) COLLATE Turkish_CI_AS,
    YkKod	      Varchar(30) COLLATE Turkish_CI_AS,		
    YkAd	      Varchar(50) COLLATE Turkish_CI_AS,
    KdvYuzde	  Float,
    Fiyat         Float,
    Litre 		  Float,
    Tutar         Float)

    Declare @Tarih  Datetime
    Declare @FirmaNo  int
    declare @CariKod	      Varchar(50)
    
    
    select @CariKod=zrap_carkod From sistemtanim

    Select @FirmaNo=Max(Firmano),@Tarih=MAX(Tarih) From PomVardimas with (nolock) 
    Where varno in (select * from CsvToInt(@VarNoIn))

    insert into @EKSTRE_TEMP 
    (SayacKod,StokKod,KdvYuzde,Fiyat,Litre,Tutar)
    SELECT p.SayacKod,p.stkod,p.kdvyuz,
    case when sum(satmik)>0 
    then sum(P.satmik*p.brimfiy)/sum(p.satmik) else 0 end,
    sum(P.satmik),sum(p.satmik*p.brimfiy)
    FROM  pomvardisayac AS p  with (nolock)
    where p.varno in (select * from CsvToInt(@VarNoIn))
    and satmik>0
    group by P.SayacKod,p.stkod,p.kdvyuz
    
    
    update @EKSTRE_TEMP set YKKod=dt.YKKod from @EKSTRE_TEMP as t
    join (select Kod,ykkod from sayackart as c 
    where c.sil=0) dt 
    on dt.Kod=t.SayacKod
    
    update @EKSTRE_TEMP set YkAd=dt.Ad from @EKSTRE_TEMP as t
    join (select Kod,Ad from yazarkasakart as c 
    where c.sil=0) dt on dt.Kod=t.YKKod
  
    
  
  insert into @TABLE_SAYAC_ZRAPOR 
  (Firmano,CariKod,Tarih,YKKod,YkAd,StokKod,KdvYuzde,Fiyat,Litre,Tutar) 
  Select @FirmaNo,@CariKod,@Tarih,YKKod,YkAd,StokKod,KdvYuzde,
  round(case When Sum(Litre)>0 then Sum(Tutar)/Sum(Litre) else 0 end,8) Fiyat,
  Sum(Litre),Sum(Tutar) From @EKSTRE_TEMP
  Group by YKKod,YkAd,StokKod,KdvYuzde
  


  return





END

================================================================================
