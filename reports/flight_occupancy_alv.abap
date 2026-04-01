*&---------------------------------------------------------------------*
*& Report zvc_flight_occupancy_alv
*&---------------------------------------------------------------------*
*& Flight occupancy analysis displayed in SALV
*&---------------------------------------------------------------------*
REPORT zvc_flight_occupancy_alv.

**********************************************************************
* Types
**********************************************************************

TYPES: BEGIN OF ty_flight_occ,
         carrid        TYPE sflight-carrid,
         connid        TYPE sflight-connid,
         fldate        TYPE sflight-fldate,
         planetype     TYPE sflight-planetype,
         seatsmax      TYPE sflight-seatsmax,
         seatsocc      TYPE sflight-seatsocc,
         seatsfree     TYPE i,
         occupancy_pct TYPE p LENGTH 5 DECIMALS 2,
         bucket        TYPE c LENGTH 4,
       END OF ty_flight_occ.

TYPES tt_flight_occ TYPE STANDARD TABLE OF ty_flight_occ WITH EMPTY KEY.

**********************************************************************
* Selection screen
**********************************************************************

PARAMETERS p_rows TYPE i DEFAULT 50.

**********************************************************************
* Data declarations
**********************************************************************

DATA lt_flights TYPE tt_flight_occ.

**********************************************************************
* Read source data
**********************************************************************

SELECT carrid,
       connid,
       fldate,
       planetype,
       seatsmax,
       seatsocc
  FROM sflight
  INTO CORRESPONDING FIELDS OF TABLE @lt_flights
  UP TO @p_rows ROWS.

**********************************************************************
* Calculate derived fields
**********************************************************************

LOOP AT lt_flights ASSIGNING FIELD-SYMBOL(<ls_flight>).

  <ls_flight>-seatsfree = <ls_flight>-seatsmax - <ls_flight>-seatsocc.

  IF <ls_flight>-seatsmax > 0.
    <ls_flight>-occupancy_pct = ( <ls_flight>-seatsocc * 100 ) / <ls_flight>-seatsmax.
  ELSE.
    <ls_flight>-occupancy_pct = 0.
  ENDIF.

  IF <ls_flight>-occupancy_pct >= 80.
    <ls_flight>-bucket = 'HIGH'.
  ELSEIF <ls_flight>-occupancy_pct >= 50.
    <ls_flight>-bucket = 'MID'.
  ELSE.
    <ls_flight>-bucket = 'LOW'.
  ENDIF.

ENDLOOP.

**********************************************************************
* Display result in SALV
**********************************************************************

IF lt_flights IS INITIAL.
  MESSAGE 'No flight data found.' TYPE 'I'.
  RETURN.
ENDIF.

TRY.

    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = DATA(lo_alv)
      CHANGING
        t_table      = lt_flights
    ).

    lo_alv->get_functions( )->set_all( abap_true ).

    lo_alv->get_columns( )->get_column( 'CARRID' )->set_short_text( 'Airline' ).
    lo_alv->get_columns( )->get_column( 'CONNID' )->set_short_text( 'Conn.' ).
    lo_alv->get_columns( )->get_column( 'FLDATE' )->set_short_text( 'Date' ).
    lo_alv->get_columns( )->get_column( 'PLANETYPE' )->set_short_text( 'Plane Type' ).
    lo_alv->get_columns( )->get_column( 'SEATSMAX' )->set_short_text( 'Max Seats' ).
    lo_alv->get_columns( )->get_column( 'SEATSOCC' )->set_short_text( 'Occupied' ).
    lo_alv->get_columns( )->get_column( 'SEATSFREE' )->set_short_text( 'Free' ).
    lo_alv->get_columns( )->get_column( 'OCCUPANCY_PCT' )->set_short_text( 'Occ. %' ).
    lo_alv->get_columns( )->get_column( 'BUCKET' )->set_short_text( 'Level' ).

    lo_alv->display( ).

  CATCH cx_salv_msg INTO DATA(lx_salv).
    MESSAGE lx_salv->get_text( ) TYPE 'E'.
ENDTRY.
