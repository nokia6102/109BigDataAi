  
DECLARE @sql NVARCHAR(1024)=N'SELECT 員工編號 AS [Eid],姓名 AS [Name]
	,稱呼 AS [Gender],薪資 AS [Salary] FROM 員工';

EXEC sp_execute_external_script
	@language =N'R'
	,@script=N'
		sqlData <- data.frame(InputDataSet);		

		mainDir <- "C:\\PP"    
		dest_filename = tempfile(pattern = "EmployeeSalary_", tmpdir = mainDir);
		dest_filename = paste(dest_filename, ''.jpg'',sep="");
		print(dest_filename, quote=FALSE);
		jpeg(filename=dest_filename, width=800, height=600);

		rxHistogram(~ Salary, data = sqlData,fillColor="yellow",lineColor="red",xNumTicks=5,ylab="PersonNum");		
		dev.off()
		'
	,@input_data_1=@sql;	
GO

------------------------------

DECLARE @sqlQuery NVARCHAR(1024)=N'SELECT DATEPART(MONTH,[訂單日期]) AS [Month]
		,CONVERT(INT,ROUND(SUM(單價*數量),0)) AS [Income]		
		FROM 訂貨主檔 AS A JOIN 訂貨明細 AS B ON A.訂單號碼=B.訂單號碼
		WHERE A.訂單日期 >= ''2003-1-1'' AND A.訂單日期 < ''2004-1-1''
		GROUP BY DATEPART(MONTH,[訂單日期])
		ORDER BY [Month]';

EXEC sp_execute_external_script
	@language =N'Python'
	,@script=N'
import pandas as pd
import matplotlib.pyplot as plt

sqlData = pd.DataFrame(in_data);

plt.bar(sqlData["Month"],sqlData["Income"],color="blue",label="Income")
plt.savefig("D:\\PP\\Graph1.png")'
	,@input_data_1=@sqlQuery
	,@input_data_1_name = N'in_data'
;
GO

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE @sqlQuery NVARCHAR(1024)=N'SELECT DATEPART(MONTH,[訂單日期]) AS [Month]
		,ROUND(SUM(單價*數量),0) AS [Income]		
		FROM 訂貨主檔 AS A JOIN 訂貨明細 AS B ON A.訂單號碼=B.訂單號碼
		WHERE A.訂單日期 >= ''2003-1-1'' AND A.訂單日期 < ''2004-1-1''
		GROUP BY DATEPART(MONTH,[訂單日期])
		ORDER BY [Month]
		';

EXEC sp_execute_external_script  
	@language = N'R'  
	, @script = N'
	myData <- data.frame(InputDataSet);
	OutputDataSet <- myData;

	mainDir <- "C:\\PP"    
	dest_filename = tempfile(pattern = "Month_Income_", tmpdir = mainDir);
	dest_filename = paste(dest_filename, ''.jpg'',sep="");
    print(dest_filename, quote=FALSE);
	jpeg(filename=dest_filename, width=1024, height=1024);    
		
	rxLinePlot(Income~Month ,type=c("b","r"),data=myData,xTitle="Month"
		,yTitle="Income",col="blue");

    dev.off();		
	'
	, @input_data_1 = @sqlQuery	;	
GO




DECLARE @sqlQuery NVARCHAR(1024)=N'SELECT
		DATEPART(MONTH,[訂單日期]) AS [Month]
		,CONVERT(NVARCHAR,D.類別編號) AS [TypeId]
		,SUM(數量) AS [Amount]
		FROM 訂貨主檔 AS A JOIN 訂貨明細 AS B ON A.訂單號碼=B.訂單號碼
			JOIN 產品資料 AS C ON B.產品編號=C.產品編號
			JOIN 產品類別 AS D ON C.類別編號=D.類別編號
		WHERE A.訂單日期 >= ''2003-1-1'' AND A.訂單日期 < ''2004-1-1''
		GROUP BY DATEPART(MONTH,[訂單日期]),D.類別編號
		ORDER BY [Month]
		';

EXEC sp_execute_external_script  
	@language = N'R'  
	, @script = N'
	myData <- data.frame(InputDataSet);
	OutputDataSet <- myData;

	mainDir <- "C:\\PP"    
	dest_filename = tempfile(pattern = "Month_Income_", tmpdir = mainDir);
	dest_filename = paste(dest_filename, ''.jpg'',sep="");
    print(dest_filename, quote=FALSE);
	jpeg(filename=dest_filename, width=1024, height=1024);    
	
	#rxLinePlot(Amount~Month,groups=TypeId ,type="l",data=myData,xTitle="Month"
	#	,yTitle="Income",col="blue");
	
	rxLinePlot(Amount~Month | TypeId ,type="l",data=myData,xTitle="Month"
		,yTitle="Income",col="blue");

    dev.off();		
	'
	, @input_data_1 = @sqlQuery;	
GO