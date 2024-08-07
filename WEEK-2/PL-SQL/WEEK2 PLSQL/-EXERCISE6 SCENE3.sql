-EXERCISE6 SCENE3
DECLARE
    -- Define a cursor to retrieve all loans
    CURSOR curLoans IS
        SELECT LoanID, InterestRate
        FROM Loans;

    -- Define a variable to store the new interest rate
    v_NewInterestRate DECIMAL(5, 2) := 4.50; -- Example new interest rate

    -- Define variables to store cursor data
    v_LoanID Loans.LoanID%TYPE;
    v_OldInterestRate Loans.InterestRate%TYPE;

BEGIN
    -- Open the cursor
    OPEN curLoans;

    -- Fetch and process each record from the cursor
    LOOP
        FETCH curLoans INTO v_LoanID, v_OldInterestRate;
        EXIT WHEN curLoans%NOTFOUND;

        -- Update the interest rate based on the new policy
        UPDATE Loans
        SET InterestRate = v_NewInterestRate
        WHERE LoanID = v_LoanID;

        -- Optionally, log the update (for verification or auditing purposes)
        DBMS_OUTPUT.PUT_LINE('Updated LoanID: ' || v_LoanID ||
                             '. Old Interest Rate: ' || v_OldInterestRate ||
                             ', New Interest Rate: ' || v_NewInterestRate);
    END LOOP;

    -- Close the cursor
    CLOSE curLoans;

    -- Commit the changes to make them permanent
    COMMIT;
END;
/
