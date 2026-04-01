*&---------------------------------------------------------------------*
*& Report zvc_perform_form
*&---------------------------------------------------------------------*
*& FORM and PERFORM examples
*&---------------------------------------------------------------------*
REPORT zvc_perform_form.

**********************************************************************
* Data declarations
**********************************************************************

DATA: lv_number TYPE i VALUE 0,
      lv_sum    TYPE i.

**********************************************************************
* PERFORM with CHANGING
**********************************************************************

PERFORM add_one CHANGING lv_number.
PERFORM add_one CHANGING lv_number.

cl_demo_output=>display(
  EXPORTING
    data = lv_number
    name = 'Result after add_one'
).

**********************************************************************
* PERFORM with USING
**********************************************************************

DATA(lv_number_one) = 1.
DATA(lv_number_two) = 2.

PERFORM sum_numbers USING lv_number_one lv_number_two
                    CHANGING lv_sum.

cl_demo_output=>display(
  EXPORTING
    data = lv_sum
    name = 'Sum result'
).

**********************************************************************
* FORM definitions
**********************************************************************

FORM add_one CHANGING cv_number TYPE i.

  cv_number = cv_number + 1.

ENDFORM.

FORM sum_numbers USING    iv_number_one TYPE i
                         iv_number_two TYPE i
                CHANGING cv_sum        TYPE i.

  cv_sum = iv_number_one + iv_number_two.

ENDFORM.
