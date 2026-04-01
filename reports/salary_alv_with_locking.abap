*&---------------------------------------------------------------------*
*& Report zvc_lock_object
*&---------------------------------------------------------------------*
*& ALV report with lock object handling and data update
*&---------------------------------------------------------------------*
REPORT zvc_lock_object.

**********************************************************************
* Data retrieval
**********************************************************************

SELECT *
  FROM zvc_salaries
  INTO TABLE @DATA(lt_salaries).

**********************************************************************
* Field catalog
**********************************************************************

DATA(lt_fieldcat) = VALUE slis_t_fieldcat_alv(
  ( fieldname = 'EMPLOYEEID' key = abap_true )
  ( fieldname = 'SMONTH'     key = abap_true )
  ( fieldname = 'SALARY'     edit = abap_true )
).

**********************************************************************
* ALV display
**********************************************************************

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_callback_program      = sy-repid
    i_callback_user_command = 'HANDLE_USER_COMMAND'
    it_fieldcat             = lt_fieldcat
  TABLES
    t_outtab                = lt_salaries
  EXCEPTIONS
    program_error           = 1
    OTHERS                  = 2.

IF sy-subrc <> 0.
  MESSAGE 'Error during ALV display' TYPE 'E'.
ENDIF.

**********************************************************************
* User command handling
**********************************************************************

FORM handle_user_command USING rcomm TYPE sy-ucomm
                               sel   TYPE slis_selfield.

  CASE rcomm.

    WHEN '&DATA_SAVE'.

      LOOP AT lt_salaries INTO DATA(ls_salaries).

        CALL FUNCTION 'ENQUEUE_EZVC_LO_SALARIES'
          EXPORTING
            mode_zvc_salaries = 'X'
            employeeid        = ls_salaries-employeeid
            smonth            = ls_salaries-smonth
          EXCEPTIONS
            foreign_lock      = 1
            system_failure    = 2
            OTHERS            = 3.

        IF sy-subrc <> 0.
          MESSAGE 'Record is locked by another user' TYPE 'E'.
        ENDIF.

      ENDLOOP.

      MODIFY zvc_salaries FROM TABLE lt_salaries.

      IF sy-subrc <> 0.
        MESSAGE 'Error while saving data' TYPE 'E'.
      ENDIF.

      COMMIT WORK.

      LOOP AT lt_salaries INTO ls_salaries.

        CALL FUNCTION 'DEQUEUE_EZVC_LO_SALARIES'
          EXPORTING
            employeeid = ls_salaries-employeeid
            smonth     = ls_salaries-smonth.

      ENDLOOP.

      MESSAGE 'Data saved successfully' TYPE 'S'.

  ENDCASE.

ENDFORM.
