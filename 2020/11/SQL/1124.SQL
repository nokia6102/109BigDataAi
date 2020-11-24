  
DECLARE @sql NVARCHAR(1024)=N'SELECT ���u�s�� AS [Eid],�m�W AS [Name]
	,�٩I AS [Gender],�~�� AS [Salary] FROM ���u';

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

DECLARE @sqlQuery NVARCHAR(1024)=N'SELECT DATEPART(MONTH,[�q����]) AS [Month]
		,CONVERT(INT,ROUND(SUM(���*�ƶq),0)) AS [Income]		
		FROM �q�f�D�� AS A JOIN �q�f���� AS B ON A.�q�渹�X=B.�q�渹�X
		WHERE A.�q���� >= ''2003-1-1'' AND A.�q���� < ''2004-1-1''
		GROUP BY DATEPART(MONTH,[�q����])
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


DECLARE @sqlQuery NVARCHAR(1024)=N'SELECT DATEPART(MONTH,[�q����]) AS [Month]
		,ROUND(SUM(���*�ƶq),0) AS [Income]		
		FROM �q�f�D�� AS A JOIN �q�f���� AS B ON A.�q�渹�X=B.�q�渹�X
		WHERE A.�q���� >= ''2003-1-1'' AND A.�q���� < ''2004-1-1''
		GROUP BY DATEPART(MONTH,[�q����])
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
		DATEPART(MONTH,[�q����]) AS [Month]
		,CONVERT(NVARCHAR,D.���O�s��) AS [TypeId]
		,SUM(�ƶq) AS [Amount]
		FROM �q�f�D�� AS A JOIN �q�f���� AS B ON A.�q�渹�X=B.�q�渹�X
			JOIN ���~��� AS C ON B.���~�s��=C.���~�s��
			JOIN ���~���O AS D ON C.���O�s��=D.���O�s��
		WHERE A.�q���� >= ''2003-1-1'' AND A.�q���� < ''2004-1-1''
		GROUP BY DATEPART(MONTH,[�q����]),D.���O�s��
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