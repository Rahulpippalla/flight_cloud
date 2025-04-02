CLASS Zcx_agency DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_t100_message,
      if_abap_behv_message.

    CONSTANTS:
      message_class TYPE symsgid VALUE 'ZCM_AGENCY',
      BEGIN OF name_required,
        msgid TYPE symsgid VALUE message_class,
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF name_required,

      BEGIN OF email_invalid_format,
        msgid TYPE symsgid VALUE message_class,
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF email_invalid_format,

      BEGIN OF country_code_invalid,
        msgid TYPE symsgid VALUE message_class,
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'MV_COUNTRY_CODE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF country_code_invalid,

      BEGIN OF attachment_properties_invalid,
        msgid TYPE symsgid VALUE message_class,
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF attachment_properties_invalid,

      BEGIN OF not_sufficient_numbers,
        msgid TYPE symsgid VALUE message_class,
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF not_sufficient_numbers,

      BEGIN OF number_range_depleted,
        msgid TYPE symsgid VALUE message_class,
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF number_range_depleted.


    DATA:
      mv_country_code TYPE ZR_AgencyTP-CountryCode,
      mv_numbers_left TYPE i.


    METHODS:
      constructor
        IMPORTING
          textid       LIKE if_t100_message=>t100key         OPTIONAL
          previous     LIKE previous                         OPTIONAL
          severity     TYPE if_abap_behv_message=>t_severity DEFAULT  if_abap_behv_message=>severity-error
          countrycode  TYPE ZR_AgencyTP-CountryCode        OPTIONAL
          numbers_left TYPE i                                OPTIONAL
            PREFERRED PARAMETER textid
        .