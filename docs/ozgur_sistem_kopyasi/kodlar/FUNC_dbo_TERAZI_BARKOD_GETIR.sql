-- Function: dbo.TERAZI_BARKOD_GETIR
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.683133
================================================================================

CREATE FUNCTION TERAZI_BARKOD_GETIR
(@TIP varchar(10),@BARKOD VARCHAR(20))
RETURNS
   @TB_BARKOD_STOK TABLE (
    STOK_FIRMANO         INT,
    STOK_TIP             VARCHAR(10) COLLATE Turkish_CI_AS,
    STOK_ID              INT,
    STOK_BARKOD          VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_KOD             VARCHAR(20) COLLATE Turkish_CI_AS,
    STOK_AD              VARCHAR(150) COLLATE Turkish_CI_AS,
    STOK_EKSISAT         VARCHAR(10) COLLATE Turkish_CI_AS,
    STOK_MIN             FLOAT,
    SATISMIK             FLOAT,
    TERAZI               INT,
    CARPAN               FLOAT,
    SAT1FIYAT            FLOAT,
    SAT2FIYAT            FLOAT,
    SAT3FIYAT            FLOAT,
    SAT4FIYAT            FLOAT,
    STOK_GTIP            VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_BEDELSIZ        BIT DEFAULT 0 )
AS
BEGIN
 DECLARE @TERBARKARSAY      INT
 DECLARE @GEC_BARKOD    	VARCHAR(20)
 DECLARE @SATISMIK      	VARCHAR(20)
 DECLARE @KONT              INT
 DECLARE @CARPAN            FLOAT
 DECLARE @MIKTARKR          INT
 DECLARE @I                 INT
 DECLARE @TER               INT
 Declare @BedelsizBarkodKontrol      bit


  select top 1 @BedelsizBarkodKontrol=BedelsizBarkodKontrol from sistemtanim


