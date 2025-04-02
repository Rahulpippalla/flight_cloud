  METHOD if_oo_adt_classrun~main.
    out->write( 'Starting Data Generation' ) ##NO_TEXT.

    out->write( 'Generate Data: Airport      ZAIRPORT' ) ##NO_TEXT.
    lcl_airport_data_generator=>lif_data_generator~create( out ).

    out->write( 'Generate Data: Carrier      ZCARRIER' ) ##NO_TEXT.
    lcl_carrier_data_generator=>lif_data_generator~create( out ).
    out->write( 'Generate Data: Connection   ZCONNECTION' ) ##NO_TEXT.
    lcl_connection_data_generator=>lif_data_generator~create( out ).
    out->write( 'Generate Data: Flight       ZFLIGHT' ) ##NO_TEXT.
    lcl_flight_data_generator=>lif_data_generator~create( out ).


    out->write( 'Generate Data: Agency       ZAGENCY' ) ##NO_TEXT.
    lcl_agency_data_generator=>lif_data_generator~create( out ).

    out->write( 'Generate Data: Customer      ZCUSTOMER' ) ##NO_TEXT.
    lcl_customer_data_generator=>lif_data_generator~create( out ).

    out->write( 'Generate Data: Supplement      ZSUPPLEMENT' ) ##NO_TEXT.
    lcl_supplement_data_generator=>lif_data_generator~create( out ).

    out->write( 'Generate Data: Travel      ZTRAVEL' ) ##NO_TEXT.
    out->write( 'Generate Data: Booking      ZBOOKING' ) ##NO_TEXT.
    out->write( 'Generate Data: Booking Supplement      ZBOOK_SUPPL' ) ##NO_TEXT.
    lcl_travel_data_generator=>lif_data_generator~create( out ).

    out->write( 'Generate Data: Status ValueHelps' ) ##NO_TEXT.
    lcl_status_vh_data_generator=>lif_data_generator~create( out ).


    out->write(  'Calling BAdIs' ) ##NO_TEXT.

    DATA lo_badi TYPE REF TO zdata_generation_badi.
    GET BADI lo_badi.
    CALL BADI lo_badi->data_generation
      EXPORTING
        out = out.
    out->write(  'Finished Calling BAdIs' ) ##NO_TEXT.

    out->write( 'Finished Data Generation' ) ##NO_TEXT.
  ENDMETHOD.