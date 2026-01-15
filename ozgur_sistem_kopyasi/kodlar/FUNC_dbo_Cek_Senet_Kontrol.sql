-- Function: dbo.Cek_Senet_Kontrol
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.647968
================================================================================

CREATE FUNCTION [dbo].Cek_Senet_Kontrol
(@cekno varchar(30),
@cekid int)
RETURNS
   @TB_CEK_KONT TABLE (
    gctip         VARCHAR(20)   COLLATE Turkish_CI_AS,
    tarih         datetime,
    islmtipad     VARCHAR(50)   COLLATE Turkish_CI_AS,
    ceksenno      VARCHAR(30)   COLLATE Turkish_CI_AS,
    cartip        VARCHAR(30)   COLLATE Turkish_CI_AS,
    unvan         VARCHAR(100)   COLLATE Turkish_CI_AS,
    olususer      VARCHAR(50)   COLLATE Turkish_CI_AS,
    tutar         float)
AS
BEGIN


 insert into @TB_CEK_KONT
 (gctip,tarih,islmtipad,ceksenno,cartip,unvan,tutar,olususer)
 select gctip,tarih,islmtipad,ceksenno,
 case when  gctip='G' then cartip else vercartip end,
 case when  gctip='G' then ck.ad else vck.ad end,
 case when  gctip='G' then giren else cikan end,
 olususer
 from cekkart as cek
 left join Genel_Kart as ck on ck.kod=carkod and ck.cartp=cek.cartip
 left join Genel_Kart as vck on vck.kod=vercarkod and vck.cartp=cek.vercartip
 where ceksenno=@cekno and cekid<>@cekid and cek.sil=0
  
  
  
 return

END

================================================================================
