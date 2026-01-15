-- Function: dbo.UDF_VAR_NAKIT_STOK_GRUP
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.785470
================================================================================

CREATE FUNCTION [dbo].[UDF_VAR_NAKIT_STOK_GRUP] 
(@VARNIN VARCHAR(max),@TIP VARCHAR(30))
RETURNS
  @TB_VAR_NAK_HRK TABLE (
    CARI_TIP        VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD        VARCHAR(50)  COLLATE Turkish_CI_AS,
    CARI_ADI        VARCHAR(150)  COLLATE Turkish_CI_AS,
    CARI_GRUP       VARCHAR(70)  COLLATE Turkish_CI_AS,
    STOK_TIP        VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_KOD        VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_AD         VARCHAR(100)  COLLATE Turkish_CI_AS,
    MIKTAR          FLOAT,
    BRMFIYATKDVSIZ  FLOAT,
    BRMFIYATKDVLI   FLOAT,
    KDV				FLOAT,
    KDVTUTAR		FLOAT,
    TUTARKDVSIZ     FLOAT,
    TUTARKDVLI      FLOAT)
AS
BEGIN


    DECLARE @TB_NAK_HRK TABLE (
    CARI_TIP        VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_KOD        VARCHAR(50)  COLLATE Turkish_CI_AS,
    CARI_ADI        VARCHAR(150)  COLLATE Turkish_CI_AS,
    CARI_GRUP       VARCHAR(70)  COLLATE Turkish_CI_AS,
    STOK_TIP        VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_KOD        VARCHAR(20)  COLLATE Turkish_CI_AS,
    STOK_AD         VARCHAR(100)  COLLATE Turkish_CI_AS,
    MIKTAR          FLOAT,
    BRMFIYATKDVSIZ  FLOAT,
    BRMFIYATKDVLI   FLOAT,
    KDV				FLOAT,
    KDVTUTAR		FLOAT,
    TUTARKDVSIZ     FLOAT,
    TUTARKDVLI      FLOAT)
   




  
    DECLARE @VARNO 				  int
    DECLARE @STOK_TIP             VARCHAR(10) 
    DECLARE @STOK_KOD             VARCHAR(30)
    DECLARE @STOK_KDVYUZ          FLOAT
    DECLARE @STOK_MIKTAR          FLOAT
    DECLARE @STOK_BRMKDVLI		  FLOAT
    DECLARE @STOK_BRMKDVSIZ		  FLOAT
    DECLARE @STOK_TUTARKDVLI	  FLOAT
    DECLARE @STOK_TUTARKDVSIZ	  FLOAT


    DECLARE @CAR_TIP             VARCHAR(30) 
    DECLARE @CAR_KOD             VARCHAR(50) 
   
   

     set @CAR_TIP='carikart'
     SELECT @CAR_KOD=zrap_carkod FROM sistemtanim




   DECLARE VARDI_STOK CURSOR FAST_FORWARD FOR
    SELECT p.varno,ps.stktip,ps.stkod,max(ps.kdvyuz),
     sum(ps.satmik),sum(ps.tutar)
     from pomvardimas as p with (nolock)
     inner join pomvardisayac as ps with (nolock)
      on ps.varno=p.varno and p.sil=0 
      and  p.varno in (select * from CsvToInt_Max(@VARNIN) )
      group by p.varno,ps.stktip,ps.stkod 
      order by p.varno
     OPEN  VARDI_STOK
      FETCH NEXT FROM VARDI_STOK INTO
       @VARNO,@STOK_TIP,@STOK_KOD,@STOK_KDVYUZ,
       @STOK_MIKTAR,@STOK_TUTARKDVLI
       WHILE @@FETCH_STATUS = 0
        BEGIN  


     declare @GEC_STOK_MIKTAR      FLOAT
     declare @GEC_STOK_TUTAR       FLOAT

     set @GEC_STOK_MIKTAR=0
     set @GEC_STOK_TUTAR=0

     select @GEC_STOK_MIKTAR=sum(h.mik),
     @GEC_STOK_TUTAR=sum(h.mik*(h.brmfiy-(h.fiyfarktop+h.vadfarktop)))
     from veresimas as  m   with (nolock) 
     inner join veresihrk as h  with (nolock)
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
     
     
     insert into @TB_NAK_HRK 
      (CARI_TIP,CARI_KOD,STOK_TIP,STOK_KOD,
      KDV,MIKTAR,BRMFIYATKDVLI,
      BRMFIYATKDVSIZ,TUTARKDVLI,
      TUTARKDVSIZ,KDVTUTAR)
      values 
      (@CAR_TIP,@CAR_KOD,@STOK_TIP,@STOK_KOD,
      @STOK_KDVYUZ*100,@STOK_MIKTAR,@STOK_BRMKDVLI,
      @STOK_BRMKDVSIZ,@STOK_TUTARKDVLI,
      @STOK_TUTARKDVSIZ,@STOK_TUTARKDVLI-@STOK_TUTARKDVSIZ) 


     FETCH NEXT FROM VARDI_STOK INTO
       @VARNO,@STOK_TIP,@STOK_KOD,@STOK_KDVYUZ,
       @STOK_MIKTAR,@STOK_TUTARKDVLI

   END
   
     CLOSE VARDI_STOK
     DEALLOCATE VARDI_STOK 
  
   
     delete from @TB_NAK_HRK where MIKTAR=0
    
    
  
     insert into @TB_VAR_NAK_HRK 
      (CARI_TIP,CARI_KOD,STOK_TIP,STOK_KOD,
      KDV,MIKTAR,BRMFIYATKDVLI,
      BRMFIYATKDVSIZ,TUTARKDVLI,
      TUTARKDVSIZ,KDVTUTAR) 
      select 
      CARI_TIP,CARI_KOD,STOK_TIP,STOK_KOD,
      KDV,sum(MIKTAR),
      case when SUM(MIKTAR)<>0 then 
      SUM(TUTARKDVLI)/SUM(MIKTAR) else 0 end,
      case when SUM(MIKTAR)<>0 then 
      SUM(TUTARKDVSIZ)/SUM(MIKTAR) else 0 end,
      SUM(TUTARKDVLI),
      SUM(TUTARKDVSIZ),
      SUM(KDVTUTAR)
      FROM @TB_NAK_HRK
      GROUP BY 
      CARI_TIP,CARI_KOD,STOK_TIP,
      STOK_KOD,
      KDV
      
      
      
     UPDATE @TB_VAR_NAK_HRK 
     SET CARI_ADI=DT.AD,
     CARI_GRUP=DT.grupad1
     FROM @TB_VAR_NAK_HRK AS T 
     join (select kod,cartp,ad,grupad1 from Genel_Kart )
     dt on dt.kod=t.CARI_KOD and dt.cartp=t.CARI_TIP
   
   
     UPDATE @TB_VAR_NAK_HRK set 
     STOK_AD=dt.AD
     from @TB_VAR_NAK_HRK t join
     (select sk.tip,sk.kod,sk.ad from gelgidlistok as sk) dt
     on dt.tip=t.STOK_TIP and dt.kod=t.STOK_KOD
   
    
    
  
  RETURN

end

================================================================================
