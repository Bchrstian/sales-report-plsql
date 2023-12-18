CREATE OR REPLACE PACKAGE BODY sales_report_package AS
  FUNCTION show_items_sold(p_branch_name VARCHAR2, p_month VARCHAR2) RETURN VARCHAR2 IS
    v_branch_id NUMBER;
    v_manager_name VARCHAR2(60);

    
    v_total_items NUMBER := 0;
    v_total_customers NUMBER := 0;
    v_item_details VARCHAR2(4000);

    
    CURSOR items_cursor IS
      SELECT isd.item_id, isd.quantity
      FROM item_sold isd
      JOIN customers c ON isd.customer_id = c.id
      JOIN branch b ON c.branch_id = b.id
      WHERE isd.month_sold = p_month AND b.name = p_branch_name;

    item_name VARCHAR2(20);
    item_type_name VARCHAR2(20);

  BEGIN
    -- Exception handling
    BEGIN
      -- Get Branch ID and Manager Name
      SELECT id, f_name || ' ' || l_name INTO v_branch_id, v_manager_name
      FROM branch_manager
      WHERE branch_id = (SELECT id FROM branch WHERE name = p_branch_name);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Branch not found.');
        RETURN NULL;
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: An unexpected error occurred.');
        RETURN NULL;
    END;

    DBMS_OUTPUT.PUT_LINE('************************************************************');
    DBMS_OUTPUT.PUT_LINE('This is a report of the sales made in ' || p_branch_name || ', ' || p_month);
    DBMS_OUTPUT.PUT_LINE('************************************************************');
    DBMS_OUTPUT.PUT_LINE('Branch: ' || p_branch_name);
    DBMS_OUTPUT.PUT_LINE('Manager: ' || v_manager_name);

    
    FOR item_info IN items_cursor LOOP
      BEGIN
        SELECT i.name, it.name
        INTO item_name, item_type_name
        FROM item i
        JOIN item_type it ON i.item_type_id = it.id
        WHERE i.id = item_info.item_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('Error: Item details not found for Item ID ' || item_info.item_id);
          CONTINUE; -- Skip to the next iteration
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('Error: An unexpected error occurred while fetching item details.');
          RETURN NULL;
      END;

    
      v_total_items := v_total_items + item_info.quantity;
      v_total_customers := v_total_customers + 1;

      DBMS_OUTPUT.PUT_LINE(item_info.quantity || ' ' || item_name || ' ' || item_type_name);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('No of Items sold: ' || v_total_items);
    DBMS_OUTPUT.PUT_LINE('No of Customers: ' || v_total_customers);
    DBMS_OUTPUT.PUT_LINE('Break down of items sold:' || CHR(10) || v_item_details);

    RETURN NULL;
  END show_items_sold;

  FUNCTION totals(p_branch_name VARCHAR2, p_month VARCHAR2) RETURN VARCHAR2 IS
    v_branch_id NUMBER;
    v_manager_name VARCHAR2(60);

  
    CURSOR items_cursor IS
      SELECT isd.item_id, isd.quantity
      FROM item_sold isd
      JOIN customers c ON isd.customer_id = c.id
      JOIN branch b ON c.branch_id = b.id
      WHERE isd.month_sold = p_month AND b.name = p_branch_name;

    item_name VARCHAR2(20);
    item_type_name VARCHAR2(20);
    sold_price NUMBER;
    total_price NUMBER := 0;

  BEGIN
    -- Exception handling
    BEGIN
      -- Get Branch ID and Manager Name
      SELECT id, f_name || ' ' || l_name INTO v_branch_id, v_manager_name
      FROM branch_manager
      WHERE branch_id = (SELECT id FROM branch WHERE name = p_branch_name);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Branch not found.');
        RETURN NULL;
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: An unexpected error occurred.');
        RETURN NULL;
    END;

    FOR item_info IN items_cursor LOOP
      BEGIN
        SELECT price INTO sold_price FROM item WHERE id = item_info.item_id;
        SELECT name INTO item_name FROM item WHERE id = item_info.item_id;
        SELECT name INTO item_type_name FROM item_type WHERE id IN (SELECT item_type_id FROM item WHERE id = item_info.item_id);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('Error: Item details not found for Item ID ' || item_info.item_id);
          CONTINUE; -- Skip to the next iteration
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('Error: An unexpected error occurred while fetching item details.');
          RETURN NULL;
      END;

      DBMS_OUTPUT.PUT_LINE('The price of ' || item_info.quantity || ' ' || item_name || ' ' || item_type_name || ': USD ' || item_info.quantity * sold_price);
      total_price := total_price + (item_info.quantity * sold_price);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total sales made in ' || p_branch_name || ' in the Month of ' || p_month || ': USD ' || total_price);
    DBMS_OUTPUT.PUT_LINE('Total sales made in ' || p_branch_name || ' in the Month of ' || p_month || ': RWF ' || total_price * 1952 || ' (Exchange rate: $1952)');

    RETURN NULL;
  END totals;

  FUNCTION show_other_branches_sales(p_branch_name VARCHAR2, p_month VARCHAR2) RETURN VARCHAR2 IS
    v_exchange_rate NUMBER := 1952;

   
    CURSOR total_sales_cur IS
      SELECT b.name AS branch_name, NVL(SUM(isd.quantity * i.price), 0) AS total_sales_usd
      FROM branch b
      LEFT JOIN customers c ON b.id = c.branch_id
      LEFT JOIN item_sold isd ON c.id = isd.customer_id
      LEFT JOIN item i ON isd.item_id = i.id
      WHERE UPPER(b.name) <> UPPER(p_branch_name) -- Exclude the specified branch
        AND UPPER(isd.month_sold) = UPPER(p_month) -- Filter by the specified month
      GROUP BY b.name;

  BEGIN
    -- Exception handling
    BEGIN
    
      DBMS_OUTPUT.PUT_LINE('Sales in other Branches in FRW (Exchange rate: $' || v_exchange_rate || ')');
      DBMS_OUTPUT.PUT_LINE('***********************************************************');
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: An unexpected error occurred.');
        RETURN NULL;
    END;

   
    FOR total_sales_rec IN total_sales_cur LOOP
      DBMS_OUTPUT.PUT_LINE('Total sales made in ' || total_sales_rec.branch_name ||
        ' in the Month of ' || p_month || ': FRW ' || TO_CHAR(total_sales_rec.total_sales_usd * v_exchange_rate) ||
        ' (Exchange rate: $' || v_exchange_rate || ')');
    END LOOP;

    RETURN NULL; 
  END show_other_branches_sales;

  PROCEDURE print_sales_report(p_branch_name VARCHAR2, p_month VARCHAR2) IS
  BEGIN
   
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Printing Sales Report for ' || p_branch_name || ' - ' || p_month);
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------');
    
  
 
    DBMS_OUTPUT.PUT_LINE(show_items_sold(p_branch_name, p_month));

  
    DBMS_OUTPUT.PUT_LINE(totals(p_branch_name, p_month));

    DBMS_OUTPUT.PUT_LINE(show_other_branches_sales(p_branch_name, p_month));
  END print_sales_report;
END sales_report_package;
/