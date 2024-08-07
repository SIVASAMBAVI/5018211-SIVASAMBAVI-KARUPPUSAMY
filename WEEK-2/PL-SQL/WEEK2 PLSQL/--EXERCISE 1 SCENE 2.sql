--EXERCISE 1 SCENE 2
DECLARE
    CURSOR c_customers IS
        SELECT customer_id, balance
        FROM customers;

    v_customer_id customers.customer_id%TYPE;
    v_balance customers.balance%TYPE;

BEGIN
    OPEN c_customers;
    LOOP
        FETCH c_customers INTO v_customer_id, v_balance;
        EXIT WHEN c_customers%NOTFOUND;

        IF v_balance > 10000 THEN
            UPDATE customers
            SET IsVIP = 'TRUE'
            WHERE customer_id = v_customer_id;
        END IF;
    END LOOP;

    CLOSE c_customers;
    COMMIT;
END;
/
