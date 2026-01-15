-- Function: dbo.UDF_KASA_GENEL_HRK
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.733296
================================================================================

CREATE FUNCTION [dbo].UDF_KASA_GENEL_HRK (
@firmano		  int,
@KOD              VARCHAR(20),
@TARIH1           DATETIME,
@TARIH2           DATETIME,
@silin            varchar(10))
RETURNS
   @TB_KASA_GENEL_HRK TABLE(
   id             int,
   Firmano        int,
   Firma_Ad       VARCHAR(150) COLLATE Turkish_CI_AS,
   kashrkid       int,
   fisfattip      varchar(5) COLLATE Turkish_CI_AS NULL,
   fisfatid       int,
   tarih          datetime,
   saat           varchar(8) COLLATE Turkish_CI_AS NULL,
   kaskod         varchar(20) COLLATE Turkish_CI_AS NULL,
   kasaad         varchar(50) COLLATE Turkish_CI_AS NULL,
   gctip          varchar(1) COLLATE Turkish_CI_AS NULL,
   varok          int,
   sil            int,
   varno          int,
   masterid       int,
   islmtip        varchar(20) COLLATE Turkish_CI_AS NULL,
   islmtipad      varchar(50) COLLATE Turkish_CI_AS NULL,
   islmhrk        varchar(20) COLLATE Turkish_CI_AS NULL,
   islmhrkad      varchar(50) COLLATE Turkish_CI_AS NULL,
   yertip         varchar(20) COLLATE Turkish_CI_AS NULL,
   yerad          varchar(50) COLLATE Turkish_CI_AS NULL,
   olususer       varchar(50) COLLATE Turkish_CI_AS NULL,
   olustarsaat    datetime,
   belno          varchar(20) COLLATE Turkish_CI_AS NULL,
   ack            varchar(100) COLLATE Turkish_CI_AS NULL,
   giren          float,
   cikan          float,
   kur			  float,
   remote_id	  float,	
   parabrm        varchar(10) COLLATE Turkish_CI_AS NULL,
   unvan          varchar(150) COLLATE Turkish_CI_AS NULL,
   cartip         varchar(30) COLLATE Turkish_CI_AS NULL,
   carkod         varchar(30) COLLATE Turkish_CI_AS NULL,
   RG             int,
   devir		  bit,
   DegUser		  varchar(150) COLLATE Turkish_CI_AS NULL,
   DegTarSaat    datetime  )
