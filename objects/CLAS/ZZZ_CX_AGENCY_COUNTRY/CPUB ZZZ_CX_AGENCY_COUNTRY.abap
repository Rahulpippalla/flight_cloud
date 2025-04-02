CLASS Zzz_cx_agency_country DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_t100_message,
      if_abap_behv_message.

    CONSTANTS:
      message_class TYPE symsgid VALUE 'ZZZ_AGENCY_CNTRY',
      BEGIN OF number_invalid,
        msgid TYPE symsgid VALUE message_class,
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'MV_PHONE_NUMBER',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF number_invalid,

      BEGIN OF combination_invalid,
        msgid TYPE symsgid VALUE message_class,
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'MV_PHONE_NUMBER',
        attr2 TYPE scx_attrname VALUE 'MV_COUNTRY_CODE',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF combination_invalid.


    DATA:
      mv_phone_number TYPE ZI_Agency-PhoneNumber,
      mv_COUNTRY_CODE TYPE ZI_Agency-CountryCode.


    METHODS:
      constructor
        IMPORTING
          textid      LIKE if_t100_message=>t100key         OPTIONAL
          previous    LIKE previous                         OPTIONAL
          severity    TYPE if_abap_behv_message=>t_severity DEFAULT  if_abap_behv_message=>severity-error
          phonenumber TYPE Zi_agency-PhoneNumber        OPTIONAL
          countrycode TYPE Zi_agency-CountryCode        OPTIONAL
            PREFERRED PARAMETER textid
        .