CLASS zcl_travel_auxiliary DEFINITION
  INHERITING FROM cl_abap_behv
  PUBLIC
  FINAL
  CREATE PUBLIC .


  PUBLIC SECTION.

    "! Calculates the <em>fail_cause</em> according to the message class and ID.  If the the message is raised in a dependent
    "! like <em>Create by Association</em> this is also taken in account.
    "!
    "! @parameter msgid | <p class="shorttext synchronized" lang="en">Message class</p>
    "! @parameter msgno | <p class="shorttext synchronized" lang="en">Message ID</p>
    "! @parameter is_dependend | <p class="shorttext synchronized" lang="en">Is this message raised in a dependent situation</p>
    "! @parameter fail_cause | <p class="shorttext synchronized" lang="en"></p>
    CLASS-METHODS get_cause_from_message
      IMPORTING
        msgid             TYPE symsgid
        msgno             TYPE symsgno
        is_dependend      TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(fail_cause) TYPE if_abap_behv=>t_fail_cause.
