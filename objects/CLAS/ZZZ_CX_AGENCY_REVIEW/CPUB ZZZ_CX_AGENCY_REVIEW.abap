CLASS Zzz_cx_agency_review DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_t100_message,
      if_abap_behv_message.

    CONSTANTS:
      message_class TYPE symsgid VALUE 'ZZZ_AGENCY_RVIEW',
      BEGIN OF rating_invalid,
        msgid TYPE symsgid VALUE message_class,
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF rating_invalid.


    METHODS:
      constructor
        IMPORTING
          textid   LIKE if_t100_message=>t100key         OPTIONAL
          previous LIKE previous                         OPTIONAL
          severity TYPE if_abap_behv_message=>t_severity DEFAULT  if_abap_behv_message=>severity-error
            PREFERRED PARAMETER textid
        .