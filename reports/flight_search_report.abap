*&---------------------------------------------------------------------*
*& Report zvc_search_flights
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvc_search_flights.

TYPES: BEGIN OF t_flights,
         fldate   TYPE sflight-fldate,
         cityfrom TYPE spfli-cityfrom,
         cityto   TYPE spfli-cityto.
TYPES: END OF t_flights.

DATA: lt_flights TYPE STANDARD TABLE OF t_flights,
      ls_flights TYPE t_flights.


SELECT-OPTIONS: s_ctfr FOR ls_flights-cityfrom NO INTERVALS,
                s_ctto FOR ls_flights-cityto NO INTERVALS,
                s_fldat FOR ls_flights-fldate NO INTERVALS.

IF s_ctfr[] IS INITIAL.
  APPEND VALUE #( sign = 'I' option = 'CP' low = '*' ) TO s_ctfr.
ENDIF.

IF s_ctto[] IS INITIAL.
  APPEND VALUE #( sign = 'I' option = 'CP' low = '*' ) TO s_ctto.
ENDIF.

IF s_fldat[] IS INITIAL.
  APPEND VALUE #( sign = 'I' option = 'BT' low = '00000000' high = '99991231' ) TO s_fldat.
ENDIF.

SELECT * FROM
sflight
INNER JOIN spfli
ON sflight~carrid = spfli~carrid AND
sflight~connid = spfli~connid
WHERE
fldate IN @s_fldat
AND cityfrom IN @s_ctfr
AND cityto IN @s_ctto
INTO CORRESPONDING FIELDS OF TABLE  @lt_flights.

cl_salv_table=>factory(

  IMPORTING
    r_salv_table   =  DATA(rl_salv_table)                         
  CHANGING
    t_table        = lt_flights
).

cl_demo_output=>display(
  EXPORTING
    data = lt_flights               
    name = CONV #( TEXT-001 )
).

rl_salv_table->display( ).
