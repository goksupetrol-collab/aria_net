-- Stored Procedure: dbo.SpOtomasyonSaatPivotRapor
-- Tarih: 2026-01-14 20:06:08.377994
================================================================================

CREATE PROCEDURE dbo.SpOtomasyonSaatPivotRapor 
@Firmano    int,
@BasTar     Datetime,
@BitTar     Datetime
AS
BEGIN
   

/*                         
  DECLARE @data Table
(
    id int identity(1,1)
    ,ReadyDate datetime
    ,foo varchar(500)
)
INSERT INTO @data
VALUES

('10-14-2019 06:05','(this will populate no columns)')
,('10-14-2019 07:12','(this will populate the 7:00 hour and 8:00 hour)')
,('10-14-2019 10:02','(this will populate the 10:00 hour, 11:00, 12:00)')
,('10-14-2019 12:50','(this will populate the 12:00, 13:00, 14:00)') 


;WITH Numbers AS
(
    SELECT 1 AS Number
    UNION ALL
    SELECT Number+1
        FROM Numbers 
        WHERE Number < 24
)
,src
as (
Select *, 
    flag = CASE WHEN Number >= DATEPART(hour, ReadyDate) AND Number < DATEPART(hour, ReadyDate)  THEN 1 ELSE 0 END 
from @Data
    CROSS APPLY Numbers
)
Select * 
from src
    PIVOT 
    (
      max(flag) for number in ([1],[2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18], [19], [20], [21], [22], [23], [24])
    ) as ptable                              
                                

*/ 

  CREATE Table #TempSaat (
   Firmano   int,
   Tarih     Datetime,
   Saat      int,
   Toplam      int
  )
  
  
  if @Firmano=0
   insert into #TempSaat (Firmano,Tarih,Saat,Toplam) 
   select Firmano, 
    CAST([Tarih] as date) AS Tarih,
    DATEPART(hour,[Saat]) AS Saat,
     COUNT(*) AS Toplam
    from [otomasoku]
    where [Tarih]>= @BasTar  /*'2019-07-01 00:00:00.000' */
     and [Tarih]< DATEADD(day,1,@BitTar)                    /*'2019-07-31 23:59:00.000' */
     GROUP BY Firmano,
        CAST([Tarih] as date),
         DATEPART(hour,[Saat])
         
         
  if @Firmano>0
   insert into #TempSaat (Firmano,Tarih,Saat,Toplam) 
   select Firmano, 
    CAST([Tarih] as date) AS Tarih,
    DATEPART(hour,[Saat]) AS Saat,
     COUNT(*) AS Toplam
    from [otomasoku]
    where firmano=@Firmano  
    and [Tarih]>= @BasTar  /*'2019-07-01 00:00:00.000' */
     and [Tarih]< DATEADD(day,1,@BitTar)                    /*'2019-07-31 23:59:00.000' */
     GROUP BY Firmano,
        CAST([Tarih] as date),
         DATEPART(hour,[Saat])       


 if @Firmano=0
 begin
   select Firmano,Tarih,
   isnull([0],0) [0],isnull([1],0) [1],isnull([2],0) [2],isnull([3],0) [3],
   isnull([4],0) [4],isnull([5],0) [5],isnull([6],0) [6],isnull([7],0) [7],
   isnull([8],0) [8],isnull([9],0) [9],isnull([10],0) [10],isnull([11],0) [11],
   isnull([12],0) [12],isnull([13],0) [13],isnull([14],0) [14],isnull([15],0) [15],
   isnull([16],0) [16],isnull([17],0) [17],isnull([18],0) [18],isnull([19],0) [19],
   isnull([20],0) [20],isnull([21],0) [21],isnull([22],0) [22],isnull([23],0) [23],
   
   (isnull([0],0)+isnull([1],0)+isnull([2],0)+isnull([3],0)+
   isnull([4],0)+isnull([5],0)+isnull([6],0)+isnull([7],0)+
   isnull([8],0)+isnull([9],0)+isnull([10],0)+isnull([11],0)+
   isnull([12],0)+isnull([13],0)+isnull([14],0)+isnull([15],0)+
   isnull([16],0)+isnull([17],0)+isnull([18],0)+isnull([19],0)+
   isnull([20],0)+isnull([21],0)+isnull([22],0)+isnull([23],0) ) Toplam
  from 
  (
    select Firmano,Tarih,Saat,Toplam
    from #TempSaat
   
   /* select Firmano, 
    CAST([Tarih] as date) AS Tarih,
    DATEPART(hour,[Saat]) AS Saat,
     COUNT(*) AS Toplam
    from [otomasoku]
    where [Tarih]>= @BasTar  --'2019-07-01 00:00:00.000'
     and [Tarih]< DATEADD(day,1,@BitTar)                    --'2019-07-31 23:59:00.000'
     GROUP BY Firmano,
        CAST([Tarih] as date),
         DATEPART(hour,[Saat])
         */

  ) src
  pivot
  (
    sum(Toplam) 
    for Saat in  ([0],[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23]) 
  ) piv 
  order by Firmano,Tarih
 
 end
 
 
 
 



END

================================================================================
