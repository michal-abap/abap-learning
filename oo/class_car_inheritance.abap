CLASS zvc_cl_car DEFINITION INHERITING FROM zvc_cl_machine
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS set_number_of_seats REDEFINITION.

ENDCLASS.

CLASS zvc_cl_car IMPLEMENTATION.

  METHOD set_number_of_seats.
    IF i_ov_number_of_seats <= 0.
      MESSAGE 'Number of seats must be greater than 0.' TYPE 'E'.
    ELSE.
      me->ov_number_of_seats = i_ov_number_of_seats.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
