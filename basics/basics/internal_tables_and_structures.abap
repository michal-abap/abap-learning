*&---------------------------------------------------------------------*
*& Report zvc_internal_str_tab
*&---------------------------------------------------------------------*
*& Internal tables and structures example
*&---------------------------------------------------------------------*
REPORT zvc_internal_str_tab.

**********************************************************************
* Types
**********************************************************************

TYPES: BEGIN OF ty_salary,
         employee_id TYPE char20,
         month       TYPE d,
         salary      TYPE i,
       END OF ty_salary.

TYPES tt_salary TYPE STANDARD TABLE OF ty_salary WITH EMPTY KEY.

**********************************************************************
* Data declarations
**********************************************************************

DATA: ls_salary TYPE ty_salary,
      lt_salary TYPE tt_salary.

**********************************************************************
* APPEND example
**********************************************************************

ls_salary-employee_id = 'MBELDYGA'.
ls_salary-month       = '20270101'.
ls_salary-salary      = 30000.
APPEND ls_salary TO lt_salary.

ls_salary-employee_id = 'KMOCHOCKA'.
ls_salary-month       = '20270101'.
ls_salary-salary      = 20000.
APPEND ls_salary TO lt_salary.

cl_demo_output=>display(
  EXPORTING
    data = lt_salary
    name = 'APPEND example'
).

**********************************************************************
* VALUE expression example
**********************************************************************

lt_salary = VALUE tt_salary(
  ( employee_id = 'ABAP_B2B' month = '20260701' salary = 7000 )
  ( employee_id = 'VINTED'   month = '20260801' salary = 5000 )
).

cl_demo_output=>display(
  EXPORTING
    data = lt_salary
    name = 'VALUE expression example'
).
