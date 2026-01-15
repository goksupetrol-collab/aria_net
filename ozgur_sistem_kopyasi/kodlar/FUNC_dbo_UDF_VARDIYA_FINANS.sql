-- Function: dbo.UDF_VARDIYA_FINANS
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.798987
================================================================================

CREATE FUNCTION [dbo].UDF_VARDIYA_FINANS (
@yertip varchar(20),
@varno float,
@SILIN VARCHAR(20))
RETURNS
@TB_VARDIYA_FINANS TABLE (
    id          FLOAT,
    firmano		int,
    Tarih       Datetime,
    Saat        varchar(10) COLLATE Turkish_CI_AS,
    VadeTar     Datetime,
    Giren       FLOAT,
    Cikan       FLOAT,
    Ytlgiren    FLOAT,
    Ytlcikan    FLOAT,
    Kur         FLOAT,
    Parabrm     varchar(10) COLLATE Turkish_CI_AS,
    Grpad      VARCHAR(50) COLLATE Turkish_CI_AS,
    Grptip     VARCHAR(20) COLLATE Turkish_CI_AS,
    Hrkidad     VARCHAR(20) COLLATE Turkish_CI_AS,
    Hrkid       FLOAT,
    Masterid    FLOAT,
    Varno       FLOAT,
    Varok       INT,
    Sil         INT,
    Yerad       VARCHAR(30) COLLATE Turkish_CI_AS,
    Yertip      VARCHAR(30) COLLATE Turkish_CI_AS,
    Perkod      VARCHAR(30) COLLATE Turkish_CI_AS,
    Perad       VARCHAR(100) COLLATE Turkish_CI_AS,
    Adaid       int,
    AdaAd       VARCHAR(50) COLLATE Turkish_CI_AS,
    tipkod      varchar(20) COLLATE Turkish_CI_AS,
    tipad       varchar(50) COLLATE Turkish_CI_AS,
    hrkkod      varchar(20) COLLATE Turkish_CI_AS,
    hrkad      varchar(50) COLLATE Turkish_CI_AS,
    BelNo       varchar(30) COLLATE Turkish_CI_AS,
    Kod         varchar(30) COLLATE Turkish_CI_AS,
    CarKod      varchar(30) COLLATE Turkish_CI_AS,
    CarTip      varchar(20) COLLATE Turkish_CI_AS,
    Cartur      varchar(30) COLLATE Turkish_CI_AS,
    Unvan       varchar(150) COLLATE Turkish_CI_AS,
    Kasakod     varchar(30) COLLATE Turkish_CI_AS,
    KasaAd      varchar(50) COLLATE Turkish_CI_AS,
    Bankakod     varchar(30) COLLATE Turkish_CI_AS,
    BankaAd      varchar(100) COLLATE Turkish_CI_AS,
    Ack          varchar(200) COLLATE Turkish_CI_AS,
    Olustarsaat  Datetime,
    Olususer     varchar(50) COLLATE Turkish_CI_AS
    )
AS
BEGIN

 DECLARE @SIL_TEMP TABLE (
 sil      int)

declare @separator char(1)
 set @separator = ','

 declare @separator_position int
 declare @array_value varchar(1000)

 IF (LEN(RTRIM(@SILIN)) > 0)
 BEGIN
  set @SILIN = @SILIN + ','
 END

 while patindex('%,%' , @SILIN) <> 0
 begin

   select @separator_position =  patindex('%,%' , @SILIN)
   select @array_value = left(@SILIN, @separator_position - 1)

  Insert @SIL_TEMP
  Values (@array_value)

   select @SILIN = stuff(@SILIN, 1, @separator_position, '')
 end



/*- kasa hrk */
  insert into @TB_VARDIYA_FINANS (id,firmano,Tarih,Saat,VadeTar,Giren,Cikan,Kur,Parabrm,
  Grpad,Grptip,Hrkidad,Hrkid,Masterid,Varno,Varok,Sil,Yerad,Yertip,Perkod,
  Perad,Adaid,AdaAd,tipkod,tipad,hrkkod,hrkad,BelNo,Ack,Kod,
  CarKod,CarTip,Kasakod,KasaAd,Bankakod,
  BankaAd,Olustarsaat,Olususer)

  SELECT h.id,h.firmano,h.tarih,h.saat,null as vadetar,h.giren,h.cikan,
  h.kur,h.parabrm,'KASA İŞLEMLERİ','kasahrk',
  ('kashrkid') as hrkidad,h.kashrkid as hrkid,h.masterid,h.varno,h.varok,
  h.sil,h.yerad,h.yertip,
  h.perkod,'',h.adaid,'',h.islmtip,h.islmtipad,h.islmhrk,h.islmhrkad,
  h.belno,h.ack,h.kaskod,h.carkod,h.cartip,
  h.kaskod,'',
  ('') as bankod,('') as bankad,
  h.olustarsaat,h.olususer
  from kasahrk as h
  where h.masterid=0
  and h.islmhrk<>'TES' and h.sil in (select * from @SIL_TEMP)
  and h.yertip=@yertip and h.varno=@varno


