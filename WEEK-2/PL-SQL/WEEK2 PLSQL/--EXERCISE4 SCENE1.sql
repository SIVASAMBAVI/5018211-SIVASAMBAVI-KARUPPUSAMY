--EXERCISE4 SCENE1
CREATE FUNCTION CalculateAge (@DateOfBirth DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT;

    -- Calculate the age in years
    SET @Age = DATEDIFF(YEAR, @DateOfBirth, GETDATE());

    -- Adjust the age if the birthday has not occurred this year
    IF (MONTH(@DateOfBirth) > MONTH(GETDATE())) OR (MONTH(@DateOfBirth) = MONTH(GETDATE()) AND DAY(@DateOfBirth) > DAY(GETDATE()))
    BEGIN
        SET @Age = @Age - 1;
    END

    RETURN @Age;
END
GO
