*&---------------------------------------------------------------------*
*& Report zvc_display_sflight
*&---------------------------------------------------------------------*
*& Simple report to display flight data (SFLIGHT)
*&---------------------------------------------------------------------*
REPORT zvc_display_sflight.

**********************************************************************
* Data declarations
**********************************************************************

DATA lt_sflight TYPE STANDARD TABLE OF sflight WITH EMPTY KEY.

**********************************************************************
* Read data
**********************************************************************

SELECT *
  FROM sflight
  INTO TABLE @lt_sflight
  UP TO 50 ROWS.

**********************************************************************
* Output
**********************************************************************

IF lt_sflight IS INITIAL.
  cl_demo_output=>display( 'No flight data found.' ).
  RETURN.
ENDIF.

cl_demo_output=>display( lt_sflight ).
