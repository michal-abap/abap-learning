CLASS zvc_cl_plane DEFINITION INHERITING FROM zvc_cl_machine
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES zvc_if_plane.

    ALIASES:
      get_people_capacity FOR zvc_if_plane~get_people_capacity,
      get_number_of_wheels FOR zvc_if_plane~get_number_of_wheels.

    METHODS set_people_capacity
      IMPORTING iv_people_capacity TYPE i.

    METHODS set_number_of_wheels
      IMPORTING iv_number_of_wheels TYPE i
      RAISING   zvc_cx_plane.

    METHODS set_model
      IMPORTING iv_model TYPE string.

    METHODS get_model
      EXPORTING ev_model TYPE string.

  PRIVATE SECTION.

    DATA: ov_people_capacity  TYPE i,
          ov_number_of_wheels TYPE i,
          ov_model            TYPE string.

ENDCLASS.

CLASS zvc_cl_plane IMPLEMENTATION.

  METHOD set_model.
    ov_model = COND #(
      WHEN iv_model CS 'Boeing' THEN iv_model
      WHEN iv_model CS 'Airbus' THEN iv_model
      ELSE ''
    ).
  ENDMETHOD.

  METHOD set_number_of_wheels.
    IF iv_number_of_wheels > 3.
      ov_number_of_wheels = iv_number_of_wheels.
    ELSE.
      RAISE EXCEPTION TYPE zvc_cx_plane.
    ENDIF.
  ENDMETHOD.

  METHOD set_people_capacity.
    IF iv_people_capacity >= 1.
      ov_people_capacity = iv_people_capacity.
    ENDIF.
  ENDMETHOD.

  METHOD get_model.
    ev_model = ov_model.
  ENDMETHOD.

  METHOD get_number_of_wheels.
    ev_number_of_wheels = ov_number_of_wheels.
  ENDMETHOD.

  METHOD get_people_capacity.
    ev_people_capacity = ov_people_capacity.
  ENDMETHOD.

ENDCLASS.
