/****** SSMS 中 SelectTopNRows 命令的指令碼  ******/
 
SELECT TOP (10000) *FROM [ex].[dbo].[telemetry]

--https://docs.microsoft.com/zh-tw/sql/relational-databases/indexes/create-clustered-indexes?view=sql-server-ver15
--建立一叢集索引 先用 machneID正序升冪排序, 再用datime正序升冪排序
CREATE CLUSTERED INDEX CI ON [dbo].[telemetry] ([machineID] ASC, [datetime] ASC);
SELECT TOP (10000) * FROM [ex].[dbo].[telemetry]