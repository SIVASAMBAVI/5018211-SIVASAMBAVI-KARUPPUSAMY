--EXERCISE4 SCENE2
CREATE FUNCTION CalculateMonthlyInstallment (
    @LoanAmount DECIMAL(18, 2),
    @AnnualInterestRate DECIMAL(5, 2),
    @LoanDurationYears INT
)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @MonthlyInterestRate DECIMAL(18, 6);
    DECLARE @TotalPayments INT;
    DECLARE @MonthlyInstallment DECIMAL(18, 2);

    -- Calculate the monthly interest rate
    SET @MonthlyInterestRate = @AnnualInterestRate / 100 / 12;

    -- Calculate the total number of payments
    SET @TotalPayments = @LoanDurationYears * 12;

    -- Calculate the monthly installment
    IF @MonthlyInterestRate > 0
    BEGIN
        SET @MonthlyInstallment = @LoanAmount * @MonthlyInterestRate * POWER(1 + @MonthlyInterestRate, @TotalPayments) /
                                  (POWER(1 + @MonthlyInterestRate, @TotalPayments) - 1);
    END
    ELSE
    BEGIN
        -- If the interest rate is 0%, the installment is simply the loan amount divided by the number of payments
        SET @MonthlyInstallment = @LoanAmount / @TotalPayments;
    END

    RETURN @MonthlyInstallment;
END
GO
