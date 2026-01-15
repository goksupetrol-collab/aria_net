-- Function: dbo.UDF_PomVarNakitStokMas
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.761160
================================================================================

CREATE FUNCTION [dbo].UDF_PomVarNakitStokMas (
@firmano           int,
@TIPIN			   VARCHAR(30),
@BASTARIH          DATETIME,
@BITTARIH          DATETIME)
RETURNS
   @TB_STOK TABLE (
    VARNO 				 INT,
    TARIH                DATETIME,
    SAAT             	 VARCHAR(10) COLLATE Turkish_CI_AS,
    CARKOD				 VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_TIP             VARCHAR(10) COLLATE Turkish_CI_AS,
    STOK_KOD             VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_KDVYUZ          FLOAT,
    STOK_MIKTAR          FLOAT,
    STOK_TUTAR  		 FLOAT,
    ACK 				 VARCHAR(100) COLLATE Turkish_CI_AS,
    OLUSTARSAAT          DATETIME)
AS
BEGIN

   DECLARE @CAR_KOD             VARCHAR(30) 
     
   SELECT @CAR_KOD=zrap_carkod FROM sistemtanim
   
    DECLARE @VARNO 				  int
    DECLARE @TARIH 				  DATETIME
    DECLARE @SAAT				  VARCHAR(10) 	 
    DECLARE @STOK_TIP             VARCHAR(10) 
    DECLARE @STOK_KOD             VARCHAR(30)
    DECLARE @STOK_KDVYUZ          FLOAT
    DECLARE @STOK_MIKTAR          FLOAT
    DECLARE @STOK_TUTAR  		  FLOAT
    DECLARE @ACK                  VARCHAR(100) 
    DECLARE @OLUSTARSAAT     	  DATETIME


  if @TIPIN='pomvardimas'
   DECLARE VARDI_STOK CURSOR FAST_FORWARD FOR
    SELECT p.varno,p.tarih,p.saat,p.varad,p.olustarsaat,
    ps.stktip,ps.stkod,max(ps.kdvyuz),sum(ps.satmik),sum(ps.tutar)
    from pomvardimas as p 
    inner join pomvardisayac as ps 
     on ps.varno=p.varno and p.varok=1
      and p.tarih>=@BASTARIH and p.tarih<=@BASTARIH  
      group by p.varno,p.tarih,p.saat,p.varad,p.olustarsaat,
      ps.stktip,ps.stkod
      order by p.varno
      
      
   if @TIPIN='marvardimas'
   DECLARE VARDI_STOK CURSOR FAST_FORWARD FOR
    SELECT p.varno,p.tarih,p.saat,p.varad,p.olustarsaat,
    ps.stktip,ps.stkod,max(ps.kdvyuz),sum(ps.mik),sum(ps.mik-ps.brmfiy)
    from marvardimas as p
    inner join marsatmas as pm
    on pm.varno=p.varno and pm.sil=0 and p.varok=1
    inner join marsathrk as ps 
     on ps.varno=p.varno and pm.marsatid=ps.marsatid and p.sil=0 
      and p.tarih>=@BASTARIH and p.tarih<=@BASTARIH  
      group by p.varno,p.tarih,p.saat,p.varad,p.olustarsaat,
      ps.stktip,ps.stkod
      order by p.varno  
      
      
      
      
     OPEN  VARDI_STOK
      FETCH NEXT FROM VARDI_STOK INTO
       @VARNO,@TARIH,@SAAT,@ACK,@OLUSTARSAAT,
       @STOK_TIP,@STOK_KOD,@STOK_KDVYUZ,@STOK_MIKTAR,@STOK_TUTAR
       WHILE @@FETCH_STATUS = 0
        BEGIN  

     declare @GEC_STOK_MIKTAR      FLOAT
     declare @GEC_STOK_TUTAR       FLOAT

     set @GEC_STOK_MIKTAR=0
     set @GEC_STOK_TUTAR=0

     select @GEC_STOK_MIKTAR=sum(h.mik),
     @GEC_STOK_TUTAR=sum(h.mik*h.brmfiy) from veresimas as m 
     inner join veresihrk as h 
     on m.verid=h.verid and m.sil=h.sil and m.sil=0
     and h.stktip=@STOK_TIP and h.stkod=@STOK_KOD
     and m.yertip='pomvardimas' and m.varno=@VARNO
     group by m.varno,h.stktip,h.stkod
     
  
     
     
     set @STOK_MIKTAR=@STOK_MIKTAR-@GEC_STOK_MIKTAR
     set @STOK_TUTAR=@STOK_TUTAR-@GEC_STOK_TUTAR

     insert into @TB_STOK (VARNO,TARIH,SAAT,ACK,CARKOD,OLUSTARSAAT,
     STOK_TIP,STOK_KOD,STOK_KDVYUZ,STOK_MIKTAR,STOK_TUTAR)
     values (@VARNO,@TARIH,@SAAT,@ACK,@CAR_KOD,@OLUSTARSAAT,
     @STOK_TIP,@STOK_KOD,@STOK_KDVYUZ,@STOK_MIKTAR,@STOK_TUTAR) 


     FETCH NEXT FROM VARDI_STOK INTO
       @VARNO,@TARIH,@SAAT,@ACK,@OLUSTARSAAT,
       @STOK_TIP,@STOK_KOD,@STOK_KDVYUZ,@STOK_MIKTAR,@STOK_TUTAR

   END
   
     CLOSE VARDI_STOK
     DEALLOCATE VARDI_STOK


RETURN


END

================================================================================
