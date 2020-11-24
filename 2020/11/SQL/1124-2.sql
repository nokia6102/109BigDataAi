SELECT [Survived], [Pclass], [Sex],[IsGroup], [IsFamilyHasChild], [IsMomOrDad], [AgeLevel] FROM NewTitanic2 WHERE [PassengerId]<=910;

SELECT [Survived],COUNT(*)
FROM [Titantic].[dbo].[NewTitanic2]
WHERE [PassengerId]<=910
GROUP BY [Survived];
