*&---------------------------------------------------------------------*
*& Report zvc_loops
*&---------------------------------------------------------------------*
*& Loop processing examples based on SFLIGHT data
*&---------------------------------------------------------------------*
REPORT zvc_loops.

**********************************************************************
* Data declarations
**********************************************************************

DATA: lt_sflight_full TYPE STANDARD TABLE OF sflight,
      ls_sflight_full TYPE sflight.

**********************************************************************
* Loop with REFERENCE INTO
**********************************************************************

SELECT carrid,
       connid,
       fldate,
       seatsmax,
       seatsocc,
       ( seatsmax - seatsocc ) AS seatsfree
  FROM sflight
  INTO TABLE @DATA(lt_sflight_ref)
  WHERE fldate > '20260101'.

LOOP AT lt_sflight_ref REFERENCE INTO DATA(lr_sflight).
  lr_sflight->seatsfree = lr_sflight->seatsmax - lr_sflight->seatsocc.
ENDLOOP.

cl_demo_output=>display(
  EXPORTING
    data = lt_sflight_ref
    name = 'Loop with reference'
).

**********************************************************************
* Loop with ASSIGNING FIELD-SYMBOL
**********************************************************************

SELECT carrid,
       connid,
       fldate,
       seatsmax,
       seatsocc,
       ( seatsmax - seatsocc ) AS seatsfree
  FROM sflight
  INTO TABLE @DATA(lt_sflight_fs)
  WHERE fldate > '20260101'.

LOOP AT lt_sflight_fs ASSIGNING FIELD-SYMBOL(<ls_sflight_fs>).
  <ls_sflight_fs>-seatsfree = <ls_sflight_fs>-seatsmax - <ls_sflight_fs>-seatsocc.
ENDLOOP.

cl_demo_output=>display(
  EXPORTING
    data = lt_sflight_fs
    name = 'Loop with field-symbol'
).

**********************************************************************
* Loop with INTO DATA and APPEND
**********************************************************************

SELECT carrid,
       connid,
       fldate,
       seatsmax,
       seatsocc,
       ( seatsmax - seatsocc ) AS seatsfree
  FROM sflight
  INTO TABLE @DATA(lt_sflight_str)
  WHERE fldate > '20260101'.

LOOP AT lt_sflight_str INTO DATA(ls_sflight_str).
  ls_sflight_str-seatsfree = ls_sflight_str-seatsmax - ls_sflight_str-seatsocc.
  ls_sflight_full = CORRESPONDING #( ls_sflight_str ).
  APPEND ls_sflight_full TO lt_sflight_full.
ENDLOOP.

cl_demo_output=>display(
  EXPORTING
    data = lt_sflight_full
    name = 'Loop with structure'
).

**********************************************************************
* WHILE example
**********************************************************************

SELECT carrid,
       connid,
       fldate,
       seatsmax,
       seatsocc,
       ( seatsmax - seatsocc ) AS seatsfree
  FROM sflight
  INTO TABLE @DATA(lt_while)
  WHERE fldate > '20260101'.

WHILE lt_while IS NOT INITIAL.
  DELETE lt_while INDEX 1.
ENDWHILE.

cl_demo_output=>display(
  EXPORTING
    data = lt_while
    name = 'WHILE loop'
).

**********************************************************************
* DO example
**********************************************************************

SELECT carrid,
       connid,
       fldate,
       seatsmax,
       seatsocc,
       ( seatsmax - seatsocc ) AS seatsfree
  FROM sflight
  INTO TABLE @DATA(lt_do)
  WHERE fldate > '20260101'.

DO.
  DELETE lt_do INDEX 1.
  IF lt_do IS INITIAL.
    EXIT.
  ENDIF.
ENDDO.

cl_demo_output=>display(
  EXPORTING
    data = lt_do
    name = 'DO loop'
).

**********************************************************************
* Flight occupancy analysis
**********************************************************************

TYPES: BEGIN OF ty_flight_ext,
         carrid        TYPE sflight-carrid,
         connid        TYPE sflight-connid,
         fldate        TYPE sflight-fldate,
         seatsmax      TYPE sflight-seatsmax,
         seatsocc      TYPE sflight-seatsocc,
         seatsfree     TYPE i,
         occupancy_pct TYPE p LENGTH 5 DECIMALS 2,
         bucket        TYPE c LENGTH 4,
       END OF ty_flight_ext.

DATA lt_flights_occ TYPE STANDARD TABLE OF ty_flight_ext WITH EMPTY KEY.

SELECT carrid,
       connid,
       fldate,
       seatsmax,
       seatsocc
  FROM sflight
  INTO CORRESPONDING FIELDS OF TABLE @lt_flights_occ
  WHERE fldate > '20260101'.

LOOP AT lt_flights_occ REFERENCE INTO DATA(lr_flight_occ).

  lr_flight_occ->seatsfree = lr_flight_occ->seatsmax - lr_flight_occ->seatsocc.

  IF lr_flight_occ->seatsmax > 0.
    lr_flight_occ->occupancy_pct = ( lr_flight_occ->seatsocc * 100 ) / lr_flight_occ->seatsmax.
  ELSE.
    lr_flight_occ->occupancy_pct = 0.
  ENDIF.

  IF lr_flight_occ->occupancy_pct >= 80.
    lr_flight_occ->bucket = 'HIGH'.
  ELSEIF lr_flight_occ->occupancy_pct >= 50.
    lr_flight_occ->bucket = 'MID'.
  ELSE.
    lr_flight_occ->bucket = 'LOW'.
  ENDIF.

ENDLOOP.

cl_demo_output=>display(
  EXPORTING
    data = lt_flights_occ
    name = 'Flight occupancy analysis'
).
