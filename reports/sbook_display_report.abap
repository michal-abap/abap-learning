*&---------------------------------------------------------------------*
*& Report zvc_show_sbook
*&---------------------------------------------------------------------*
*& SBOOK display report
*&---------------------------------------------------------------------*
REPORT zvc_show_sbook.

**********************************************************************
* Selection screen
**********************************************************************

PARAMETERS: p_carrid TYPE sbook-carrid OBLIGATORY,
            p_connid TYPE sbook-connid OBLIGATORY,
            p_fldate TYPE sbook-fldate OBLIGATORY.

**********************************************************************
* Data declarations
**********************************************************************

DATA lt_sbook TYPE STANDARD TABLE OF sbook WITH EMPTY KEY.

**********************************************************************
* Main processing
**********************************************************************

SELECT *
  FROM sbook
  WHERE carrid = @p_carrid
    AND connid = @p_connid
    AND fldate = @p_fldate
  INTO TABLE @lt_sbook.

IF lt_sbook IS INITIAL.
  MESSAGE 'No SBOOK data found for the selected criteria.' TYPE 'I'.
  RETURN.
ENDIF.

**********************************************************************
* SALV display
**********************************************************************

TRY.

    DATA lo_alv TYPE REF TO cl_salv_table.

    cl_salv_table=>factory(
      EXPORTING
        r_container  = cl_gui_container=>default_screen
      IMPORTING
        r_salv_table = lo_alv
      CHANGING
        t_table      = lt_sbook
    ).

    lo_alv->get_functions( )->set_all( abap_true ).
    lo_alv->display( ).

  CATCH cx_salv_msg INTO DATA(lx_salv).
    MESSAGE lx_salv->get_text( ) TYPE 'E'.
ENDTRY.
