-- Function: dbo.UDF_KASA_TAR_SONDURUM
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.735250
================================================================================

CREATE FUNCTION [dbo].UDF_KASA_TAR_SONDURUM 
(@firmano        int,
@KOD 			VARCHAR(20),
@TARIH1 		DATETIME,
@TARIH2 		DATETIME)
RETURNS
  @TB_KASA_SONDURUM TABLE (
    Firma_id     int,
    DEVREDEN     FLOAT,
    GIREN        FLOAT,
    CIKAN        FLOAT)
BEGIN
DECLARE @DEVREDEN FLOAT
DECLARE @GIREN FLOAT
DECLARE @CIKAN FLOAT
 
  DECLARE @ONDA_HANE       INT
  DECLARE @VAR_TES_TEK     INT
  DECLARE @KAS_FIN_GOS     INT

   select @ONDA_HANE=para_ondalik,@VAR_TES_TEK=t.var_tes_tek,
   @KAS_FIN_GOS=t.kas_fin_var from sistemtanim as t

   set @DEVREDEN=0
   set @GIREN=0
   set @CIKAN=0
   
   /*finans işlemlerini gosterme */
   if @firmano=0
   select @DEVREDEN=isnull(sum(round(giren-cikan,@ONDA_HANE)),0)
   from kasahrk as h WITH (NOLOCK, INDEX = kasahrk_index3)
   where h.kaskod=@KOD and h.sil=0 and tarih < @TARIH1
   and ((varno>0  and islmhrk='TES') or (varno=0))

   if @firmano>0
   select @DEVREDEN=isnull(sum(round(giren-cikan,@ONDA_HANE)),0) from 
   kasahrk as h WITH (NOLOCK, INDEX = kasahrk_index3)
   where  (h.firmano=@firmano or h.firmano=0) 
   and h.kaskod=@KOD and h.sil=0 and tarih < @TARIH1
   and ((varno>0  and islmhrk='TES') or (varno=0))


   
   /*finans işlemlerini goster */
   if @KAS_FIN_GOS=1
    begin
     
    if @firmano=0
     select @DEVREDEN=@DEVREDEN+
     isnull(sum(round(giren-cikan,@ONDA_HANE)),0) from kasahrk as h
     WITH (NOLOCK, INDEX = kasahrk_index3)
     where h.kaskod=@KOD and h.sil=0 and tarih < @TARIH1
     and h.varno>0 and islmhrk<>'TES'
     
     
    if @firmano>0
     select @DEVREDEN=@DEVREDEN+
     isnull(sum(round(giren-cikan,@ONDA_HANE)),0) from kasahrk as h
     WITH (NOLOCK, INDEX = kasahrk_index3)
     where  (h.firmano=@firmano or h.firmano=0) 
     and h.kaskod=@KOD and h.sil=0 and tarih < @TARIH1
     and h.varno>0 and islmhrk<>'TES'
     
     end  
   /*and ((varno>0 and varok=1 and islmhrk='TES') or (varno=0)) */
   
    if @firmano=0
    SELECT @GIREN=isnull(sum(h.giren),0),
    @CIKAN=isnull(sum(round(h.cikan,@ONDA_HANE)),0)
    FROM kasahrk as h WITH (NOLOCK, INDEX = kasahrk_index3)
    where h.kaskod=@KOD
    and h.sil=0 AND tarih >= @TARIH1 and tarih <= @TARIH2
    and ((varno>0 and islmhrk='TES') or (varno=0))
    
    if @firmano>0
    SELECT @GIREN=isnull(sum(h.giren),0),
    @CIKAN=isnull(sum(round(h.cikan,@ONDA_HANE)),0)
    FROM kasahrk as h 
    WITH (NOLOCK, INDEX = kasahrk_index3)
    where 
    (h.firmano=@firmano or h.firmano=0) 
    and h.kaskod=@KOD
    and h.sil=0 AND tarih >= @TARIH1 and tarih <= @TARIH2
    and ((varno>0 and islmhrk='TES') or (varno=0))  
    
    
    
    
    if @KAS_FIN_GOS=1
     begin
      
      if @firmano=0
      SELECT @GIREN=@GIREN+
      isnull(sum(h.giren),0),
      @CIKAN=@CIKAN+isnull(sum(round(h.cikan,@ONDA_HANE)),0)
      FROM kasahrk as h WITH (NOLOCK, INDEX = kasahrk_index3)
      where h.kaskod=@KOD
      and h.sil=0 AND tarih >= @TARIH1 and tarih <= @TARIH2
      and varno>0 and islmhrk<>'TES'
      
      
      if @firmano>0
      SELECT @GIREN=@GIREN+
      isnull(sum(h.giren),0),
      @CIKAN=@CIKAN+isnull(sum(round(h.cikan,@ONDA_HANE)),0)
      FROM kasahrk as h WITH (NOLOCK, INDEX = kasahrk_index3)
      where  (h.firmano=@firmano or h.firmano=0) and h.kaskod=@KOD
      and h.sil=0 AND tarih >= @TARIH1 and tarih <= @TARIH2
      and varno>0 and islmhrk<>'TES'
      
      
      
   end 
    
    
   /* and ((varno>0 and varok=1 and islmhrk='TES') or (varno=0)) */

    
   INSERT @TB_KASA_SONDURUM (Firma_id,DEVREDEN,GIREN,CIKAN)
   VALUES (@Firmano,@DEVREDEN,@GIREN,@CIKAN)

  RETURN

END

================================================================================
