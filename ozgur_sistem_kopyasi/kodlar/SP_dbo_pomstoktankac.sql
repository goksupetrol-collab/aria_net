-- Stored Procedure: dbo.pomstoktankac
-- Tarih: 2026-01-14 20:06:08.354992
================================================================================

CREATE PROCEDURE [dbo].pomstoktankac
@firmano int,
@varno float
AS
BEGIN


 declare @stkkod   varchar(20)
 declare @stktip   varchar(10)
 declare @tankkod  varchar(30)
 declare @kdvyuz   float
 declare @brimfiy  float
 declare @satismik float
 declare @acmik    float
 declare @trsmik    float
 declare @testmik    float

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

/*--stok kartlarına gore */
 /*delete from pomvardistok where varno=@varno */
 update pomvardistok Set Sil=1,TransferStartId=isnull(TransferStartId,0)+1 where varno=@varno  

DECLARE POM_SAYACSTOK CURSOR FAST_FORWARD FOR
 SELECT p.stkod,p.stktip,avg(p.kdvyuz),
  case when sum(p.satmik)>0 then
  sum(p.tutar)/sum(p.satmik) else avg(p.brimfiy) end,
  sum(p.satmik),isnull(sum(p.transfermik),0),isnull(sum(p.testmik),0),
 (select sum(isnull(MIKTAR,0)) 
 from @TB_DEP_TARIH as  s where
 s.STOK_TIP=p.stktip and s.STOK_KOD=p.stkod)
 FROM pomvardisayac as p with (nolock) 
 where varno=@varno and firmano=@firmano and Sil=0
 group by p.stkod,p.stktip

 OPEN POM_SAYACSTOK
 FETCH NEXT FROM POM_SAYACSTOK INTO
 @stkkod,@stktip,@kdvyuz,@brimfiy,@satismik,@trsmik,@testmik,@acmik
 WHILE @@FETCH_STATUS = 0
 BEGIN

   set @acmik=isnull(@acmik,0)

   insert into pomvardistok
   (firmano,varno,kod,acmik,satmik,kalan,brimfiy,stktip,kdvyuz,
   transfer_cks_mik,transfer_grs_mik,testmik)
   values
   (@firmano,@varno,@stkkod,@acmik,@satismik,@acmik-@satismik,@brimfiy,@stktip,@kdvyuz,
   @trsmik,@trsmik,@testmik)
   
 FETCH NEXT FROM POM_SAYACSTOK INTO  @stkkod,@stktip,@kdvyuz,@brimfiy,@satismik,@trsmik,@testmik,@acmik

 END
 CLOSE POM_SAYACSTOK
 DEALLOCATE POM_SAYACSTOK
/*-----------stok kartlarına gore */

/*-----tank kartlarına gore */
 /*delete from pomvarditank where varno=@varno */
 update pomvarditank Set Sil=1,TransferStartId=isnull(TransferStartId,0)+1 where varno=@varno  

DECLARE POM_SAYACTANK CURSOR FAST_FORWARD FOR
 SELECT p.tankod,p.stkod,p.stktip,avg(p.kdvyuz),
  case when sum(p.satmik)>0 then
  sum(p.tutar)/sum(p.satmik) else avg(p.brimfiy) end,
  sum(p.satmik),isnull(sum(p.transfermik),0),isnull(sum(p.testmik),0),
 (select MIKTAR from @TB_DEP_TARIH as  s where
 s.dep_kod=p.tankod and s.STOK_TIP=p.stktip and s.STOK_KOD=p.stkod)
 FROM pomvardisayac as p with (nolock)
 where varno=@varno and firmano=@firmano and Sil=0
 group by p.tankod,p.stkod,p.stktip

 OPEN POM_SAYACTANK
 FETCH NEXT FROM POM_SAYACTANK INTO
 @tankkod,@stkkod,@stktip,@kdvyuz,@brimfiy,@satismik,@trsmik,@testmik,@acmik
 WHILE @@FETCH_STATUS = 0
 BEGIN
 
  set @acmik=isnull(@acmik,0)

   insert into pomvarditank
   (firmano,varno,kod,stkod,acmik,satmik,kalan,brimfiy,stktip,kdvyuz,transfer_cks_mik,testmik)
   values
   (@firmano,@varno,@tankkod,@stkkod,@acmik,@satismik,@acmik-(@satismik+@trsmik+@testmik),@brimfiy,@stktip,@kdvyuz,@trsmik,@testmik)

 FETCH NEXT FROM POM_SAYACTANK INTO  @tankkod,@stkkod,@stktip,@kdvyuz,@brimfiy,@satismik,@trsmik,@testmik,@acmik

 END
 CLOSE POM_SAYACTANK
 DEALLOCATE POM_SAYACTANK
/*-----------tank kartlarına gore */


END

================================================================================
