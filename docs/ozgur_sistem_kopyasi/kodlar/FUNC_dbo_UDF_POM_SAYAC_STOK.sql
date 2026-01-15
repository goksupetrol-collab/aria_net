-- Function: dbo.UDF_POM_SAYAC_STOK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.758773
================================================================================

CREATE FUNCTION [dbo].UDF_POM_SAYAC_STOK (@firmano int,@varno int)
RETURNS
  @TB_POM_SAYACSTOK TABLE (
  [firmano]         int,
  [varno]           int,
  [kod]             varchar(30) COLLATE Turkish_CI_AS NOT NULL,
  [stktip]          varchar(10) COLLATE Turkish_CI_AS NULL,
  [acmik]           float,
  [satmik]          float,
  [kalan]           float,
  [brimfiy]         float,
  [tutar]           float,
  [testmik]         float,
  [transfermik]     float,
  [kdvyuz]          float)
 AS
 BEGIN
 
 declare @kod      varchar(20)
 declare @stktip   varchar(10)
 declare @kdvyuz   float
 declare @brimfiy  float
 declare @satismik float


 /*-- stok son durumları */
  DECLARE @TB_DEP_TARIH TABLE (
    VAR_NO     FLOAT,
    DEP_KOD    VARCHAR(30) COLLATE Turkish_CI_AS,
    STOK_TIP   VARCHAR(10) COLLATE Turkish_CI_AS,
    STOK_KOD   VARCHAR(30) COLLATE Turkish_CI_AS,
    MIKTAR     FLOAT,
    TUTAR      FLOAT)
   INSERT INTO @TB_DEP_TARIH
   SELECT * FROM DBO.DEPO_TARIHLI_STOKIN ('pomvardimas',@varno)
/*--stok son durumları */


 DECLARE POM_SAYACSTOK CURSOR FAST_FORWARD FOR
 SELECT s.stkod,s.stktip,s.kdvyuz,
 avg(s.brimfiy),sum(s.satmik+s.testmik+s.transfermik+s.digermik)
 FROM pomvardisayac as s
 where varno=@varno
 group by s.stkod,s.stktip,s.kdvyuz,
 s.brimfiy
 
 OPEN POM_SAYACSTOK
 FETCH NEXT FROM POM_SAYACSTOK INTO  @kod,@stktip,@kdvyuz,@brimfiy,@satismik
 WHILE @@FETCH_STATUS = 0
 BEGIN
 
   insert into @TB_POM_SAYACSTOK
   (kod,acmik,satmik,kalan,brimfiy,tutar,stktip,kdvyuz)
   values
   (@kod,0,@satismik,0,@brimfiy,@satismik*@brimfiy,@stktip,@kdvyuz)

  /*  insert into pomvarditank (varno,kod,acmik,satmik,kalan,brimfiy,tutar,stkod,stktip,kdvyuz) */
  /*  values  (@varno,@tankkod,@stkkalan,0,@tankkalan,@satfiy,@tankkalan*@satfiy,@kod,@stktip,@kdvyuz/100); */


 FETCH NEXT FROM POM_SAYACSTOK INTO  @kod,@stktip,@kdvyuz,@brimfiy,@satismik

 END
 CLOSE POM_SAYACSTOK
 DEALLOCATE POM_SAYACSTOK
 
 RETURN


 END

================================================================================
