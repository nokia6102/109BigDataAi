/****** SSMS 中 SelectTopNRows 命令的指令碼  ******/
 
SELECT TOP (10000) *
FROM [ex].[dbo].[telemetry]

--https://docs.microsoft.com/zh-tw/sql/relational-databases/indexes/create-clustered-indexes?view=sql-server-ver15
CREATE CLUSTERED INDEX CI ON [dbo].[telemetry] ([machineID] ASC, [datetime] ASC);
