-- Function: dbo.UDF_GUNLUK_BORDRO_POS
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.726100
================================================================================

CREATE FUNCTION [dbo].[UDF_GUNLUK_BORDRO_POS] 
(@FIRMANO INT,
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
  @TB_GENEL_BORDRO TABLE (
    FIS_NO              VARCHAR(30) COLLATE Turkish_CI_AS,
    POSKOD			    VARCHAR(20) COLLATE Turkish_CI_AS,
    POSUNVAN			VARCHAR(50) COLLATE Turkish_CI_AS,
    CARITIP             VARCHAR(20) COLLATE Turkish_CI_AS,
    CARIKOD             VARCHAR(50) COLLATE Turkish_CI_AS,
    VERGINO             VARCHAR(50) COLLATE Turkish_CI_AS, 
    CARIUNVAN           VARCHAR(200) COLLATE Turkish_CI_AS,
    TUTAR			    FLOAT)
AS
BEGIN
 
 
   insert into @TB_GENEL_BORDRO (FIS_NO,POSKOD,CARITIP,CARIKOD,CARIUNVAN,TUTAR) 
   SELECT k.belno,K.poskod,K.cartip,K.carkod,'',K.giren
   From poshrk as k with (nolock)  where k.tarih>=@TARIH1 and k.tarih<=@TARIH2 and k.Sil=0 
   and ISNULL(cartip,'')<>''  and k.firmano=@FIRMANO 
   
   
   
    UPDATE @TB_GENEL_BORDRO SET 
    POSUNVAN=dt.AD
    from @TB_GENEL_BORDRO as t join 
    (Select kod,ad from poskart ) dt on 
    dt.kod=t.POSKOD
   

    UPDATE @TB_GENEL_BORDRO SET 
    CARIUNVAN=dt.Unvan,
    VERGINO=dt.VergiKNo
    from @TB_GENEL_BORDRO as t join 
    (Select cartip,kod,unvan,VergiKNo from Genel_Cari_Kart ) dt on 
    dt.kod=t.CARIKOD



  RETURN

end

================================================================================
