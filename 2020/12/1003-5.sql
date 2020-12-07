------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @savedmodel VARBINARY(MAX);
SELECT @savedmodel=�ҫ� FROM �ҫ��� WHERE �s��=1;

DECLARE @query NVARCHAR(MAX);
SET @query=N'SELECT * FROM TestPic ORDER BY NEWID()';

EXEC sp_execute_external_script 
  @language = N'R',
  @script = N'
    mod <- rxUnserializeModel(model);
    
	testdata<-data.frame(InputDataSet,stringsAsFactors = FALSE);
	testdata[] <- lapply(testdata, function(x) if (is.factor(x)) as.character(x) else {x})
	predict_result <- rxPredict(modelObject = mod, data = testdata,extraVarsToWrite = "Label");	
		
	#print(summary(predict_result));
	#print(predict_result);

	OutputDataSet <- predict_result;
  '
  ,@input_data_1 = @query
  ,@params = N'@model varbinary(max)'
  ,@model=@savedmodel
GO


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------