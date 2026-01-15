-- Function: dbo.Epdk_Fatura_Liste
-- Tip: SQL_TABLE_VALUED_FUNCTION
-- Tarih: 2026-01-14 20:06:08.653336
================================================================================

CREATE FUNCTION dbo.Epdk_Fatura_Liste 
(@fattip varchar(100),
@bastar  datetime,
@bittar  datetime)
RETURNS
   
   @TABLE_EPDK_FATURA TABLE (
   id					    int,   
   fattip					VARCHAR(20) COLLATE Turkish_CI_AS,
   CariKod					VARCHAR(50) COLLATE Turkish_CI_AS,
   LisansNo					VARCHAR(50) COLLATE Turkish_CI_AS,
   Tarih					datetime,
   Fat_Seri					VARCHAR(50) COLLATE Turkish_CI_AS,
   Fat_No					VARCHAR(50) COLLATE Turkish_CI_AS,
   Fat_SeriNo				VARCHAR(50) COLLATE Turkish_CI_AS,
   Stok_Kod					VARCHAR(50) COLLATE Turkish_CI_AS,
   Epdk_Yakit_Tur			int,
   Litre					Float)
   
AS
BEGIN
  

    insert into @TABLE_EPDK_FATURA 
    (id,fattip,CariKod,LisansNo,Tarih,
    Fat_Seri,Fat_No,Fat_SeriNo,Stok_Kod,Epdk_Yakit_Tur,Litre)
    Select M.id,M.fattip,M.carkod,'',m.tarih,
    m.fatseri,m.fatno,
    cast(m.fatseri as varchar(20))+cast(m.fatno as varchar(20)),
    h.stkod,s.Epdk_Tur,(h.mik*h.carpan)
      
    from faturamas as m WITH (NOLOCK)
    inner join faturahrk as h WITH (NOLOCK) 
    on h.fatid=m.fatid
    and h.sil=0 and m.sil=0 and m.fattip in (select * from CsvToSTR(@fattip))
    and m.tarih>=@bastar and m.tarih<=@bittar
    inner join Stokkart as s on S.kod=h.stkod
    and s.tip='akykt' and s.sil=0 and S.Epdk_Tur>0 
    Where m.cartip='carikart' 
    and ISNULL(m.entegre_tip,'')<>'EPDK' and h.stktip='akykt'
    and M.carkod in 
    (select kod from carikart as k where k.sil=0 and k.Epdk_LisansNo<>'')
    
    
    update @TABLE_EPDK_FATURA set LisansNo=dt.Epdk_LisansNo from @TABLE_EPDK_FATURA as t
    join (select Kod,Epdk_LisansNo from carikart as c where c.sil=0 ) dt 
    on dt.Kod=t.CariKod

    


  return





END

================================================================================
