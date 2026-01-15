-- Function: dbo.UDF_GUNLUK_BORDRO_ZRAPOR
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.728128
================================================================================

CREATE FUNCTION [dbo].[UDF_GUNLUK_BORDRO_ZRAPOR] 
(@FIRMANO INT,
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
  @TB_GENEL_BORDRO TABLE (
    FIS_NO              VARCHAR(30) COLLATE Turkish_CI_AS,
    ACK       			VARCHAR(100) COLLATE Turkish_CI_AS,
    TUTARKDVSIZ			FLOAT,
    KDVTUTAR        	FLOAT,
    TUTARKDVLI        	FLOAT)
AS
BEGIN
 
 
   insert into @TB_GENEL_BORDRO (FIS_NO,ACK,TUTARKDVSIZ,KDVTUTAR,TUTARKDVLI) 
   SELECT z.zseri+''+z.zserino,ykkod,Genel_Ara_Top,Genel_Kdv_Top,Genel_Top
   From Zrapormas as z with (nolock)  where z.tarih>=@TARIH1 and z.tarih<=@TARIH2 and z.Sil=0 
   and z.firmano=@FIRMANO 
   

    UPDATE @TB_GENEL_BORDRO SET ACK=dt.ad from @TB_GENEL_BORDRO as t join 
    (Select kod,ad from yazarkasakart ) dt on dt.kod=t.ack



  RETURN

end

================================================================================
