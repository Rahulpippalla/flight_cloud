CLASS Zcm_flight_messages DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .
    INTERFACES if_abap_behv_message .

    CONSTANTS:
      gc_msgid TYPE symsgid VALUE 'ZCM_FLIGHT',

      BEGIN OF customer_unkown,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'MV_CUSTOMER_ID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF customer_unkown,

      BEGIN OF agency_unkown,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'MV_AGENCY_ID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF agency_unkown,

      BEGIN OF begin_date_bef_end_date,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'MV_BEGIN_DATE',
        attr2 TYPE scx_attrname VALUE 'MV_END_DATE',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF begin_date_bef_end_date,

      BEGIN OF begin_date_on_or_bef_sysdate,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE 'MV_BEGIN_DATE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF begin_date_on_or_bef_sysdate,


      BEGIN OF status_invalid,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE 'MV_STATUS',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF status_invalid,

      BEGIN OF discount_invalid,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF discount_invalid,

      BEGIN OF enter_begin_date,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_begin_date,

      BEGIN OF enter_end_date,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_end_date,

      BEGIN OF enter_agency_id,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '009',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_agency_id,

      BEGIN OF enter_customer_id,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_customer_id,

      BEGIN OF enter_connection_id,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '011',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_connection_id,

      BEGIN OF no_flight_exists,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '012',
        attr1 TYPE scx_attrname VALUE 'MV_CARRIER_ID',
        attr2 TYPE scx_attrname VALUE 'MV_FLIGHT_DATE',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF no_flight_exists,

      BEGIN OF supplement_unknown,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '013',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF supplement_unknown,

      BEGIN OF enter_supplement_id,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '014',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_supplement_id,

      BEGIN OF enter_airline_id,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '016',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_airline_id,

      BEGIN OF enter_flight_date,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '017',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_flight_date,

      BEGIN OF not_sufficient_numbers,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '018',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF not_sufficient_numbers,

      BEGIN OF number_range_depleted,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '019',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF number_range_depleted,

      BEGIN OF not_authorized,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '020',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF not_authorized,

      BEGIN OF not_authorized_for_agencyID,
        msgid TYPE symsgid VALUE 'ZCM_FLIGHT',
        msgno TYPE symsgno VALUE '021',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF not_authorized_for_agencyID.


    METHODS constructor
      IMPORTING
        textid                LIKE if_t100_message=>t100key OPTIONAL
        attr1                 TYPE i OPTIONAL
        attr2                 TYPE string OPTIONAL
        attr3                 TYPE string OPTIONAL
        attr4                 TYPE string OPTIONAL
        previous              LIKE previous OPTIONAL
        travel_id             TYPE Ztravel_id OPTIONAL
        booking_id            TYPE Zbooking_id OPTIONAL
        booking_supplement_id TYPE Zbooking_supplement_id OPTIONAL
        agency_id             TYPE Zagency_id OPTIONAL
        customer_id           TYPE Zcustomer_id OPTIONAL
        carrier_id            TYPE Zcarrier-carrier_id OPTIONAL
        connection_id         TYPE Zconnection-connection_id OPTIONAL
        supplement_id         TYPE Zsupplement-supplement_id OPTIONAL
        begin_date            TYPE Zbegin_date OPTIONAL
        end_date              TYPE Zend_date OPTIONAL
        booking_date          TYPE Zbooking_date OPTIONAL
        flight_date           TYPE Zflight_date OPTIONAL
        status                TYPE Ztravel_status OPTIONAL
        currency_code         TYPE Zcurrency_code OPTIONAL
        severity              TYPE if_abap_behv_message=>t_severity OPTIONAL
        uname                 TYPE syuname OPTIONAL.


    DATA:
      mv_attr1                 TYPE string,
      mv_attr2                 TYPE string,
      mv_attr3                 TYPE string,
      mv_attr4                 TYPE string,
      mv_travel_id             TYPE Ztravel_id,
      mv_booking_id            TYPE Zbooking_id,
      mv_booking_supplement_id TYPE Zbooking_supplement_id,
      mv_agency_id             TYPE Zagency_id,
      mv_customer_id           TYPE Zcustomer_id,
      mv_carrier_id            TYPE Zcarrier-carrier_id,
      mv_connection_id         TYPE Zconnection-connection_id,
      mv_supplement_id         TYPE Zsupplement-supplement_id,
      mv_begin_date            TYPE Zbegin_date,
      mv_end_date              TYPE Zend_date,
      mv_booking_date          TYPE Zbooking_date,
      mv_flight_date           TYPE Zflight_date,
      mv_status                TYPE Ztravel_status,
      mv_currency_code         TYPE Zcurrency_code,
      mv_uname                 TYPE syuname.

