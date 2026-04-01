*&---------------------------------------------------------------------*
*& Report zgpt_append_value_exercises
*&---------------------------------------------------------------------*
*& APPEND and VALUE examples
*&---------------------------------------------------------------------*
REPORT zgpt_append_value_exercises.

**********************************************************************
* Data declarations
**********************************************************************

DATA lt_flights TYPE STANDARD TABLE OF sflight WITH EMPTY KEY.

**********************************************************************
* Insert data using APPEND VALUE
**********************************************************************

APPEND VALUE #( carrid = 'LH' connid = '0400' fldate = '20260201' ) TO lt_flights.
APPEND VALUE #( carrid = 'LH' connid = '0401' fldate = '20260202' ) TO lt_flights.
APPEND VALUE #( carrid = 'LO' connid = '0100' fldate = '20260203' ) TO lt_flights.
APPEND VALUE #( carrid = 'LA' connid = '0600' fldate = '20260301' ) TO lt_flights.
APPEND VALUE #( carrid = 'LC' connid = '0701' fldate = '20260402' ) TO lt_flights.
APPEND VALUE #( carrid = 'LF' connid = '0800' fldate = '20260503' ) TO lt_flights.

* Example with dynamic date
APPEND VALUE #( carrid = 'XX' connid = '9999' fldate = sy-datum ) TO lt_flights.

**********************************************************************
* Output
**********************************************************************

cl_demo_output=>write_text(
  |Number of records: { lines( lt_flights ) }|
).

cl_demo_output=>display( lt_flights ).
