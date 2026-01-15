-- Function: dbo.UDF_PomVarNakitStokHrk
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.760238
================================================================================

CREATE FUNCTION [dbo].[UDF_PomVarNakitStokHrk] (
@firmano           int,
@TIPIN			   VARCHAR(30),
@BASTARIH          DATETIME,
@BITTARIH          DATETIME)
RETURNS
   @TB_STOK TABLE (
    FIRMANO				 INT,
    VARNO 				 INT,
    SERINO				 INT,
    TARIH                DATETIME,
    SAAT             	 VARCHAR(10) COLLATE Turkish_CI_AS,
    CARKOD				 VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_TIP             VARCHAR(10) COLLATE Turkish_CI_AS,
    STOK_KOD             VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_BRIM            VARCHAR(10) COLLATE Turkish_CI_AS,
    STOK_KDVYUZ          FLOAT,
    STOK_MIKTAR          FLOAT,
    STOK_BRMKDVLI        FLOAT,
    STOK_BRMKDVSIZ       FLOAT,
    STOK_TUTARKDVLI  	 FLOAT,
    STOK_TUTARKDVSIZ	 FLOAT,
    ACK                  VARCHAR(100) COLLATE Turkish_CI_AS,
    OLUSTARSAAT          DATETIME)
AS
BEGIN

    DECLARE @FIRMA    		  int
    DECLARE @VARNO 				  int
    DECLARE @SERINO  			  int
    DECLARE @TARIH 				  DATETIME
    DECLARE @SAAT				  VARCHAR(10) 
    DECLARE @STOK_TIP             VARCHAR(10) 
    DECLARE @STOK_KOD             VARCHAR(30)
    DECLARE @STOK_BRIM            VARCHAR(10) 
    DECLARE @STOK_KDVYUZ          FLOAT
    DECLARE @STOK_MIKTAR          FLOAT
    DECLARE @STOK_BRMKDVLI		  FLOAT
    DECLARE @STOK_BRMKDVSIZ		  FLOAT
    DECLARE @STOK_TUTARKDVLI	  FLOAT
    DECLARE @STOK_TUTARKDVSIZ	  FLOAT
    DECLARE @ACK                  VARCHAR(100) 
    DECLARE @OLUSTARSAAT     	  DATETIME


   DECLARE @CAR_KOD             VARCHAR(30) 
   
 
 if @firmano=0  
  SELECT @CAR_KOD=zrap_carkod FROM sistemtanim


 if @firmano>0  
  SELECT @CAR_KOD=Entegre_ZraporOnMuhKod FROM Firma where id=@firmano


 if @TIPIN='pomvardimas'
  begin
  if @firmano=0  
   DECLARE VARDI_STOK CURSOR FAST_FORWARD FOR
    SELECT p.firmano,p.varno,p.kaptar,p.kapsaat,p.varad,p.olustarsaat,
    ps.stktip,ps.stkod,max(ps.kdvyuz),
    sum(ps.satmik),sum(ps.tutar)
    from pomvardimas as p with (nolock)
    inner join pomvardisayac as ps with (nolock)
     on ps.varno=p.varno and p.sil=0 and p.varok=1 /*and p.firmano=@Firmano */
      and p.kaptar>=@BASTARIH and p.kaptar<=@BITTARIH  
      group by p.firmano,p.varno,p.kaptar,p.kapsaat,p.varad,p.olustarsaat,
      ps.stktip,ps.stkod
      order by p.varno
      
      
   if @firmano>0  
   DECLARE VARDI_STOK CURSOR FAST_FORWARD FOR
    SELECT p.firmano,p.varno,p.kaptar,p.kapsaat,p.varad,p.olustarsaat,
    ps.stktip,ps.stkod,max(ps.kdvyuz),
    sum(ps.satmik),sum(ps.tutar)
    from pomvardimas as p with (nolock)
    inner join pomvardisayac as ps with (nolock) 
     on ps.varno=p.varno and p.sil=0 and p.varok=1 and p.firmano in (0,@Firmano)
      and p.kaptar>=@BASTARIH and p.kaptar<=@BITTARIH  
      group by p.firmano,p.varno,p.kaptar,p.kapsaat,p.varad,p.olustarsaat,
      ps.stktip,ps.stkod
      order by p.varno 
      
      
   end    
   
  
   if @TIPIN='marvardimas'
   begin 
   if @firmano=0  
    DECLARE VARDI_STOK CURSOR FAST_FORWARD FOR
    SELECT p.firmano,p.varno,p.kaptar,p.kapsaat,p.varad,p.olustarsaat,
    ps.stktip,ps.stkod,max(ps.kdvyuz),
    sum(case when ps.islmtip='satis' then ps.mik else -1*ps.mik end),
    sum(case when ps.islmtip='satis' then ps.mik else -1*ps.mik end *ps.brmfiy)
    from marvardimas as p with (nolock)
    inner join marsatmas as pm with (nolock)
    on pm.varno=p.varno and pm.sil=0  /*and pm.firmano=@Firmano */
    inner join marsathrk as ps  with (nolock)
     on ps.varno=p.varno and pm.marsatid=ps.marsatid and p.sil=0 and p.varok=1
      and p.kaptar>=@BASTARIH and p.kaptar<=@BITTARIH and pm.sil=0 and ps.sil=0 
      group by p.firmano,p.varno,p.kaptar,p.kapsaat,p.varad,p.olustarsaat,
      ps.stktip,ps.stkod
      having ABS(sum(case when ps.islmtip='satis' then ps.mik else -1*ps.mik end))>0
      order by p.varno
      
    if @firmano>0    
     DECLARE VARDI_STOK CURSOR FAST_FORWARD FOR
     SELECT p.firmano,p.varno,p.kaptar,p.kapsaat,p.varad,p.olustarsaat,
     ps.stktip,ps.stkod,max(ps.kdvyuz),
     sum(case when ps.islmtip='satis' then ps.mik else -1*ps.mik end),
     sum(case when ps.islmtip='satis' then ps.mik else -1*ps.mik end *ps.brmfiy)
     from marvardimas as p with (nolock)
     inner join marsatmas as pm with (nolock)
     on pm.varno=p.varno and pm.sil=0  and pm.firmano in (0,@Firmano)
     inner join marsathrk as ps  with (nolock)
     on ps.varno=p.varno and pm.marsatid=ps.marsatid and p.sil=0 and p.varok=1
      and p.kaptar>=@BASTARIH and p.kaptar<=@BITTARIH  and pm.sil=0 and ps.sil=0 
      group by p.firmano,p.varno,p.kaptar,p.kapsaat,p.varad,p.olustarsaat,
      ps.stktip,ps.stkod
      having ABS(sum(case when ps.islmtip='satis' then ps.mik else -1*ps.mik end))>0
      order by p.varno
      
    end 
      
      
      
     OPEN  VARDI_STOK
      FETCH NEXT FROM VARDI_STOK INTO
       @FIRMA,@VARNO,@TARIH,@SAAT,@ACK,@OLUSTARSAAT,
       @STOK_TIP,@STOK_KOD,@STOK_KDVYUZ,
       @STOK_MIKTAR,@STOK_TUTARKDVLI
       WHILE @@FETCH_STATUS = 0
        BEGIN  

    if  @TIPIN='pomvardimas'
     SET @STOK_BRIM='LİTRE'
     
    if  @TIPIN='marvardimas'
     SET @STOK_BRIM='ADET'
     
     

     declare @GEC_STOK_MIKTAR      FLOAT
     declare @GEC_STOK_TUTAR       FLOAT

     set @GEC_STOK_MIKTAR=0
     set @GEC_STOK_TUTAR=0

     select @GEC_STOK_MIKTAR=sum(h.mik),
     @GEC_STOK_TUTAR=sum(h.mik*h.brmfiy) from veresimas as
      m inner join veresihrk as h with (nolock)
     on m.verid=h.verid and m.sil=h.sil and m.sil=0
     and h.stktip=@STOK_TIP and h.stkod=@STOK_KOD
     and m.yertip='pomvardimas' and m.varno=@VARNO
     group by m.varno,h.stktip,h.stkod
     
     
     set @STOK_MIKTAR=@STOK_MIKTAR-@GEC_STOK_MIKTAR
     set @STOK_TUTARKDVLI=@STOK_TUTARKDVLI-@GEC_STOK_TUTAR
     
     
     SET @STOK_BRMKDVLI=0
     SET @STOK_BRMKDVSIZ=0
     
     
     if @STOK_MIKTAR<>0
      begin
       SET @STOK_BRMKDVLI=@STOK_TUTARKDVLI/@STOK_MIKTAR
       SET @STOK_BRMKDVSIZ=@STOK_BRMKDVLI/(1+@STOK_KDVYUZ) 
      end 
     
     SET @STOK_TUTARKDVSIZ=@STOK_BRMKDVSIZ*@STOK_MIKTAR 
     
     set @SERINO=1
     
     if @TIPIN='pomvardimas' and @firmano=0  
      SELECT @SERINO=count(*)+1 from pomvardimas with (nolock) where 
      kapsaat=@TARIH and varno>@VARNO 
      
      
     if @TIPIN='pomvardimas' and @firmano>0  
      SELECT @SERINO=count(*)+1 from pomvardimas with (nolock) where 
      kapsaat=@TARIH and varno>@VARNO and firmano=@Firmano

     
     insert into @TB_STOK (FIRMANO,VARNO,SERINO,TARIH,SAAT,ACK,CARKOD,OLUSTARSAAT,
     STOK_TIP,STOK_KOD,STOK_BRIM,STOK_KDVYUZ,STOK_MIKTAR,
     STOK_BRMKDVLI,STOK_BRMKDVSIZ,STOK_TUTARKDVLI,STOK_TUTARKDVSIZ)
     values (@FIRMA,@VARNO,@SERINO,@TARIH,@SAAT,@ACK,@CAR_KOD,@OLUSTARSAAT,
     @STOK_TIP,@STOK_KOD,@STOK_BRIM,@STOK_KDVYUZ,@STOK_MIKTAR,
     @STOK_BRMKDVLI,@STOK_BRMKDVSIZ,
     @STOK_TUTARKDVLI,@STOK_TUTARKDVSIZ) 


     FETCH NEXT FROM VARDI_STOK INTO
       @FIRMA,@VARNO,@TARIH,@SAAT,@ACK,@OLUSTARSAAT,
       @STOK_TIP,@STOK_KOD,@STOK_KDVYUZ,
       @STOK_MIKTAR,@STOK_TUTARKDVLI

   END
   
     CLOSE VARDI_STOK
     DEALLOCATE VARDI_STOK 

     delete from @TB_STOK where STOK_MIKTAR=0


RETURN


END

================================================================================
