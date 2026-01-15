-- Function: dbo.UDF_STOK_TAR
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.771606
================================================================================

CREATE FUNCTION [dbo].[UDF_STOK_TAR] (
@FIRMANO          INT,
@HRK_KRITER       VARCHAR(4000),
@STOK_DEPKOD      VARCHAR(20),
@STOK_KODIN       VARCHAR (8000),
@STOK_TIP         VARCHAR(20),
@STOKBRIMTIP      INT,
@KDVTIP           VARCHAR(10),
@TARIH1           DATETIME,
@TARIH2           DATETIME)
RETURNS

  @TB_STOKTAR_HRK TABLE (
    FIRMANO           INT,
    STOK_TIP          VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_GRUP         VARCHAR(100) COLLATE Turkish_CI_AS,
    STOK_KOD          VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_AD           VARCHAR(100) COLLATE Turkish_CI_AS,
    STOK_BARKOD       VARCHAR(30) COLLATE Turkish_CI_AS,
    DEPO_KOD          VARCHAR(30)  COLLATE Turkish_CI_AS,
    DEPO_AD           VARCHAR(50)  COLLATE Turkish_CI_AS,
    DEVIRMIKTAR       FLOAT,
    DEVIRBRMFIY       FLOAT,
    DEVIRTUTAR        FLOAT,
    GIRENMIKTAR       FLOAT,
    GIRENTUTAR        FLOAT,
    CIKANMIKTAR       FLOAT,
    CIKANTUTAR        FLOAT,
    KALANMIKTAR       FLOAT,
    KALANTUTAR        FLOAT,
    BRIM              VARCHAR(20)  COLLATE Turkish_CI_AS,
    BRMFIYKDVLI       FLOAT,
    KDVYUZ            FLOAT,
    MEVCUTMIKTAR      FLOAT)
