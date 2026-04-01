*&---------------------------------------------------------------------*
*& Report zvc_program_week3
*&---------------------------------------------------------------------*
*& Flight discount calculation based on SFLIGHT data
*&---------------------------------------------------------------------*
REPORT zvc_program_week3.

**********************************************************************
* Selection screen
**********************************************************************

CONSTANTS c_listbox_id TYPE vrm_id VALUE 'P_DISC'.

PARAMETERS: p_carrid TYPE sflight-carrid,
            p_connid TYPE sflight-connid,
            p_fldate TYPE sflight-fldate,
            p_disc   TYPE char3 AS LISTBOX VISIBLE LENGTH 15.

**********************************************************************
* Types and data
**********************************************************************

TYPES: BEGIN OF ty_result,
         carrid      TYPE sflight-carrid,
         connid      TYPE sflight-connid,
         fldate      TYPE sflight-fldate,
         planetype   TYPE sflight-planetype,
         price       TYPE sflight-price,
         discount    TYPE i,
         final_price TYPE sflight-price,
       END OF ty_result.

TYPES tt_result TYPE STANDARD TABLE OF ty_result WITH EMPTY KEY.

DATA: ls_result      TYPE ty_result,
      lt_result      TYPE tt_result,
      lv_disc_pct    TYPE i,
      lv_final_price TYPE sflight-price.

**********************************************************************
* Populate discount listbox
**********************************************************************

AT SELECTION-SCREEN OUTPUT.

  DATA: lt_values TYPE vrm_values,
        ls_value  LIKE LINE OF lt_values.

  CLEAR lt_values.

  ls_value-key  = '000'.
  ls_value-text = 'Regular price (0%)'.
  APPEND ls_value TO lt_values.

  ls_value-key  = '005'.
  ls_value-text = '5%'.
  APPEND ls_value TO lt_values.

  ls_value-key  = '010'.
  ls_value-text = '10%'.
  APPEND ls_value TO lt_values.

  ls_value-key  = '015'.
  ls_value-text = '15%'.
  APPEND ls_value TO lt_values.

  ls_value-key  = '020'.
  ls_value-text = '20%'.
  APPEND ls_value TO lt_values.

  ls_value-key  = '025'.
  ls_value-text = '25%'.
  APPEND ls_value TO lt_values.

  ls_value-key  = '050'.
  ls_value-text = '50%'.
  APPEND ls_value TO lt_values.

  ls_value-key  = '100'.
  ls_value-text = '100%'.
  APPEND ls_value TO lt_values.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = c_listbox_id
      values = lt_values.

  IF p_disc IS INITIAL.
    p_disc = '000'.
  ENDIF.

**********************************************************************
* Main processing
**********************************************************************

START-OF-SELECTION.

  SELECT SINGLE carrid,
                connid,
                fldate,
                planetype,
                price
    FROM sflight
    INTO ( @ls_result-carrid,
           @ls_result-connid,
           @ls_result-fldate,
           @ls_result-planetype,
           @ls_result-price )
    WHERE carrid = @p_carrid
      AND connid = @p_connid
      AND fldate = @p_fldate.

  IF sy-subrc <> 0.
    MESSAGE 'No SFLIGHT record found for the selected criteria.' TYPE 'E'.
  ENDIF.

  lv_disc_pct         = p_disc.
  ls_result-discount  = lv_disc_pct.

  lv_final_price        = ls_result-price * ( 100 - lv_disc_pct ) / 100.
  ls_result-final_price = lv_final_price.

**********************************************************************
* Lock and save result to custom table
**********************************************************************

  CALL FUNCTION 'ENQUEUE_EZVC_SFLIGHT_DIS'
    EXPORTING
      carrid = p_carrid
      connid = p_connid
      fldate = p_fldate
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.

  IF sy-subrc <> 0.
    MESSAGE 'The record is currently locked by another user.' TYPE 'E'.
  ENDIF.

  DATA ls_db TYPE zvc_sflight_disc.

  CLEAR ls_db.

  ls_db-carrid      = ls_result-carrid.
  ls_db-connid      = ls_result-connid.
  ls_db-fldate      = ls_result-fldate.
  ls_db-discount    = ls_result-discount.
  ls_db-final_price = ls_result-final_price.
  ls_db-price       = ls_result-price.
  ls_db-erdat       = sy-datum.
  ls_db-erzet       = sy-uzeit.
  ls_db-ernam       = sy-uname.

  MODIFY zvc_sflight_disc FROM @ls_db.
  IF sy-subrc <> 0.

    CALL FUNCTION 'DEQUEUE_EZVC_SFLIGHT_DIS'
      EXPORTING
        carrid = p_carrid
        connid = p_connid
        fldate = p_fldate.

    MESSAGE 'Error while saving data to ZVC_SFLIGHT_DISC.' TYPE 'E'.
  ENDIF.

  COMMIT WORK.

  CALL FUNCTION 'DEQUEUE_EZVC_SFLIGHT_DIS'
    EXPORTING
      carrid = p_carrid
      connid = p_connid
      fldate = p_fldate.

**********************************************************************
* Display result
**********************************************************************

  APPEND ls_result TO lt_result.

  cl_demo_output=>display(
    EXPORTING
      data = lt_result
      name = 'Discount calculation result'
  ).
