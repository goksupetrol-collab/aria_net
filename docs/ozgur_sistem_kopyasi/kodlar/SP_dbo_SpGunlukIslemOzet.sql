-- Stored Procedure: dbo.SpGunlukIslemOzet
-- Tarih: 2026-01-14 20:06:08.372992
================================================================================

CREATE PROCEDURE [dbo].[SpGunlukIslemOzet]
@Firmano int,
@Tarih   Datetime
AS
BEGIN

  declare @Sirano  int

  /*1.Rapor Stok Durum Rapor Urun Adi Miktar - Tutar  */
   Declare  @StokDurum TABLE (
   KARTKOD     VARCHAR(30),
   KARTAD     VARCHAR(150),
   MIKTAR      FLOAT,
   TUTAR       FLOAT
   )
																												
																											
   /*2.Rapor Pompaci Vardiya Satis Rapor Urun Adi Miktar - Tutar - Kar tutar  */
   Declare  @PompaciVardiyaDurum TABLE (
   KARTKOD     VARCHAR(30),
   KARTAD     VARCHAR(150),
   MIKTAR      FLOAT,
   TUTAR       FLOAT,
   KARTUTAR    FLOAT
   )									
																														
																														

   /*3.Rapor Pos mevduat Rapor Urun BANKA,POS  Tutar  */
   Declare  @BankaPosDurum TABLE (
   KARTKOD     VARCHAR(30),
   KARTAD     VARCHAR(150),
   MIKTAR      FLOAT,
   TUTAR       FLOAT
   )	
    
  
   /*4.Rapor Cari BorcAlacak Rapor Urun BANKA,POS  Tutar  */
   Declare  @CariBorcAlacakDurum TABLE (
   KARTKOD     VARCHAR(30),
   KARTAD     VARCHAR(150),
   MIKTAR      FLOAT,
   TUTAR       FLOAT
   )	
   
   
   /*5.Rapor GelirGider Rapor Tutar  */
   Declare  @GelirGiderDurum TABLE (
   KARTKOD     VARCHAR(30),
   KARTAD     VARCHAR(150),
   MIKTAR      FLOAT,
   TUTAR       FLOAT
   )	
   
   
   
    CREATE TABLE  #TB_RAPOR (
    Id         		    INT IDENTITY(1, 1),
    SiraNo			    int DEFAULT 1,
    BaslikNo              int default 0,
    GrupNo					int,
    DegerId				 int, 
    DegerKod		     VARCHAR(50), 
    Alan1Type            int default 0, /* string 0 - 1 float -2 tarih  */
    Alan1Deger			VARCHAR(100)  COLLATE Turkish_CI_AS DEFAULT '',
    Alan2Type			 int default 0, /* string 0 - 1 float -2 tarih  */
    Alan2Deger    	        VARCHAR(100)  COLLATE Turkish_CI_AS DEFAULT '',
    Alan3Type			 int default 0, /* string 0 - 1 float -2 tarih  */
    Alan3Deger               VARCHAR(100)  COLLATE Turkish_CI_AS DEFAULT '',
    Alan4Type			 int default 0, /* string 0 - 1 float -2 tarih  */
    Alan4Deger               VARCHAR(100)  COLLATE Turkish_CI_AS DEFAULT '',
    Alan5Type			 int default 0, /* string 0 - 1 float -2 tarih  */
    Alan5Deger               VARCHAR(100)  COLLATE Turkish_CI_AS DEFAULT '', 
    Alan6Type			 int default 0, /* string 0 - 1 float -2 tarih  */
    Alan6Deger               VARCHAR(100)  COLLATE Turkish_CI_AS DEFAULT '', 
    Alan7Type			 int default 0, /* string 0 - 1 float -2 tarih  */
    Alan7Deger               VARCHAR(100)  COLLATE Turkish_CI_AS DEFAULT ''
    )

    
    /*------------Stok Durum*/
     set @Sirano=1
     insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger)
      select 1,@Sirano,1,'Stok Durum '
    
    
     insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger,Alan2Deger,Alan3Deger,Alan4Deger)
     select 2,@Sirano,1,'ÃƒÅ“rÃƒÂ¼n ','Miktar','Tutar','Fiyat'
     
     
      insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type)
      select 5,@Sirano,1,s.Kod,Ad,1,0,1,0,1 from stokkart as s with (nolock) 
      Where s.sil=0 and s.tip='akykt' and s.firmano in (0,@Firmano)
      
      insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type)
      select 5,@Sirano,1,'markt','MARKET',1,0,1,0,1
      
      /*Son Akaryakit Tarihteki Alis Fiyat */
      
       Declare  @StokFiyat TABLE (
       Tip     VARCHAR(30),
       Kod     VARCHAR(150),
       Tarih      Datetime,
       BakiyeMiktar      float default 0,
       SatisMiktar		float default 0,
       SatisTutar		float default 0,
       AlisFiyat       float default 0,
       FifoFiyat       float default 0
       )
      
      insert into @StokFiyat (Tip,Kod,BakiyeMiktar,Tarih)
      SELECT  S.stktip,s.stkod,sum(giren-cikan),
      max(
      case when s.giren>0 then S.tarih+cast(saat as datetime) else null end)
      FROM stkhrk as s with (NOLOCK) WHERE 
      s.sil=0  and (s.tarih<=@Tarih) and s.firmano in (0,@Firmano)
      group by s.stkod,S.stktip
      
     
      update @StokFiyat set 
      SatisMiktar=round(dt.SatisMiktar,2),
      SatisTutar=round(dt.SatisTutar,2)
       from @StokFiyat as t 
      join (select sum(cikan-giren) SatisMiktar,
      sum((cikan*brmfiykdvli)-(giren*brmfiykdvli) ) as SatisTutar,
      S.stktip,s.stkod 
      from stkhrk as s with (NOLOCK) 
      where s.sil=0  and s.Tarih=@Tarih /*and s.cikan>0 */
      and s.firmano in (0,@Firmano) and s.yertip in ('marvardimas','pomvardimas')
      group by S.stktip,s.stkod ) dt on 
      dt.stktip=t.tip and dt.stkod=t.kod
           
      
      
      
        declare @i      int
        declare @Count      int
        declare @Tip    varchar(20)
        declare @Kod    varchar(50)
        declare @KodIn  varchar(500)
        declare @StokTipCount      int
       set  @StokTipCount=1
       
      WHILE @StokTipCount < 3 /*3 */
       begin
       
       
       
       
        if @StokTipCount=1
         set @Tip='akykt'
         
        if @StokTipCount=2
         set @Tip='markt'
       
       
        set @StokTipCount=@StokTipCount+1
        set @KodIn=''
        set @i=0
        declare Cur CURSOR FAST_FORWARD  FOR 
         select Tip,Kod,
         (Select Count(Kod) from @StokFiyat Where Tip=@Tip )
         Say from @StokFiyat Where Tip=@Tip
         open Cur
        fetch next from  Cur into @Tip,@Kod,@Count
        while @@FETCH_STATUS=0
         begin
          set @i=@i+1
          
            
          if @KodIn=''
           set @KodIn=@Kod
          else
           set @KodIn=@KodIn+','+@Kod
          
  
          
          
          if (@i%20)=0
           begin   
            update @StokFiyat set FifoFiyat=round(dt.BRMTUT,2) from @StokFiyat as t 
            join (select * from fn_StokFifo(@Firmano,@Tip,@KodIn,@Tarih) )dt
            on dt.STOK_TIP=t.Tip and dt.STOK_KOD=t.kod
            set @KodIn=''
          end
          
          if (@Count=@i) and @KodIn<>''
           begin   
            update @StokFiyat set FifoFiyat=dt.BRMTUT from @StokFiyat as t 
            join (select * from fn_StokFifo(@Firmano,@Tip,@KodIn,@Tarih) )dt
            on dt.STOK_TIP=t.Tip and dt.STOK_KOD=t.kod
            set @KodIn=''
          end
          
         
         FETCH next from  Cur into @Tip,@Kod,@Count
        end
       close Cur
       deallocate Cur
      
     end /* while  */
      
          
      
      update @StokFiyat set AlisFiyat=round(dt.brmfiykdvli,2) from @StokFiyat as t 
      join (select S.brmfiykdvli,S.stktip,s.stkod,
      S.tarih+cast(saat as datetime) as tarih from stkhrk as s with (NOLOCK) 
      where s.sil=0 and s.giren>0 and s.firmano in (@Firmano) ) dt on dt.Tarih=t.Tarih 
      and dt.stktip=t.tip and dt.stkod=t.kod
      
      /*Akaryakit */
      update #TB_RAPOR set 
      Alan2Deger=dt.miktar,
      Alan3Deger=dt.Tutar,
      Alan4Deger=dt.AlisFiyat  
      From #TB_RAPOR as t 
      join (select Tip,Kod,AlisFiyat,Round(BakiyeMiktar,2) Miktar,
      Round(BakiyeMiktar*AlisFiyat,2) as Tutar 
      from @StokFiyat where Tip='akykt' )
      dt on t.DegerKod=dt.Kod
      
      
       /*Market */
      update #TB_RAPOR set Alan2Deger=dt.miktar,
      Alan3Deger=dt.Tutar,
      Alan4Deger=dt.AlisFiyat From #TB_RAPOR as t 
      join (select Round(sum(BakiyeMiktar),2) Miktar,
      Round(sum(BakiyeMiktar*AlisFiyat),2) as Tutar,
      case when Round(sum(BakiyeMiktar),2)>0 then 
      Round(sum(BakiyeMiktar*AlisFiyat),2) / Round(sum(BakiyeMiktar),2) 
      else 0 end AlisFiyat 
       from @StokFiyat where Tip='markt'  )
      dt on t.DegerKod='markt'     
      
        
      /*Toplam */
       
      insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger)
      select 10,1,1,'','TOPLAM',
      1,Round(sum(BakiyeMiktar),2) Miktar,1,Round(sum(BakiyeMiktar*AlisFiyat),2)
      as Tutar from @StokFiyat
     
   /* Stok Durum Sonu */
   
     
     
    /* Pompaci Vardiya Durum*/
     set @Sirano=10
     insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger)
     select 1,@Sirano,1,'Pompaci Vardiya Satis '                                                                                                                                                     
    
    
     insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger,Alan2Deger,Alan3Deger,Alan4Deger)
     select 2,@Sirano,1,'Urun ','Miktar','Tutar','Kar'
    
    
      insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)
      select 5,@Sirano,1,s.Kod,Ad,1,0,1,0,1,0 from stokkart as s with (nolock) 
      Where s.sil=0 and s.tip='akykt' and s.firmano in (0,@Firmano)
    
    
      update #TB_RAPOR set Alan2Deger=dt.miktar,
      Alan3Deger=dt.Tutar,Alan4Deger=dt.KarTutar  
      From #TB_RAPOR as t 
      join (select Tip,Kod,Round(SatisMiktar,2) Miktar,
      Round(SatisTutar,2) as Tutar,
      Round(SatisTutar,2)-(SatisMiktar*FifoFiyat) as KarTutar
      
      from @StokFiyat where Tip='akykt' )
      dt on t.DegerKod=dt.Kod and t.SiraNo=@Sirano
      
      
      
      insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)
      select 10,@Sirano,1,'','TOPLAM',1,
      Round(Sum(SatisMiktar),2),1,Round(Sum(SatisTutar),2),
      1,Round(sum((SatisTutar)-(SatisMiktar*FifoFiyat)),2) 
      from @StokFiyat where Tip='akykt' 

    /* Pompaci Vardiya Sonu*/
    
    
    /*Pos Banka Durum */
    
    set @Sirano=20
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger)
    select 1,@Sirano,1,'Cari - Banka - Pos Durum '       
     
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger,Alan2Deger,Alan3Deger,Alan4Deger)
    select 2,@Sirano,1,'Aciklama ','Borc Bakiye','Alacak Bakiye','Bakiye'
    
    
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)  
      select TOP 1 5,@Sirano,1,'','CARi',
      1,LTRIM(STR(round(Sum(borc),2),25,2)),1,LTRIM(STR(round(Sum(alacak),2),25,2)),
      1,LTRIM(STR(round(Sum(borc-alacak),2),25,2)) FROM  carihrk as s with (nolock)
      where s.cartip='carikart' and s.Sil=0 and s.firmano in (0,@Firmano) and s.Tarih<@Tarih   
    
    
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)  
    select TOP 1 5,@Sirano,1,'','BANKA',
      1,BAKIYE_BORC,1,BAKIYE_ALACAK,1,BAKIYE_BORC-BAKIYE_ALACAK  FROM  UDF_MIZAN_BANKA (@firmano,0,'2000-01-01',@Tarih,0)
       
       
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)  
      select TOP 1 5,@Sirano,1,'','POS',
      1,BAKIYE_BORC,1,BAKIYE_ALACAK,1,BAKIYE_BORC-BAKIYE_ALACAK FROM  UDF_MIZAN_POS_BEKLEYEN (@firmano,0,'2000-01-01',@Tarih,0) 
      
      
      
      
      
     
    
      insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)
      SELECT 10,@Sirano,1,'','TOPLAM',
      1,LTRIM(STR(Sum(cast( Alan2Deger as float)),25,2)),
      1,LTRIM(STR(sum(cast( Alan3Deger as float)),25,2)),
      1,LTRIM(STR(sum(cast( Alan4Deger as float)),25,2))
      from #TB_RAPOR where BaslikNo=5 and Sirano=@Sirano
     
  
   /*Pos Banka Durum Sonu */
   
   
   
  
   
    /*Cari Durum */
    
  /*  set @Sirano=40
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger)
    select 1,@Sirano,1,'Cari  '       
     
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger,Alan2Deger,Alan3Deger,Alan4Deger)
    select 2,@Sirano,1,'AÃƒÂ§Ã„Â±klama ','BorÃƒÂ§ Bakiye','Alacak Bakiye',''
    
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger)  
    select TOP 1 5,@Sirano,1,'','BANKA',
      1,BAKIYE_BORC,1,BAKIYE_ALACAK FROM  UDF_MIZAN_BANKA (0,0,'2000-01-01',@Tarih,0)
       
       
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger)  
    select TOP 1 5,@Sirano,1,'','POS',
      1,BAKIYE_BORC,1,BAKIYE_ALACAK FROM  UDF_MIZAN_POS_BEKLEYEN (0,0,'2000-01-01',@Tarih,0) 
     
    
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger)
      SELECT 5,@Sirano,1,'','TOPLAM',1,Sum(cast( Alan2Deger as float)),1,sum(cast( Alan3Deger as float))
      from #TB_RAPOR where BaslikNo=5 and Sirano=@Sirano
    */ 
  
   /*CariDurum Sonu */
   
   
   
    
   
   
    /* Market Vardiya Satis */
     set @Sirano=50
     insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger)
     select 1,@Sirano,1,'Market Vardiya Satis '                                                                                                                                                     
    
    
     insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger,Alan2Deger,Alan3Deger,Alan4Deger)
     select 2,@Sirano,1,'Urun ','Miktar','Tutar','Kar'
    
    
      insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)
      select 5,@Sirano,1,'markt','MARKET',1,0,1,0,1,0 
       
    
      update #TB_RAPOR set Alan2Deger=dt.SatisMiktar,
      Alan3Deger=dt.SatisTutar,Alan4Deger=dt.KarTutar  
      From #TB_RAPOR as t 
      join (select  Round(Sum(SatisMiktar),2) SatisMiktar,
      Round(Sum(SatisTutar),2) SatisTutar ,
      Round(sum((SatisTutar)-(SatisMiktar*FifoFiyat)),2) KarTutar  
      from @StokFiyat where Tip='markt' )
      dt on t.SiraNo=@Sirano and BaslikNo=5
     
      insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)
      select 10,@Sirano,1,'','TOPLAM',
      1,Round(Sum(SatisMiktar),2),
      1,Round(Sum(SatisTutar),2),
      1,Round(sum((SatisTutar)-(SatisMiktar*isnull(FifoFiyat,0))),2) 
      from @StokFiyat where Tip='markt' 
   
    /* Market Vardiya Sonu*/
    
    
    
    
     /* Gelir Gider */
     set @Sirano=60
     insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger)
     select 1,@Sirano,1,'Gelir - Gider'                                                                                                                                                     
    
    
     insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger,Alan2Deger,Alan3Deger,Alan4Deger)
     select 2,@Sirano,1,'Aciklama ','Gelir','Gider','Fark'
    
    
     insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)  
      select 5,@Sirano,1,'','Gider',
      1,LTRIM(STR(isnull(round(Sum(alacak),2),0),25,2)),
      1,LTRIM(STR(isnull(round(Sum(borc),2),0),25,2)),
      1,LTRIM(STR(isnull(round(Sum(alacak-borc),2),0),25,2)) FROM  carihrk as s with (nolock)
      where s.cartip='gelgidkart' and s.Sil=0 and s.firmano in (0,@Firmano) and s.Tarih=@Tarih
      and Borc>0    
      
      
      insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)  
      select 5,@Sirano,1,'','Gelir',
      1,LTRIM(STR(isnull(round(Sum(alacak),2),0),25,2)),
      1,LTRIM(STR(isnull(round(Sum(borc),2),0),25,2)),
      1,LTRIM(STR(isnull(round(Sum(alacak-borc),2),0),25,2)) FROM  carihrk as s with (nolock)
      where s.cartip='gelgidkart' and s.Sil=0 and s.firmano in (0,@Firmano) and s.Tarih=@Tarih
      and Alacak>0   
  
    
      insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)
      SELECT 10,@Sirano,1,'','TOPLAM',
      1,LTRIM(STR(isnull(Sum(cast( Alan2Deger as float)),0),25,2)),
      1,LTRIM(STR(isnull(Sum(cast( Alan3Deger as float)),0),25,2)),
      1,LTRIM(STR(isnull(Sum(cast( Alan4Deger as float)),0),25,2))
      from #TB_RAPOR where BaslikNo=5 and Sirano=@Sirano

    /* Gelir Gider Sonu*/
    
  
  
  
   /*Kasa Durum Durum */
    
    set @Sirano=70
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger)
    select 1,@Sirano,1,'Kasa Durum '       
     
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger,Alan2Deger,Alan3Deger,Alan4Deger)
    select 2,@Sirano,1,'Aciklama ','Giren','Cikan','Bakiye'
    
           
     insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)  
      select 5,@Sirano,1,'',ACK,
      1,BORC,1,ALACAK,1,BAKIYE_BORC-BAKIYE_ALACAK FROM  UDF_MIZAN_KASA (@Firmano,0,@Tarih,@Tarih,0)
      Where ParentId=1 
      
            
     
    
      insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)
      SELECT 5,@Sirano,1,'','TOPLAM',
      1,LTRIM(STR(Sum(cast( Alan2Deger as float)),25,2)),
      1,LTRIM(STR(sum(cast( Alan3Deger as float)),25,2)),
      1,LTRIM(STR(sum(cast( Alan4Deger as float)),25,2))
      from #TB_RAPOR where BaslikNo=5 and Sirano=@Sirano
     
 
   /*Kasa Durum Sonu */


    set @Sirano=80
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger)
    select 1,@Sirano,1,'Genel Kar/Zarar '
    
     insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger,Alan2Deger,Alan3Deger)
     select 2,@Sirano,1,'Aciklama','Kar','Zarar'
    
    
      declare @KarZarar float
      select @KarZarar=Round(sum((SatisTutar)-(SatisMiktar*FifoFiyat)),2)
      from @StokFiyat 
      
      select @KarZarar=Round(sum((SatisTutar)-(SatisMiktar*FifoFiyat)),2)
      from @StokFiyat
      /*gelir gider */
      SELECT @KarZarar=@KarZarar+isnull(Sum(cast( Alan4Deger as float)),0)
      from #TB_RAPOR where BaslikNo=5 and Sirano=60
      
      
       
     
      insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger)  
      select 5,@Sirano,1,'','KAR/ZARAR',
      1, CASE when @KarZarar>0 then @KarZarar else 0 end,
      1, CASE when @KarZarar<0 then -1*@KarZarar else 0 end
   

  
    select * from #TB_RAPOR order by SiraNo,BaslikNo,Id
  
  /*  select * from @StokFiyat */
  
  return


END

================================================================================
