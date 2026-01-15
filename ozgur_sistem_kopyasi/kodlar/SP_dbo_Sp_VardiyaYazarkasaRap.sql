-- Stored Procedure: dbo.Sp_VardiyaYazarkasaRap
-- Tarih: 2026-01-14 20:06:08.367996
================================================================================

CREATE PROCEDURE dbo.Sp_VardiyaYazarkasaRap (@Firmano int,@VarTip int,@Varno varchar(4000))
AS
BEGIN


   create Table  #Table (
    Id              int IDENTITY(1, 1) NOT NULL,
    Tip             int,
    UrunTip	        nvarchar(50),
    UrunKod	        nvarchar(50),
    UrunAd          nvarchar(100),
    UrunKdv         Float Default 0, 
    Fis             Float Default 0,
    Emc          	Float Default 0,
    TTS             Float Default 0,
    VeresiyeTutar       Float Default 0,
    VardiyaUrunTutar 	Float Default 0,
    VardiyaUrunFiyat       Float Default 0,
    VardiyaUrunMiktar      Float Default 0,
    ZRaporUrunTutar 	Float Default 0,
    ZraporUrunFiyat       Float Default 0,
    ZraporUrunMiktar      Float Default 0,
    ZRaporFarkTutar 	Float Default 0,
    ZraporFarkMiktar      Float Default 0,
    
    
    Transfer        Float Default 0,
    AraTutar       Float Default 0,
    Pos1Kod         varchar(50),
    Pos1Tutar      Float Default 0,
    Pos2Kod         varchar(50),
    Pos2Tutar      Float Default 0,
    Pos3Kod         varchar(50),
    Pos3Tutar      Float Default 0,
    Pos4Kod         varchar(50),
    Pos4Tutar      Float Default 0,    
    Pos5Kod         varchar(50),
    Pos5Tutar      Float Default 0,
    Pos6Kod         varchar(50),
    Pos6Tutar      Float Default 0,
    Pos7Kod         varchar(50),
    Pos7Tutar      Float Default 0,
    Pos8Kod         varchar(50),
    Pos8Tutar      Float Default 0,
    PosTutar      Float Default 0,
    NakitTutar    Float Default 0,
    
    NakitKdvTutar    Float Default 0,
    PosKdvTutar    Float Default 0,
    
    
    
   )
   
   if @VarTip=1
    begin
    
     insert into #Table (Tip,UrunTip,UrunKod,UrunAd,UrunKdv,VardiyaUrunFiyat,VardiyaUrunMiktar,VardiyaUrunTutar) 
     Select  1,stktip,Kod,'',max(kdvyuz),
     case when sum(satmik)=0 then max(brimfiy) else sum(satmik*brimfiy)/sum(satmik) end brimfiy,
     sum(satmik) satmik,
     sum(satmik*brimfiy) tutar from pomvardistok with (nolock)
     where varno in (Select * From CsvToInt(@Varno)) and Sil=0
     group by stktip,Kod
     
     insert into #Table (Tip,UrunTip,UrunKod,UrunAd,UrunKdv)
     values (2,'','','Toplam','0')
     
    /* insert into #Table (Tip,UrunTip,UrunKod,UrunAd,UrunKdv) */
   /*  values (3,'','','Kasa','0') */
     
     
     
     
     
     /*veresiye Fis */
     update #Table  Set Fis=dt.Tutar From #Table  as t 
     join (Select h.stktip,h.stkod,Sum(h.mik*h.brmfiy) Tutar 
     From  veresimas as m with (NOLOCK)
     inner join  veresihrk as h with (NOLOCK) on m.verid=h.verid and m.sil=0 and h.Sil=0
     and m.fistip='FISVERSAT' and m.ototag=0
     where  m.yertip='pomvardimas' and m.varno in (Select * From CsvToInt(@Varno)) 
     group by h.stktip,h.stkod  ) dt
     on dt.stktip=t.UrunTip and dt.stkod=t.UrunKod

    /*tts */
     update #Table  Set TTS=dt.Tutar From #Table  as t 
     join (Select h.stktip,h.stkod,Sum(h.mik*h.brmfiy) Tutar 
     From  veresimas as m with (NOLOCK)
     inner join  veresihrk as h with (NOLOCK) on m.verid=h.verid and m.sil=0 and h.Sil=0
     and m.fistip='FISVERSAT' and m.ototag>0
     where  m.yertip='pomvardimas' and m.varno in (Select * From CsvToInt(@Varno)) 
     group by h.stktip,h.stkod  ) dt
     on dt.stktip=t.UrunTip and dt.stkod=t.UrunKod
     
     
   /*Veresiye Tutar */
     update #Table  Set VeresiyeTutar=Fis+Emc+TTS  
     
       
     update #Table  Set 
     ZRaporUrunTutar=dt.Tutar,
     ZraporUrunFiyat=dt.fiyat,
     ZraporUrunMiktar=dt.Miktar     
     From #Table  as t 
     join (Select h.tip,h.kod,
      case when Sum(h.miktar)>0 then  
     Sum(h.miktar*h.brmfiy)/Sum(h.miktar) else
      1 end as Fiyat,
     Sum(h.miktar) miktar,
     Sum(h.miktar*h.brmfiy) Tutar 
     From  zrapormas as m with (NOLOCK)
     inner join  zraporhrk as h with (NOLOCK) on m.zrapid=h.zrapid  and h.Sil=0
     inner join ZraporVardiya as v with (NOLOCK) on m.zrapid=v.zrapid 
     and v.varno in (Select * From CsvToInt(@Varno))  and v.Sil=0
     where m.sil=0
     group by h.tip,h.kod  ) dt
     on dt.tip=t.UrunTip and dt.kod=t.UrunKod
     
     
     
     /*Veresiye Tutar */
       update #Table  Set AraTutar=VardiyaUrunTutar-VeresiyeTutar
     
     
     
   DECLARE @sSQL nvarchar(4000)
    declare @i int
    set @i=1
    declare @poskod varchar(50)
    declare @giren   float
    declare pom_var CURSOR FAST_FORWARD  FOR 
    select poskod,sum(giren) giren from poshrk with (nolock) 
    where varno in (Select * From CsvToInt(@Varno)) and sil=0 and yertip='pomvardimas'
    group by Poskod
     open pom_var
     fetch next from  pom_var into @poskod,@giren
     while @@FETCH_STATUS=0
      begin
       
      /*Tutar Yaz  */
       set @sSQL='Update #Table set '+
       'Pos'+cast(@i as varchar(5))+'kod='''+cast(@poskod as varchar(50))+''','+
       'Pos'+cast(@i as varchar(5))+'Tutar='''+cast(@giren as varchar(50))+''' where Tip=2 '
       EXEC (@sSQL)
       
        set @sSQL='Update #Table set Pos'+cast(@i as varchar(5))+'kod='''+cast(@poskod as varchar(50))+''' where Tip=1 '
        EXEC (@sSQL) 
       
                  
        
        DECLARE @retval float   
        DECLARE @ParmDefinition nvarchar(500);

       /*AraTutar */

        SELECT @sSQL = N'SELECT top 1 @retvalOUT = Id FROM #Table where Tip=1 and (AraTutar-PosTutar)>=@araTutar'
        SET @ParmDefinition = N'@araTutar float,@retvalOUT float OUTPUT'
        EXEC sp_executesql @sSQL, @ParmDefinition,@giren,@retvalOUT=@retval OUTPUT
        /*SELECT @retval */
        
        
        set @sSQL='Update #Table set Pos'+cast(@i as varchar(5))+'Tutar=@giren where Id=@Id '
        SET @ParmDefinition = N'@giren float,@Id int'
        EXEC sp_executesql @sSQL,@ParmDefinition,@giren,@retval
       
        set @sSQL='Update #Table set PosTutar=PosTutar+@giren where Tip=1 and Id=@Id'
        SET @ParmDefinition = N'@giren float,@Id int'
        EXEC sp_executesql @sSQL,@ParmDefinition,@giren,@retval
            
     
      
      set @i=@i+1

      FETCH next from  pom_var into @poskod,@giren
     end
   close Pom_Var
   deallocate pom_var
     

  
    
  
 

    end
   
   
     
     update #Table  Set UrunAd=dt.Ad From #Table  as t 
     join (Select tip,kod,ad From  stokkart as m with (NOLOCK) ) dt
     on dt.tip=t.UrunTip and dt.kod=t.UrunKod
    
     
     
    
     
   
    Update #Table set ZRaporFarkTutar=VardiyaUrunTutar-ZRaporUrunTutar,
    ZRaporFarkMiktar=VardiyaUrunMiktar-ZRaporUrunMiktar where Tip=1
    Update #Table set NakitTutar=AraTutar-PosTutar where Tip=1
   
    Update #Table set NakitKdvTutar=NakitTutar-(NakitTutar/(1+UrunKdv)) where Tip=1
    Update #Table set PosKdvTutar=PosTutar-(PosTutar/(1+UrunKdv)) where Tip=1
   
   
   
   
     update #Table  Set 
     TTS=dt.TTS,Fis=dt.Fis,Emc=Dt.Emc,
     VardiyaUrunMiktar=dt.VardiyaUrunMiktar,
     VardiyaUrunTutar=dt.VardiyaUrunTutar,
     ZraporUrunMiktar=dt.ZraporUrunMiktar,
     ZraporUrunTutar=dt.ZraporUrunTutar,
     ZRaporFarkTutar=dt.ZRaporFarkTutar,
     ZRaporFarkMiktar=dt.ZRaporFarkMiktar,
     PosTutar=Dt.PosTutar,
     NakitTutar=Dt.NakitTutar,
     NakitKdvTutar=dt.NakitKdvTutar,
     PosKdvTutar=dt.PosKdvTutar
     
     From #Table  as t 
     join (Select Sum(Fis) Fis,Sum(Emc) Emc,Sum(TTS) TTS,
     Sum(VardiyaUrunMiktar) VardiyaUrunMiktar,Sum(VardiyaUrunTutar) VardiyaUrunTutar,
     Sum(ZraporUrunMiktar) ZraporUrunMiktar,Sum(ZraporUrunTutar) ZraporUrunTutar,
     Sum(ZRaporFarkTutar) ZRaporFarkTutar,Sum(ZRaporFarkMiktar) ZRaporFarkMiktar,
     Sum(PosTutar) PosTutar,Sum(NakitTutar) NakitTutar,
     Sum(NakitKdvTutar) NakitKdvTutar,Sum(PosKdvTutar) PosKdvTutar
     From  #Table Where Tip=1 ) dt
     on t.Tip=2
   
   
   
    
   Select * From #Table
   
   
   



END

================================================================================
