*&---------------------------------------------------------------------*
*& Report zgpt_append_value_exercises_2
*&---------------------------------------------------------------------*
*& APPEND VALUE and SWITCH example
*&---------------------------------------------------------------------*
REPORT zgpt_append_value_exercises_2.

**********************************************************************
* Types
**********************************************************************

TYPES: BEGIN OF ty_out,
         carrid TYPE sflight-carrid,
         connid TYPE sflight-connid,
         fldate TYPE sflight-fldate,
         info   TYPE string,
       END OF ty_out.

TYPES tt_out TYPE STANDARD TABLE OF ty_out WITH EMPTY KEY.

**********************************************************************
* Data declarations
**********************************************************************

DATA lt_src TYPE STANDARD TABLE OF sflight WITH EMPTY KEY.
DATA lt_out TYPE tt_out.

**********************************************************************
* Read source data
**********************************************************************

SELECT *
  FROM sflight
  INTO TABLE @lt_src
  UP TO 10 ROWS.

**********************************************************************
* Build output data
**********************************************************************

LOOP AT lt_src INTO DATA(ls_src).

  DATA(lv_info) = SWITCH string(
    ls_src-carrid
    WHEN 'LH' THEN 'EU airline'
    WHEN 'AA' THEN 'US airline'
    ELSE 'Other airline'
  ).

  APPEND VALUE ty_out(
    carrid = ls_src-carrid
    connid = ls_src-connid
    fldate = ls_src-fldate
    info   = lv_info
  ) TO lt_out.

ENDLOOP.

**********************************************************************
* Output
**********************************************************************

cl_demo_output=>display( lt_out ).
