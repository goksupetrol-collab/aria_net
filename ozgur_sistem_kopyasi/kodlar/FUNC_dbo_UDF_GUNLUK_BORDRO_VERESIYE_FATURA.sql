-- Function: dbo.UDF_GUNLUK_BORDRO_VERESIYE_FATURA
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.727585
================================================================================

CREATE FUNCTION [dbo].[UDF_GUNLUK_BORDRO_VERESIYE_FATURA] 
(@FIRMANO INT,
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
  @TB_GENEL_BORDRO TABLE (
    FIS_NO              VARCHAR(30) COLLATE Turkish_CI_AS,
    CARITIP             VARCHAR(20) COLLATE Turkish_CI_AS,
    CARIKOD				VARCHAR(50) COLLATE Turkish_CI_AS,
    CARIUNVAN 			VARCHAR(200) COLLATE Turkish_CI_AS,
    VERGINO				VARCHAR(50) COLLATE Turkish_CI_AS,
    TUTARKDVSIZ			FLOAT,
    KDVTUTAR        	FLOAT,
    TUTARKDVLI        	FLOAT)
AS
BEGIN
 
   
   insert into @TB_GENEL_BORDRO (FIS_NO,CARITIP,CARIKOD,CARIUNVAN,VERGINO,TUTARKDVSIZ,KDVTUTAR,TUTARKDVLI) 
   SELECT v.fatseri+''+v.fatno,cartip,carkod,'','',
   v.genel_net_top ,v.genel_kdv_top,v.genel_top
   From faturamas as v with (nolock) where v.tarih>=@TARIH1 and v.tarih<=@TARIH2 and v.Sil=0 
   and v.firmano=@FIRMANO and v.fattip='FATVERSAT'

    UPDATE @TB_GENEL_BORDRO SET 
    CARIUNVAN=dt.Unvan,
    VERGINO=dt.VergiKNo
    from @TB_GENEL_BORDRO as t join 
    (Select cartip,kod,unvan,VergiKNo from Genel_Cari_Kart ) dt on 
    dt.kod=t.CARIKOD



  RETURN

end

================================================================================
