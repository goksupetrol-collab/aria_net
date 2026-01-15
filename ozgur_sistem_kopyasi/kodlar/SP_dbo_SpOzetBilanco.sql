-- Stored Procedure: dbo.SpOzetBilanco
-- Tarih: 2026-01-14 20:06:08.378293
================================================================================

CREATE PROCEDURE [dbo].[SpOzetBilanco]
@Firmano int,
@Tarih   Datetime
AS
BEGIN

  declare @Sirano  int
  declare @Alacak decimal(13,2)
  declare @Borc decimal(13,2)

  /*1.Rapor Stok Durum Rapor Urun Adi Miktar - Tutar  */
   Declare  @StokDurum TABLE (
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
    DegerId				    int, 
    DegerKod		        VARCHAR(50), 
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

   
   
   
   
    CREATE TABLE  #TB_OZETRAPOR (
    Id         		    INT IDENTITY(1, 1),
    StokMiktar		    decimal(13,2),
    StokTutar		    decimal(13,2),
    CariAlacak          decimal(13,2) default 0,
    CariBorc            decimal(13,2) default 0,
    PerAlacak           decimal(13,2) default 0,
    PerBorc             decimal(13,2) default 0,
    KasaAlacak          decimal(13,2) default 0,
    KasaBorc            decimal(13,2) default 0,
    ToplamAlacak        decimal(13,2) default 0,
    ToplamBorc          decimal(13,2) default 0
    )

    
    /*------------Stok Durum*/
     set @Sirano=1
     insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger)
      select 1,@Sirano,1,'Stok Durum '
    
    
     insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger,Alan2Deger,Alan3Deger,Alan4Deger)
     select 2,@Sirano,1,'Ürün ','-','Tutar','-'
     
     
      insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type)
      select 5,@Sirano,1,'stok','STOK',1,0,1,0,1 
     
     
      
      /*Son Akaryakit Tarihteki Alis Fiyat */
      
       Declare  @StokFiyat TABLE (
       Tip     VARCHAR(30),
       Kod     VARCHAR(150),
       Tarih      Datetime,
       BakiyeMiktar      float default 0,
       SatisMiktar		float default 0,
       SatisTutar		float default 0,
       AlisFiyat       float default 0,
       FifoFiyat       float default 0,
       SatisFiyat      float default 0
       )
      
      insert into @StokFiyat (Tip,Kod,BakiyeMiktar,Tarih)
      SELECT  S.stktip,s.stkod,sum(giren-cikan),
      max(
      case when s.giren>0 then S.tarih+cast(saat as datetime) else null end)
      FROM stkhrk as s with (NOLOCK) WHERE 
      s.sil=0  and (s.tarih<=@Tarih) and s.firmano in (0,@Firmano)
      group by s.stkod,S.stktip
      
      
      
      
       update @StokFiyat 
       set SatisFiyat=dt.Sat1Fiy 
       from @StokFiyat as t 
       join (select tip,kod,sat1fiy from stokkart s with (NOLOCK) 
       where sil=0 ) dt on 
       dt.tip=t.tip and dt.kod=t.kod

      
      
      update #TB_RAPOR set 
      /*Alan2Deger=dt.miktar, */
      Alan3Deger=cast(dt.Tutar as decimal(13,2))
      /*Alan4Deger=dt.SatisFiyat */
       From #TB_RAPOR as t 
      join (select
      Round(sum(BakiyeMiktar),2) Miktar,
      Round(sum(BakiyeMiktar*SatisFiyat),2) as Tutar,
      case when Round(sum(BakiyeMiktar),2)>0 then 
      Round(sum(BakiyeMiktar*SatisFiyat),2) / Round(sum(BakiyeMiktar),2) 
      else 0 end SatisFiyat 
       from @StokFiyat  )
      dt on t.DegerKod='stok' 
      
      
      
     insert into #TB_OZETRAPOR (StokMiktar,StokTutar)
      values (0,0)
    
    
      update #TB_OZETRAPOR set  
      StokMiktar=isnull(dt.miktar,0),
      StokTutar=isnull(cast(dt.Tutar as decimal(13,2)),0)
      From #TB_RAPOR as t 
      join (select  Round(sum(BakiyeMiktar),2) Miktar,
      Round(sum(BakiyeMiktar*SatisFiyat),2) as Tutar,
      case when Round(sum(BakiyeMiktar),2)>0 then 
      Round(sum(BakiyeMiktar*SatisFiyat),2) / Round(sum(BakiyeMiktar),2) 
      else 0 end SatisFiyat from @StokFiyat  )
      dt on t.DegerKod='stok' 
   
      
     
    
     
    
    
    
    /*Pos Banka Durum */
    
    set @Sirano=20
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger)
    select 1,@Sirano,1,'Cari - Personel - Kasa Durum '       
     
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger,Alan2Deger,Alan3Deger,Alan4Deger)
    select 2,@Sirano,1,'Aciklama ','Alacağımız','Borçlarımız','Bakiye'
    
   
    
   
    
    
    
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)  
      select TOP 1 5,@Sirano,1,'','CARI',
      1,LTRIM(STR(round(Sum(borc),2),25,2)),1,
      LTRIM(STR(round(Sum(alacak),2),25,2)),
      1,LTRIM(STR(round(Sum(borc-alacak),2),25,2)) 
      FROM  carihrk as s with (nolock)
      where s.cartip='carikart' and s.Sil=0 
      and s.firmano in (@Firmano) and s.Tarih<=@Tarih  
      
      
      
      set @Borc=0
      Set @Alacak=0
      
      select
      @Alacak=round(Sum(borc),2),
      @Borc=round(Sum(alacak),2) 
      FROM  carihrk as s with (nolock)
      where s.cartip='carikart' and s.Sil=0 
      and s.firmano in (@Firmano) and s.Tarih<=@Tarih 
      
     
      update #TB_OZETRAPOR set  
      CariAlacak=isnull(@Alacak,0),
      CariBorc=isnull(@Borc,0)
      From #TB_RAPOR
    
    
   
    
    /*
      update #TB_OZETRAPOR set  
      CariAlacak=cast(  round(dt.alacak,2) as decimal(13,5)),--isnull(cast(dt.alacak as decimal(13,2)),0),
      CariBorc=0--isnull(cast(dt.borc as decimal(13,2)),0)
      From #TB_RAPOR as t join (
      select
      round(Sum(borc),2) alacak,
      round(Sum(alacak),2) borc
      FROM  carihrk as s with (nolock)
      where s.cartip='carikart' and s.Sil=0 
      and s.firmano in (@Firmano) and s.Tarih<=@Tarih   
      ) dt on 1=1 
    */

    
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)  
      select TOP 1 5,@Sirano,1,'','PERSONEL',
      1,LTRIM(STR(round(Sum(borc),2),25,2)),1,
      LTRIM(STR(round(Sum(alacak),2),25,2)),
      1,LTRIM(STR(round(Sum(borc-alacak),2),25,2)) 
      FROM  carihrk as s with (nolock)
      where s.cartip='perkart' and s.Sil=0 
      and s.firmano in (@Firmano) and s.Tarih<=@Tarih  
    
    
      update #TB_OZETRAPOR set  
      PerAlacak=isnull(dt.alacak,0),
      PerBorc=isnull(dt.borc,2)
      From #TB_RAPOR as t join (
      select
      round(Sum(borc),2) alacak,
      round(Sum(alacak),2) borc
      FROM  carihrk as s with (nolock)
      where s.cartip='perkart' and s.Sil=0 
      and s.firmano in (@Firmano) and s.Tarih<=@Tarih   
      ) dt on 1=1 
    
    
    
    /*
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)  
      select TOP 1 5,@Sirano,1,'','BANKA',
      1,round(cast(BAKIYE_BORC as decimal(15,2)),2),1,
      round(cast(BAKIYE_ALACAK as decimal(15,2)) ,2),1,
      round(cast(BAKIYE_BORC-BAKIYE_ALACAK as decimal(15,2)),2)  
      FROM  UDF_MIZAN_BANKA (@firmano,0,'2000-01-01',@Tarih,0)
       
       
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)  
      select TOP 1 5,@Sirano,1,'','POS',
      1,round(cast(BAKIYE_BORC as decimal(15,2)),2),1,
      round(cast(BAKIYE_ALACAK as decimal(15,2)) ,2),1,
      round(cast(BAKIYE_BORC-BAKIYE_ALACAK as decimal(15,2)),2)  
      FROM  UDF_MIZAN_POS_BEKLEYEN (@firmano,0,'2000-01-01',@Tarih,0) 
      */

     
     
 
  
   /*Kasa Durum Durum */
    
    /*insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger) */
    /*select 1,@Sirano,1,'Kasa Durum '        */
     
   /* insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger,Alan2Deger,Alan3Deger,Alan4Deger) */
    /*select 2,@Sirano,1,'Aciklama ','Giren','Cikan','Bakiye' */
    
   set @Sirano=70 
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
    Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type)
    select 5,@Sirano,1,'kasa','KASA',1,0,1,0,1 
    
    
    update #TB_RAPOR set 
      Alan2Deger=isnull(dt.Borc,0),
      Alan3Deger=isnull(dt.Alacak,0),
      Alan4Deger=isnull(dt.bakiye,0)  
      From #TB_RAPOR as t 
      join (select 
      Sum(cast(BORC as decimal(15,2))) Borc,
      Sum(cast(ALACAK as decimal(15,2))) Alacak,
      Sum(cast(BAKIYE_BORC-BAKIYE_ALACAK as decimal(15,2))) bakiye
      
      FROM  UDF_MIZAN_KASA (@Firmano,0,@Tarih,@Tarih,0)  
      Where ParentId>0  )
      dt on  t.SiraNo=@Sirano
      
      
      
      
      update #TB_OZETRAPOR set  
      KasaAlacak=isnull(dt.alacak,0),
      KasaBorc=isnull(dt.borc,0)
      From #TB_RAPOR as t join (
      select
      round(Sum(borc),2) alacak,
      round(Sum(alacak),2) borc
      FROM  UDF_MIZAN_KASA (@Firmano,0,@Tarih,@Tarih,0)  
      Where ParentId>0  )
      dt on 1=1
  
    
    
     update #TB_OZETRAPOR set ToplamAlacak=StokTutar+CariAlacak+PerAlacak+KasaAlacak
     
     update #TB_OZETRAPOR set ToplamBorc=CariBorc+PerBorc+KasaBorc
     
    
    
    /*
     --ilgili gun      
     insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)  
      select 5,@Sirano,1,'',ACK,
      1,cast(BORC as decimal(15,2)),1,
      cast(ALACAK as decimal(15,2)),1,
      cast(BAKIYE_BORC-BAKIYE_ALACAK as decimal(15,2)) 
      FROM  UDF_MIZAN_KASA (@Firmano,0,@Tarih,@Tarih,0)
      --FROM  UDF_MIZAN_KASA (@Firmano,0,'2000-01-01',@Tarih,0)

      Where ParentId>0 
      */
     
     /*
      insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)
      SELECT 10,@Sirano,1,'','TOPLAM',
      1,LTRIM(STR(Sum(cast( Alan2Deger as decimal(13,2))),25,2)),
      1,LTRIM(STR(sum(cast( Alan3Deger as decimal(13,2))),25,2)),
      1,LTRIM(STR(sum(cast( Alan4Deger as decimal(13,2))),25,2))
      from #TB_RAPOR where BaslikNo=5 and Sirano=@Sirano
    */
      insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)
      SELECT 5,@Sirano,1,'','TOPLAM',
      1,LTRIM(STR(Sum(cast( Alan2Deger as decimal(13,2))),25,2)),
      1,LTRIM(STR(sum(cast( Alan3Deger as decimal(13,2))),25,2)),
      1,LTRIM(STR(sum(cast( Alan4Deger as decimal(13,2))),25,2))
      from #TB_RAPOR where BaslikNo=5 and Sirano in (20,70)
     
 
   /*Kasa Durum Sonu */


    set @Sirano=80
    insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,Alan1Deger)
    select 1,@Sirano,1,'Genel Toplam '
    
     insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,
     Alan1Deger,Alan2Deger,Alan3Deger,Alan4Deger)
     select 2,@Sirano,1,'Aciklama','Alacaklarımız','Borçlarımız','Fark'
     
     
     declare @Stok decimal(12,2)
      set @Stok=0
         
      select @Stok=cast(sum((BakiyeMiktar*SatisFiyat))as decimal(13,2))
      from @StokFiyat
     
     
    
      set @Alacak=0
      set @Borc=0
      
      
      
      SELECT 
      @Alacak=LTRIM(STR(Sum(cast( Alan2Deger as decimal(13,2))),25,2)),
      @Borc=LTRIM(STR(sum(cast( Alan3Deger as decimal(13,2))),25,2))
      from #TB_RAPOR where BaslikNo=5 and Sirano in (70)
      
      
      if @Stok<0
      set @Borc=@Borc+@Stok
      else
       set @Alacak=@Alacak+@Stok
     
     
      insert into #TB_RAPOR (BaslikNo,SiraNo,GrupNo,DegerKod,Alan1Deger,
      Alan2Type,Alan2Deger,Alan3Type,Alan3Deger,Alan4Type,Alan4Deger)
      SELECT 5,@Sirano,1,'','Toplam',
      1,round(@Alacak,2),
      1,round(@Borc,2),
      1,round(@Alacak-@Borc,2)
      
      
      
      
  
    
  
    /*select * from #TB_RAPOR order by SiraNo,BaslikNo,Id */
    select * from #TB_OZETRAPOR
  
  /*
  select * from @StokFiyat 
   
   
   select Tip,Kod,Sum(bakiyemiktar) Miktar,
   Sum(bakiyemiktar*satisfiyat) from @StokFiyat
   group by Tip,Kod 
  */
  
  return


END

================================================================================
