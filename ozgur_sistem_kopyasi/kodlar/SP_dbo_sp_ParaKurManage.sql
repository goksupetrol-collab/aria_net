-- Stored Procedure: dbo.sp_ParaKurManage
-- Tarih: 2026-01-14 20:06:08.367278
================================================================================

CREATE PROCEDURE [dbo].sp_ParaKurManage(@Act int,@Id int,@ParaBirim_Id int,@tarih datetime,
@userid int,@UserTarih datetime,
@Alis float,@Satis float,@OzelAlis float,@OzelSatis float,
@Return nvarchar(20) output)
AS
BEGIN

declare @MID int,@FID int,@DID int;
/*
select @MID=mid,@FID=Fid,@DID=Did from users where id=@userid;

declare @Count int,@Son_Id int

if @Act = 1
 begin
  Select @Son_Id=isnull(Max(Id),0)+1 from Kurgrs where MID=@MID and FID=@FID and DID=@DID
  begin transaction
  insert into Kurgrs
    (MID,FID,DID,ParaBirim_Id,Id,Tarih,Alis,Satis,OzelAlis,OzelSatis)
  values
    (@MID,@FID,@DID,@ParaBirim_Id,@Id,@Tarih,@Alis,@Satis,@OzelAlis,@OzelSatis)

  Exec sp_ActLog @Act,@MID,@FID,@DID,'Kurgrs',@Son_Id,@userid,@UserTarih

  if @@error<>0
  begin
    rollback
    select @return = 'f_Kaydedilemedi'
  end
  else
  begin
    commit
    select @return = 's_Ok'
  end

  return
end

if @Act = 0
begin
  select @Count = count(*) from ParaKur where MID=@MID and FID=@FID and DID=@DID and Id = @Id
  if @Count = 0
  begin
    select @return = 'f_KayitYok'
    return
  end

  begin transaction

  Update ParaKur
  Set Alis=@Alis,Satis=@Satis,OzelAlis=@OzelAlis,OzelSatis=@OzelSatis
  where MID=@MID and FID=@FID and DID=@DID and Id = @Id

  Exec sp_ActLog @Act,@MID,@FID,@DID,'Kurgrs',@Id,@userid,@UserTarih

  if @@error<>0
  begin
    rollback
    select @return = 'f_Güncellenemedi'
  end
  else
  begin
    commit
    select @return = 's_Ok'
  end

  return
end

if @Act = -1
begin
  select @Count = count(*) from ParaKur where MID=@MID and FID=@FID and DID=@DID and Id = @Id
  if @Count = 0
  begin
    select @return = 'f_KayitYok'
    return
  end

  begin transaction

    Update ParaKur
    Set Del=1
     where MID=@MID and FID=@FID and DID=@DID and Id = @Id

    Exec sp_ActLog @Act,@MID,@FID,@DID,'Kurgrs',@Id,@userid,@UserTarih
	
  if @@error<>0
  begin
    rollback
    select @return = 'f_Silinemedi'
  end
  else
  begin
    commit
    select @return = 's_Ok'
  end

  return
end

if @Act = -2 --normal delete
begin
  select @Count = count(*) from ParaKur where MID=@MID and FID=@FID and DID=@DID and Id = @Id
  if @Count = 0
  begin
    select @return = 'f_KayitYok'
    return
  end

  begin transaction

    Delete from ParaKur
    where MID=@MID and FID=@FID and DID=@DID and Id = @Id

    Exec sp_ActLog @Act,@MID,@FID,@DID,'Kurgrs',@Id,@userid,@UserTarih
	
  if @@error<>0
  begin
    rollback
    select @return = 'f_Silinemedi'
  end
  else
  begin
    commit
    select @return = 's_Ok'
  end

  return
end

select @return = 'f_BilinmeyenIslem'
return
*/
END

================================================================================