/* pos hrk */

  insert into @TB_VARDIYA_FINANS (id,firmano,Tarih,Saat,VadeTar,Giren,Cikan,Kur,Parabrm,
  Grpad,Grptip,Hrkidad,Hrkid,Masterid,Varno,Varok,Sil,Yerad,Yertip,Perkod,
  Perad,Adaid,AdaAd,tipkod,tipad,hrkkod,hrkad,BelNo,Ack,Kod,
  CarKod,CarTip,Kasakod,KasaAd,Bankakod,
  Bankaad,Olustarsaat,Olususer)

  SELECT h.id,h.firmano,h.tarih,h.saat,h.vadetar,h.giren,h.cikan,h.kur,h.parabrm,
  'POS İŞLEMLERİ','poshrk',('poshrkid'),h.poshrkid,
  h.masterid,h.varno,h.varok,h.sil,h.yerad,h.yertip,
  h.perkod,'',h.adaid,'',
  h.islmtip,h.islmtipad,h.islmhrk,h.islmhrkad,
  h.belno,h.ack,
  h.poskod,
  h.carkod,h.cartip,
  ('') as kaskod,('') as kasad,
  h.bankod,'',
  h.olustarsaat,h.olususer
  from poshrk as h
  where h.masterid=0
  and h.islmhrk<>'POS' and h.sil in (select * from @SIL_TEMP)
  and h.yertip=@yertip and h.varno=@varno


 /*--cekkart */
  insert into @TB_VARDIYA_FINANS (id,firmano,Tarih,Saat,VadeTar,Giren,Cikan,Kur,Parabrm,
  Grpad,Grptip,Hrkidad,Hrkid,Masterid,Varno,Varok,Sil,Yerad,Yertip,Perkod,
  Perad,Adaid,AdaAd,tipkod,tipad,hrkkod,hrkad,BelNo,Ack,Kod,
  CarKod,CarTip,Kasakod,KasaAd,Bankakod,
  BankaAd,Olustarsaat,Olususer)

  select h.id,h.firmano,h.tarih,h.saat,h.vadetar,h.giren,h.cikan,h.kur,h.parabrm,
  'ÇEK-SENET','cekkart','cekid',h.cekid,h.masterid,h.varno,h.varok,h.sil,
  h.yerad,h.yertip,h.perkod,'',h.adaid,'',
  h.islmtip,h.islmtipad,h.islmhrk,h.islmhrkad,ceksenno,ack,
  h.refno,
  case when h.islmhrk='ALN' then h.carkod
  when islmhrk='KSN' then   h.vercarkod end,
  case when h.islmhrk='ALN' then h.cartip
  when islmhrk='KSN' then   h.vercartip end,
  ('') as kaskod,('') as kasad,
  ('') as bankod,(banka),
  h.olustarsaat,h.olususer

  from cekkart as h
  where
  h.sil in (select * from @SIL_TEMP)
  and h.yertip=@yertip and h.varno=@varno

 /*- banka hrk */
  insert into @TB_VARDIYA_FINANS (id,firmano,Tarih,Saat,VadeTar,
  Giren,Cikan,
  Kur,Parabrm,
  Grpad,Grptip,Hrkidad,Hrkid,Masterid,Varno,Varok,Sil,Yerad,Yertip,Perkod,
  Perad,Adaid,AdaAd,tipkod,tipad,hrkkod,hrkad,BelNo,Ack,Kod,
  CarKod,CarTip,Kasakod,KasaAd,Bankakod,
  BankaAd,Olustarsaat,Olususer)
  select h.id,firmano,h.tarih,h.saat,h.vadetar,
  case 
  when h.islmhrk='CKN' then h.alacak
  when h.islmhrk='YTN' then 0
   else h.borc end,
  case 
  when h.islmhrk='YTN' then h.borc 
  when h.islmhrk='CKN' then 0
  else h.alacak end,
  h.kur,h.parabrm,
  'BANKA İŞLEMLERİ','bankahrk',('bankhrkid'),h.bankhrkid,h.masterid,
  h.varno,h.varok,h.sil,h.yerad,h.yertip,
  h.perkod,'',h.adaid,'',
  h.islmtip,h.islmtipad,h.islmhrk,h.islmhrkad,
  h.belno,h.ack,
  h.bankod,h.carkod,h.cartip,h.kaskod,'',
  h.bankod,'',
  h.olustarsaat,h.olususer
  from bankahrk as h
  where h.masterid=0
  and h.sil in (select * from @SIL_TEMP)
  and h.yertip=@yertip and h.varno=@varno


 /*- cari hrk */
  insert into @TB_VARDIYA_FINANS (id,firmano,Tarih,Saat,VadeTar,Giren,Cikan,Kur,Parabrm,
  Grpad,Grptip,Hrkidad,Hrkid,Masterid,Varno,Varok,Sil,Yerad,Yertip,Perkod,
  Perad,Adaid,AdaAd,tipkod,tipad,hrkkod,hrkad,BelNo,Ack,Kod,
  CarKod,CarTip,Kasakod,KasaAd,Bankakod,
  BankaAd,Olustarsaat,Olususer)
  select h.id,firmano,h.tarih,h.saat,h.vadetar,h.borc,h.alacak,h.kur,h.parabrm,
  'CARİ İŞLEMLER','carihrk',('carhrkid'),h.carhrkid,h.masterid,
  h.varno,h.varok,h.sil,h.yerad,h.yertip,h.perkod,'',h.adaid,'',
  h.islmtip,h.islmtipad,h.islmhrk,h.islmhrkad,
  h.belno,h.ack,
  h.carkod,h.carkod,h.cartip,'','',
  '','',
  h.olustarsaat,h.olususer
  from carihrk as h
  where h.masterid=0 and h.islmtip='MAH'
  and h.sil in (select * from @SIL_TEMP)
  and h.yertip=@yertip and h.varno=@varno