AS
BEGIN
  DECLARE @STKHRKTAR_TEMP TABLE (
    FIRMANO           INT,
    STOK_TIP        VARCHAR(20)   COLLATE Turkish_CI_AS,
    STOK_GRUP       VARCHAR(100) COLLATE Turkish_CI_AS,
    STOK_KOD        VARCHAR(50)   COLLATE Turkish_CI_AS,
    STOK_AD         VARCHAR(150)  COLLATE Turkish_CI_AS,
    STOK_BARKOD     VARCHAR(30) COLLATE Turkish_CI_AS,
    DEPO_KOD        VARCHAR(30)   COLLATE Turkish_CI_AS,
    DEPO_AD         VARCHAR(50)   COLLATE Turkish_CI_AS,
    DEVIRMIKTAR     FLOAT,
    DEVIRBRMFIY     FLOAT,
    DEVIRTUTAR      FLOAT,
    GIRENMIKTAR     FLOAT,
    GIRENTUTAR      FLOAT,
    CIKANMIKTAR     FLOAT,
    CIKANTUTAR      FLOAT,
    KALANMIKTAR     FLOAT,
    KALANTUTAR      FLOAT,
    BRIM            VARCHAR(20)  COLLATE Turkish_CI_AS,
    BRMFIYKDVLI     FLOAT,
    KDVYUZ          FLOAT,
    MEVCUTMIKTAR    FLOAT)

  DECLARE @HRK_FIRMANO    INT
  DECLARE @HRK_STOK_TIP    VARCHAR(20)
  DECLARE @HRK_STOK_GRUP   VARCHAR(100)
  DECLARE @HRK_STOK_KOD    VARCHAR(50)
  DECLARE @HRK_STOK_AD     VARCHAR(150)
  DECLARE @HRK_BARKOD      VARCHAR(30)
  DECLARE @HRK_DEPO_KOD    VARCHAR(30)
  DECLARE @HRK_DEPO_AD     VARCHAR(50)
  DECLARE @HRK_TARIH       DATETIME
  DECLARE @HRK_DEVIRMIK    FLOAT
  DECLARE @HRK_DEVIRBRM    FLOAT
  DECLARE @HRK_DEVIRTUT    FLOAT
  DECLARE @HRK_GIRENMIK    FLOAT
  DECLARE @HRK_GIRENTUT    FLOAT
  DECLARE @HRK_CIKANMIK    FLOAT
  DECLARE @HRK_CIKANTUT    FLOAT
  DECLARE @HRK_KALANMIK    FLOAT
  DECLARE @HRK_KALANTUT    FLOAT
  DECLARE @HRK_BRIM        VARCHAR(50)
  DECLARE @HRK_BRMFIYKDVLI FLOAT
  DECLARE @HRK_KDVYUZ      FLOAT
  DECLARE @MEVCUTMIKTAR    FLOAT



 /*---------------------------------------------------------------------------- */
   
   DECLARE @STKHRK_TEMP TABLE (
    FIRMANO         INT,
    TARIH           DATETIME,
    STOK_TIP        VARCHAR(20)   COLLATE Turkish_CI_AS,
    STOK_KOD        VARCHAR(50)   COLLATE Turkish_CI_AS,
    DEPO_KOD        VARCHAR(30)   COLLATE Turkish_CI_AS,
    GIRENMIKTAR     FLOAT,
    CIKANMIKTAR     FLOAT,
    BRIM            VARCHAR(20)  COLLATE Turkish_CI_AS,
    ISLEMTIP        VARCHAR(20)  COLLATE Turkish_CI_AS,
    BRMFIYKDVLI     FLOAT,
    KDVYUZ          FLOAT,
    MEVCUTMIKTAR    FLOAT)
 

 
 if (@FIRMANO=0) and (@STOK_DEPKOD<>'')
  begin
   INSERT @STKHRK_TEMP (FIRMANO,TARIH,STOK_TIP,STOK_KOD,DEPO_KOD,ISLEMTIP,
   BRIM,KDVYUZ,BRMFIYKDVLI,GIRENMIKTAR,CIKANMIKTAR)
   SELECT 0,h.Tarih+cast(h.saat as datetime),k.tip,k.kod,isnull(h.depkod,''),h.islmtip,
   k.brim,h.kdvyuz,
   h.brmfiykdvli,h.giren,h.cikan from stokkart as k with (nolock)
   inner join stkhrk h with (nolock) on k.kod=h.stkod and
   k.tip=h.stktip and h.sil=0 and h.depkod=@STOK_DEPKOD
   and h.islmtip not in
   (select * from CsvToSTR(@HRK_KRITER)) 
   WHERE k.tip=@STOK_TIP and k.sil=0 and k.kod
   in (select * FROM CsvToSTR(@STOK_KODIN))
   AND tarih <= @TARIH2
   
   
   
   
   
   
 end


 if (@FIRMANO=0) and (@STOK_DEPKOD='') 
  begin
   INSERT @STKHRK_TEMP (FIRMANO,TARIH,STOK_TIP,STOK_KOD,DEPO_KOD,ISLEMTIP,
   BRIM,KDVYUZ,BRMFIYKDVLI,GIRENMIKTAR,CIKANMIKTAR)
   SELECT 0,h.Tarih+cast(h.saat as datetime),k.tip,k.kod,isnull(h.depkod,''),h.islmtip,
   k.brim,h.kdvyuz,
   h.brmfiykdvli,h.giren,h.cikan from stokkart as k with (nolock)
   inner join stkhrk h with (nolock) on k.kod=h.stkod and
   k.tip=h.stktip and h.sil=0 
   and h.islmtip not in
   (select * from CsvToSTR(@HRK_KRITER)) 
   WHERE k.tip=@STOK_TIP and k.sil=0 and k.kod
   in (select * FROM CsvToSTR(@STOK_KODIN))
   AND tarih <= @TARIH2
   
   
   
   
   
  end
 /*------------------------------------------------------------ */
 
  /*firmano Kriter */
  if (@FIRMANO>0) and  (@STOK_DEPKOD<>'')
  begin
   INSERT @STKHRK_TEMP (FIRMANO,TARIH,STOK_TIP,STOK_KOD,DEPO_KOD,ISLEMTIP,
   BRIM,KDVYUZ,BRMFIYKDVLI,GIRENMIKTAR,CIKANMIKTAR)
   SELECT 0,h.Tarih+cast(h.saat as datetime),k.tip,k.kod,isnull(h.depkod,''),h.islmtip,
   k.brim,h.kdvyuz,
   h.brmfiykdvli,h.giren,h.cikan from stokkart as k with (nolock)
   inner join stkhrk h with (nolock) on k.kod=h.stkod and
   k.tip=h.stktip and h.sil=0 and h.firmano in (@FIRMANO,0)
   and h.depkod=@STOK_DEPKOD
   and h.islmtip not in
   (select * from CsvToSTR(@HRK_KRITER)) 
   WHERE k.tip=@STOK_TIP and k.sil=0 and k.kod
   in (select * FROM CsvToSTR(@STOK_KODIN))
   AND tarih <= @TARIH2
   

  end


 if (@FIRMANO>0) and (@STOK_DEPKOD='')
 begin
   INSERT @STKHRK_TEMP (FIRMANO,TARIH,STOK_TIP,STOK_KOD,DEPO_KOD,ISLEMTIP,
   BRIM,KDVYUZ,BRMFIYKDVLI,GIRENMIKTAR,CIKANMIKTAR)
   SELECT 0,h.Tarih+cast(h.saat as datetime),k.tip,k.kod,isnull(h.depkod,''),h.islmtip,
   k.brim,h.kdvyuz,
   h.brmfiykdvli,h.giren,h.cikan from stokkart as k with (nolock)
   inner join stkhrk h with (nolock) on k.kod=h.stkod and
   k.tip=h.stktip and h.sil=0 and h.firmano in (@FIRMANO,0)
   and h.islmtip not in
   (select * from CsvToSTR(@HRK_KRITER)) 
   WHERE k.tip=@STOK_TIP and k.sil=0 and k.kod
   in (select * FROM CsvToSTR(@STOK_KODIN))
   AND tarih <= @TARIH2
   
   
  
   
   
  end

 /*------------------------------------------------------------ */
 

 
 if (@STOK_DEPKOD<>'')
   INSERT @STKHRKTAR_TEMP (FIRMANO,STOK_TIP,STOK_GRUP,STOK_KOD,STOK_AD,
   STOK_BARKOD,DEPO_KOD,DEPO_AD,BRIM,KDVYUZ,BRMFIYKDVLI,
   DEVIRMIKTAR,DEVIRBRMFIY,DEVIRTUTAR,GIRENMIKTAR,GIRENTUTAR,
   CIKANMIKTAR,CIKANTUTAR,KALANMIKTAR,KALANTUTAR,MEVCUTMIKTAR)
   SELECT FIRMANO,STOK_TIP,'',STOK_KOD,'',
   '',DEPO_KOD,'',BRIM,MAX(KDVYUZ)*100,0 BRMFIYKDVLI,
   0 DEVIRMIKTAR,0 DEVIRBRMFIY,0 DEVIRTUTAR,0 GIRENMIKTAR,0 GIRENTUTAR,
   0 CIKANMIKTAR,0 CIKANTUTAR,0 KALANMIKTAR,0 KALANTUTAR,MAX(MEVCUTMIKTAR)
   FROM @STKHRK_TEMP
   GROUP BY FIRMANO,STOK_TIP,STOK_KOD,BRIM,DEPO_KOD

  if (@STOK_DEPKOD='')
   INSERT @STKHRKTAR_TEMP (FIRMANO,STOK_TIP,STOK_GRUP,STOK_KOD,STOK_AD,
   STOK_BARKOD,DEPO_KOD,DEPO_AD,BRIM,KDVYUZ,BRMFIYKDVLI,
   DEVIRMIKTAR,DEVIRBRMFIY,DEVIRTUTAR,GIRENMIKTAR,GIRENTUTAR,
   CIKANMIKTAR,CIKANTUTAR,KALANMIKTAR,KALANTUTAR,MEVCUTMIKTAR)
   SELECT FIRMANO,STOK_TIP,'',STOK_KOD,'',
   '','' DEPO_KOD,'',BRIM,0 KDVYUZ,0 BRMFIYKDVLI,
   0 DEVIRMIKTAR,0 DEVIRBRMFIY,0 DEVIRTUTAR,0 GIRENMIKTAR,0 GIRENTUTAR,
   0 CIKANMIKTAR,0 CIKANTUTAR,0 KALANMIKTAR,0 KALANTUTAR,MAX(MEVCUTMIKTAR)
   FROM @STKHRK_TEMP
   GROUP BY FIRMANO,STOK_TIP,STOK_KOD,BRIM



  /* MEVCUT MIKTAR   */
  if (@FIRMANO=0) and (@STOK_DEPKOD<>'')
   UPDATE @STKHRKTAR_TEMP SET MEVCUTMIKTAR=DT.miktar from @STKHRKTAR_TEMP as t join
   (select h.stktip,h.stkod,sum(h.giren-h.cikan) as miktar from stkhrk h with (nolock) where sil=0
   and h.stktip=@STOK_TIP and h.depkod=@STOK_DEPKOD and h.stkod in (select * FROM CsvToSTR(@STOK_KODIN))
   group by h.stktip,h.stkod ) dt on dt.stkod=t.STOK_KOD and dt.stktip=t.STOK_TIP
   
  if (@FIRMANO=0) and (@STOK_DEPKOD='')   
   UPDATE @STKHRKTAR_TEMP SET MEVCUTMIKTAR=DT.miktar from @STKHRKTAR_TEMP as t join
   (select h.stktip,h.stkod,sum(h.giren-h.cikan) as miktar from stkhrk h with (nolock) where sil=0
   and h.stktip=@STOK_TIP and h.stkod in (select * FROM CsvToSTR(@STOK_KODIN))
   group by h.stktip,h.stkod ) dt on dt.stkod=t.STOK_KOD and dt.stktip=t.STOK_TIP 


  if (@FIRMANO>0) and  (@STOK_DEPKOD<>'')
   UPDATE @STKHRKTAR_TEMP SET MEVCUTMIKTAR=DT.miktar from @STKHRKTAR_TEMP as t join
   (select h.stktip,h.stkod,sum(h.giren-h.cikan) as miktar from stkhrk h with (nolock) where sil=0
   and h.stktip=@STOK_TIP and h.firmano in (@FIRMANO,0)
   and h.depkod=@STOK_DEPKOD and h.stkod in (select * FROM CsvToSTR(@STOK_KODIN))
   group by h.stktip,h.stkod ) dt on dt.stkod=t.STOK_KOD and dt.stktip=t.STOK_TIP

  if (@FIRMANO>0) and (@STOK_DEPKOD='')
    UPDATE @STKHRKTAR_TEMP SET MEVCUTMIKTAR=DT.miktar from @STKHRKTAR_TEMP as t join 
   (select h.stktip,h.stkod,sum(h.giren-h.cikan) as miktar from stkhrk h with (nolock) where sil=0
   and h.stktip=@STOK_TIP and h.firmano in (@FIRMANO,0)
   and h.stkod in (select * FROM CsvToSTR(@STOK_KODIN))
   group by h.stktip,h.stkod ) dt on dt.stkod=t.STOK_KOD and dt.stktip=t.STOK_TIP
   

 /*Devir Bilgileri Hesapla */
 
 if @STOK_DEPKOD<>'' 
 begin
   UPDATE @STKHRKTAR_TEMP SET DEVIRMIKTAR=DEVIRMIKTART
   from @STKHRKTAR_TEMP t join
   (SELECT k.STOK_TIP,k.STOK_KOD,k.DEPO_KOD,
   isnull(SUM(GIRENMIKTAR-CIKANMIKTAR),0) AS DEVIRMIKTART
   from @STKHRK_TEMP as k WHERE K.TARIH < @TARIH1
   group by k.STOK_TIP,k.STOK_KOD,k.DEPO_KOD)
   dt  on t.STOK_TIP=dt.STOK_TIP and t.STOK_KOD=dt.STOK_KOD
   and t.DEPO_KOD=dt.DEPO_KOD
 end
 
 if @STOK_DEPKOD='' 
 begin
   UPDATE @STKHRKTAR_TEMP SET DEVIRMIKTAR=DEVIRMIKTART
   from @STKHRKTAR_TEMP t join
   (SELECT k.STOK_TIP,k.STOK_KOD,
   isnull(SUM(GIRENMIKTAR-CIKANMIKTAR),0) AS DEVIRMIKTART
   from @STKHRK_TEMP as k WHERE K.TARIH < @TARIH1
   group by k.STOK_TIP,k.STOK_KOD)
   dt  on t.STOK_TIP=dt.STOK_TIP and t.STOK_KOD=dt.STOK_KOD
 end

 /*Devir Bilgileri Hesapla Sonu */
 
 
 
  /*Icerik Giren Cikan Bilgileri */
  
   DECLARE STKTAR_HRK CURSOR FAST_FORWARD FOR
    SELECT
      k.STOK_TIP,k.STOK_KOD
      FROM @STKHRKTAR_TEMP as k
      GROUP BY k.STOK_TIP,k.STOK_KOD

  OPEN STKTAR_HRK

  FETCH NEXT FROM STKTAR_HRK INTO
   @HRK_STOK_TIP,@HRK_STOK_KOD
   /*@HRK_DEPO_KOD */
   

  WHILE @@FETCH_STATUS = 0
  BEGIN
  
   SET @HRK_KDVYUZ=0
   SET @HRK_BRMFIYKDVLI=0
   SET @HRK_DEVIRBRM=0
  
  
   SET @HRK_GIRENMIK=0
   SET @HRK_CIKANMIK=0 
   SET @HRK_GIRENTUT=0 
   SET @HRK_CIKANTUT=0
  
     SELECT
      @HRK_GIRENMIK=ISNULL(SUM(k.GIRENMIKTAR),0),
      @HRK_CIKANMIK=ISNULL(SUM(k.CIKANMIKTAR),0),
      @HRK_GIRENTUT=ISNULL(SUM(k.GIRENMIKTAR*k.BRMFIYKDVLI),0),
      @HRK_CIKANTUT=ISNULL(SUM(k.CIKANMIKTAR*k.BRMFIYKDVLI),0)
      FROM @STKHRK_TEMP as k WHERE k.STOK_KOD=@HRK_STOK_KOD
      and k.TARIH>=@TARIH1 /*and k.TARIH<=@TARIH2  */
      GROUP BY k.STOK_TIP,k.STOK_KOD
  
  

  /* Ortalama Alis */
   IF @STOKBRIMTIP=0
    BEGIN
    
    select @HRK_KDVYUZ=(alskdv/100) From Stokkart 
    with (nolock) Where tip=@HRK_STOK_TIP and Kod=@HRK_STOK_KOD
    

    SELECT  @HRK_BRMFIYKDVLI=case when SUM(h.GIRENMIKTAR)<>0 then 
    sum(h.GIRENMIKTAR*h.BRMFIYKDVLI)/SUM(h.GIRENMIKTAR)
    else 0 end 
    from @STKHRK_TEMP as h 
    where STOK_TIP=@HRK_STOK_TIP and STOK_KOD=@HRK_STOK_KOD
    and  h.TARIH<=DATEADD(MINUTE,59,DATEADD(HOUR,23,@TARIH2)) 
    
    SELECT  @HRK_DEVIRBRM=case when SUM(h.GIRENMIKTAR)<>0 then 
    sum(h.GIRENMIKTAR*h.BRMFIYKDVLI)/SUM(h.GIRENMIKTAR)
    else 0 end 
    from @STKHRK_TEMP as h 
    where STOK_TIP=@HRK_STOK_TIP and STOK_KOD=@HRK_STOK_KOD
    and h.TARIH<@TARIH1
        
    
    
     
  END

   /* Son Tarihteki Alis Fiyat */
   if @STOKBRIMTIP=1
    BEGIN
        /*
        SELECT TOP 1 @HRK_KDVYUZ=isnull(h.KDVYUZ,0),
        @HRK_BRMFIYKDVLI=isnull(h.BRMFIYKDVLI,0)
        from @STKHRK_TEMP as h 
        where STOK_TIP=@HRK_STOK_TIP and STOK_KOD=@HRK_STOK_KOD
        and h.TARIH<=@TARIH2 and h.GIRENMIKTAR>0 
        order by h.TARIH desc
        
        
         SELECT TOP 1 @HRK_DEVIRBRM=isnull(h.BRMFIYKDVLI,0)
         from @STKHRK_TEMP as h 
         where STOK_TIP=@HRK_STOK_TIP and STOK_KOD=@HRK_STOK_KOD
         and h.TARIH<@TARIH1 and h.GIRENMIKTAR>0 
         order by h.TARIH desc 
         
         */
         
         /* SELECT TOP 1 
          @HRK_KDVYUZ=isnull(h.KDVYUZ,0)
          from @STKHRK_TEMP as h 
          where STOK_TIP=@HRK_STOK_TIP and STOK_KOD=@HRK_STOK_KOD
          and h.TARIH<=DATEADD(MINUTE,59,DATEADD(HOUR,23,@TARIH2)) 
          order by h.TARIH desc
         */
         
         select @HRK_KDVYUZ=(alskdv/100) From Stokkart  
         with (nolock) Where tip=@HRK_STOK_TIP and Kod=@HRK_STOK_KOD
    
         
         
                  declare @EvrakTarih datetime
                   
                       
             
                    SELECT TOP 1 @EvrakTarih=h.TARIH,
                    @HRK_BRMFIYKDVLI=h.BRMFIYKDVLI 
                    from @STKHRK_TEMP as h 
                    where STOK_TIP=@HRK_STOK_TIP and STOK_KOD=@HRK_STOK_KOD
                    and h.TARIH<=DATEADD(MINUTE,59,DATEADD(HOUR,23,@TARIH2)) 
                    and h.GIRENMIKTAR>0 and ISLEMTIP<>'MARIAD'
                    order by h.TARIH desc
                 
                  /*Ayni Zaman Dilinde 1 den fazla Kayit Varsa  */
                    if (Select Count(STOK_KOD) from @STKHRK_TEMP as h 
                    where STOK_TIP=@HRK_STOK_TIP and STOK_KOD=@HRK_STOK_KOD
                    and h.TARIH=@EvrakTarih and h.GIRENMIKTAR>0 and ISLEMTIP<>'MARIAD')>1
                    begin
                       SELECT @HRK_BRMFIYKDVLI=
                       sum(h.BRMFIYKDVLI*h.GIRENMIKTAR)/sum(h.GIRENMIKTAR)
                     from @STKHRK_TEMP as h 
                      where STOK_TIP=@HRK_STOK_TIP and STOK_KOD=@HRK_STOK_KOD
                      and h.TARIH=@EvrakTarih and h.GIRENMIKTAR>0 and ISLEMTIP<>'MARIAD'
                     end 
          
          
          
         
                    SELECT TOP 1 @EvrakTarih=h.TARIH,
                    @HRK_DEVIRBRM=h.BRMFIYKDVLI 
                    from @STKHRK_TEMP as h 
                    where STOK_TIP=@HRK_STOK_TIP and STOK_KOD=@HRK_STOK_KOD
                    and h.TARIH<@TARIH1 and h.GIRENMIKTAR>0 and ISLEMTIP<>'MARIAD'
                    order by h.TARIH desc
         
         
                    /*Ayni Zaman Diliminde 1 den fazla Kayit Varsa  */
                    if (Select Count(STOK_KOD) from @STKHRK_TEMP as h 
                    where STOK_TIP=@HRK_STOK_TIP and STOK_KOD=@HRK_STOK_KOD
                    and h.TARIH=@EvrakTarih and h.GIRENMIKTAR>0 and ISLEMTIP<>'MARIAD')>1
                    begin
                       SELECT @HRK_DEVIRBRM=
                       sum(h.BRMFIYKDVLI*h.GIRENMIKTAR)/sum(h.GIRENMIKTAR)
                     from @STKHRK_TEMP as h 
                      where STOK_TIP=@HRK_STOK_TIP and STOK_KOD=@HRK_STOK_KOD
                      and h.TARIH=@EvrakTarih and h.GIRENMIKTAR>0 and ISLEMTIP<>'MARIAD'
                     end 
                    
         

         
         
     END  
   
   
   /* Son Tarihteki Satis Fiyati */
   if @STOKBRIMTIP=2
    BEGIN
    
     select @HRK_KDVYUZ=(sat1kdv/100) From Stokkart  
      with (nolock) Where tip=@HRK_STOK_TIP and Kod=@HRK_STOK_KOD
    
   
   
      SELECT TOP 1 
      /*@HRK_KDVYUZ=isnull(h.KDVYUZ,0), */
      @HRK_BRMFIYKDVLI=isnull(h.BRMFIYKDVLI,0)
      from @STKHRK_TEMP as h 
      where STOK_TIP=@HRK_STOK_TIP and STOK_KOD=@HRK_STOK_KOD
      and h.TARIH<=DATEADD(MINUTE,59,DATEADD(HOUR,23,@TARIH2)) 
      and h.CIKANMIKTAR>0 
      order by h.TARIH desc
      
      
       SELECT TOP 1 @HRK_DEVIRBRM=isnull(h.BRMFIYKDVLI,0)
       from @STKHRK_TEMP as h 
       where STOK_TIP=@HRK_STOK_TIP and STOK_KOD=@HRK_STOK_KOD
       and h.TARIH<@TARIH1 and h.CIKANMIKTAR>0 
       order by h.TARIH desc

    END
   
   
   /*Fifo (Ortalama Birim Fiyat) */
   if @STOKBRIMTIP=3
   BEGIN
    set  @HRK_DEPO_KOD=''
    if @STOK_DEPKOD<>''
    set @HRK_DEPO_KOD=@STOK_DEPKOD
   
   
      select @HRK_KDVYUZ=(sat1kdv/100) From Stokkart 
      with (nolock) Where tip=@HRK_STOK_TIP and Kod=@HRK_STOK_KOD
   
   
     SELECT @HRK_BRMFIYKDVLI=MALIYET FROM STOKFIFO (1,@HRK_DEPO_KOD,@HRK_STOK_TIP,@HRK_STOK_KOD,@TARIH1,@TARIH2)
     SELECT @HRK_DEVIRBRM=MALIYET FROM STOKFIFO (1,@HRK_DEPO_KOD,@HRK_STOK_TIP,@HRK_STOK_KOD,0,@TARIH1)
   END
   
   /*Satis Fiyat -1 */
   IF @STOKBRIMTIP=4
   BEGIN
   
   
     select 
     @HRK_KDVYUZ=sat1kdv/100,
     @HRK_BRMFIYKDVLI=case when sat1kdvtip='Dahil' then
      sat1fiy else sat1fiy*(1+(sat1kdv/100)) end from stokkart with (nolock) 
      where tip=@HRK_STOK_TIP and kod=@HRK_STOK_KOD
     
      SET @HRK_DEVIRBRM=@HRK_BRMFIYKDVLI
   
   END

   /*Satis Fiyat -2 */
   if @STOKBRIMTIP=5
   BEGIN
   select @HRK_KDVYUZ=sat2kdv/100,
   @HRK_BRMFIYKDVLI=case when sat2kdvtip='Dahil' then
    sat2fiy else sat2fiy*(1+(sat2kdv/100))  end from stokkart with (nolock)
   where tip=@HRK_STOK_TIP and kod=@HRK_STOK_KOD
   
   SET @HRK_DEVIRBRM=@HRK_BRMFIYKDVLI
   
   END
   
   
    /*Alis Fiyat */
   if @STOKBRIMTIP=6
   BEGIN
   select @HRK_KDVYUZ=alskdv/100,
   @HRK_BRMFIYKDVLI=case when alskdvtip='Dahil' then
    alsfiy else alsfiy*(1+(alsfiy/100))  end from stokkart with (nolock)
   where tip=@HRK_STOK_TIP and kod=@HRK_STOK_KOD
   
   SET @HRK_DEVIRBRM=@HRK_BRMFIYKDVLI
   
   END
   

   IF @KDVTIP<>'Dahil' /*Haric */
    BEGIN
     set @HRK_BRMFIYKDVLI=@HRK_BRMFIYKDVLI/(1+@HRK_KDVYUZ)
     set @HRK_DEVIRBRM=@HRK_DEVIRBRM/(1+@HRK_KDVYUZ)
     SET @HRK_GIRENTUT=@HRK_GIRENTUT/(1+@HRK_KDVYUZ)
     SET @HRK_CIKANTUT=@HRK_CIKANTUT/(1+@HRK_KDVYUZ)
      
    END 



 
     update @STKHRKTAR_TEMP
       set KDVYUZ=@HRK_KDVYUZ,BRMFIYKDVLI=@HRK_BRMFIYKDVLI,
       DEVIRTUTAR=DEVIRMIKTAR*@HRK_DEVIRBRM,
       GIRENMIKTAR=@HRK_GIRENMIK,GIRENTUTAR=@HRK_GIRENTUT,
       CIKANMIKTAR=@HRK_CIKANMIK,CIKANTUTAR=@HRK_CIKANTUT,
       KALANMIKTAR=DEVIRMIKTAR+@HRK_GIRENMIK-@HRK_CIKANMIK,
       KALANTUTAR=(DEVIRMIKTAR+@HRK_GIRENMIK-@HRK_CIKANMIK)*@HRK_BRMFIYKDVLI
       where STOK_TIP=@HRK_STOK_TIP and STOK_KOD=@HRK_STOK_KOD



     FETCH NEXT FROM STKTAR_HRK INTO
    @HRK_STOK_TIP,@HRK_STOK_KOD
  END

  CLOSE STKTAR_HRK
  DEALLOCATE STKTAR_HRK

  /*---------------------------------------------------------------------------- */
  
  
   UPDATE @STKHRKTAR_TEMP set STOK_AD=dt.ad,
   STOK_BARKOD=DT.barkod,STOK_GRUP=dt.grup_ad from @STKHRKTAR_TEMP as t join 
   (select K.tip,K.kod,K.ad,K.barkod,g.ad grup_ad from stokkart k with (nolock)
   left join grup as g on g.id=case when k.grp3>0 then k.grp3 
   when k.grp2>0 then k.grp2 when k.grp1>0 then k.grp1 end) dt
   on dt.tip=t.STOK_TIP and dt.kod=STOK_KOD
  
  
    
  /*
    update @STKHRKTAR_TEMP set KALANMIKTAR=DEVIRMIKTAR+GIRENMIKTAR-CIKANMIKTAR,
    KALANTUTAR=(DEVIRTUTAR/DEVIRMIKTAR)*(DEVIRMIKTAR+GIRENMIKTAR-CIKANMIKTAR)
    where GIRENMIKTAR=0 and CIKANMIKTAR=0 and DEVIRMIKTAR>0
    */
  
   INSERT @TB_STOKTAR_HRK
    SELECT * FROM @STKHRKTAR_TEMP
  

  

  RETURN

END

================================================================================
