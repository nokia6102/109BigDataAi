 
SELECT DISTINCT  
	IDENTITY(INT,1,1) AS Id,
    [Type]
INTO itemlist
FROM [SeaGate].[dbo].[海關圖]

SELECT * FROM itemlist

SELECT * FROM [海關圖] ORDER BY [Label]

UPDATE  A SET A.[Label]=B.[Id]
FROM  [海關圖] AS A JOIN itemlist AS B
ON A.[Type]=B.[Type];

SELECT * FROM [海關圖] ORDER BY [Label]
  
 