/*isletme k.k hrk */
  insert into @TB_VARDIYA_FINANS (id,firmano,Tarih,Saat,VadeTar,Giren,Cikan,Kur,Parabrm,
  Grpad,Grptip,Hrkidad,Hrkid,Masterid,Varno,Varok,Sil,Yerad,Yertip,Perkod,
  Perad,Adaid,AdaAd,tipkod,tipad,hrkkod,hrkad,BelNo,Ack,Kod,
  CarKod,CarTip,Kasakod,KasaAd,Bankakod,
  BankaAd,Olustarsaat,Olususer)

  select h.id,h.firmano,h.tarih,h.saat,h.vadetar,h.borc,h.alacak,h.kur,h.parabrm,
  'İŞLETME KART İŞLEMLERİ','istkhrk',('istkhrkid'),h.istkhrkid,h.masterid,
  h.varno,h.varok,h.sil,h.yerad,h.yertip,h.perkod,'',h.adaid,'',
  h.islmtip,h.islmtipad,h.islmhrk,h.islmhrkad,
  h.belno,h.ack,h.istkkod,h.carkod,h.cartip,
  (''),('') ,(''),(''),
  h.olustarsaat,h.olususer
  from istkhrk as h
  where h.masterid=0
  and h.sil in (select * from @SIL_TEMP)
  and h.yertip=@yertip and h.varno=@varno

 /*cari unvan */
  update @TB_VARDIYA_FINANS set Cartur=dt.tip ,Unvan=dt.ad from @TB_VARDIYA_FINANS as t
  join (select kod,ad,cartp,tip from Genel_Kart ) dt
  on dt.kod=t.CarKod and dt.cartp=t.cartip

/* kasa ad */
  update @TB_VARDIYA_FINANS set Kasaad=dt.ad from @TB_VARDIYA_FINANS as t
  join (select kod,ad from Kasakart as k ) dt
  on dt.kod=t.kasakod

/* banka ad */
  update @TB_VARDIYA_FINANS set Bankaad=dt.ad from @TB_VARDIYA_FINANS as t
  join (select kod,ad from bankakart as k ) dt
  on dt.kod=t.Bankakod


 /* personel unvan */
  update @TB_VARDIYA_FINANS set perad=dt.ad from @TB_VARDIYA_FINANS as t
  join (select kod,(k.ad+' '+k.soyad) ad from Perkart as k ) dt
  on dt.kod=t.perkod


 /* ada ad */
  update @TB_VARDIYA_FINANS set Adaad=dt.ad from @TB_VARDIYA_FINANS as t
  join (select id,ad from grup as k where k.tabload='sayackart') dt
  on dt.id=t.adaid


  update @TB_VARDIYA_FINANS  set Ytlgiren=giren*kur,ytlcikan=cikan*kur



  RETURN




END

================================================================================
