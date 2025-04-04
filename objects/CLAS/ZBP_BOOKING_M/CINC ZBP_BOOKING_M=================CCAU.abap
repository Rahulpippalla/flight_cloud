CLASS ltcl_booking DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    CONSTANTS:
      travel_id1  TYPE ztravel_id VALUE '11',
      travel_id2  TYPE ztravel_id VALUE '12',
      travel_id3  TYPE ztravel_id VALUE '13',
      travel_id4  TYPE ztravel_id VALUE '14',
      booking_id1 TYPE zbooking_id VALUE '21',
      booking_id2 TYPE zbooking_id VALUE '22',
      booking_id3 TYPE zbooking_id VALUE '23',
      booking_id4 TYPE zbooking_id VALUE '24',
      c_currency  TYPE zcurrency_code VALUE 'EUR'.

    CLASS-DATA:
      class_under_test     TYPE REF TO lhc_booking,
      cds_test_environment TYPE REF TO if_cds_test_environment,
      sql_test_environment TYPE REF TO if_osql_test_environment.


    CLASS-METHODS:
      "! Instantiate class under test and set up test double framework
      class_setup,

      "! Destroy test environment and test double
      class_teardown.


    METHODS:
      "! Reset test double
      setup,

      "! Reset transactional buffer
      teardown.


    METHODS:
      "! Calls { @link ..lhc_booking.METH:validate_travel_status }
      "! and checks if a pair of status is valid.
      validatestatus_success        FOR TESTING RAISING cx_static_check,

      "! Calls { @link ..lhc_booking.METH:validate_travel_status }
      "! and checks if invalid permutations of sets of status
      "! returns messages.
      validatestatus_not_valid      FOR TESTING RAISING cx_static_check,

      "! Calls { @link ..lhc_booking.METH:get_instance_features }
      "! using travels with an <em>accepted</em>, <em>rejected</em>,
      "! <em>open</em> and unknown status.
      get_instance_features        FOR TESTING RAISING cx_static_check,

      "! Checks if { @link ..lhc_booking.METH:earlynumbering_cba_booksupplem }
      "! draws a new number for instances where no number is drawn yet.
      earlynumbering_cba_new_number     FOR TESTING RAISING cx_static_check,

      "! Checks if { @link ..lhc_booking.METH:calculatetotalprice }
      "! calculates the total_price correctly by triggering an action.
      calculatetotalprice     FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_booking IMPLEMENTATION.

  METHOD class_setup.
    CREATE OBJECT class_under_test FOR TESTING.
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds(
                               VALUE #(
                                   ( i_for_entity = 'ZI_Travel_M'            )
                                   ( i_for_entity = 'ZI_Booking_M'           )
                                   ( i_for_entity = 'ZI_BookSuppl_M' )
                                 )
                             ).
    cds_test_environment->enable_double_redirection(  ).
    sql_test_environment = cl_osql_test_environment=>create(
                               VALUE #(
                                   ( 'ZCUSTOMER' )
                                   ( 'ZAGENCY' )
                                 )
                               ).
  ENDMETHOD.

  METHOD setup.
    cds_test_environment->clear_doubles( ).
    sql_test_environment->clear_doubles( ).

    DATA:
      travel_mock_data TYPE STANDARD TABLE OF ztravel_m.

    travel_mock_data = VALUE #(
        ( travel_id = travel_id1  currency_code = c_currency )
        ( travel_id = travel_id2  currency_code = c_currency )
        ( travel_id = travel_id3  currency_code = c_currency )
        ( travel_id = travel_id4  currency_code = c_currency )
      ).
    cds_test_environment->insert_test_data( travel_mock_data ).
  ENDMETHOD.

  METHOD teardown.
    ROLLBACK ENTITIES.                                 "#EC CI_ROLLBACK
  ENDMETHOD.

  METHOD class_teardown.
    cds_test_environment->destroy( ).
    sql_test_environment->destroy( ).
  ENDMETHOD.


  METHOD validatestatus_success.
    DATA:
      booking_mock_data TYPE STANDARD TABLE OF zbooking_m,
      bookings_to_test  TYPE TABLE FOR VALIDATION zi_travel_m\\booking~validatestatus,
      failed            TYPE RESPONSE FOR FAILED LATE  zi_travel_m,
      reported          TYPE RESPONSE FOR REPORTED LATE  zi_travel_m.

    booking_mock_data = VALUE #(
        travel_id = travel_id1
        ( booking_id = booking_id1  booking_status = 'N' )
        ( booking_id = booking_id2  booking_status = 'X' )
        ( booking_id = booking_id3  booking_status = 'B' )
      ).
    cds_test_environment->insert_test_data( booking_mock_data ).

    bookings_to_test = CORRESPONDING #( booking_mock_data ).

    class_under_test->validatestatus(
        EXPORTING
          keys     = bookings_to_test
        CHANGING
          failed   = failed
          reported = reported
      ).
    cl_abap_unit_assert=>assert_initial( reported ).
    cl_abap_unit_assert=>assert_initial( failed   ).
  ENDMETHOD.

  METHOD validatestatus_not_valid.
    DATA:
      booking_mock_data TYPE STANDARD TABLE OF zbooking_m,
      bookings_to_test  TYPE TABLE FOR VALIDATION zi_travel_m\\booking~validatestatus,
      failed            TYPE RESPONSE FOR FAILED LATE  zi_travel_m,
      reported          TYPE RESPONSE FOR REPORTED LATE  zi_travel_m.

    booking_mock_data = VALUE #(
        ( travel_id = travel_id1  booking_id = booking_id1  booking_status = 'K' )
      ).
    cds_test_environment->insert_test_data( booking_mock_data ).

    bookings_to_test = CORRESPONDING #( booking_mock_data ).

    class_under_test->validatestatus(
        EXPORTING
          keys     = bookings_to_test
        CHANGING
          failed   = failed
          reported = reported
      ).

    cl_abap_unit_assert=>assert_not_initial( failed ).
    cl_abap_unit_assert=>assert_equals(
        exp = 1
        act = lines( failed-booking )
      ).

    cl_abap_unit_assert=>assert_equals(
        exp = travel_id1
        act = failed-booking[ 1 ]-travel_id
      ).

    cl_abap_unit_assert=>assert_equals(
        exp = booking_id1
        act = failed-booking[ 1 ]-booking_id
      ).

    cl_abap_unit_assert=>assert_not_initial( reported ).
    cl_abap_unit_assert=>assert_equals(
        exp = 1
        act = lines( reported-booking )
      ).

    cl_abap_unit_assert=>assert_equals(
        exp = travel_id1
        act = reported-booking[ 1 ]-travel_id
      ).

    cl_abap_unit_assert=>assert_equals(
        exp = booking_id1
        act = reported-booking[ 1 ]-booking_id
      ).

    TYPES: reported_booking LIKE LINE OF reported-booking.
    DATA: exp_reported_element TYPE reported_booking-%element.
    exp_reported_element-booking_status = if_abap_behv=>mk-on.
    cl_abap_unit_assert=>assert_equals(
        exp = exp_reported_element
        act = reported-booking[ 1 ]-%element
      ).
  ENDMETHOD.

  METHOD get_instance_features.
    TYPES: t_instance_feature TYPE STRUCTURE FOR INSTANCE FEATURES RESULT zi_travel_m\\booking,
           BEGIN OF t_check.
             INCLUDE TYPE t_instance_feature.
    TYPES: booking_status TYPE zi_booking_m-booking_status,
           END OF t_check,
           t_check_table TYPE STANDARD TABLE OF t_check WITH KEY travel_id.

    DATA:
      check_table        TYPE t_check_table,
      booking_mock_data  TYPE STANDARD TABLE OF zbooking_m,
      travels_to_test    TYPE TABLE FOR INSTANCE FEATURES KEY zi_travel_m\\booking,
      requested_features TYPE STRUCTURE FOR INSTANCE FEATURES REQUEST zi_travel_m\\booking,
      act_result         TYPE TABLE FOR INSTANCE FEATURES RESULT zi_travel_m\\booking,
      exp_result         TYPE TABLE FOR INSTANCE FEATURES RESULT zi_travel_m\\booking,
      reported           TYPE RESPONSE FOR REPORTED EARLY zi_travel_m,
      failed             TYPE RESPONSE FOR FAILED   EARLY zi_travel_m.

    " In current implementation requested_features is not used.
    requested_features = VALUE #( ).

    check_table = VALUE t_check_table(
        (
          travel_id              = travel_id1
          booking_id             = booking_id1
          booking_status         = 'B'
          %assoc-_booksupplement = if_abap_behv=>fc-o-disabled
        )
        (
          travel_id              = travel_id1
          booking_id             = booking_id2
          booking_status         = 'X'
          %assoc-_booksupplement = if_abap_behv=>fc-o-enabled
        )
        (
          travel_id              = travel_id1
          booking_id             = booking_id3
          booking_status         = 'N'
          %assoc-_booksupplement = if_abap_behv=>fc-o-enabled
        )
        (
          travel_id              = travel_id1
          booking_id             = booking_id4
          booking_status         = 'T'
          %assoc-_booksupplement = if_abap_behv=>fc-o-enabled
        )
      ).

    booking_mock_data = CORRESPONDING #(
                          check_table
                          MAPPING
                            travel_id      = travel_id
                            booking_id     = booking_id
                            booking_status = booking_status
                          EXCEPT *
                        ).
    cds_test_environment->insert_test_data( booking_mock_data ).

    travels_to_test = CORRESPONDING #( check_table ).

    exp_result = CORRESPONDING #( check_table ).

    class_under_test->get_features(
      EXPORTING
        keys               = travels_to_test
        requested_features = requested_features
      CHANGING
        result             = act_result
        failed             = failed
        reported           = reported
    ).

    cl_abap_unit_assert=>assert_initial( reported ).
    cl_abap_unit_assert=>assert_initial( failed   ).

    SORT act_result BY travel_id ASCENDING.
    SORT exp_result BY travel_id ASCENDING.

    cl_abap_unit_assert=>assert_equals(
        exp = exp_result
        act = act_result
      ).
  ENDMETHOD.

  METHOD earlynumbering_cba_new_number.
    DATA:
      booking_mock_data            TYPE STANDARD TABLE OF zbooking_m,
      booking_supplement_mock_data TYPE STANDARD TABLE OF zbooksuppl_m,
      exp_travel_read              TYPE TABLE FOR READ RESULT zi_travel_m\\booking,
      mapped                       TYPE RESPONSE FOR MAPPED EARLY  zi_travel_m,
      failed                       TYPE RESPONSE FOR FAILED EARLY  zi_travel_m,
      reported                     TYPE RESPONSE FOR REPORTED EARLY  zi_travel_m,
      entities                     TYPE TABLE FOR CREATE zi_travel_m\\booking\_booksupplement.

    booking_mock_data = VALUE #(
        travel_id = travel_id1
        ( booking_id = booking_id1 ) "no existing booking_supplement_supplements and no number provided
        ( booking_id = booking_id2 ) "no existing booking_supplement_supplements but some numbers provided
        ( booking_id = booking_id3 ) "existing booking_supplement_supplements
        ( booking_id = booking_id4 ) "existing booking_supplement_supplements and some numbers provided
      ).
    cds_test_environment->insert_test_data( booking_mock_data ).

    booking_supplement_mock_data = VALUE #(
        travel_id = travel_id1
        ( booking_id   = booking_id3  booking_supplement_id = '1' )
        ( booking_id   = booking_id4  booking_supplement_id = '2' )
      ).
    cds_test_environment->insert_test_data( booking_supplement_mock_data ).

    entities = VALUE #(
        travel_id = travel_id1
        (
          booking_id = booking_id1  "no existing booking_supplements and no number provided
          %target   = VALUE #(
              ( %cid = '1b1' )
            )
        )
        (
          booking_id = booking_id2  "no existing booking_supplements but some numbers provided
          %target   = VALUE #(
              ( %cid = '2b1' )
              ( %cid = '2b2'  booking_supplement_id = '1' )
            )
        )
        (
          booking_id = booking_id3  "existing booking_supplements
          %target   = VALUE #(
              ( %cid = '3b1' )
            )
        )
        (
          booking_id = booking_id4  "existing booking_supplements and some numbers provided
          %target   = VALUE #(
              ( %cid = '4b1' )
              ( %cid = '4b2'  booking_supplement_id = '1' )
              ( %cid = '4b3'  booking_supplement_id = '3' )
            )
        )
      ).

    class_under_test->earlynumbering_cba_booksupplem(
        EXPORTING
          entities = entities
        CHANGING
          mapped   = mapped
          failed   = failed
          reported = reported
      ).

    cl_abap_unit_assert=>assert_initial( failed   ).
    cl_abap_unit_assert=>assert_initial( reported ).
    cl_abap_unit_assert=>assert_initial( mapped-travel ).
    cl_abap_unit_assert=>assert_initial( mapped-booking ).
    cl_abap_unit_assert=>assert_not_initial( mapped-booksuppl ).

    cl_abap_unit_assert=>assert_equals(
        exp = REDUCE #( INIT i = 0
                        FOR booking IN entities
                        NEXT i += lines( booking-%target ) )
        act = lines( mapped-booksuppl )
      ).

    cl_abap_unit_assert=>assert_equals(
        exp = CONV zbooking_supplement_id( '1' )
        act = VALUE zbooking_supplement_id( mapped-booksuppl[ %cid = '1b1' ]-booking_supplement_id )
      ).

    cl_abap_unit_assert=>assert_equals(
        exp = CONV zbooking_supplement_id( '2' )
        act = VALUE zbooking_supplement_id( mapped-booksuppl[ %cid = '2b1' ]-booking_supplement_id )
      ).

    cl_abap_unit_assert=>assert_equals(
        exp = CONV zbooking_supplement_id( '2' )
        act = VALUE zbooking_supplement_id( mapped-booksuppl[ %cid = '3b1' ]-booking_supplement_id )
      ).

    cl_abap_unit_assert=>assert_equals(
        exp = CONV zbooking_supplement_id( '4' )
        act = VALUE zbooking_supplement_id( mapped-booksuppl[ %cid = '4b1' ]-booking_supplement_id )
      ).
  ENDMETHOD.

  METHOD calculatetotalprice.
    CONSTANTS:
      c_flight_price TYPE zflight_price VALUE '10'.

    DATA:
      booking_mock_data TYPE STANDARD TABLE OF zbooking_m,
      reported          TYPE RESPONSE FOR REPORTED LATE  zi_travel_m.

    booking_mock_data = VALUE #(
        flight_price  = c_flight_price
        currency_code = c_currency
        travel_id     = travel_id1
        ( booking_id = booking_id1 )
        ( booking_id = booking_id2 )
        ( booking_id = booking_id3 )
      ).
    cds_test_environment->insert_test_data( booking_mock_data ).


    class_under_test->calculatetotalprice(
       EXPORTING
         keys     = CORRESPONDING #( booking_mock_data )
       CHANGING
         reported = reported
     ).

    cl_abap_unit_assert=>assert_initial( reported ).


    READ ENTITIES OF zi_travel_m
      ENTITY travel
        FIELDS ( total_price ) WITH VALUE #( ( travel_id = travel_id1 ) )
        RESULT DATA(read_result).

    cl_abap_unit_assert=>assert_not_initial( read_result ).

    cl_abap_unit_assert=>assert_equals(
        exp = CONV ztotal_price( c_flight_price * lines( booking_mock_data ) )
        act = read_result[ 1 ]-total_price
      ).
  ENDMETHOD.

ENDCLASS.