-- Stored Procedure: dbo.VAR_TANK_STOK_HESAPLA
-- Tarih: 2026-01-14 20:06:08.386264
================================================================================

CREATE PROCEDURE [dbo].VAR_TANK_STOK_HESAPLA (
@TIP VARCHAR(30),
@VARNIN VARCHAR(max))
AS
BEGIN

declare @varno           int
declare @ac_tarih        datetime
declare @ac_saat         varchar(10)
declare @kap_tarih       datetime
declare @kap_saat        varchar(10)
declare @say             int

   DECLARE CRS_VAR_DEPO_HRK CURSOR FAST_FORWARD FOR
    select IntValue varno from CsvToInt_Max(@VARNIN)
    OPEN CRS_VAR_DEPO_HRK
     FETCH NEXT FROM CRS_VAR_DEPO_HRK INTO
      @varno
      WHILE @@FETCH_STATUS = 0
      BEGIN

      if @TIP='pomvardimas'
      begin
      SELECT @say=count(*),
      @ac_tarih=tarih,@ac_saat=saat,
      @kap_tarih=kaptar,@kap_saat=kapsaat
      from pomvardimas with (nolock) where varno=@varno and sil=0
      group by tarih,saat,kaptar,kapsaat

       if @say>0
        begin
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

        /*--- stoklar */
        update pomvardistok set acmik=dt.miktar,
        kalan=dt.miktar-satmik from pomvardistok as t join
        (select STOK_TIP,STOK_KOD,isnull(sum(MIKTAR),0) as miktar
        from  @TB_DEP_TARIH group by STOK_TIP,STOK_KOD) dt on t.varno=@varno
        and dt.STOK_TIP=t.stktip and dt.STOK_KOD=t.kod

        /*--- tanklar */
        update pomvarditank set acmik=dt.miktar,kalan=dt.miktar-satmik 
        from pomvarditank as t join
        (select DEP_KOD,STOK_TIP,STOK_KOD,isnull(MIKTAR,0) as miktar
        from  @TB_DEP_TARIH )
        dt on t.varno=@varno
        and dt.DEP_KOD=t.kod and 
        dt.STOK_TIP=t.stktip and dt.STOK_KOD=t.stkod
       end

      end


       FETCH NEXT FROM CRS_VAR_DEPO_HRK INTO
       @varno
      END
      CLOSE CRS_VAR_DEPO_HRK
      DEALLOCATE CRS_VAR_DEPO_HRK




END

================================================================================
