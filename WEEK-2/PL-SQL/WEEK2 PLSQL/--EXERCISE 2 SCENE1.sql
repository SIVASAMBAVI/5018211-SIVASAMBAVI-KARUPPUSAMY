--EXERCISE 2 SCENE1
CREATE OR REPLACE PROCEDURE SafeTransferFunds (
    p_from_account_id IN accounts.account_id%TYPE,
    p_to_account_id IN accounts.account_id%TYPE,
    p_amount IN NUMBER
)
IS
    v_from_balance accounts.balance%TYPE;
    v_to_balance accounts.balance%TYPE;
    v_error_message VARCHAR2(4000);
BEGIN
    -- Fetch the balance of the from account
    SELECT balance INTO v_from_balance
    FROM accounts
    WHERE account_id = p_from_account_id
    FOR UPDATE;

    -- Check if the from account has sufficient funds
    IF v_from_balance < p_amount THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient funds in the source account.');
    END IF;

    -- Fetch the balance of the to account
    SELECT balance INTO v_to_balance
    FROM accounts
    WHERE account_id = p_to_account_id
    FOR UPDATE;

    -- Perform the transfer
    UPDATE accounts
    SET balance = balance - p_amount
    WHERE account_id = p_from_account_id;

    UPDATE accounts
    SET balance = balance + p_amount
    WHERE account_id = p_to_account_id;

    -- Commit the transaction
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Transfer of ' || p_amount || ' from account ' || p_from_account_id || 
                         ' to account ' || p_to_account_id || ' was successful.');
EXCEPTION
    WHEN OTHERS THEN
        -- Log the error message
        v_error_message := SQLERRM;
        INSERT INTO error_log (error_message, error_time)
        VALUES (v_error_message, SYSDATE);

        -- Rollback the transaction
        ROLLBACK;

        DBMS_OUTPUT.PUT_LINE('Error occurred during the transfer: ' || v_error_message);
END SafeTransferFunds;
/
