--EXERCISE6 SCENE2
DECLARE
    -- Define a cursor to retrieve all accounts
    CURSOR curAccounts IS
        SELECT AccountID, Balance
        FROM Accounts;

    -- Define a variable to store the maintenance fee
    v_AnnualFee DECIMAL(18, 2) := 50.00; -- Example fee amount

    -- Define variables to store cursor data
    v_AccountID Accounts.AccountID%TYPE;
    v_Balance Accounts.Balance%TYPE;

BEGIN
    -- Open the cursor
    OPEN curAccounts;

    -- Fetch and process each record from the cursor
    LOOP
        FETCH curAccounts INTO v_AccountID, v_Balance;
        EXIT WHEN curAccounts%NOTFOUND;

        -- Deduct the annual maintenance fee from the balance
        UPDATE Accounts
        SET Balance = v_Balance - v_AnnualFee
        WHERE AccountID = v_AccountID;

        -- Optionally, you could log the fee application or handle special cases here
        DBMS_OUTPUT.PUT_LINE('Applied annual fee to AccountID: ' || v_AccountID ||
                             '. New balance: ' || TO_CHAR(v_Balance - v_AnnualFee, '999,999.99'));
    END LOOP;

    -- Close the cursor
    CLOSE curAccounts;

    -- Commit the changes to make them permanent
    COMMIT;
END;
/
