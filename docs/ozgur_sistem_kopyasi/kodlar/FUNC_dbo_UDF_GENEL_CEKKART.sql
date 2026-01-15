-- Function: dbo.UDF_GENEL_CEKKART
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.719873
================================================================================

CREATE FUNCTION [dbo].UDF_GENEL_CEKKART (
@FIRMANO   INT,
@TARIH1 DATETIME,
@TARIH2 DATETIME)
RETURNS
  @TB_GENEL_CEKKART TABLE (
    DRM_AD            VARCHAR(30)  COLLATE Turkish_CI_AS,
    CARI_KOD          VARCHAR(20)  COLLATE Turkish_CI_AS,
    CARI_AD           VARCHAR(150)  COLLATE Turkish_CI_AS,
    BANKA             VARCHAR(150)  COLLATE Turkish_CI_AS,
    ISLEMTAR          DATETIME,
    VADETAR           DATETIME,
    TUTAR             FLOAT)
AS
BEGIN

  IF @FIRMANO>0
  INSERT @TB_GENEL_CEKKART (DRM_AD,CARI_KOD,CARI_AD,
  BANKA,ISLEMTAR,VADETAR,TUTAR)
  select
  k.islmhrkad,vc.kod,vc.ad,
  k.banka,k.tarih,k.vadetar,
  isnull(sum(k.giren),0)
  FROM cekkart as k with (nolock)
  inner join Genel_Kart as vc with (nolock) on k.carkod=vc.kod and
  k.cartip=vc.cartp and k.firmano=@FIRMANO
  and k.tarih>=@TARIH1 and k.tarih<=@TARIH2 and k.sil=0
  and k.islmhrk='ALN'
  group by k.islmhrkad,vc.kod,vc.ad,k.banka,k.tarih,k.vadetar,k.id
  else
  INSERT @TB_GENEL_CEKKART (DRM_AD,CARI_KOD,CARI_AD,
  BANKA,ISLEMTAR,VADETAR,TUTAR)
  select
  k.islmhrkad,vc.kod,vc.ad,
  k.banka,k.tarih,k.vadetar,
  isnull(sum(k.giren),0)
  FROM cekkart as k with (nolock)
  inner join Genel_Kart as vc with (nolock) on k.carkod=vc.kod and
  k.cartip=vc.cartp
  and k.tarih>=@TARIH1 and k.tarih<=@TARIH2 and k.sil=0
  and k.islmhrk='ALN'
  group by k.islmhrkad,vc.kod,vc.ad,k.banka,k.tarih,k.vadetar,k.id 

  IF @FIRMANO>0
  INSERT @TB_GENEL_CEKKART (DRM_AD,CARI_KOD,CARI_AD,
  BANKA,ISLEMTAR,VADETAR,TUTAR)
  select
  k.islmhrkad,vc.kod,vc.ad,
  k.banka,k.tarih,k.vadetar,
  isnull(sum(k.cikan),0)
  FROM cekkart as k with (nolock)
  inner join Genel_Kart as vc with (nolock) on k.vercarkod=vc.kod and
  k.vercartip=vc.cartp and k.firmano=@FIRMANO
  and k.tarih>=@TARIH1 and k.tarih<=@TARIH2 and k.sil=0
  and k.islmhrk='KSN'
  group by k.islmhrkad,vc.kod,vc.ad,k.banka,k.tarih,k.vadetar,k.id
  else
  INSERT @TB_GENEL_CEKKART (DRM_AD,CARI_KOD,CARI_AD,
  BANKA,ISLEMTAR,VADETAR,TUTAR)
  select
  k.islmhrkad,vc.kod,vc.ad,
  k.banka,k.tarih,k.vadetar,
  isnull(sum(k.cikan),0)
  FROM cekkart as k with (nolock)
  inner join Genel_Kart as vc with (nolock) on k.vercarkod=vc.kod and
  k.vercartip=vc.cartp
  and k.tarih>=@TARIH1 and k.tarih<=@TARIH2 and k.sil=0
  and k.islmhrk='KSN'
  group by k.islmhrkad,vc.kod,vc.ad,k.banka,k.tarih,k.vadetar,k.id
  

 IF @FIRMANO>0
  INSERT @TB_GENEL_CEKKART (DRM_AD,CARI_KOD,CARI_AD,
  BANKA,ISLEMTAR,VADETAR,TUTAR)
  select
  k.drmad,vc.kod,vc.ad,
  k.banka,k.tarih,k.vadetar,
  isnull(sum(k.cikan),0)
  FROM cekkart as k with (nolock)
  inner join Genel_Kart as vc with (nolock) on k.vercarkod=vc.kod and
  k.vercartip=vc.cartp and k.firmano=@FIRMANO
  and k.tarih>=@TARIH1 and k.tarih<=@TARIH2 and k.sil=0
  and k.drm in ('ODE')
  group by k.drmad,vc.kod,vc.ad,k.banka,k.tarih,k.vadetar,k.id
  else
  INSERT @TB_GENEL_CEKKART (DRM_AD,CARI_KOD,CARI_AD,
  BANKA,ISLEMTAR,VADETAR,TUTAR)
  select
  k.drmad,vc.kod,vc.ad,
  k.banka,k.tarih,k.vadetar,
  isnull(sum(k.cikan),0)
  FROM cekkart as k with (nolock)
  inner join Genel_Kart as vc with (nolock) on k.vercarkod=vc.kod and
  k.vercartip=vc.cartp
  and k.tarih>=@TARIH1 and k.tarih<=@TARIH2 and k.sil=0
  and k.drm in ('ODE')
  group by k.drmad,vc.kod,vc.ad,k.banka,k.tarih,k.vadetar,k.id

  
 RETURN

end

================================================================================
