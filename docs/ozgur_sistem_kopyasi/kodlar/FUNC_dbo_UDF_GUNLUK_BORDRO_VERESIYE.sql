-- Function: dbo.UDF_GUNLUK_BORDRO_VERESIYE
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.726672
================================================================================

CREATE FUNCTION [dbo].[UDF_GUNLUK_BORDRO_VERESIYE] 
(@FIRMANO INT,
@TARIH1 DATETIME,
@TARIH2 DATETIME,
@Tip    int)
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
 

    DECLARE @TEMP TABLE (
    VER_ID				INT,
    CARTIP              VARCHAR(30)  COLLATE Turkish_CI_AS,
    CARKOD     		    VARCHAR(50)  COLLATE Turkish_CI_AS,
    STKTIP  		    VARCHAR(30) COLLATE Turkish_CI_AS,
    STKKOD     		    VARCHAR(50) COLLATE Turkish_CI_AS,
    TARIH       		DATETIME,
    SIL					BIT DEFAULT 0)


   insert @TEMP (VER_ID,CARTIP,CARKOD,STKTIP,STKKOD,TARIH)
   Select h.Verid,v.cartip,v.carkod,h.Stktip,h.Stkod,v.tarih 
   from Veresihrk as h with (nolock) 
   inner join veresimas as v with (nolock) on 
   v.verid=h.verid and  v.sil=0 and h.sil=0
   where v.tarih>=@TARIH1 and v.tarih<=@TARIH2 
   and v.firmano=@FIRMANO 


   update @TEMP SET SIL=1 FROM @TEMP AS T 
   JOIN (SELECT VER_ID FROM @TEMP AS  T 
   INNER JOIN Cari_Fat_Urun_Iskonto as I on I.Car_Kod=T.CARKOD 
   and I.Stk_Kod=T.STKKOD AND T.STKTIP=I.StkTip ) DT ON 
   DT.VER_ID=T.VER_ID



   if @Tip=1
     insert into @TB_GENEL_BORDRO (FIS_NO,CARITIP,CARIKOD,CARIUNVAN,VERGINO,TUTARKDVSIZ,KDVTUTAR,TUTARKDVLI) 
     SELECT v.seri+''+v.no,cartip,carkod,'','',
     Genel_KdvliToplam-Genel_KdvToplam,Genel_KdvToplam,Genel_KdvliToplam
     From veresimas as v with (nolock)  
     where v.tarih>=@TARIH1 and v.tarih<=@TARIH2 and v.Sil=0 and isnull(v.hrk_stk_pro,0)=0
     and v.firmano=@FIRMANO and v.verid in (Select VER_ID FROM @TEMP WHERE SIL=0 GROUP BY VER_ID)
    
   
   
    
   if @Tip=2
     insert into @TB_GENEL_BORDRO (FIS_NO,CARITIP,CARIKOD,CARIUNVAN,VERGINO,TUTARKDVSIZ,KDVTUTAR,TUTARKDVLI) 
     SELECT v.seri+''+v.no,cartip,carkod,'','',
     Genel_KdvliToplam-Genel_KdvToplam,Genel_KdvToplam,Genel_KdvliToplam
     From veresimas as v with (nolock)  
     where v.tarih>=@TARIH1 and v.tarih<=@TARIH2 and v.Sil=0 and isnull(v.hrk_stk_pro,0)=1
     and v.firmano=@FIRMANO and v.verid in (Select VER_ID FROM @TEMP WHERE SIL=0 GROUP BY VER_ID)
    
   
   
   
   

    UPDATE @TB_GENEL_BORDRO SET 
    CARIUNVAN=dt.Unvan,
    VERGINO=dt.VergiKNo
    from @TB_GENEL_BORDRO as t join 
    (Select cartip,kod,unvan,VergiKNo from Genel_Cari_Kart ) dt on 
    dt.kod=t.CARIKOD



  RETURN

end

================================================================================
