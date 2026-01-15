-- Function: dbo.UDF_GUNLUK_BORDRO_NAKIT
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.724677
================================================================================

CREATE FUNCTION [dbo].[UDF_GUNLUK_BORDRO_NAKIT] 
(@FIRMANO INT,
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
  @TB_GENEL_BORDRO TABLE (
    FIS_NO              VARCHAR(30) COLLATE Turkish_CI_AS,
    CARITIP             VARCHAR(20) COLLATE Turkish_CI_AS,
    CARIKOD             VARCHAR(50) COLLATE Turkish_CI_AS,
    VERGINO             VARCHAR(50) COLLATE Turkish_CI_AS, 
    CARIUNVAN           VARCHAR(200) COLLATE Turkish_CI_AS,
    TUTAR			    FLOAT)
AS
BEGIN
 
 
   insert into @TB_GENEL_BORDRO (FIS_NO,CARITIP,CARIKOD,CARIUNVAN,TUTAR) 
   SELECT k.belno,K.cartip,K.carkod,'',K.giren
   From kasahrk as k with (nolock)  where k.tarih>=@TARIH1 and k.tarih<=@TARIH2 and k.Sil=0 
   and ISNULL(cartip,'')='carikart'  and k.firmano=@FIRMANO AND K.giren>0
   

    UPDATE @TB_GENEL_BORDRO SET 
    CARIUNVAN=dt.Unvan,
    VERGINO=dt.VergiKNo
    from @TB_GENEL_BORDRO as t join 
    (Select cartip,kod,unvan,VergiKNo from Genel_Cari_Kart ) dt on 
    dt.kod=t.CARIKOD and dt.cartip=t.CARITIP



  RETURN

end

================================================================================
