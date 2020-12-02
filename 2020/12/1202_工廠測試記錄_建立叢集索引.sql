/****** SSMS 中 SelectTopNRows 命令的指令碼  ******/
 
SELECT TOP (10000) *FROM [ex].[dbo].[telemetry]

--https://docs.microsoft.com/zh-tw/sql/relational-databases/indexes/create-clustered-indexes?view=sql-server-ver15
--建立一叢集索引 先用 machneID正序升冪排序, 再用datime正序升冪排序
CREATE CLUSTERED INDEX CI ON [dbo].[telemetry] ([machineID] ASC, [datetime] ASC);
/*
DROP TABLE #TT

SELECT TOP (10000) *, DATEPART(HOUR, datetime) AS H, ROW_NUMBER() OVER(ORDER BY datetime ASC)  AS[RowId]
INTO #TT
FROM [ex].[dbo].[telemetry] 
WHERE ([datetime] >= '20150101 00:00:00' AND [datetime] <= '20150101 23:59:29') AND machineID=1
 
SELECT * FROM #TT
*/

--2015-1-4 1 20:00
--EXEC dbo.sp_rename @objname=N'[dbo].[telemetry].[_datetime]', @newname=N'_datetime222', @objtype=N'COLUMN'
EXEC sp_rename 'dbo.telemetry._datetime', '_datetime','COLUMN';

CREATE FUNCTION
---Teacher
DECLARE @dt1 DATETIME2='2015-1-4 20:00:00';
DECLARE @dt2 DATETIME2= DATEADD(HOUR,-23,@dt1);

WITH Temp
AS
(
	SELECT *
	FROM [dbo].[telemetry]
	WHERE [_datetime]>=@dt2 AND [_datetime]<=@dt1 AND [machineID]=1
)
--SELECT * FROM Temp;

