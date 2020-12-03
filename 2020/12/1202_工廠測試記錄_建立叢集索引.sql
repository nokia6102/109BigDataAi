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
--DROP TABLE [telemetry_Data1]
DECLARE @dt1 DATETIME2='2015-1-2 07:00:00';
SELECT [_datetime],[machineID]
	,( ([volt]-(SELECT AVG([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [volt_3z]
	,( ([rotate]-(SELECT AVG([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [rotate_3z]
	,( ([pressure]-(SELECT AVG([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [pressure_3z]
	,( ([vibration]-(SELECT AVG([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-2,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [vibration_3z]	
	,( ([volt]-(SELECT AVG([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [volt_4z]
	,( ([rotate]-(SELECT AVG([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [rotate_4z]
	,( ([pressure]-(SELECT AVG([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [pressure_4z]
	,( ([vibration]-(SELECT AVG([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-3,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [vibration_4z]
	,( ([volt]-(SELECT AVG([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [volt_5z]
	,( ([rotate]-(SELECT AVG([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [rotate_5z]
	,( ([pressure]-(SELECT AVG([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [pressure_5z]
	,( ([vibration]-(SELECT AVG([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-4,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [vibration_5z]
	,( ([volt]-(SELECT AVG([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [volt_6z]
	,( ([rotate]-(SELECT AVG([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [rotate_6z]
	,( ([pressure]-(SELECT AVG([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [pressure_6z]
	,( ([vibration]-(SELECT AVG([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-5,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [vibration_6z]
	,( ([volt]-(SELECT AVG([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [volt_12z]
	,( ([rotate]-(SELECT AVG([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [rotate_12z]
	,( ([pressure]-(SELECT AVG([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [pressure_12z]
	,( ([vibration]-(SELECT AVG([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-11,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [vibration_12z]
	,( ([volt]-(SELECT AVG([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([volt]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [volt_24z]
	,( ([rotate]-(SELECT AVG([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([rotate]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [rotate_24z]
	,( ([pressure]-(SELECT AVG([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([pressure]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [pressure_24z]
	,( ([vibration]-(SELECT AVG([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID]))/(SELECT STDEV([vibration]) FROM [telemetry] WHERE [_datetime]>=DATEADD(HOUR,-23,tel._datetime) AND [_datetime]<=tel._datetime AND [machineID]=tel.[machineID])) AS [vibration_24z]
INTO [telemetry_Data1]
FROM [dbo].[telemetry] AS tel
WHERE tel._datetime>=@dt1
------
SELECT * FROM [dbo].[errors]
ALTER TABLE [dbo].[errors] ALTER COLUMN [machineID] INT;
SELECT DISTINCT [errorID] FROM [dbo].[errors]

WITH Temp
AS
(
	SELECT [_datetime],[machineID]
		,[error1] AS Error1Sum
		,[error2] AS Error2Sum
		,[error3] AS Error3Sum
		,[error4] AS Error4Sum
		,[error5] AS Error5Sum
	FROM dbo.errors
	PIVOT (COUNT([errorID]) FOR [errorID] IN([error1],[error2],[error3],[error4],[error5])) AS P
)
--SELECT * FROM Temp

SELECT t1.[_datetime],t1.[machineID]
	,ISNULL(t2.[Error1Sum],0) AS [Error1Sum]
	,ISNULL(t2.[Error2Sum],0) AS [Error2Sum]
	,ISNULL(t2.[Error3Sum],0) AS [Error3Sum]
	,ISNULL(t2.[Error4Sum],0) AS [Error4Sum]
	,ISNULL(t2.[Error5Sum],0) AS [Error5Sum]
--INTO PivotError
FROM [dbo].[telemetry] AS t1 LEFT JOIN Temp AS t2
	ON t1.[machineID]=t2.[machineID] AND t1.[_datetime]=t2.[_datetime]+

--CREATE CLUSTERED INDEX CI ON PivotError([machineID] ASC,[_datetime] ASC);


SELECT TOP(1000) *
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX([_datetime]) FROM [PivotError] WHERE [Error1Sum]=1 AND [machineID]=pe.[machineID] AND [_datetime]<pe.[_datetime])
		,pe.[_datetime]),0)/(24.0*365) AS SinceLastError1_Days
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX([_datetime]) FROM [PivotError] WHERE [Error2Sum]=1 AND [machineID]=pe.[machineID] AND [_datetime]<pe.[_datetime])
		,pe.[_datetime]),0)/(24.0*365) AS SinceLastError2_Days
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX([_datetime]) FROM [PivotError] WHERE [Error3Sum]=1 AND [machineID]=pe.[machineID] AND [_datetime]<pe.[_datetime])
		,pe.[_datetime]),0)/(24.0*365) AS SinceLastError3_Days
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX([_datetime]) FROM [PivotError] WHERE [Error4Sum]=1 AND [machineID]=pe.[machineID] AND [_datetime]<pe.[_datetime])
		,pe.[_datetime]),0)/(24.0*365) AS SinceLastError4_Days
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX([_datetime]) FROM [PivotError] WHERE [Error5Sum]=1 AND [machineID]=pe.[machineID] AND [_datetime]<pe.[_datetime])
		,pe.[_datetime]),0)/(24.0*365) AS SinceLastError5_Days
FROM [PivotError] AS pe;

SELECT *
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX([_datetime]) FROM [PivotError] WHERE [Error1Sum]=1 AND [machineID]=pe.[machineID] AND [_datetime]<pe.[_datetime])
		,pe.[_datetime]),0)/(24.0*365) AS SinceLastError1_Days
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX([_datetime]) FROM [PivotError] WHERE [Error2Sum]=1 AND [machineID]=pe.[machineID] AND [_datetime]<pe.[_datetime])
		,pe.[_datetime]),0)/(24.0*365) AS SinceLastError2_Days
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX([_datetime]) FROM [PivotError] WHERE [Error3Sum]=1 AND [machineID]=pe.[machineID] AND [_datetime]<pe.[_datetime])
		,pe.[_datetime]),0)/(24.0*365) AS SinceLastError3_Days
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX([_datetime]) FROM [PivotError] WHERE [Error4Sum]=1 AND [machineID]=pe.[machineID] AND [_datetime]<pe.[_datetime])
		,pe.[_datetime]),0)/(24.0*365) AS SinceLastError4_Days
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX([_datetime]) FROM [PivotError] WHERE [Error5Sum]=1 AND [machineID]=pe.[machineID] AND [_datetime]<pe.[_datetime])
		,pe.[_datetime]),0)/(24.0*365) AS SinceLastError5_Days
INTO [PivotError2]
FROM [PivotError] AS pe;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

WITH Temp
AS
(
	SELECT [_datetime],[machineID]
		,[comp1] AS Comp1
		,[comp2] AS Comp2
		,[comp3] AS Comp3
		,[comp4] AS Comp4
	FROM [dbo].[maint]
	PIVOT (COUNT([comp]) FOR [comp] IN([comp1],[comp2],[comp3],[comp4])) AS P
)

SELECT t1.[_datetime],t1.[machineID]
	,ISNULL(t2.[Comp1],0) AS [Comp1Sum]
	,ISNULL(t2.[Comp2],0) AS [Comp2Sum]
	,ISNULL(t2.[Comp3],0) AS [Comp3Sum]
	,ISNULL(t2.[Comp4],0) AS [Comp4Sum]	
INTO PivotComp
FROM [dbo].[telemetry] AS t1 LEFT JOIN Temp AS t2
	ON t1.[machineID]=t2.[machineID] AND t1.[_datetime]=t2.[_datetime]
GO

CREATE CLUSTERED INDEX CI ON [PivotComp]([machineID],[_datetime]);
GO

SELECT TOP(10000) * FROM PivotComp;

DROP TABLE PivotError
WITH Temp
AS
(
	SELECT [_datetime],[machineID]
		,[error1] AS Error1Sum
		,[error2] AS Error2Sum
		,[error3] AS Error3Sum
		,[error4] AS Error4Sum
		,[error5] AS Error5Sum
	FROM dbo.errors
	PIVOT (COUNT([errorID]) FOR [errorID] IN([error1],[error2],[error3],[error4],[error5])) AS P
)
--SELECT * FROM Temp

SELECT t1.[_datetime],t1.[machineID]
	,ISNULL(t2.[Error1Sum],0) AS [Error1Sum]
	,ISNULL(t2.[Error2Sum],0) AS [Error2Sum]
	,ISNULL(t2.[Error3Sum],0) AS [Error3Sum]
	,ISNULL(t2.[Error4Sum],0) AS [Error4Sum]
	,ISNULL(t2.[Error5Sum],0) AS [Error5Sum]
 INTO PivotError
FROM [dbo].[telemetry] AS t1 LEFT JOIN Temp AS t2
	ON t1.[machineID]=t2.[machineID] AND t1.[_datetime]=t2.[_datetime]
GO




SELECT TOP(10000) *
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX(pt.[_datetime]) FROM [PivotComp] AS pt WHERE pt.[Comp1Sum]=1 AND pt.[machineID]=pc.[machineID] AND pt.[_datetime]<pc.[_datetime])
		,pc.[_datetime]),0)/24.0 AS SinceLastComp1_Days
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX(pt.[_datetime]) FROM [PivotComp] AS pt WHERE pt.[Comp2Sum]=1 AND pt.[machineID]=pc.[machineID] AND pt.[_datetime]<pc.[_datetime])
		,pc.[_datetime]),0)/24.0 AS SinceLastComp2_Days
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX(pt.[_datetime]) FROM [PivotComp] AS pt WHERE pt.[Comp3Sum]=1 AND pt.[machineID]=pc.[machineID] AND pt.[_datetime]<pc.[_datetime])
		,pc.[_datetime]),0)/24.0 AS SinceLastComp3_Days
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX(pt.[_datetime]) FROM [PivotComp] AS pt WHERE pt.[Comp4Sum]=1 AND pt.[machineID]=pc.[machineID] AND pt.[_datetime]<pc.[_datetime])
		,pc.[_datetime]),0)/24.0 AS SinceLastComp4_Days
FROM [PivotComp] AS pc
ORDER BY [machineID],[_datetime]


SELECT *
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX(pt.[_datetime]) FROM [PivotComp] AS pt WHERE pt.[Comp1Sum]=1 AND pt.[machineID]=pc.[machineID] AND pt.[_datetime]<pc.[_datetime])
		,pc.[_datetime]),0)/24.0 AS SinceLastComp1_Days
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX(pt.[_datetime]) FROM [PivotComp] AS pt WHERE pt.[Comp2Sum]=1 AND pt.[machineID]=pc.[machineID] AND pt.[_datetime]<pc.[_datetime])
		,pc.[_datetime]),0)/24.0 AS SinceLastComp2_Days
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX(pt.[_datetime]) FROM [PivotComp] AS pt WHERE pt.[Comp3Sum]=1 AND pt.[machineID]=pc.[machineID] AND pt.[_datetime]<pc.[_datetime])
		,pc.[_datetime]),0)/24.0 AS SinceLastComp3_Days
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX(pt.[_datetime]) FROM [PivotComp] AS pt WHERE pt.[Comp4Sum]=1 AND pt.[machineID]=pc.[machineID] AND pt.[_datetime]<pc.[_datetime])
		,pc.[_datetime]),0)/24.0 AS SinceLastComp4_Days
INTO [PivotComp2]
FROM [PivotComp] AS pc;

DROP TABLE PivotComp2
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT *
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX([_datetime]) FROM [PivotError] WHERE [Error1Sum]=1 AND [machineID]=pe.[machineID] AND [_datetime]<pe.[_datetime])
		,pe.[_datetime]),0)/(24.0*365) AS SinceLastError1_Days
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX([_datetime]) FROM [PivotError] WHERE [Error2Sum]=1 AND [machineID]=pe.[machineID] AND [_datetime]<pe.[_datetime])
		,pe.[_datetime]),0)/(24.0*365) AS SinceLastError2_Days
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX([_datetime]) FROM [PivotError] WHERE [Error3Sum]=1 AND [machineID]=pe.[machineID] AND [_datetime]<pe.[_datetime])
		,pe.[_datetime]),0)/(24.0*365) AS SinceLastError3_Days
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX([_datetime]) FROM [PivotError] WHERE [Error4Sum]=1 AND [machineID]=pe.[machineID] AND [_datetime]<pe.[_datetime])
		,pe.[_datetime]),0)/(24.0*365) AS SinceLastError4_Days
	,ISNULL(DATEDIFF(HOUR
		,(SELECT MAX([_datetime]) FROM [PivotError] WHERE [Error5Sum]=1 AND [machineID]=pe.[machineID] AND [_datetime]<pe.[_datetime])
		,pe.[_datetime]),0)/(24.0*365) AS SinceLastError5_Days
INTO [PivotError2]
FROM [PivotError] AS pe
-- WHERE A.[machineID]<=20;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

