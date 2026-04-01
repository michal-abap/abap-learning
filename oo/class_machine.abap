CLASS zvc_cl_machine DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS get_number_of_seats
      RETURNING VALUE(r_result) TYPE i.

    METHODS set_number_of_seats
      IMPORTING i_ov_number_of_seats TYPE i.

  PROTECTED SECTION.
    DATA ov_number_of_seats TYPE i.

ENDCLASS.

CLASS zvc_cl_machine IMPLEMENTATION.

  METHOD get_number_of_seats.
    r_result = me->ov_number_of_seats.
  ENDMETHOD.

  METHOD set_number_of_seats.
    me->ov_number_of_seats = i_ov_number_of_seats.
  ENDMETHOD.

ENDCLASS.