SELECT [_datetime],[machineID]
	,( ([volt]-(SELECT AVG([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,@dt1) AND [_datetime]<=@dt1) ) AS [volt_3z]
	,( ([rotate]-(SELECT AVG([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,@dt1) AND [_datetime]<=@dt1) ) AS [rotate_3z]
	,( ([pressure]-(SELECT AVG([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,@dt1) AND [_datetime]<=@dt1) ) AS [pressure_3z]
	,( ([vibration]-(SELECT AVG([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,@dt1) AND [_datetime]<=@dt1) ) AS [vibration_3z]

	,( ([volt]-(SELECT AVG([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,@dt1) AND [_datetime]<=@dt1) ) AS [volt_4z]
	,( ([rotate]-(SELECT AVG([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,@dt1) AND [_datetime]<=@dt1) ) AS [rotate_4z]
	,( ([pressure]-(SELECT AVG([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,@dt1) AND [_datetime]<=@dt1) ) AS [pressure_4z]
	,( ([vibration]-(SELECT AVG([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,@dt1) AND [_datetime]<=@dt1) ) AS [vibration_4z]

	,( ([volt]-(SELECT AVG([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,@dt1) AND [_datetime]<=@dt1) ) AS [volt_5z]
	,( ([rotate]-(SELECT AVG([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,@dt1) AND [_datetime]<=@dt1) ) AS [rotate_5z]
	,( ([pressure]-(SELECT AVG([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,@dt1) AND [_datetime]<=@dt1) ) AS [pressure_5z]
	,( ([vibration]-(SELECT AVG([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,@dt1) AND [_datetime]<=@dt1) ) AS [vibration_5z]

	,( ([volt]-(SELECT AVG([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,@dt1) AND [_datetime]<=@dt1) ) AS [volt_6z]
	,( ([rotate]-(SELECT AVG([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,@dt1) AND [_datetime]<=@dt1) ) AS [rotate_6z]
	,( ([pressure]-(SELECT AVG([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,@dt1) AND [_datetime]<=@dt1) ) AS [pressure_6z]
	,( ([vibration]-(SELECT AVG([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,@dt1) AND [_datetime]<=@dt1) ) AS [vibration_6z]

	,( ([volt]-(SELECT AVG([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,@dt1) AND [_datetime]<=@dt1) ) AS [volt_12z]
	,( ([rotate]-(SELECT AVG([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,@dt1) AND [_datetime]<=@dt1) ) AS [rotate_12z]
	,( ([pressure]-(SELECT AVG([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,@dt1) AND [_datetime]<=@dt1) ) AS [pressure_12z]
	,( ([vibration]-(SELECT AVG([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,@dt1) AND [_datetime]<=@dt1) ) AS [vibration_12z]

	,( ([volt]-(SELECT AVG([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,@dt1) AND [_datetime]<=@dt1) ) AS [volt_24z]
	,( ([rotate]-(SELECT AVG([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,@dt1) AND [_datetime]<=@dt1) ) AS [rotate_24z]
	,( ([pressure]-(SELECT AVG([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,@dt1) AND [_datetime]<=@dt1) ) AS [pressure_24z]
	,( ([vibration]-(SELECT AVG([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,@dt1) AND [_datetime]<=@dt1) ) AS [vibration_24z]
FROM Temp

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--DROP FUNCTION dbo.GetScoreLast24;

CREATE FUNCTION GetScoreLast24(@machineId INT,@dt1 DATETIME2)
RETURNS @tt TABLE 
(
	[_datetime] DATETIME,[machineID] INT
	,[volt_3z] FLOAT,[rotate_3z] FLOAT,[pressure_3z] FLOAT,[vibration_3z] FLOAT
	,[volt_4z] FLOAT,[rotate_4z] FLOAT,[pressure_4z] FLOAT,[vibration_4z] FLOAT
	,[volt_5z] FLOAT,[rotate_5z] FLOAT,[pressure_5z] FLOAT,[vibration_5z] FLOAT
	,[volt_6z] FLOAT,[rotate_6z] FLOAT,[pressure_6z] FLOAT,[vibration_6z] FLOAT
	,[volt_12z] FLOAT,[rotate_12z] FLOAT,[pressure_12z] FLOAT,[vibration_12z] FLOAT
	,[volt_24z] FLOAT,[rotate_24z] FLOAT,[pressure_24z] FLOAT,[vibration_24z] FLOAT
)
AS
  BEGIN	
	DECLARE @dt2 DATETIME2= DATEADD(HOUR,-23,@dt1);
	WITH Temp
	AS
	(
		SELECT *
		FROM [dbo].[telemetry]
		WHERE [_datetime]>=@dt2 AND [_datetime]<=@dt1 AND [machineID]=1
	)
	,Temp2
	AS
	(
		SELECT [_datetime],[machineID]
			,( ([volt]-(SELECT AVG([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,@dt1) AND [_datetime]<=@dt1) ) AS [volt_3z]
			,( ([rotate]-(SELECT AVG([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,@dt1) AND [_datetime]<=@dt1) ) AS [rotate_3z]
			,( ([pressure]-(SELECT AVG([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,@dt1) AND [_datetime]<=@dt1) ) AS [pressure_3z]
			,( ([vibration]-(SELECT AVG([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,@dt1) AND [_datetime]<=@dt1) ) AS [vibration_3z]
			,( ([volt]-(SELECT AVG([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,@dt1) AND [_datetime]<=@dt1) ) AS [volt_4z]
			,( ([rotate]-(SELECT AVG([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,@dt1) AND [_datetime]<=@dt1) ) AS [rotate_4z]
			,( ([pressure]-(SELECT AVG([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,@dt1) AND [_datetime]<=@dt1) ) AS [pressure_4z]
			,( ([vibration]-(SELECT AVG([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,@dt1) AND [_datetime]<=@dt1) ) AS [vibration_4z]
			,( ([volt]-(SELECT AVG([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,@dt1) AND [_datetime]<=@dt1) ) AS [volt_5z]
			,( ([rotate]-(SELECT AVG([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,@dt1) AND [_datetime]<=@dt1) ) AS [rotate_5z]
			,( ([pressure]-(SELECT AVG([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,@dt1) AND [_datetime]<=@dt1) ) AS [pressure_5z]
			,( ([vibration]-(SELECT AVG([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,@dt1) AND [_datetime]<=@dt1) ) AS [vibration_5z]
			,( ([volt]-(SELECT AVG([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,@dt1) AND [_datetime]<=@dt1) ) AS [volt_6z]
			,( ([rotate]-(SELECT AVG([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,@dt1) AND [_datetime]<=@dt1) ) AS [rotate_6z]
			,( ([pressure]-(SELECT AVG([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,@dt1) AND [_datetime]<=@dt1) ) AS [pressure_6z]
			,( ([vibration]-(SELECT AVG([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,@dt1) AND [_datetime]<=@dt1) ) AS [vibration_6z]
			,( ([volt]-(SELECT AVG([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,@dt1) AND [_datetime]<=@dt1) ) AS [volt_12z]
			,( ([rotate]-(SELECT AVG([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,@dt1) AND [_datetime]<=@dt1) ) AS [rotate_12z]
			,( ([pressure]-(SELECT AVG([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,@dt1) AND [_datetime]<=@dt1) ) AS [pressure_12z]
			,( ([vibration]-(SELECT AVG([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,@dt1) AND [_datetime]<=@dt1) ) AS [vibration_12z]
			,( ([volt]-(SELECT AVG([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,@dt1) AND [_datetime]<=@dt1) ) AS [volt_24z]
			,( ([rotate]-(SELECT AVG([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,@dt1) AND [_datetime]<=@dt1) ) AS [rotate_24z]
			,( ([pressure]-(SELECT AVG([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,@dt1) AND [_datetime]<=@dt1) ) AS [pressure_24z]
			,( ([vibration]-(SELECT AVG([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,@dt1) AND [_datetime]<=@dt1))/(SELECT STDEV([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,@dt1) AND [_datetime]<=@dt1) ) AS [vibration_24z]
		FROM Temp		
	)
	INSERT INTO @tt
		SELECT * FROM Temp2 WHERE [_datetime]=@dt1;

	RETURN;
  END
GO
	
SELECT * FROM dbo.GetScoreLast24(1,'2015-2-5 13:00:00');
SELECT * FROM dbo.GetScoreLast24(10,'2015-5-10 17:00:00');

SELECT B.*
FROM [telemetry] AS A CROSS APPLY dbo.GetScoreLast24(A.machineID,A._datetime) AS B
WHERE A._datetime>='2015-1-15 13:00:00' AND A._datetime<='2015-1-15 15:00:00' AND A.machineID=1;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* 不用了
CREATE TABLE [telemetry_Data1]
(
	[_datetime] DATETIME,[machineID] INT
	,[volt_3z] FLOAT,[rotate_3z] FLOAT,[pressure_3z] FLOAT,[vibration_3z] FLOAT
	,[volt_4z] FLOAT,[rotate_4z] FLOAT,[pressure_4z] FLOAT,[vibration_4z] FLOAT
	,[volt_5z] FLOAT,[rotate_5z] FLOAT,[pressure_5z] FLOAT,[vibration_5z] FLOAT
	,[volt_6z] FLOAT,[rotate_6z] FLOAT,[pressure_6z] FLOAT,[vibration_6z] FLOAT
	,[volt_12z] FLOAT,[rotate_12z] FLOAT,[pressure_12z] FLOAT,[vibration_12z] FLOAT
	,[volt_24z] FLOAT,[rotate_24z] FLOAT,[pressure_24z] FLOAT,[vibration_24z] FLOAT
);
GO
CREATE CLUSTERED INDEX CI ON [telemetry_Data1]([machineID] ASC,[_datetime] ASC);
GO


DECLARE @machineId INT=1;
DECLARE @dt1 DATETIME2='2015-1-2 07:00:00'
WHILE @machineId<=1000
  BEGIN
	INSERT INTO [telemetry_Data1]
		SELECT B.*
		FROM [telemetry] AS A CROSS APPLY dbo.GetScoreLast24(A.machineID,A._datetime) AS B
		WHERE A.machineID=@machineId AND A._datetime>=@dt1;
	SET @machineId=@machineId+1;
  END
GO
*/
-----------------