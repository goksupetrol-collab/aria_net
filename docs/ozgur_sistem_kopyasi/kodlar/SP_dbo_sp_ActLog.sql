-- Stored Procedure: dbo.sp_ActLog
-- Tarih: 2026-01-14 20:06:08.365985
================================================================================

CREATE Procedure [dbo].[sp_ActLog]
( @Act int,
  @MID int,
  @FID int,
  @DID int,
  @Tablo varchar(50),
  @Id int,
  @Usr int,
  @Usr2 datetime
)

as

if @Act=1
begin
  Exec('Insert Into '+@Tablo+'_ (MID,FID,DID,Id,Crt,Crt2) values ('+@MID+','+@FID+','+@DID+','+@Id+','+@Usr+','+@Usr2+')')
end
if @Act=0
begin
  Exec('Update '+@Tablo+'_ Set Upd='+@Usr+',Upd2='+@Usr2+' Where MID='+@MID+' and FID='+@FID+' and DID='+@DID+' and Id='+@Id)
end
if @Act=-1
begin
  Exec('Update '+@Tablo+'_ Set Del='+@Usr+',Del2='+@Usr2+' Where MID='+@MID+' and FID='+@FID+' and DID='+@DID+' and Id='+@Id)
end
if @Act=-2
begin
  Exec('Delete from '+@Tablo+'_ Where MID='+@MID+' and FID='+@FID+' and DID='+@DID+' and Id='+@Id)
end

================================================================================
