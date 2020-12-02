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

EXEC sp_rename 'dbo.telemetry._datetime222', '_datetime','COLUMN';

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

--My Formated
WITH Temp
AS
(
	SELECT *
	FROM [dbo].[telemetry]
	WHERE [_datetime]>=@dt2 AND [_datetime]<=@dt1 AND [machineID]=1
)
SELECT [_datetime], 
       [machineid], 
       ( ( [volt] - (SELECT Avg([volt]) 
                     FROM   [telemetry] 
                     WHERE  [_datetime] >= Dateadd(hour, -2, @dt1) 
                            AND [_datetime] <= @dt1) ) / (SELECT Stdev([volt]) 
                                                          FROM   [telemetry] 
                                                          WHERE 
           [_datetime] >= Dateadd(hour, -2, @dt1) 
           AND [_datetime] <= @dt1) ) AS [volt_3z], 
       ( ( [rotate] - (SELECT Avg([rotate]) 
                       FROM   [telemetry] 
                       WHERE  [_datetime] >= Dateadd(hour, -2, @dt1) 
                              AND [_datetime] <= @dt1) ) / 
         (SELECT Stdev([rotate]) 
          FROM   [telemetry] 
          WHERE 
           [_datetime] >= Dateadd(hour, -2, @dt1) 
           AND [_datetime] <= @dt1) ) AS [rotate_3z], 
       ( ( [pressure] - (SELECT Avg([pressure]) 
                         FROM   [telemetry] 
                         WHERE  [_datetime] >= Dateadd(hour, -2, @dt1) 
                                AND [_datetime] <= @dt1) ) / 
         (SELECT Stdev([pressure]) 
          FROM   [telemetry] 
          WHERE 
           [_datetime] >= Dateadd(hour, -2, @dt1) 
           AND [_datetime] <= @dt1) ) AS [pressure_3z], 
       ( ( [vibration] - (SELECT Avg([vibration]) 
                          FROM   [telemetry] 
                          WHERE  [_datetime] >= Dateadd(hour, -2, @dt1) 
                                 AND [_datetime] <= @dt1) ) / (SELECT 
         Stdev([vibration]) 
                                                               FROM 
         [telemetry] 
                                                               WHERE 
           [_datetime] >= Dateadd(hour, -2, @dt1) 
           AND [_datetime] <= @dt1) ) AS [vibration_3z], 
       ( ( [volt] - (SELECT Avg([volt]) 
                     FROM   [telemetry] 
                     WHERE  [_datetime] >= Dateadd(hour, -3, @dt1) 
                            AND [_datetime] <= @dt1) ) / (SELECT Stdev([volt]) 
                                                          FROM   [telemetry] 
                                                          WHERE 
           [_datetime] >= Dateadd(hour, -3, @dt1) 
           AND [_datetime] <= @dt1) ) AS [volt_4z], 
       ( ( [rotate] - (SELECT Avg([rotate]) 
                       FROM   [telemetry] 
                       WHERE  [_datetime] >= Dateadd(hour, -3, @dt1) 
                              AND [_datetime] <= @dt1) ) / 
         (SELECT Stdev([rotate]) 
          FROM   [telemetry] 
          WHERE 
           [_datetime] >= Dateadd(hour, -3, @dt1) 
           AND [_datetime] <= @dt1) ) AS [rotate_4z], 
       ( ( [pressure] - (SELECT Avg([pressure]) 
                         FROM   [telemetry] 
                         WHERE  [_datetime] >= Dateadd(hour, -3, @dt1) 
                                AND [_datetime] <= @dt1) ) / 
         (SELECT Stdev([pressure]) 
          FROM   [telemetry] 
          WHERE 
           [_datetime] >= Dateadd(hour, -3, @dt1) 
           AND [_datetime] <= @dt1) ) AS [pressure_4z], 
       ( ( [vibration] - (SELECT Avg([vibration]) 
                          FROM   [telemetry] 
                          WHERE  [_datetime] >= Dateadd(hour, -3, @dt1) 
                                 AND [_datetime] <= @dt1) ) / (SELECT 
         Stdev([vibration]) 
                                                               FROM 
         [telemetry] 
                                                               WHERE 
           [_datetime] >= Dateadd(hour, -3, @dt1) 
           AND [_datetime] <= @dt1) ) AS [vibration_4z], 
       ( ( [volt] - (SELECT Avg([volt]) 
                     FROM   [telemetry] 
                     WHERE  [_datetime] >= Dateadd(hour, -4, @dt1) 
                            AND [_datetime] <= @dt1) ) / (SELECT Stdev([volt]) 
                                                          FROM   [telemetry] 
                                                          WHERE 
           [_datetime] >= Dateadd(hour, -4, @dt1) 
           AND [_datetime] <= @dt1) ) AS [volt_5z], 
       ( ( [rotate] - (SELECT Avg([rotate]) 
                       FROM   [telemetry] 
                       WHERE  [_datetime] >= Dateadd(hour, -4, @dt1) 
                              AND [_datetime] <= @dt1) ) / 
         (SELECT Stdev([rotate]) 
          FROM   [telemetry] 
          WHERE 
           [_datetime] >= Dateadd(hour, -4, @dt1) 
           AND [_datetime] <= @dt1) ) AS [rotate_5z], 
       ( ( [pressure] - (SELECT Avg([pressure]) 
                         FROM   [telemetry] 
                         WHERE  [_datetime] >= Dateadd(hour, -4, @dt1) 
                                AND [_datetime] <= @dt1) ) / 
         (SELECT Stdev([pressure]) 
          FROM   [telemetry] 
          WHERE 
           [_datetime] >= Dateadd(hour, -4, @dt1) 
           AND [_datetime] <= @dt1) ) AS [pressure_5z], 
       ( ( [vibration] - (SELECT Avg([vibration]) 
                          FROM   [telemetry] 
                          WHERE  [_datetime] >= Dateadd(hour, -4, @dt1) 
                                 AND [_datetime] <= @dt1) ) / (SELECT 
         Stdev([vibration]) 
                                                               FROM 
         [telemetry] 
                                                               WHERE 
           [_datetime] >= Dateadd(hour, -4, @dt1) 
           AND [_datetime] <= @dt1) ) AS [vibration_5z], 
       ( ( [volt] - (SELECT Avg([volt]) 
                     FROM   [telemetry] 
                     WHERE  [_datetime] >= Dateadd(hour, -5, @dt1) 
                            AND [_datetime] <= @dt1) ) / (SELECT Stdev([volt]) 
                                                          FROM   [telemetry] 
                                                          WHERE 
           [_datetime] >= Dateadd(hour, -5, @dt1) 
           AND [_datetime] <= @dt1) ) AS [volt_6z], 
       ( ( [rotate] - (SELECT Avg([rotate]) 
                       FROM   [telemetry] 
                       WHERE  [_datetime] >= Dateadd(hour, -5, @dt1) 
                              AND [_datetime] <= @dt1) ) / 
         (SELECT Stdev([rotate]) 
          FROM   [telemetry] 
          WHERE 
           [_datetime] >= Dateadd(hour, -5, @dt1) 
           AND [_datetime] <= @dt1) ) AS [rotate_6z], 
       ( ( [pressure] - (SELECT Avg([pressure]) 
                         FROM   [telemetry] 
                         WHERE  [_datetime] >= Dateadd(hour, -5, @dt1) 
                                AND [_datetime] <= @dt1) ) / 
         (SELECT Stdev([pressure]) 
          FROM   [telemetry] 
          WHERE 
           [_datetime] >= Dateadd(hour, -5, @dt1) 
           AND [_datetime] <= @dt1) ) AS [pressure_6z], 
       ( ( [vibration] - (SELECT Avg([vibration]) 
                          FROM   [telemetry] 
                          WHERE  [_datetime] >= Dateadd(hour, -5, @dt1) 
                                 AND [_datetime] <= @dt1) ) / (SELECT 
         Stdev([vibration]) 
                                                               FROM 
         [telemetry] 
                                                               WHERE 
           [_datetime] >= Dateadd(hour, -5, @dt1) 
           AND [_datetime] <= @dt1) ) AS [vibration_6z], 
       ( ( [volt] - (SELECT Avg([volt]) 
                     FROM   [telemetry] 
                     WHERE  [_datetime] >= Dateadd(hour, -11, @dt1) 
                            AND [_datetime] <= @dt1) ) / (SELECT Stdev([volt]) 
                                                          FROM   [telemetry] 
                                                          WHERE 
           [_datetime] >= Dateadd(hour, -11, @dt1) 
           AND [_datetime] <= @dt1) ) AS [volt_12z], 
       ( ( [rotate] - (SELECT Avg([rotate]) 
                       FROM   [telemetry] 
                       WHERE  [_datetime] >= Dateadd(hour, -11, @dt1) 
                              AND [_datetime] <= @dt1) ) / 
         (SELECT Stdev([rotate]) 
          FROM   [telemetry] 
          WHERE 
           [_datetime] >= Dateadd(hour, -11, @dt1) 
           AND [_datetime] <= @dt1) ) AS [rotate_12z], 
       ( ( [pressure] - (SELECT Avg([pressure]) 
                         FROM   [telemetry] 
                         WHERE  [_datetime] >= Dateadd(hour, -11, @dt1) 
                                AND [_datetime] <= @dt1) ) / 
         (SELECT Stdev([pressure]) 
          FROM   [telemetry] 
          WHERE 
           [_datetime] >= Dateadd(hour, -11, @dt1) 
           AND [_datetime] <= @dt1) ) AS [pressure_12z], 
       ( ( [vibration] - (SELECT Avg([vibration]) 
                          FROM   [telemetry] 
                          WHERE  [_datetime] >= Dateadd(hour, -11, @dt1) 
                                 AND [_datetime] <= @dt1) ) / (SELECT 
         Stdev([vibration]) 
                                                               FROM 
         [telemetry] 
                                                               WHERE 
           [_datetime] >= Dateadd(hour, -11, @dt1) 
           AND [_datetime] <= @dt1) ) AS [vibration_12z], 
       ( ( [volt] - (SELECT Avg([volt]) 
                     FROM   [telemetry] 
                     WHERE  [_datetime] >= Dateadd(hour, -23, @dt1) 
                            AND [_datetime] <= @dt1) ) / (SELECT Stdev([volt]) 
                                                          FROM   [telemetry] 
                                                          WHERE 
           [_datetime] >= Dateadd(hour, -23, @dt1) 
           AND [_datetime] <= @dt1) ) AS [volt_24z], 
       ( ( [rotate] - (SELECT Avg([rotate]) 
                       FROM   [telemetry] 
                       WHERE  [_datetime] >= Dateadd(hour, -23, @dt1) 
                              AND [_datetime] <= @dt1) ) / 
         (SELECT Stdev([rotate]) 
          FROM   [telemetry] 
          WHERE 
           [_datetime] >= Dateadd(hour, -23, @dt1) 
           AND [_datetime] <= @dt1) ) AS [rotate_24z], 
       ( ( [pressure] - (SELECT Avg([pressure]) 
                         FROM   [telemetry] 
                         WHERE  [_datetime] >= Dateadd(hour, -23, @dt1) 
                                AND [_datetime] <= @dt1) ) / 
         (SELECT Stdev([pressure]) 
          FROM   [telemetry] 
          WHERE 
           [_datetime] >= Dateadd(hour, -23, @dt1) 
           AND [_datetime] <= @dt1) ) AS [pressure_24z], 
       ( ( [vibration] - (SELECT Avg([vibration]) 
                          FROM   [telemetry] 
                          WHERE  [_datetime] >= Dateadd(hour, -23, @dt1) 
                                 AND [_datetime] <= @dt1) ) / (SELECT 
         Stdev([vibration]) 
                                                               FROM 
         [telemetry] 
                                                               WHERE 
           [_datetime] >= Dateadd(hour, -23, @dt1) 
           AND [_datetime] <= @dt1) ) AS [vibration_24z] 
FROM   temp 