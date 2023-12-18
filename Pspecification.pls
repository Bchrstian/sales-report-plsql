CREATE OR REPLACE PACKAGE sales_report_package AS
  FUNCTION show_items_sold(p_branch_name VARCHAR2, p_month VARCHAR2) RETURN VARCHAR2;
  FUNCTION totals(p_branch_name VARCHAR2, p_month VARCHAR2) RETURN VARCHAR2;
  FUNCTION show_other_branches_sales(p_branch_name VARCHAR2, p_month VARCHAR2) RETURN VARCHAR2;
  PROCEDURE print_sales_report(p_branch_name VARCHAR2, p_month VARCHAR2);
END sales_report_package;
/