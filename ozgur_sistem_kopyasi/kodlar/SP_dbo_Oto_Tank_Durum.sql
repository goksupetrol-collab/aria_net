-- Stored Procedure: dbo.Oto_Tank_Durum
-- Tarih: 2026-01-14 20:06:08.350557
================================================================================

CREATE PROCEDURE [dbo].Oto_Tank_Durum
AS
BEGIN
  DECLARE @TB_TANK_ON_DURUM TABLE (
  TK_ID        int,
  TK_KOD       VARCHAR(20) COLLATE Turkish_CI_AS,
  TK_AD        VARCHAR(40) COLLATE Turkish_CI_AS,
  TK_KAPASITE  FLOAT,
  TK_MEVCUT    FLOAT)
  
  declare @son_tarsaat datetime

  SELECT top 1 @son_tarsaat=max(tarih+cast(saat as datetime))
  FROM otomasoku

  if @son_tarsaat is NULL
  set @son_tarsaat=cast(YEAR(getdate()) as varchar)+'-01-01'

  /* insert into @TB_TANK_ON_DURUM (TK_KOD) */
  /* select kod from otomaspumptan where tip=1 --tank */

   insert into @TB_TANK_ON_DURUM (TK_ID,TK_KOD,TK_AD,TK_KAPASITE,TK_MEVCUT)
   select tk.id,tk.kod,tk.ad,kapsit,isnull(sum(h.giren-h.cikan),0) mevcut
   from tankkart as tk
   inner join otomaspumptan as tksec on tksec.tip=1 and tk.kod=tksec.kod
   left join stkhrk as h on h.sil=0 and h.depkod=tk.kod
   and h.tarih+cast(h.saat as datetime)<=@son_tarsaat
   where tk.sil=0
   group by tk.id,tk.kod,tk.ad,kapsit


  /* select @son_tarsaat */

  /*- ven son vardiyadan sonraki akaryakıt stok girişleri nerde? */
  update @TB_TANK_ON_DURUM
  set TK_MEVCUT=(TK_MEVCUT-dt.mevcut)
  from @TB_TANK_ON_DURUM as t
  join (select tank_kod,sum(litre) as mevcut from otomaspumphrk as h where
  h.tarih+cast(h.saat as datetime)>@son_tarsaat
  group by tank_kod ) dt
  on t.TK_KOD=dt.tank_kod


  select * from @TB_TANK_ON_DURUM
  
  
END

================================================================================
