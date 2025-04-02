CLASS Zcx_carriers_s DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES:
      if_t100_message,
      if_abap_behv_message.

    CONSTANTS:
      BEGIN OF name_required,
        msgid TYPE symsgid VALUE 'ZCM_CARRIER_S',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'MV_AIRLINE_ID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF name_required,
      BEGIN OF invalid_currency_code,
        msgid TYPE symsgid VALUE 'ZCM_CARRIER_S',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'MV_CURRENCY_CODE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_currency_code,
      BEGIN OF currency_code_required,
        msgid TYPE symsgid VALUE 'ZCM_CARRIER_S',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'MV_AIRLINE_ID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF currency_code_required,
      BEGIN OF airline_still_used,
        msgid TYPE symsgid VALUE 'ZCM_CARRIER_S',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE 'MV_AIRLINE_ID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF airline_still_used.


    DATA:
      mv_airline_id    TYPE Zcarrier_id,
      mv_currency_code TYPE Zcurrency_code.

    METHODS:
      constructor
        IMPORTING
          textid        LIKE if_t100_message=>t100key         OPTIONAL
          previous      LIKE previous                         OPTIONAL
          severity      TYPE if_abap_behv_message=>t_severity DEFAULT  if_abap_behv_message=>severity-error
          airline_id    TYPE Zcarrier_id         OPTIONAL
          currency_code TYPE Zcurrency_code OPTIONAL
        .
