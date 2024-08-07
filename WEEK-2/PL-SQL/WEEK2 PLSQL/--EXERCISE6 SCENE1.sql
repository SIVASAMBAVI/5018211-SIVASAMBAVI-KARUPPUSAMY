--EXERCISE6 SCENE1
DECLARE
    -- Define a cursor to retrieve transactions for the current month
    CURSOR curTransactions IS
        SELECT t.CustomerID, t.TransactionDate, t.Amount, t.TransactionType
        FROM Transactions t
        WHERE EXTRACT(MONTH FROM t.TransactionDate) = EXTRACT(MONTH FROM SYSDATE)
          AND EXTRACT(YEAR FROM t.TransactionDate) = EXTRACT(YEAR FROM SYSDATE)
        ORDER BY t.CustomerID, t.TransactionDate;

    -- Define variables to store cursor data
    v_CustomerID Transactions.CustomerID%TYPE;
    v_TransactionDate Transactions.TransactionDate%TYPE;
    v_Amount Transactions.Amount%TYPE;
    v_TransactionType Transactions.TransactionType%TYPE;
    v_PreviousCustomerID Transactions.CustomerID%TYPE := NULL;
    v_StatementText VARCHAR2(4000);

BEGIN
    -- Open the cursor
    OPEN curTransactions;

    -- Fetch and process each record from the cursor
    LOOP
        FETCH curTransactions INTO v_CustomerID, v_TransactionDate, v_Amount, v_TransactionType;
        EXIT WHEN curTransactions%NOTFOUND;

        -- Check if the customer ID has changed
        IF v_CustomerID != v_PreviousCustomerID THEN
            -- Print the previous customer's statement if needed
            IF v_PreviousCustomerID IS NOT NULL THEN
                DBMS_OUTPUT.PUT_LINE('Statement for Customer ID: ' || v_PreviousCustomerID);
                DBMS_OUTPUT.PUT_LINE(v_StatementText);
                DBMS_OUTPUT.PUT_LINE('----------------------------------------');
            END IF;

            -- Reset the statement text for the new customer
            v_StatementText := 'Transactions for Customer ID: ' || v_CustomerID || CHR(10);
            v_PreviousCustomerID := v_CustomerID;
        END IF;

        -- Append transaction details to the statement text
        v_StatementText := v_StatementText || TO_CHAR(v_TransactionDate, 'DD-MON-YYYY') || ': ' ||
                           CASE WHEN v_TransactionType = 'D' THEN 'Deposit' ELSE 'Withdrawal' END || ' of ' ||
                           TO_CHAR(v_Amount, '999,999.99') || CHR(10);
    END LOOP;

    -- Print the statement for the last customer
    IF v_PreviousCustomerID IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Statement for Customer ID: ' || v_PreviousCustomerID);
        DBMS_OUTPUT.PUT_LINE(v_StatementText);
    END IF;

    -- Close the cursor
    CLOSE curTransactions;
END;
/
