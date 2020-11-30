USE Pitcher;
GO

SELECT * FROM Pitcher;
DELETE FROM Pitcher WHERE [IP]=0;

DECLARE @ip_max FLOAT,@ip_min FLOAT,@so_max FLOAT,@so_min FLOAT
	,@go_max FLOAT,@go_min FLOAT,@ao_max FLOAT,@ao_min FLOAT;
SELECT @ip_max=MAX([IP]),@ip_min=MIN([IP])
	, @so_max=MAX([SO]),@so_min=MIN([SO])
	, @go_max=MAX([GO]),@go_min=MIN([GO])
	, @ao_max=MAX([AO]),@ao_min=MIN([AO]) FROM Pitcher;
SELECT [ERA], [WHIP]
	, ([IP]-@ip_min)/(@ip_max-@ip_min) AS [ip_new]
	, (1.0*([H]+[HR])*9)/[IP] AS [H9]
	, (1.0*[BB]+[IBB]+[HBP]*9)/[IP] AS [B9]
	, ([SO]-@so_min)/(@so_max-@so_min) AS [so_new]
	, ([GO]-@go_min)/(@go_max-@go_min) AS [go_new]
	, ([AO]-@ao_min)/(@ao_max-@ao_min) AS [ao_new]
FROM Pitcher;


