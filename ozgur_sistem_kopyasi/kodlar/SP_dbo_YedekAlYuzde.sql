-- Stored Procedure: dbo.YedekAlYuzde
-- Tarih: 2026-01-14 20:06:08.390516
================================================================================

CREATE PROCEDURE dbo.YedekAlYuzde
@DbAd  varchar(150)
AS
BEGIN
  

  SELECT A.NAME,B.TOTAL_ELAPSED_TIME/60000 AS [Running Time],
  B.ESTIMATED_COMPLETION_TIME/60000 AS [Remaining],
  B.PERCENT_COMPLETE as [%],(SELECT TEXT FROM sys.dm_exec_sql_text(B.SQL_HANDLE))AS COMMAND FROM
  MASTER..SYSDATABASES A, sys.dm_exec_requests B
  WHERE A.DBID=B.DATABASE_ID and A.NAME=@DbAd
  AND B.COMMAND LIKE '%BACKUP%'
  order by percent_complete desc,B.TOTAL_ELAPSED_TIME/60000 desc
  

END

================================================================================
