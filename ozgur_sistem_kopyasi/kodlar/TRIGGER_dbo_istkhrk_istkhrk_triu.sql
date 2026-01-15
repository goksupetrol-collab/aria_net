-- Trigger: dbo.istkhrk_triu
-- Tablo: dbo.istkhrk
-- Disabled: False
-- Tarih: 2026-01-14 20:06:08.962775
================================================================================

CREATE TRIGGER [dbo].[istkhrk_triu] ON [dbo].[istkhrk]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN
declare @postut float,@varno float,@tut float
declare @varok int
declare @istkkod varchar(30)
declare @masterid float
declare @istkhrkid float
declare @belno varchar(20)
declare @sil     int


SET NOCOUNT ON


select @sil=sil,@istkhrkid=istkhrkid,@masterid=masterid,@istkkod=istkkod,
@varno=varno,@varok=varok,@belno=belno from inserted


 if isnull(@istkhrkid,0)=0
  return

  exec istkarthrkgiris @istkhrkid,@sil

  exec numara_no_yaz 'makbuz',@belno


SET NOCOUNT OFF
END

================================================================================
