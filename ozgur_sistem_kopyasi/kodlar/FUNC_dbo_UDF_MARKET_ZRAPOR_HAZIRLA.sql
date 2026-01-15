-- Function: dbo.UDF_MARKET_ZRAPOR_HAZIRLA
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.747016
================================================================================

CREATE FUNCTION dbo.[UDF_MARKET_ZRAPOR_HAZIRLA] 
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
   StokGrpId                int, 
   StokKod					VARCHAR(50) COLLATE Turkish_CI_AS,
   KdvYuzde					Float,
   Fiyat					Float,
   Miktar					Float,
   Tutar					Float
   )
   
AS
BEGIN
  
    DECLARE @EKSTRE_TEMP TABLE (
    StokGrpId                    int, 
    StokTip	      Varchar(10) COLLATE Turkish_CI_AS,
    StokKod	      Varchar(30) COLLATE Turkish_CI_AS,
    YkKod	      Varchar(30) COLLATE Turkish_CI_AS,		
    YkAd	      Varchar(50) COLLATE Turkish_CI_AS,
    KdvYuzde	  Float,
    Fiyat         Float,
    Miktar 		  Float,
    Tutar         Float)

    Declare @Tarih  Datetime
    Declare @FirmaNo  int
    declare @CariKod	      Varchar(50)
    
    
   

    Select @FirmaNo=Max(Firmano),
    @Tarih=MAX(Tarih) From MarVardimas with (nolock) 
    Where varno in (select * from CsvToInt(@VarNoIn))

    select @CariKod=ZraporCariKod From Firma Where id=@FirmaNo

    insert into @EKSTRE_TEMP 
    (StokTip,StokKod,KdvYuzde,Fiyat,Miktar,Tutar)
    SELECT h.stktip,h.stkod,h.kdvyuz,
    sum(( case when m.islmtip='satis' then h.mik else -1*h.mik end)*h.brmfiy)
    /sum( case when m.islmtip='satis' then h.mik else -1*h.mik end),
    
    sum(case when m.islmtip='satis' then h.mik else -1*h.mik end),
    sum((case when m.islmtip='satis' then h.mik else -1*h.mik end)*h.brmfiy)
    FROM  marsatmas AS m  with (nolock)
    inner join marsathrk as h with (nolock)
    on m.marsatid=h.marsatid and  m.sil=0 and  h.sil=0
    where m.varno in (select * from CsvToInt(@VarNoIn))
    group by h.stktip,h.stkod,h.kdvyuz
    having abs(sum(case when m.islmtip='satis' then h.mik else -1*h.mik end))>0
       
    
    
    update @EKSTRE_TEMP set StokGrpId=dt.GrpId,
    KdvYuzde=dt.kdv/100,
    YKKod=dt.YKKod from @EKSTRE_TEMP as t
    join (select k.Tip,k.Kod,g.kdv,
    case when K.grp3>0 then K.grp3 
    when K.grp2>0 and K.grp3=0 then K.Grp2 
    when K.grp1>0 and K.grp2=0 then K.Grp1 end GrpId,
    G.ykkod from stokkart as k with (nolock) 
    inner join grup as g on g.id=k.grp1 where k.sil=0 and g.sil=0 ) dt 
    on dt.Tip=t.StokTip and dt.Kod=t.StokKod
    
    update @EKSTRE_TEMP set YkAd=dt.Ad from @EKSTRE_TEMP as t
    join (select Kod,Ad from yazarkasakart as c 
    where c.sil=0) dt on dt.Kod=t.YKKod
  
    
    
  
  insert into @TABLE_SAYAC_ZRAPOR 
  (Firmano,CariKod,Tarih,YKKod,YkAd,StokKod,KdvYuzde,Fiyat,Miktar,Tutar) 
  Select @FirmaNo,@CariKod,@Tarih,YKKod,YkAd,
  cast(StokGrpId as varchar(20)),KdvYuzde,
  round(case When Sum(Miktar)>0 then Sum(Tutar)/Sum(Miktar) else 0 end,8) Fiyat,
  Sum(Miktar),
  Sum(Tutar) From @EKSTRE_TEMP
  Group by YKKod,YkAd,StokGrpId,KdvYuzde
  
  
  update @TABLE_SAYAC_ZRAPOR set Miktar=-1,Fiyat=ABS(Tutar)
  Where Tutar<0 and Miktar=0
  
  
  
  
  
    update @TABLE_SAYAC_ZRAPOR set ZSeri=dt.zseri,ZNo= cast( isnull(Dt.zserino,0) as int)+1 
    from @TABLE_SAYAC_ZRAPOR as t
    join (select ykkod,zseri,zserino from zrapormas as c with (nolock)  where 
    id in (Select max(id) id  From zrapormas as z with (nolock) 
    Where z.sil=0 and z.firmano=@FirmaNo group by ykkod )
    ) dt on dt.ykkod=t.YKKod 
  


  return





END

================================================================================