AS
BEGIN

  DECLARE @ONDA_HANE       INT
  DECLARE @VAR_TES_TEK     INT
  DECLARE @KAS_FIN_GOS     INT

  select @ONDA_HANE=para_ondalik,@VAR_TES_TEK=t.var_tes_tek,
  @KAS_FIN_GOS=t.kas_fin_var from sistemtanim as t


  if @firmano=0
      insert into @TB_KASA_GENEL_HRK 
      (id,Firmano,kashrkid,fisfattip,fisfatid,
      tarih,saat,kaskod,gctip,varok,
      sil,varno,masterid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      belno,ack,olususer,olustarsaat,giren,cikan,kur,
      remote_id,parabrm,unvan,cartip,carkod,rg,devir,
      DegUser,DegTarSaat)
      select h.id,h.firmano,h.kashrkid,h.fisfattip,h.fisfatid,
      h.tarih,h.saat,h.kaskod,h.gctip,h.varok,
      h.sil,h.varno,h.masterid,h.islmtip,h.islmtipad,h.islmhrk,
      h.islmhrkad,h.yertip,h.yerad,h.belno,h.ack,h.olususer,h.olustarsaat,
      round(h.giren,@ONDA_HANE),
      round(h.cikan,@ONDA_HANE),h.kur,h.remote_id,
      h.parabrm,'',
      case
      when h.islmhrk='TES' then 'perkart'
      when h.islmtip='VIR' then 'kasakart'
      when h.islmhrk='ELT' then  cek.cartip
      else h.cartip end,
      case
      when h.islmhrk='TES' then  h.perkod
      when h.islmtip='VIR' then  h.kaskod
      when h.islmhrk='ELT' then  cek.carkod
      else h.carkod end,h.rg,h.devir,
      h.deguser,h.degtarsaat
      from kasahrk as h with (NOLOCK) 
      left join cekkart as cek with (NOLOCK) on cek.refno=h.karsiheskod
      where h.kaskod=@KOD
      and h.tarih>=@TARIH1 and h.tarih<=@TARIH2
      and h.varno=0 and h.sil in (select * from dbo.CsvToSTR(@silin))



    if @firmano>0
    insert into @TB_KASA_GENEL_HRK (id,Firmano,kashrkid,fisfattip,fisfatid,
      tarih,saat,kaskod,gctip,varok,
      sil,varno,masterid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
      belno,ack,olususer,olustarsaat,giren,cikan,kur,
      remote_id,parabrm,unvan,cartip,carkod,rg,devir,
      DegUser,DegTarSaat)
      select h.id,h.firmano,h.kashrkid,h.fisfattip,h.fisfatid,
      h.tarih,h.saat,h.kaskod,h.gctip,h.varok,
      h.sil,h.varno,h.masterid,h.islmtip,h.islmtipad,h.islmhrk,
      h.islmhrkad,h.yertip,h.yerad,h.belno,h.ack,h.olususer,h.olustarsaat,
      round(h.giren,@ONDA_HANE),
      round(h.cikan,@ONDA_HANE),h.kur,
      h.remote_id,
      h.parabrm,'',
      case
      when h.islmhrk='TES' then 'perkart'
      when h.islmtip='VIR' then 'kasakart'
      when h.islmhrk='ELT' then  cek.cartip
      else h.cartip end,
      case
      when h.islmhrk='TES' then  h.perkod
      when h.islmtip='VIR' then  h.kaskod
      when h.islmhrk='ELT' then  cek.carkod
      else h.carkod end,h.rg,h.devir,
      h.deguser,h.degtarsaat
      from kasahrk as h WITH (NOLOCK, INDEX = kasahrk_index2)
      left join cekkart as cek with (NOLOCK) on cek.refno=h.karsiheskod
      where (h.firmano=@firmano or h.firmano=0) and h.kaskod=@KOD
      and h.tarih>=@TARIH1 and h.tarih<=@TARIH2
      and h.varno=0 and h.sil in (select * from dbo.CsvToSTR(@silin))
      



  
  /* vardiya finans işlmelerini goster */
    if @KAS_FIN_GOS=1
     begin

         if @firmano=0
          insert into @TB_KASA_GENEL_HRK 
          (id,Firmano,kashrkid,fisfattip,fisfatid,
          tarih,saat,kaskod,gctip,varok,
          sil,varno,masterid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
          belno,ack,olususer,olustarsaat,giren,cikan,kur,
          remote_id,parabrm,unvan,cartip,carkod,rg,devir,
          DegUser,DegTarSaat)
          select h.id,h.firmano,h.kashrkid,h.fisfattip,h.fisfatid,
          h.tarih,h.saat,h.kaskod,h.gctip,h.varok,
          h.sil,h.varno,h.masterid,h.islmtip,h.islmtipad,h.islmhrk,
          h.islmhrkad,h.yertip,h.yerad,h.belno,h.ack,h.olususer,
          h.olustarsaat,
          round(h.giren,@ONDA_HANE),
          round(h.cikan,@ONDA_HANE),h.kur,
          h.remote_id,
          h.parabrm,'',
          case
          when h.islmhrk='TES' then 'perkart'
          when h.islmtip='VIR' then 'kasakart'
          when h.islmhrk='ELT' then  cek.cartip
          else h.cartip end,
          case
          when h.islmhrk='TES' then  h.perkod
          when h.islmtip='VIR' then  h.kaskod
          when h.islmhrk='ELT' then  cek.carkod
          else h.carkod end,h.rg,h.devir,
          h.deguser,h.degtarsaat
          from kasahrk as h with (NOLOCK)
          left join cekkart as cek with (NOLOCK) on cek.refno=h.karsiheskod
          where h.kaskod=@KOD  and h.tarih>=@TARIH1 and h.tarih<=@TARIH2
          and h.varno>0 and h.sil
          in (select * from dbo.CsvToSTR(@silin)) and h.islmhrk<>'TES'
          
          
          if @firmano>0
          insert into @TB_KASA_GENEL_HRK (id,Firmano,kashrkid,fisfattip,fisfatid,
          tarih,saat,kaskod,gctip,varok,
          sil,varno,masterid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
          belno,ack,olususer,olustarsaat,giren,cikan,kur,
          remote_id,parabrm,unvan,cartip,carkod,rg,devir,
          DegUser,DegTarSaat)
          select h.id,h.firmano,h.kashrkid,h.fisfattip,h.fisfatid,
          h.tarih,h.saat,h.kaskod,h.gctip,h.varok,
          h.sil,h.varno,h.masterid,h.islmtip,h.islmtipad,h.islmhrk,
          h.islmhrkad,h.yertip,h.yerad,h.belno,h.ack,h.olususer,h.olustarsaat,
          round(h.giren,@ONDA_HANE),
          round(h.cikan,@ONDA_HANE),h.kur,
          h.remote_id,
          h.parabrm,'',
          case
          when h.islmhrk='TES' then 'perkart'
          when h.islmtip='VIR' then 'kasakart'
          when h.islmhrk='ELT' then  cek.cartip
          else h.cartip end,
          case
          when h.islmhrk='TES' then  h.perkod
          when h.islmtip='VIR' then  h.kaskod
          when h.islmhrk='ELT' then  cek.carkod
          else h.carkod end,h.rg,h.devir,
          h.deguser,h.degtarsaat
          from kasahrk as h with (NOLOCK)
          left join cekkart as cek with (NOLOCK) on cek.refno=h.karsiheskod
          where (h.firmano=@firmano or h.firmano=0) and h.kaskod=@KOD
          and h.tarih>=@TARIH1 and h.tarih<=@TARIH2
          and h.varno>0 and h.sil
          in (select * from dbo.CsvToSTR(@silin)) and h.islmhrk<>'TES'
          
          
       end
          

  
  /*tesimat tek satır değilse */
    if @VAR_TES_TEK=0
     begin
     
      if @firmano=0
          insert into @TB_KASA_GENEL_HRK (id,Firmano,
          kashrkid,fisfattip,fisfatid,
          tarih,saat,kaskod,gctip,varok,
          sil,varno,masterid,islmtip,islmtipad,islmhrk,
          islmhrkad,yertip,yerad,
          belno,ack,olususer,olustarsaat,giren,cikan,kur,
          remote_id,parabrm,unvan,cartip,carkod,rg,h.devir,
          DegUser,DegTarSaat)
          select h.id,h.firmano,h.kashrkid,h.fisfattip,h.fisfatid,
          h.tarih,h.saat,h.kaskod,h.gctip,h.varok,
          h.sil,h.varno,h.masterid,h.islmtip,h.islmtipad,h.islmhrk,
          h.islmhrkad,h.yertip,h.yerad,h.belno,h.ack,h.olususer,h.olustarsaat,
          round(h.giren,@ONDA_HANE),
          round(h.cikan,@ONDA_HANE),h.kur,
          h.remote_id,
          h.parabrm,'',
          'perkart',h.perkod,h.rg,h.devir,
          h.deguser,h.degtarsaat
          from kasahrk as h with (NOLOCK)
          where kaskod=@KOD and tarih>=@TARIH1 and tarih<=@TARIH2
          and varno>0 and h.sil in (select * from dbo.CsvToSTR(@silin))
          and h.islmhrk='TES' 


       if @firmano>0
          insert into @TB_KASA_GENEL_HRK (id,Firmano,
          kashrkid,fisfattip,fisfatid,
          tarih,saat,kaskod,gctip,varok,
          sil,varno,masterid,islmtip,islmtipad,islmhrk,islmhrkad,yertip,yerad,
          belno,ack,olususer,olustarsaat,giren,cikan,kur,
          remote_id,parabrm,unvan,cartip,carkod,rg,devir,
          DegUser,DegTarSaat)
          select h.id,h.firmano,h.kashrkid,h.fisfattip,h.fisfatid,
          h.tarih,h.saat,h.kaskod,h.gctip,h.varok,
          h.sil,h.varno,h.masterid,h.islmtip,h.islmtipad,h.islmhrk,
          h.islmhrkad,h.yertip,h.yerad,h.belno,h.ack,h.olususer,h.olustarsaat,
          round(h.giren,@ONDA_HANE),
          round(h.cikan,@ONDA_HANE),h.kur,
          h.remote_id,
          h.parabrm,'',
          'perkart',h.perkod,h.rg,h.devir,
          h.deguser,h.degtarsaat
          from kasahrk as h with (NOLOCK)
          where (h.firmano=@firmano or h.firmano=0) and
          h.kaskod=@KOD and tarih>=@TARIH1 and tarih<=@TARIH2
          and varno>0 and h.sil in (select * from dbo.CsvToSTR(@silin))
          and h.islmhrk='TES'

      end
          

 /*teslimat tek satır ise */
  if @VAR_TES_TEK=1
   begin
       if @firmano=0
          insert into @TB_KASA_GENEL_HRK (id,Firmano,
          kashrkid,fisfattip,fisfatid,
          tarih,saat,kaskod,gctip,varok,
          sil,varno,masterid,islmtip,islmtipad,islmhrk,
          islmhrkad,yertip,yerad,
          belno,ack,olususer,olustarsaat,giren,cikan,kur,
          remote_id,parabrm,unvan,cartip,carkod,rg,devir,
          DegUser,DegTarSaat)
          select max(h.id),h.firmano,max(h.kashrkid),
          '-',0,max(h.tarih),max(h.saat),
          h.kaskod,h.gctip,h.varok,
          h.sil,h.varno,max(h.masterid),
          h.islmtip,h.islmtipad,h.islmhrk,
          h.islmhrkad,h.yertip,h.yerad,
          CAST(varno as varchar),
          '(TEK SATIR) VARDIYA TESLIMAT' as ack,
          max(h.olususer),max(h.olustarsaat),
          sum(round(h.giren,@ONDA_HANE)),
          sum(round(h.cikan,@ONDA_HANE)),avg(h.kur),
          max(h.remote_id),
          h.parabrm,'',
          'perkart','diger',1,1,
          max(h.deguser),max(h.degtarsaat)
          from kasahrk as h with (NOLOCK)
          where h.kaskod=@KOD and tarih>=@TARIH1 and tarih<=@TARIH2
          and varno>0 and h.sil=0 and h.islmhrk='TES' 
          GROUP BY h.firmano,h.kaskod,h.gctip,h.varok,
          h.sil,h.varno,h.islmtip,h.islmtipad,h.islmhrk,
          h.islmhrkad,h.yertip,h.yerad,h.parabrm
          
          if @firmano>0
          insert into @TB_KASA_GENEL_HRK (id,Firmano,
          kashrkid,fisfattip,fisfatid,
          tarih,saat,kaskod,gctip,varok,
          sil,varno,masterid,islmtip,islmtipad,
          islmhrk,islmhrkad,yertip,yerad,
          belno,ack,olususer,olustarsaat,giren,cikan,kur,
          remote_id,parabrm,unvan,cartip,carkod,rg,devir,
          DegUser,DegTarSaat)
          select max(h.id),h.firmano,max(h.kashrkid),
          '-',0,max(h.tarih),max(h.saat),
          h.kaskod,h.gctip,h.varok,
          h.sil,h.varno,max(h.masterid),
          h.islmtip,h.islmtipad,h.islmhrk,
          h.islmhrkad,h.yertip,h.yerad,
          CAST(varno as varchar),
          '(TEK SATIR) VARDIYA TESLIMAT' as ack,
          max(h.olususer),max(h.olustarsaat),
          sum(round(h.giren,@ONDA_HANE)),
          sum(round(h.cikan,@ONDA_HANE)),avg(h.kur),
          max(h.remote_id),
          h.parabrm,'',
          'perkart','diger',1,1,
          max(h.deguser),max(h.degtarsaat)
          from kasahrk as h with (NOLOCK)
          where (h.firmano=@firmano or h.firmano=0) and
          h.kaskod=@KOD and tarih>=@TARIH1 and tarih<=@TARIH2
          and varno>0 and h.sil=0 and h.islmhrk='TES' 
          GROUP BY h.firmano,h.kaskod,h.gctip,h.varok,
          h.sil,h.varno,h.islmtip,h.islmtipad,h.islmhrk,
          h.islmhrkad,h.yertip,h.yerad,h.parabrm
          
          
   end

      update @TB_KASA_GENEL_HRK set kasaad=dt.ad
      from @TB_KASA_GENEL_HRK as t join
      (select kod,ad from kasakart with (NOLOCK)
      where sil=0 and kod=@KOD) dt
      on t.kaskod=dt.kod

      update @TB_KASA_GENEL_HRK set unvan=dt.ad
      from @TB_KASA_GENEL_HRK as t join
      (select cartp,kod,ad from Genel_Kart with (NOLOCK) )
      dt on t.carkod=dt.kod and t.cartip=dt.cartp
      
      
      update @TB_KASA_GENEL_HRK set firma_ad=dt.ad
      from @TB_KASA_GENEL_HRK as t join
      (select id,ad from Firma) dt on dt.id=t.firmano
  


 RETURN

 END

================================================================================
