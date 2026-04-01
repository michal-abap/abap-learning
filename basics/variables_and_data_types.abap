*&---------------------------------------------------------------------*
*& Report zvc_variables
*&---------------------------------------------------------------------*
*& Variables, structures and internal tables example
*&---------------------------------------------------------------------*
REPORT zvc_variables.

**********************************************************************
* Basic variables
**********************************************************************

DATA lv_hello_world_static TYPE string.
DATA lv_number_static      TYPE i.

DATA(lv_hello_world) = 'Hello World'.
DATA(lv_number)      = 1.

lv_hello_world_static = 'Hello World'.

lv_number        = lv_number + 2.
lv_number_static = lv_number_static + 3.

WRITE: / lv_hello_world,
       / lv_hello_world_static,
       / lv_number,
       / lv_number_static.

**********************************************************************
* Structures
**********************************************************************

TYPES: BEGIN OF ty_sflight,
         carrid TYPE sflight-carrid,
         connid TYPE sflight-connid,
       END OF ty_sflight.

DATA ls_sflight_static TYPE ty_sflight.

DATA(ls_sflight) = VALUE ty_sflight(
  carrid = 'AA'
  connid = '17'
).

ls_sflight_static-carrid = 'AA'.
ls_sflight_static-connid = '17'.

WRITE: / ls_sflight-carrid,
       / ls_sflight-connid,
       / ls_sflight_static-carrid,
       / ls_sflight_static-connid.

**********************************************************************
* Internal tables
**********************************************************************

TYPES tt_sflight TYPE STANDARD TABLE OF ty_sflight WITH EMPTY KEY.

DATA lt_sflight_static TYPE tt_sflight.

DATA(lt_sflight) = VALUE tt_sflight(
  ( carrid = 'AA' connid = '18' )
  ( carrid = 'BB' connid = '88' )
).

APPEND ls_sflight_static TO lt_sflight_static.

ls_sflight_static-carrid = 'CC'.
ls_sflight_static-connid = '15'.

INSERT ls_sflight_static INTO TABLE lt_sflight_static.

INSERT VALUE #( carrid = 'AA' connid = '99' ) INTO TABLE lt_sflight_static.
INSERT VALUE #( carrid = 'AA' connid = '99' ) INTO TABLE lt_sflight.

WRITE: / 'Static table'.
LOOP AT lt_sflight_static REFERENCE INTO DATA(lr_sflight_static).
  WRITE: / lr_sflight_static->carrid,
         / lr_sflight_static->connid.
ENDLOOP.

WRITE: / 'Dynamic table'.
LOOP AT lt_sflight REFERENCE INTO DATA(lr_sflight).
  WRITE: / lr_sflight->carrid,
         / lr_sflight->connid.
ENDLOOP.

**********************************************************************
* Table operations
**********************************************************************

lt_sflight = CORRESPONDING #( BASE ( lt_sflight ) lt_sflight_static ).

cl_demo_output=>display(
  EXPORTING
    data = lt_sflight
    name = 'Merged table content'
).

lt_sflight = lt_sflight_static.

cl_demo_output=>display(
  EXPORTING
    data = lt_sflight
    name = 'Overwritten table content'
).
