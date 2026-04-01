*&---------------------------------------------------------------------*
*& Report zvc_plane_demo
*&---------------------------------------------------------------------*
*& Demonstration of OO concepts:
*& inheritance, interface, exception handling
*&---------------------------------------------------------------------*
REPORT zvc_plane_demo.

DATA: lo_plane TYPE REF TO zvc_cl_plane,
      lo_car   TYPE REF TO zvc_cl_car.

**********************************************************************
* Plane example
**********************************************************************

TRY.

    CREATE OBJECT lo_plane.

    lo_plane->set_model( 'Boeing 737' ).
    lo_plane->set_people_capacity( 180 ).
    lo_plane->set_number_of_wheels( 6 ).

    DATA(lv_model) = VALUE string( ).
    lo_plane->get_model( IMPORTING ev_model = lv_model ).

    DATA(lv_capacity) = VALUE i( ).
    lo_plane->get_people_capacity( IMPORTING ev_people_capacity = lv_capacity ).

    DATA(lv_wheels) = VALUE i( ).
    lo_plane->get_number_of_wheels( IMPORTING ev_number_of_wheels = lv_wheels ).

    cl_demo_output=>write_text( 'Plane data:' ).
    cl_demo_output=>write_text( |Model: { lv_model }| ).
    cl_demo_output=>write_text( |Capacity: { lv_capacity }| ).
    cl_demo_output=>write_text( |Wheels: { lv_wheels }| ).

  CATCH zvc_cx_plane INTO DATA(lx_plane).
    cl_demo_output=>write_text( 'Plane error occurred' ).
ENDTRY.

**********************************************************************
* Car example (inheritance)
**********************************************************************

CREATE OBJECT lo_car.

lo_car->set_number_of_seats( 5 ).

DATA(lv_seats) = lo_car->get_number_of_seats( ).

cl_demo_output=>write_text( '' ).
cl_demo_output=>write_text( 'Car data:' ).
cl_demo_output=>write_text( |Seats: { lv_seats }| ).

**********************************************************************
* Display result
**********************************************************************

cl_demo_output=>display( ).
