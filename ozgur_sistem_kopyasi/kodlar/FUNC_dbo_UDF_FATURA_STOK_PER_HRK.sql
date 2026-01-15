-- Function: dbo.UDF_FATURA_STOK_PER_HRK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.715304
================================================================================

CREATE FUNCTION [dbo].[UDF_FATURA_STOK_PER_HRK] 
(@firmano    int,
@Tartip          INT,
@bastar      datetime,
@bittar      datetime,
@YetkiId      int )
RETURNS
  @TB_FATURA_RAP TABLE (
  id					  bigint  IDENTITY(1, 1) NOT NULL,
  firmano				  int,
  per_kod                  VARCHAR(30) COLLATE Turkish_CI_AS,
  per_unvan                VARCHAR(150) COLLATE Turkish_CI_AS,
  Per_id				  int,	
  Stk_tip                 VARCHAR(30) COLLATE Turkish_CI_AS,
  Stk_Kod                 VARCHAR(30) COLLATE Turkish_CI_AS,
  Stk_Ad                  VARCHAR(150) COLLATE Turkish_CI_AS,
  Adet					  int,
  miktar   		          FLOAT,
  TUTAR_KDVSIZ            FLOAT,
  TUTAR_KDV     	      FLOAT,
  TUTAR_KDVLI             FLOAT)
AS
BEGIN
  

  declare @TB_FATURA_HRK TABLE (
  id					  bigint IDENTITY(1, 1) NOT NULL,
  Firmano				  int,
  per_kod                  VARCHAR(30) COLLATE Turkish_CI_AS,
  per_unvan                VARCHAR(150) COLLATE Turkish_CI_AS,
  Per_id				  int,	
  Stk_tip                 VARCHAR(30) COLLATE Turkish_CI_AS,
  Stk_Kod                 VARCHAR(30) COLLATE Turkish_CI_AS,
  Stk_Ad                  VARCHAR(150) COLLATE Turkish_CI_AS,
  Adet					  int,
  miktar   		          FLOAT,
  TUTAR_KDVSIZ            FLOAT,
  TUTAR_KDV     	      FLOAT,
  TUTAR_KDVLI             FLOAT)


  


  if @Tartip=1
    insert into @TB_FATURA_HRK
    (Per_id,per_kod,per_unvan,
     Stk_tip,Stk_Kod,Stk_Ad,Adet,miktar,
     TUTAR_KDV,TUTAR_KDVSIZ,TUTAR_KDVLI)
     select m.Per_id,'','',
     h.stktip,h.stkod,'',1,h.mik,
     0,
     (((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut))
     * ( case when h.carpan=0 then 1*h.mik else h.mik*h.carpan end)),/*TUTAR_ISKKDVSIZ */
     (((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut))
     * ( case when h.carpan=0 then 1*h.mik else h.mik*h.carpan end))
     *(1+h.kdvyuz)/*TUTAR_KDVLI */
     from faturamas as m WITH (NOLOCK)
     inner join faturahrklistesi as h WITH (NOLOCK)
     on m.fatid=h.fatid and m.sil=0 and h.sil=0 and Per_id>0
     where m.tarih>=@bastar and  m.tarih<=@bittar
     and m.fatrap_id not in (select rap_id from YetkiKont WITH (NOLOCK) where Yetkiid=@YetkiId and Bolumid=3 ) 
     
     
     
   if @Tartip=0
   insert into @TB_FATURA_HRK
   (Per_id,per_kod,per_unvan,
     Stk_tip,Stk_Kod,Stk_Ad,Adet,miktar,
     TUTAR_KDV,TUTAR_KDVSIZ,TUTAR_KDVLI)
     select m.Per_id,'','',
     h.stktip,h.stkod,'',1,h.mik,
     0,
     (((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut))
     * ( case when h.carpan=0 then 1*h.mik else h.mik*h.carpan end)),/*TUTAR_ISKKDVSIZ */
     (((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut))
     * ( case when h.carpan=0 then 1*h.mik else h.mik*h.carpan end))
     *(1+h.kdvyuz)/*TUTAR_KDVLI */
     from faturamas as m WITH (NOLOCK)
     inner join faturahrklistesi as h WITH (NOLOCK)
     on m.fatid=h.fatid and m.sil=0 and h.sil=0 and Per_id>0
     and m.fatrap_id not in (select rap_id from YetkiKont WITH (NOLOCK) where Yetkiid=@YetkiId and Bolumid=3 ) 
         
         
     
     update @TB_FATURA_HRK set TUTAR_KDV=TUTAR_KDVLI-TUTAR_KDVSIZ
     
     
     if @firmano>0
      delete from @TB_FATURA_HRK where firmano not in (0,@firmano)
    
   
       update @TB_FATURA_HRK set Stk_ad=dt.ad,Stk_Kod=dt.Kod from 
     @TB_FATURA_HRK as t join 
     (select tip,kod,ad from stokkart )
     dt on  dt.tip=t.Stk_tip and dt.Kod=T.Stk_Kod
   
     
     
        
     update @TB_FATURA_HRK set per_unvan=dt.unvan,Per_Kod=dt.Kod from 
     @TB_FATURA_HRK as t join 
     (select id,kod,ad+' '+soyad unvan from PerKart )  dt on dt.id=t.per_id
     
     
     
     insert into @TB_FATURA_RAP
     (firmano,Per_id,per_kod,per_unvan,
     Stk_tip,Stk_Kod,Stk_Ad,Adet,miktar,
      TUTAR_KDV,TUTAR_KDVSIZ,TUTAR_KDVLI)      
     select firmano,Per_id,per_kod,per_unvan,
     Stk_tip,Stk_Kod,Stk_Ad,
     sum(Adet),
     sum(miktar),
     sum(TUTAR_KDV),
     sum(TUTAR_KDVSIZ),sum(TUTAR_KDVLI)
     from @TB_FATURA_HRK
     group by firmano,Per_id,per_kod,per_unvan,
     Stk_tip,Stk_Kod,Stk_Ad

  
  RETURN
  

END

================================================================================