/*
 select @TERBARKARSAY=terazikarksay from sistemtanim

 if len(@BARKOD)<@TERBARKARSAY
  begin
  SELECT @GEC_BARKOD=@BARKOD
  --SET @SATISMIK='1'
  end
  else
  begin
  SELECT @GEC_BARKOD=SUBSTRING(@BARKOD,1,@TERBARKARSAY)
 -- if ISNUMERIC(SUBSTRING(@BARKOD,@TERBARKARSAY,LEN(@BARKOD)-@TERBARKARSAY))=0
  --SET @SATISMIK='1'
  --ELSE
  SET @SATISMIK=SUBSTRING(@BARKOD,@TERBARKARSAY+1,LEN(@BARKOD)-@TERBARKARSAY)
  end
*/
  SET @KONT=0
  SET @TER=0
  SET @GEC_BARKOD=@BARKOD
 
  if ('27'=SUBSTRING(@BARKOD,1,2))
  or ('28'=SUBSTRING(@BARKOD,1,2))
  or ('29'=SUBSTRING(@BARKOD,1,2))
   begin
    SET @TER=1
    SET @GEC_BARKOD=SUBSTRING(@BARKOD,1,7)
    if len(@BARKOD)>=7
    SET @SATISMIK=SUBSTRING(@BARKOD,8,5)
    ELSE
    SET @SATISMIK='1'
   end


  if (select COUNT(*) from stokkart as k with (nolock)
  inner join barkod as b with (nolock) on b.barkod=@GEC_BARKOD
  and b.kod=k.kod and k.tip=@TIP and k.tip=b.tip and
  b.sil=0 and k.sil=0 and k.drm='Aktif')>0
    begin
     SET @KONT=1
     insert into @TB_BARKOD_STOK
     (STOK_FIRMANO,STOK_TIP,STOK_ID,STOK_BARKOD,STOK_KOD,STOK_AD,STOK_EKSISAT,
     STOK_MIN,SATISMIK,TERAZI,CARPAN,SAT1FIYAT,
     SAT2FIYAT,SAT3FIYAT,SAT4FIYAT,STOK_GTIP)
     select k.firmano,k.tip,k.id,@BARKOD,k.kod,k.ad,k.eksat,k.minmik,
     1,@TER,b.carpan,
     case when sat1kdvtip='Dahil' then sat1fiy else
     sat1fiy*(1+(sat1kdv/100)) end,
     case when sat2kdvtip='Dahil' then sat2fiy else
     sat2fiy*(1+(sat2kdv/100)) end,
     case when sat3kdvtip='Dahil' then sat3fiy else
     sat3fiy*(1+(sat3kdv/100)) end,
     case when sat4kdvtip='Dahil' then sat4fiy else
     sat4fiy*(1+(sat4kdv/100)) end,
     K.Gtip
     from stokkart as k with (nolock) 
     inner join barkod as b with (nolock) on b.barkod=@GEC_BARKOD
     and b.kod=k.kod and k.tip=@TIP and k.tip=b.tip and
     b.sil=0 and k.sil=0 and k.drm='Aktif'
    end
    
   
   if (@BedelsizBarkodKontrol=1) and (@KONT=0)
    begin
        
     insert into @TB_BARKOD_STOK
     (STOK_FIRMANO,STOK_TIP,STOK_ID,STOK_BARKOD,STOK_KOD,STOK_AD,STOK_EKSISAT,
     STOK_MIN,SATISMIK,TERAZI,CARPAN,SAT1FIYAT,
     SAT2FIYAT,SAT3FIYAT,SAT4FIYAT,STOK_GTIP,STOK_BEDELSIZ)
     select k.firmano,k.tip,k.id,@BARKOD,k.kod,k.ad,k.eksat,k.minmik,
     1,@TER,b.carpan,0.01,0.01,0.01,0.01,K.Gtip,1 from stokkart as k with (nolock) 
     inner join BarkodBedelsiz as b with (nolock) on b.barkod=@GEC_BARKOD
     and b.kod=k.kod and k.tip=@TIP and k.tip=b.tip and
     b.sil=0 and k.sil=0 and k.drm='Aktif' and b.Aktif=1 
     
     if (select count(*) from @TB_BARKOD_STOK)>0
      SET @KONT=1

    end   
   
  
    if (@KONT=0)
    begin
     /*SET @KONT=0 */
     insert into @TB_BARKOD_STOK
     (STOK_FIRMANO,STOK_TIP,STOK_ID,STOK_BARKOD,STOK_KOD,STOK_AD,STOK_EKSISAT,
     STOK_MIN,SATISMIK,TERAZI,CARPAN,SAT1FIYAT,
     SAT2FIYAT,SAT3FIYAT,SAT4FIYAT,STOK_GTIP)
     select k.firmano,k.tip,k.id,@BARKOD,k.kod,k.ad,k.eksat,k.minmik,
     1,0,1,
     case when sat1kdvtip='Dahil' then sat1fiy else
     sat1fiy*(1+(sat1kdv/100)) end,
     case when sat2kdvtip='Dahil' then sat2fiy else
     sat2fiy*(1+(sat2kdv/100)) end,
     case when sat3kdvtip='Dahil' then sat3fiy else
     sat3fiy*(1+(sat3kdv/100)) end,
     case when sat4kdvtip='Dahil' then sat4fiy else
     sat4fiy*(1+(sat4kdv/100)) end,
     K.Gtip from stokkart as k with (nolock)
     inner join barkod as b with (nolock) on b.barkod=@BARKOD
     and b.kod=k.kod and k.tip=@TIP and k.tip=b.tip and
     b.sil=0 and k.sil=0 and k.drm='Aktif'
    end


  if ((select count(*) from @TB_BARKOD_STOK)>0) and @KONT=1
   begin
    select @MIKTARKR=5 FROM @TB_BARKOD_STOK
    
    SELECT @SATISMIK=SUBSTRING(@SATISMIK,1,@MIKTARKR)
    
    
    IF LEN(@SATISMIK)> 0
    BEGIN
     SET @I=LEN(@SATISMIK)
     WHILE @I> @MIKTARKR
      BEGIN
       SET @SATISMIK='0'+@SATISMIK
      END

     update @TB_BARKOD_STOK set SATISMIK=(@SATISMIK)*CARPAN
     
     update @TB_BARKOD_STOK set CARPAN=SATISMIK
     
     
    end
    
     
   end


 RETURN
  
  
END

================================================================================
