-- Function: dbo.UDF_FATURA_STOK_GRP_HRK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.714909
================================================================================

CREATE FUNCTION [dbo].UDF_FATURA_STOK_GRP_HRK 
(@firmano    int,
@Tartip          INT,
@bastar      datetime,
@bittar      datetime)
RETURNS
  @TB_FATURA_RAP TABLE (
  id					  bigint  IDENTITY(1, 1) NOT NULL,
  firmano				  int,
  sil					  int,
  fatid	                  bigint,
  fattur_id				  int,
  fatrap_id				  int,
  hrkid					  bigint,
  cartip                  VARCHAR(30) COLLATE Turkish_CI_AS,
  carkod                  VARCHAR(30) COLLATE Turkish_CI_AS,
  carunvan                VARCHAR(150) COLLATE Turkish_CI_AS,
  Per_id				  int,	
  fatserino               VARCHAR(30) COLLATE Turkish_CI_AS,
  Fatad                   VARCHAR(50) COLLATE Turkish_CI_AS,
  ACK					  VARCHAR(200) COLLATE Turkish_CI_AS,
  tarih			          DATETIME,
  saat                    VARCHAR(10) COLLATE Turkish_CI_AS,
  vadetarih	              DATETIME,
  grp1					  int,
  grp_ad				  VARCHAR(100) COLLATE Turkish_CI_AS,
  miktar   		          FLOAT,
  brm_fiyat               FLOAT,
  KDV                     FLOAT,
  TUTAR_KDVSIZ            FLOAT,
  ISKYUZDE				  FLOAT,	
  TUTAR_ISK				  FLOAT,
  TUTAR_KDV     	      FLOAT,
  TUTAR_ISKKDVSIZ		  FLOAT,
  TUTAR_KDVLI             FLOAT)
