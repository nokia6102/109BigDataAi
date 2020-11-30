CREATE TABLE �ҫ���
(
    �s�� INT IDENTITY(1,1) PRIMARY KEY,
	�ҫ��W�� NVARCHAR(20),
	�ҫ� VARBINARY(MAX)
)
GO

ALTER PROC #TempPP @sqlQuery NVARCHAR(MAX),@trainedModel VARBINARY(MAX) OUTPUT
AS
	EXECUTE sp_execute_external_script @language = N'R',
	@script = N'
			inputData<-data.frame(InputDataSet)
			cs<-colnames(inputData)
			frm<-paste(cs[1], paste(cs[2:length(cs)], collapse="+"), sep="~")
			model<-rxLinMod(frm,inputData)
			print(model)
			trainedModel<-rxSerializeModel(model,realtimeScoringOnly=TRUE)
			'
			,@input_data_1=@sqlQuery
			,@params=N'@trainedModel VARBINARY(MAX) OUTPUT'
			,@trainedModel=@trainedModel OUTPUT
;
GO

DECLARE @ss NVARCHAR(1024)=N'SELECT * FROM NewPitcher';
DECLARE @mm VARBINARY(MAX);
EXEC #TempPP @ss,@mm OUTPUT;
INSERT INTO �ҫ���(�ҫ��W��,�ҫ�) VALUES(N'�u�ʰj�k(�Y��)',@mm);

--TRUNCATE TABLE TABLE
SELECT * FROM �ҫ���
-----------------------------------------------------------