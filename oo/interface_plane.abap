INTERFACE zvc_if_plane
  PUBLIC.

* Interface defining basic plane characteristics

  METHODS get_people_capacity
    EXPORTING ev_people_capacity TYPE i.

  METHODS get_number_of_wheels
    EXPORTING ev_number_of_wheels TYPE i.

ENDINTERFACE.