AS
BEGIN
  

  declare @TB_FATURA_HRK TABLE (
  id					  bigint IDENTITY(1, 1) NOT NULL,
  firmano				  int,
  sil					  int,
  fatid	                  bigint,
  fattur_id				  int,
  fatrap_id				  int,
  hrkid					  bigint,
  cartip                  VARCHAR(30) COLLATE Turkish_CI_AS,
  carkod                 VARCHAR(30) COLLATE Turkish_CI_AS,
  carunvan               VARCHAR(150) COLLATE Turkish_CI_AS,
  fatserino               VARCHAR(30) COLLATE Turkish_CI_AS,
  Per_id				  int,	
  Fatad                   VARCHAR(50) COLLATE Turkish_CI_AS,
  ACK					  VARCHAR(200) COLLATE Turkish_CI_AS,
  tarih			          DATETIME,
  saat                    VARCHAR(10) COLLATE Turkish_CI_AS,
  vadetarih	              DATETIME,
  stktip				  VARCHAR(30) COLLATE Turkish_CI_AS,
  stk_kod				  VARCHAR(30) COLLATE Turkish_CI_AS,
  stk_ad				  VARCHAR(100) COLLATE Turkish_CI_AS,
  grp1					  int,
  grp_ad				  VARCHAR(100) COLLATE Turkish_CI_AS,
  miktar   		          FLOAT,
  brm_fiyat               FLOAT,
  KDV                     FLOAT,
  TUTAR_KDVSIZ            FLOAT,
  ISKYUZDE				  FLOAT,	
  TUTAR_ISK				  FLOAT,
  TUTAR_KDV     	      FLOAT,
  TUTAR_ISKKDVSIZ		  FLOAT,
  TUTAR_KDVLI             FLOAT,
  YUVARLAMA				  FLOAT)


  
  if @Tartip=1
   insert into @TB_FATURA_HRK
    (fatid,fatrap_id,fattur_id,hrkid,firmano,sil,
    cartip,carkod,carunvan,
     fatserino,Fatad,ACK,
     tarih,saat,vadetarih,
     stktip,stk_kod,stk_ad,miktar,brm_fiyat,KDV,TUTAR_KDVSIZ,ISKYUZDE,
     TUTAR_ISK,TUTAR_KDV,TUTAR_ISKKDVSIZ,TUTAR_KDVLI,
     YUVARLAMA)
     select M.fatid,m.fatrap_id,m.fattur_id,h.id,m.firmano,m.sil,
     m.cartip,m.carkod,'',(fatseri+fatno),m.fatad,m.ack,
     m.tarih,m.saat,m.vadtar,
     h.stktip,h.stkod,'',h.mik,h.brmfiy,h.kdvyuz*100,
     h.brmfiy*( case when h.carpan=0 then 1*h.mik else h.mik*h.carpan end),
     h.satiskyuz,(h.genisktut+h.satisktut)*
     ( case when h.carpan=0 then 1*h.mik else h.mik*h.carpan end),
     0,
     (((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut))
     * ( case when h.carpan=0 then 1*h.mik else h.mik*h.carpan end)),
     (((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut))
     * ( case when h.carpan=0 then 1*h.mik else h.mik*h.carpan end))
     *(1+h.kdvyuz),m.yuvtop
     from faturamas as m WITH (NOLOCK)
     inner join faturahrklistesi as h WITH (NOLOCK)
     on m.fatid=h.fatid and m.sil=0 and h.sil=0
     where m.tarih>=@bastar and  m.tarih<=@bittar
     
     
     
   if @Tartip=0
   insert into @TB_FATURA_HRK
    (fatid,fatrap_id,fattur_id,hrkid,firmano,sil,cartip,carkod,carunvan,
     fatserino,Fatad,ACK,
     tarih,saat,vadetarih,
     stktip,stk_kod,stk_ad,miktar,brm_fiyat,KDV,TUTAR_KDVSIZ,ISKYUZDE,
     TUTAR_ISK,TUTAR_KDV,TUTAR_ISKKDVSIZ,TUTAR_KDVLI,
     YUVARLAMA)
     select M.fatid,m.fatrap_id,m.fattur_id,h.id,m.firmano,m.sil,
     m.cartip,m.carkod,'',(fatseri+fatno),m.fatad,m.ack,
     m.tarih,m.saat,m.vadtar,
     h.stktip,h.stkod,'',h.mik,h.brmfiy,h.kdvyuz*100,
     h.brmfiy*( case when h.carpan=0 then 1*h.mik else h.mik*h.carpan end),
     h.satiskyuz,(h.genisktut+h.satisktut)*
     ( case when h.carpan=0 then 1*h.mik else h.mik*h.carpan end),
     0,
     (((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut))
     * ( case when h.carpan=0 then 1*h.mik else h.mik*h.carpan end)),
     (((h.brmfiy+h.otvbrim)-(h.satisktut+h.genisktut))
     * ( case when h.carpan=0 then 1*h.mik else h.mik*h.carpan end))
     *(1+h.kdvyuz),m.yuvtop
     from faturamas as m WITH (NOLOCK)
     inner join faturahrklistesi as h WITH (NOLOCK)
     on m.fatid=h.fatid and m.sil=0 and h.sil=0
        
     
     
     
     
     update @TB_FATURA_HRK set TUTAR_KDV=TUTAR_KDVLI-TUTAR_ISKKDVSIZ
     
     
      if @firmano>0
      delete from @TB_FATURA_HRK where firmano not in (0,@firmano)
     
     
     update @TB_FATURA_HRK set grp1=dt.grp1 from 
     @TB_FATURA_HRK as t join 
     (select kod,tip,ad,grp1=case when grp3>0 then grp3 
     when grp2>0 then grp2 when grp1>0 then grp1 end  from  gelgidlistok )
     dt on t.stktip=dt.tip and dt.kod=t.stk_kod
     
     
     update @TB_FATURA_HRK set grp_ad=dt.ad from 
     @TB_FATURA_HRK as t join 
     (select id,ad,grp1 from  grup )
     dt on t.grp1=dt.id 
     
     update @TB_FATURA_HRK set carunvan=dt.ad,Per_id=dt.per_id from 
     @TB_FATURA_HRK as t join 
     (select cartp,kod,ad,per_id from  Genel_Kart )
     dt on t.cartip=dt.cartp and dt.kod=t.carkod
     
     
     
     insert into @TB_FATURA_RAP
     (firmano,sil,fatid,fatrap_id,fattur_id,
     cartip,carkod,carunvan,per_id,
     fatserino,Fatad,ack,tarih,saat,vadetarih,
     grp1,grp_ad,miktar,brm_fiyat,kdv,TUTAR_KDVSIZ,
     ISKYUZDE,TUTAR_ISK,TUTAR_KDV,TUTAR_ISKKDVSIZ,
     TUTAR_KDVLI)      
     select firmano,sil,fatid,fatrap_id,fattur_id,
     cartip,carkod,carunvan,per_id,
     fatserino,Fatad,ack,tarih,saat,vadetarih,
     grp1,grp_ad,
     sum(miktar),
     sum(brm_fiyat*miktar)/sum(miktar),
     max(kdv),
     sum(TUTAR_KDVSIZ),
     sum(ISKYUZDE),sum(TUTAR_ISK),sum(TUTAR_KDV),
     sum(TUTAR_ISKKDVSIZ),sum(TUTAR_KDVLI)
     from @TB_FATURA_HRK
     group by firmano,sil,fatid,fatrap_id,fattur_id,
     cartip,carkod,carunvan,per_id,
     fatserino,Fatad,ack,tarih,saat,vadetarih,
     grp1,grp_ad  
  
  
  
        
     
     insert into @TB_FATURA_RAP
     (firmano,sil,fatid,fatrap_id,fattur_id,
     cartip,carkod,carunvan,per_id,
     fatserino,Fatad,ack,tarih,saat,vadetarih,
     grp1,grp_ad,miktar,brm_fiyat,kdv,TUTAR_KDVSIZ,
     ISKYUZDE,TUTAR_ISK,TUTAR_KDV,TUTAR_ISKKDVSIZ,
     TUTAR_KDVLI)      
     select firmano,sil,fatid,fatrap_id,fattur_id,
     cartip,carkod,carunvan,per_id,
     fatserino,Fatad,ack,tarih,saat,vadetarih,
     0,'YUVARLAMA',1,0,0,0,
     0,0,0,0,max(YUVARLAMA)
     from @TB_FATURA_HRK
     group by firmano,sil,fatid,fatrap_id,fattur_id,
     cartip,carkod,carunvan,per_id,
     fatserino,Fatad,ack,tarih,saat,
     vadetarih
     having max(YUVARLAMA)<>0
  

  
  RETURN
  

END

================================================================================
