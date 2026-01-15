-- Stored Procedure: dbo.kartac
-- Tarih: 2026-01-14 20:06:08.340623
================================================================================

CREATE PROCEDURE [dbo].kartac @cartip varchar(20),@kod varchar(30),@ad varchar(100),
@parabrm varchar(10),@gizli int
AS
BEGIN
  declare @grp1 int

if @cartip='gelgidkart'
 begin

    select @grp1=grp_giderid from sistemtanim 
    insert into gelgidkart (grp1,grp2,grp3,kod,ad,muhkod,fiyat,actutar,toplim,kdv,kdvtip,
    brim,parabrm,drm,olususer,olustarsaat,gizli)
    values (@grp1,0,0,@kod,@ad,'',0,0,0,0,'Dahil','AD',@parabrm,
    'Aktif','SİSTEM',getdate(),@gizli)
  
 end

  
END

================================================================================
