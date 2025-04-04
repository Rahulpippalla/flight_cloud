CLASS ltcl_handler_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CONSTANTS:
      fm_delete TYPE sxco_fm_name VALUE 'ZFLIGHT_TRAVEL_DELETE',
      fm_read   TYPE sxco_fm_name VALUE 'ZFLIGHT_TRAVEL_READ',
      fm_update TYPE sxco_fm_name VALUE 'ZFLIGHT_TRAVEL_UPDATE'.

    CONSTANTS:
      cid                   TYPE abp_behv_cid     VALUE '42',
      travel_id             TYPE Ztravel_id   VALUE '1337',
      agency_id             TYPE Zagency_id   VALUE '42',
      customer_id           TYPE Zcustomer_id VALUE '123',
      booking_id            TYPE Zbooking_id  VALUE '20',
      carrier_id            TYPE Zcarrier_id  VALUE 'XX',
      booking_supplement_id TYPE Zbooking_supplement_id VALUE '21',
      supplement_id         TYPE Zsupplement_id VALUE 'XX-42'.

    CLASS-DATA:
      fm_test_environment TYPE REF TO if_function_test_environment.

    DATA:
      behavior_handler TYPE REF TO lhc_booking,
      mapped           TYPE RESPONSE FOR MAPPED EARLY Zi_travel_u,
      failed           TYPE RESPONSE FOR FAILED EARLY Zi_travel_u,
      reported         TYPE RESPONSE FOR REPORTED EARLY Zi_travel_u,
      mapped_line      LIKE LINE OF mapped-booking,
      failed_line      LIKE LINE OF failed-booking,
      reported_line    LIKE LINE OF reported-booking,
      message          TYPE symsg,
      messages         TYPE Zt_message,
      message_obj      TYPE REF TO if_abap_behv_message.

    CLASS-METHODS:
      class_setup.

    METHODS:
      setup,
      teardown.

    METHODS:

      "! Checks if { @link ..lhc_booking.METH:read } works as expected when { @link FUNC:ZFLIGHT_TRAVEL_READ } succeeds and the <em>Booking_ID</em> is found.
      read_success                   FOR TESTING RAISING cx_static_check,
      "! Checks if { @link ..lhc_booking.METH:read } works as expected when { @link FUNC:ZFLIGHT_TRAVEL_READ } succeeds but the <em>Booking_ID</em> to be read is not found.
      read_wrong_booking_id          FOR TESTING RAISING cx_static_check,
      "! Checks if { @link ..lhc_booking.METH:read } works as expected when { @link FUNC:ZFLIGHT_TRAVEL_READ } fails.
      read_fail                      FOR TESTING RAISING cx_static_check,

      "! Checks if { @link ..lhc_booking.METH:update } works as expected when { @link FUNC:ZFLIGHT_TRAVEL_UPDATE } succeeds.
      update_success                 FOR TESTING RAISING cx_static_check,
      "! Checks if { @link ..lhc_booking.METH:update } works as expected when { @link FUNC:ZFLIGHT_TRAVEL_UPDATE } fails.
      update_fail                    FOR TESTING RAISING cx_static_check,

      "! Checks if { @link ..lhc_booking.METH:delete } works as expected when { @link FUNC:ZFLIGHT_TRAVEL_UPDATE } succeeds.
      delete_success                 FOR TESTING RAISING cx_static_check,
      "! Checks if { @link ..lhc_booking.METH:delete } works as expected when { @link FUNC:ZFLIGHT_TRAVEL_UPDATE } fails.
      delete_fail                    FOR TESTING RAISING cx_static_check,

      "! Checks if { @link ..lhc_booking.METH:rba_Travel } works as expected when { @link FUNC:ZFLIGHT_TRAVEL_READ } succeeds.
      rba_travel_success             FOR TESTING RAISING cx_static_check,
      "! Checks if { @link ..lhc_booking.METH:rba_Travel } works as expected when { @link FUNC:ZFLIGHT_TRAVEL_READ } fails.
      rba_travel_fail                FOR TESTING RAISING cx_static_check,

      "! Checks if { @link ..lhc_booking.METH:rba_Booksupplement } works as expected when { @link FUNC:ZFLIGHT_TRAVEL_READ } succeeds.
      rba_bookingsupplement_success  FOR TESTING RAISING cx_static_check,
      "! Checks if { @link ..lhc_booking.METH:rba_Booksupplement } works as expected when { @link FUNC:ZFLIGHT_TRAVEL_READ } fails.
      rba_bookingsupplement_fail     FOR TESTING RAISING cx_static_check,

      "! Checks if { @link ..lhc_booking.METH:cba_booksupplement } works as expected when { @link FUNC:ZFLIGHT_TRAVEL_READ } and { @link FUNC:ZFLIGHT_TRAVEL_UPDATE } both succeeds.
      cba_success                    FOR TESTING RAISING cx_static_check,
      "! Checks if { @link ..lhc_booking.METH:cba_booksupplement } works as expected when { @link FUNC:ZFLIGHT_TRAVEL_READ } fails.
      cba_fail_read                  FOR TESTING RAISING cx_static_check,
      "! Checks if { @link ..lhc_booking.METH:cba_booksupplement } works as expected when { @link FUNC:ZFLIGHT_TRAVEL_READ } succeeds but { @link FUNC:ZFLIGHT_TRAVEL_UPDATE } fails.
      cba_fail_update                FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_handler_test IMPLEMENTATION.

  METHOD class_setup.
    fm_test_environment = cl_function_test_environment=>create( function_modules = VALUE #(
          ( fm_delete      )
          ( fm_read        )
          ( fm_update      )
        )
      ).
  ENDMETHOD.

  METHOD setup.
    CLEAR:
      behavior_handler,
      message,
      messages,
      message_obj,
      mapped,
      failed,
      reported,
      mapped_line,
      failed_line,
      reported_line.

    CREATE OBJECT behavior_handler FOR TESTING.
    message = VALUE symsg(
        msgty = 'E'
        msgid = 'CM_TEST'
        msgno = '123'
      ).
    messages = VALUE Zt_message( ( message ) ).
    message_obj = behavior_handler->new_message(
                      id       = message-msgid
                      number   = message-msgno
                      severity = CONV #( message-msgty )
                    ).
  ENDMETHOD.

  METHOD teardown.
    fm_test_environment->clear_doubles( ).
    CLEAR: behavior_handler.
  ENDMETHOD.

  METHOD read_success.
    DATA:
      keys        TYPE TABLE     FOR READ IMPORT Zi_travel_u\\Booking,
      result      TYPE TABLE     FOR READ RESULT Zi_travel_u\\Booking,
      result_line TYPE STRUCTURE FOR READ RESULT Zi_travel_u\\Booking,
      bookings    TYPE Zt_booking.

    DATA(travel) = VALUE Ztravel(
                       travel_id   = travel_id
                       agency_id   = agency_id
                       customer_id = customer_id
                     ).
    DATA(booking) = VALUE Zbooking(
                       travel_id   = travel_id
                       booking_id  = booking_id
                       customer_id = customer_id
                       carrier_id  = carrier_id
                     ).
    APPEND booking TO bookings.
    result_line = CORRESPONDING #( booking MAPPING TO ENTITY ).

    DATA(fm_rba_double) = fm_test_environment->get_double( fm_read ).

    DATA(fm_rba_double_input)  = fm_rba_double->create_input_configuration(
                                      )->set_importing_parameter(
                                        name  = 'IV_TRAVEL_ID'
                                        value = travel_id
                                      ).
    DATA(fm_rba_double_output_succ) = fm_rba_double->create_output_configuration(
                                       )->set_exporting_parameter(
                                         name  = 'ES_TRAVEL'
                                         value = travel
                                       )->set_exporting_parameter(
                                         name  = 'ET_BOOKING'
                                         value = bookings
                                       ).

    DATA(fm_rba_double_output_msgs) = fm_rba_double->create_output_configuration( )->set_exporting_parameter( name  = 'ET_MESSAGES'  value = messages ).

    fm_rba_double->configure_call( )->when( fm_rba_double_input
                                      )->then_set_output( fm_rba_double_output_succ
                                      )->for_times( 1
                                      )->then_set_output( fm_rba_double_output_msgs
                                      ).

    keys = VALUE #( ( TravelID = travel_id  BookingID = booking_id ) ).

    behavior_handler->read(
        EXPORTING
          keys = keys
        CHANGING
          result   = result
          failed   = failed
          reported = reported
      ).

    cl_abap_unit_assert=>assert_initial( failed ).
    cl_abap_unit_assert=>assert_initial( reported ).

    cl_abap_unit_assert=>assert_not_initial( result ).
    cl_abap_unit_assert=>assert_equals(
        act = result[ 1 ]
        exp = result_line
      ).
  ENDMETHOD.

  METHOD read_wrong_booking_id.
    DATA:
      keys        TYPE TABLE     FOR READ IMPORT Zi_travel_u\\Booking,
      result      TYPE TABLE     FOR READ RESULT Zi_travel_u\\Booking,
      result_line TYPE STRUCTURE FOR READ RESULT Zi_travel_u\\Booking,
      bookings    TYPE Zt_booking.

    DATA(travel) = VALUE Ztravel(
                       travel_id   = travel_id
                       agency_id   = agency_id
                       customer_id = customer_id
                     ).
    DATA(booking) = VALUE Zbooking(
                       travel_id   = travel_id
                       booking_id  = booking_id
                       customer_id = customer_id
                       carrier_id  = carrier_id
                     ).
    APPEND booking TO bookings.

    DATA(fm_rba_double) = fm_test_environment->get_double( fm_read ).

    DATA(fm_rba_double_input)  = fm_rba_double->create_input_configuration(
                                      )->set_importing_parameter(
                                        name  = 'IV_TRAVEL_ID'
                                        value = travel_id
                                      ).
    DATA(fm_rba_double_output_succ) = fm_rba_double->create_output_configuration(
                                       )->set_exporting_parameter(
                                         name  = 'ES_TRAVEL'
                                         value = travel
                                       )->set_exporting_parameter(
                                         name  = 'ET_BOOKING'
                                         value = bookings
                                       ).

    DATA(fm_rba_double_output_msgs) = fm_rba_double->create_output_configuration( )->set_exporting_parameter( name  = 'ET_MESSAGES'  value = messages ).

    fm_rba_double->configure_call( )->when( fm_rba_double_input
                                      )->then_set_output( fm_rba_double_output_succ
                                      )->for_times( 1
                                      )->then_set_output( fm_rba_double_output_msgs
                                      ).

    keys = VALUE #( ( TravelID = travel_id  BookingID = booking_id + 1 ) ).

    behavior_handler->read(
        EXPORTING
          keys = keys
        CHANGING
          result   = result
          failed   = failed
          reported = reported
      ).

    cl_abap_unit_assert=>assert_initial( result ).
    cl_abap_unit_assert=>assert_initial( reported ).

    cl_abap_unit_assert=>assert_not_initial( failed-booking ).
    failed_line = VALUE #(
        TravelID    = travel_id
        BookingID   = booking_id + 1
        %fail-cause = if_abap_behv=>cause-not_found
      ).
    cl_abap_unit_assert=>assert_equals(
        act = failed-booking[ 1 ]
        exp = failed_line
      ).
  ENDMETHOD.

  METHOD read_fail.
    DATA:
      keys   TYPE TABLE FOR READ IMPORT Zi_travel_u\\Booking,
      result TYPE TABLE FOR READ RESULT Zi_travel_u\\Booking.


    DATA(fm_read_double) = fm_test_environment->get_double( fm_read ).

    DATA(fm_read_double_output) = fm_read_double->create_output_configuration( )->set_exporting_parameter( name  = 'ET_MESSAGES'  value = messages ).

    fm_read_double->configure_call( )->ignore_all_parameters( )->then_set_output( fm_read_double_output ).

    keys = VALUE #( ( TravelID = travel_id  BookingID = booking_id ) ).

    behavior_handler->read(
        EXPORTING
          keys = keys
        CHANGING
          result   = result
          failed   = failed
          reported = reported
      ).

    cl_abap_unit_assert=>assert_initial( mapped ).

    cl_abap_unit_assert=>assert_not_initial( failed-booking ).
    cl_abap_unit_assert=>assert_not_initial( reported-booking ).

    failed_line = VALUE #( TravelID = travel_id  bookingID = booking_id  %fail-cause = if_abap_behv=>cause-unspecific ).
    cl_abap_unit_assert=>assert_equals( exp = failed_line
                                        act = failed-booking[ 1 ] ).

    cl_abap_unit_assert=>assert_equals( exp = booking_id
                                        act = reported-booking[ 1 ]-bookingID ).

    cl_abap_unit_assert=>assert_equals( exp = message-msgty
                                        act = reported-booking[ 1 ]-%msg->if_t100_dyn_msg~msgty ).

  ENDMETHOD.

  METHOD update_success.
    DATA:
      entities    TYPE TABLE FOR UPDATE Zi_travel_u\\booking.

    DATA(fm_update_double) = fm_test_environment->get_double( fm_update ).

    DATA(travel)    = VALUE Zs_travel_in(  travel_id = travel_id ).
    DATA(travelx)   = VALUE Zs_travel_inx( travel_id = travel_id ).
    DATA(bookings)  = VALUE Zt_booking_in( (
                           travel_id   = travel_id
                           booking_id  = booking_id
                           customer_id = customer_id
                           carrier_id  = carrier_id
                         ) ).
    DATA(bookingsx) = VALUE Zt_booking_inx( (
                           action_code = Zif_flight_legacy=>action_code-update
                           booking_id  = booking_id
                           customer_id = customer_id
                           carrier_id  = carrier_id
                         ) ).

    DATA(fm_update_double_input)  = fm_update_double->create_input_configuration(
                                      )->set_importing_parameter(
                                        name  = 'IS_TRAVEL'
                                        value = travel
                                      )->set_importing_parameter(
                                        name  = 'IS_TRAVELX'
                                        value = travelx
                                      )->set_importing_parameter(
                                        name  = 'IT_BOOKING'
                                        value = bookings
                                      )->set_importing_parameter(
                                        name  = 'IT_BOOKINGX'
                                        value = bookingsx
                                      ).
    DATA(fm_update_double_output_succ) = fm_update_double->create_output_configuration( ).

    DATA(fm_update_double_output_msgs) = fm_update_double->create_output_configuration( )->set_exporting_parameter( name  = 'ET_MESSAGES'  value = messages ).

    fm_update_double->configure_call( )->when( fm_update_double_input
                                      )->then_set_output( fm_update_double_output_succ
                                      )->for_times( 1
                                      )->then_set_output( fm_update_double_output_msgs
                                      ).

    entities = VALUE #( (
                          TravelID   = travel_id
                          BookingID  = booking_id
                          CustomerID = customer_id
                          AirlineID  = carrier_id
                          %control   = VALUE #(
                                                  TravelID   = if_abap_behv=>mk-on
                                                  BookingID  = if_abap_behv=>mk-on
                                                  CustomerID = if_abap_behv=>mk-on
                                                  AirlineID  = if_abap_behv=>mk-on
                                              )
                       ) ).

    behavior_handler->update(
        EXPORTING
          entities = entities
        CHANGING
          mapped   = mapped
          failed   = failed
          reported = reported
      ).

    cl_abap_unit_assert=>assert_initial( failed ).
    cl_abap_unit_assert=>assert_initial( reported ).
  ENDMETHOD.

  METHOD update_fail.
    DATA(fm_update_double) = fm_test_environment->get_double( fm_update ).

    DATA(fm_update_double_output) = fm_update_double->create_output_configuration( )->set_exporting_parameter( name  = 'ET_MESSAGES'  value = messages ).

    fm_update_double->configure_call( )->ignore_all_parameters( )->then_set_output( fm_update_double_output ).

    behavior_handler->update(
        EXPORTING
          entities = VALUE #( ( TravelID = travel_id  BookingID = booking_id ) )
        CHANGING
          mapped   = mapped
          failed   = failed
          reported = reported
      ).

    cl_abap_unit_assert=>assert_initial( mapped ).

    cl_abap_unit_assert=>assert_not_initial( failed-booking ).
    cl_abap_unit_assert=>assert_not_initial( reported-booking ).

    failed_line = VALUE #( TravelID = travel_id  bookingID = booking_id  %fail-cause = if_abap_behv=>cause-unspecific ).
    cl_abap_unit_assert=>assert_equals( exp = failed_line
                                        act = failed-booking[ 1 ] ).

    cl_abap_unit_assert=>assert_equals( exp = booking_id
                                        act = reported-booking[ 1 ]-bookingID ).

    cl_abap_unit_assert=>assert_equals( exp = message-msgty
                                        act = reported-booking[ 1 ]-%msg->if_t100_dyn_msg~msgty ).
  ENDMETHOD.

  METHOD delete_success.

    DATA(fm_update_double) = fm_test_environment->get_double( fm_update ).

    DATA(travel)    = VALUE Zs_travel_in(     travel_id = travel_id ).
    DATA(travelx)   = VALUE Zs_travel_inx(    travel_id = travel_id ).
    DATA(bookings)  = VALUE Zt_booking_in( (  travel_id = travel_id                                    booking_id = booking_id ) ).
    DATA(bookingsx) = VALUE Zt_booking_inx( ( action_code = Zif_flight_legacy=>action_code-delete  booking_id = booking_id ) ).

    DATA(fm_update_double_input)  = fm_update_double->create_input_configuration(
                                      )->set_importing_parameter(
                                        name  = 'IS_TRAVEL'
                                        value = travel
                                      )->set_importing_parameter(
                                        name  = 'IS_TRAVELX'
                                        value = travelx
                                      )->set_importing_parameter(
                                        name  = 'IT_BOOKING'
                                        value = bookings
                                      )->set_importing_parameter(
                                        name  = 'IT_BOOKINGX'
                                        value = bookingsx
                                      ).
    DATA(fm_update_double_output_succ) = fm_update_double->create_output_configuration( ).

    DATA(fm_update_double_output_msgs) = fm_update_double->create_output_configuration( )->set_exporting_parameter( name  = 'ET_MESSAGES'  value = messages ).

    fm_update_double->configure_call( )->when( fm_update_double_input
                                      )->then_set_output( fm_update_double_output_succ
                                      )->for_times( 1
                                      )->then_set_output( fm_update_double_output_msgs
                                      ).


    behavior_handler->delete(
        EXPORTING
          keys     = VALUE #( ( TravelID = travel_id  BookingID = booking_id ) )
        CHANGING
          mapped   = mapped
          failed   = failed
          reported = reported
      ).

    cl_abap_unit_assert=>assert_initial( mapped ).
    cl_abap_unit_assert=>assert_initial( failed ).
    cl_abap_unit_assert=>assert_initial( reported ).
  ENDMETHOD.

  METHOD delete_fail.
    DATA(fm_update_double) = fm_test_environment->get_double( fm_update ).

    DATA(fm_update_double_output) = fm_update_double->create_output_configuration( )->set_exporting_parameter( name  = 'ET_MESSAGES'  value = messages ).

    fm_update_double->configure_call( )->ignore_all_parameters( )->then_set_output( fm_update_double_output ).

    behavior_handler->delete(
        EXPORTING
          keys     = VALUE #( ( TravelID = travel_id  BookingID = booking_id ) )
        CHANGING
          mapped   = mapped
          failed   = failed
          reported = reported
      ).

    cl_abap_unit_assert=>assert_initial( mapped ).

    cl_abap_unit_assert=>assert_not_initial( failed-booking ).
    cl_abap_unit_assert=>assert_not_initial( reported-booking ).

    failed_line = VALUE #( TravelID = travel_id  bookingID = booking_id  %fail-cause = if_abap_behv=>cause-unspecific ).
    cl_abap_unit_assert=>assert_equals( exp = failed_line
                                        act = failed-booking[ 1 ] ).

    cl_abap_unit_assert=>assert_equals( exp = booking_id
                                        act = reported-booking[ 1 ]-bookingID ).

    cl_abap_unit_assert=>assert_equals( exp = message-msgty
                                        act = reported-booking[ 1 ]-%msg->if_t100_dyn_msg~msgty ).

  ENDMETHOD.

  METHOD rba_travel_success.
    DATA:
      keys                   TYPE TABLE     FOR READ IMPORT Zi_travel_u\\Booking\_Travel,
      result                 TYPE TABLE     FOR READ RESULT Zi_travel_u\\Booking\_Travel,
      result_line            TYPE STRUCTURE FOR READ RESULT Zi_travel_u\\Booking\_Travel,
      association_links      TYPE TABLE     FOR READ LINK   Zi_travel_u\\Booking\_Travel,
      association_links_line TYPE STRUCTURE FOR READ LINK   Zi_travel_u\\Booking\_Travel.

    DATA(travel) = VALUE Ztravel(
                       travel_id   = travel_id
                       agency_id   = agency_id
                       customer_id = customer_id
                     ).
    result_line = CORRESPONDING #( travel MAPPING TO ENTITY ).

    DATA(fm_read_double) = fm_test_environment->get_double( fm_read ).

    DATA(fm_read_double_input)  = fm_read_double->create_input_configuration(
                                      )->set_importing_parameter(
                                        name  = 'IV_TRAVEL_ID'
                                        value = travel_id
                                      ).
    DATA(fm_read_double_output_succ) = fm_read_double->create_output_configuration(
                                       )->set_exporting_parameter(
                                         name  = 'ES_TRAVEL'
                                         value = travel
                                       ).

    DATA(fm_read_double_output_msgs) = fm_read_double->create_output_configuration( )->set_exporting_parameter( name  = 'ET_MESSAGES'  value = messages ).

    fm_read_double->configure_call( )->when( fm_read_double_input
                                      )->then_set_output( fm_read_double_output_succ
                                      )->for_times( 1
                                      )->then_set_output( fm_read_double_output_msgs
                                      ).

    keys = VALUE #( (
        TravelID  = travel_id
        BookingID = booking_id
        %control  = VALUE #(
                        AgencyID   = if_abap_behv=>mk-on
                        CustomerID = if_abap_behv=>mk-on
                      )
      ) ).

    behavior_handler->rba_travel(
        EXPORTING
          keys_rba          = keys
          result_requested  = abap_true
        CHANGING
          result            = result
          association_links = association_links
          failed            = failed
          reported          = reported
      ).

    cl_abap_unit_assert=>assert_initial( failed ).
    cl_abap_unit_assert=>assert_initial( reported ).

    cl_abap_unit_assert=>assert_not_initial( result ).

    " As it is allowed to return more filled fields than requested, field wise compare is applied.
    cl_abap_unit_assert=>assert_equals(
        act = result[ 1 ]-AgencyID
        exp = agency_id
      ).
    cl_abap_unit_assert=>assert_equals(
        act = result[ 1 ]-CustomerID
        exp = customer_id
      ).

    association_links_line = VALUE #(
        source = VALUE #( TravelID = travel_id  BookingID = booking_id )
        target = VALUE #( TravelID = travel_id )
      ).

    cl_abap_unit_assert=>assert_not_initial( association_links ).
    cl_abap_unit_assert=>assert_equals(
        act = association_links[ 1 ]
        exp = association_links_line
      ).
  ENDMETHOD.

  METHOD rba_travel_fail.
    DATA:
      keys                   TYPE TABLE     FOR READ IMPORT Zi_travel_u\\Booking\_Travel,
      result                 TYPE TABLE     FOR READ RESULT Zi_travel_u\\Booking\_Travel,
      result_line            TYPE STRUCTURE FOR READ RESULT Zi_travel_u\\Booking\_Travel,
      association_links      TYPE TABLE     FOR READ LINK   Zi_travel_u\\Booking\_Travel,
      association_links_line TYPE STRUCTURE FOR READ LINK   Zi_travel_u\\Booking\_Travel.

    DATA(travel) = VALUE Ztravel(
                       travel_id   = travel_id
                       agency_id   = agency_id
                       customer_id = customer_id
                     ).
    result_line = CORRESPONDING #( travel MAPPING TO ENTITY ).

    DATA(fm_read_double) = fm_test_environment->get_double( fm_read ).

    DATA(fm_read_double_output_msgs) = fm_read_double->create_output_configuration( )->set_exporting_parameter( name  = 'ET_MESSAGES'  value = messages ).

    fm_read_double->configure_call( )->ignore_all_parameters(
                                      )->then_set_output( fm_read_double_output_msgs
                                      ).

    keys = VALUE #( (
        TravelID  = travel_id
        BookingID = booking_id
        %control  = VALUE #(
                        AgencyID   = if_abap_behv=>mk-on
                        CustomerID = if_abap_behv=>mk-on
                      )
      ) ).

    behavior_handler->rba_travel(
        EXPORTING
          keys_rba          = keys
          result_requested  = abap_true
        CHANGING
          result            = result
          association_links = association_links
          failed            = failed
          reported          = reported
      ).


    cl_abap_unit_assert=>assert_initial( result ).
    cl_abap_unit_assert=>assert_initial( association_links ).

    cl_abap_unit_assert=>assert_not_initial( failed-booking ).
    cl_abap_unit_assert=>assert_not_initial( reported-booking ).

    failed_line = VALUE #( TravelID = travel_id  bookingID = booking_id  %fail-cause = if_abap_behv=>cause-unspecific ).
    cl_abap_unit_assert=>assert_equals( exp = failed_line
                                        act = failed-booking[ 1 ] ).

    cl_abap_unit_assert=>assert_equals( exp = booking_id
                                        act = reported-booking[ 1 ]-bookingID ).

    cl_abap_unit_assert=>assert_equals( exp = message-msgty
                                        act = reported-booking[ 1 ]-%msg->if_t100_dyn_msg~msgty ).
  ENDMETHOD.

  METHOD rba_bookingsupplement_success.
    DATA:
      keys                   TYPE TABLE     FOR READ IMPORT Zi_travel_u\\Booking\_BookSupplement,
      result                 TYPE TABLE     FOR READ RESULT Zi_travel_u\\Booking\_BookSupplement,
      result_line            TYPE STRUCTURE FOR READ RESULT Zi_travel_u\\Booking\_BookSupplement,
      association_links      TYPE TABLE     FOR READ LINK   Zi_travel_u\\Booking\_BookSupplement,
      association_links_line TYPE STRUCTURE FOR READ LINK   Zi_travel_u\\Booking\_BookSupplement,
      booking_supplements    TYPE Zt_booking_supplement.

    DATA(travel) = VALUE Ztravel(
                       travel_id   = travel_id
                       agency_id   = agency_id
                       customer_id = customer_id
                     ).
    DATA(booking_supplement) = VALUE Zbook_suppl(
                       travel_id             = travel_id
                       booking_id            = booking_id
                       booking_supplement_id = booking_supplement_id
                       supplement_id         = supplement_id
                     ).
    APPEND booking_supplement TO booking_supplements.

    DATA(fm_rba_double) = fm_test_environment->get_double( fm_read ).

    DATA(fm_rba_double_input)  = fm_rba_double->create_input_configuration(
                                      )->set_importing_parameter(
                                        name  = 'IV_TRAVEL_ID'
                                        value = travel_id
                                      ).
    DATA(fm_rba_double_output_succ) = fm_rba_double->create_output_configuration(
                                       )->set_exporting_parameter(
                                         name  = 'ET_BOOKING_SUPPLEMENT'
                                         value = booking_supplements
                                       ).

    DATA(fm_rba_double_output_msgs) = fm_rba_double->create_output_configuration( )->set_exporting_parameter( name  = 'ET_MESSAGES'  value = messages ).

    fm_rba_double->configure_call( )->when( fm_rba_double_input
                                      )->then_set_output( fm_rba_double_output_succ
                                      )->for_times( 1
                                      )->then_set_output( fm_rba_double_output_msgs
                                      ).

    keys = VALUE #( ( TravelID = travel_id  BookingID = booking_id ) ).

    behavior_handler->rba_booksupplement(
      EXPORTING
        keys_rba          = keys
        result_requested  = abap_true
      CHANGING
        result            = result
        association_links = association_links
        failed            = failed
        reported          = reported
      ).

    cl_abap_unit_assert=>assert_initial( failed ).
    cl_abap_unit_assert=>assert_initial( reported ).

    cl_abap_unit_assert=>assert_not_initial( result ).

    " As it is allowed to return more filled fields than requested, field wise compare is applied.
    cl_abap_unit_assert=>assert_equals(
        act = result[ 1 ]-SupplementID
        exp = supplement_id
      ).

    association_links_line = VALUE #(
        source = VALUE #( TravelID = travel_id  BookingID = booking_id )
        target = VALUE #( TravelID = travel_id  BookingID = booking_id  BookingSupplementID = booking_supplement_id )
      ).

    cl_abap_unit_assert=>assert_not_initial( association_links ).
    cl_abap_unit_assert=>assert_equals(
        act = association_links[ 1 ]
        exp = association_links_line
      ).
  ENDMETHOD.

  METHOD rba_bookingsupplement_fail.
    DATA:
      keys              TYPE TABLE     FOR READ IMPORT Zi_travel_u\\Booking\_BookSupplement,
      result            TYPE TABLE     FOR READ RESULT Zi_travel_u\\Booking\_BookSupplement,
      result_line       TYPE STRUCTURE FOR READ RESULT Zi_travel_u\\Booking\_BookSupplement,
      association_links TYPE TABLE     FOR READ LINK   Zi_travel_u\\Booking\_BookSupplement.


    DATA(fm_rba_double) = fm_test_environment->get_double( fm_read ).

    DATA(fm_rba_double_output_msgs) = fm_rba_double->create_output_configuration( )->set_exporting_parameter( name  = 'ET_MESSAGES'  value = messages ).

    fm_rba_double->configure_call( )->ignore_all_parameters(
                                      )->then_set_output( fm_rba_double_output_msgs
                                      ).

    keys = VALUE #( ( TravelID = travel_id  BookingID = booking_id ) ).

    behavior_handler->rba_booksupplement(
      EXPORTING
        keys_rba          = keys
        result_requested  = abap_true
      CHANGING
        result            = result
        association_links = association_links
        failed            = failed
        reported          = reported
      ).

    cl_abap_unit_assert=>assert_initial( mapped ).

    cl_abap_unit_assert=>assert_not_initial( failed-booking ).
    cl_abap_unit_assert=>assert_not_initial( reported-booking ).

    failed_line = VALUE #( TravelID = travel_id  bookingID = booking_id  %fail-cause = if_abap_behv=>cause-unspecific ).
    cl_abap_unit_assert=>assert_equals( exp = failed_line
                                        act = failed-booking[ 1 ] ).

    cl_abap_unit_assert=>assert_equals( exp = booking_id
                                        act = reported-booking[ 1 ]-bookingID ).

    cl_abap_unit_assert=>assert_equals( exp = message-msgty
                                        act = reported-booking[ 1 ]-%msg->if_t100_dyn_msg~msgty ).

  ENDMETHOD.

  METHOD cba_success.
    DATA:
      entities_cba                   TYPE TABLE FOR CREATE Zi_travel_u\\Booking\_BookSupplement,
      mapped_line_booking_supplement LIKE LINE OF mapped-bookingsupplement,
      travel                         TYPE Zs_travel_in,
      travelx                        TYPE Zs_travel_inx,
      old_booking_supplement         TYPE Zbook_suppl,
      new_booking_supplement         TYPE Zs_booking_supplement_in,
      new_booking_supplementx        TYPE Zs_booking_supplement_inx,
      old_booking_supplements        TYPE Zt_booking_supplement,
      new_booking_supplements        TYPE Zt_booking_supplement_in,
      new_booking_supplementsx       TYPE Zt_booking_supplement_inx.

    travel  = VALUE Zs_travel_in(  travel_id = travel_id ).
    travelx = VALUE Zs_travel_inx( travel_id = travel_id ).

    new_booking_supplement  = VALUE Zs_booking_supplement_in(
                                   booking_id            = booking_id
                                   booking_supplement_id = booking_supplement_id + 1
                                   supplement_id         = supplement_id
                                 ).
    APPEND new_booking_supplement TO new_booking_supplements.

    old_booking_supplement  = VALUE Zbook_suppl(
                                   travel_id             = travel_id
                                   booking_id            = booking_id
                                   booking_supplement_id = booking_supplement_id
                                   supplement_id         = supplement_id
                     ).
    APPEND old_booking_supplement TO old_booking_supplements.

    new_booking_supplementx = VALUE Zs_booking_inx(
                       booking_id  = booking_id
                       action_code = Zif_flight_legacy=>action_code-create
                     ).
    APPEND new_booking_supplementx TO new_booking_supplementsx.

    " Read double
    DATA(fm_read_double) = fm_test_environment->get_double( fm_read ).

    DATA(fm_read_double_input)  = fm_read_double->create_input_configuration(
                                      )->set_importing_parameter(
                                        name  = 'IV_TRAVEL_ID'
                                        value = travel_id
                                      ).
    DATA(fm_read_double_output_succ) = fm_read_double->create_output_configuration(
                                         )->set_exporting_parameter(
                                           name  = 'ET_BOOKING_SUPPLEMENT'
                                           value = old_booking_supplements
                                         ).

    DATA(fm_read_double_output_msgs) = fm_read_double->create_output_configuration( )->set_exporting_parameter( name  = 'ET_MESSAGES'  value = messages ).

    fm_read_double->configure_call( )->when( fm_read_double_input
                                      )->then_set_output( fm_read_double_output_succ
                                      )->for_times( 1
                                      )->then_set_output( fm_read_double_output_msgs
                                      ).


    " Update double
    DATA(fm_update_double) = fm_test_environment->get_double( fm_update ).

    DATA(fm_update_double_input)  = fm_update_double->create_input_configuration(
                                      )->set_importing_parameter(
                                        name  = 'IS_TRAVEL'
                                        value = travel
                                      )->set_importing_parameter(
                                        name  = 'IS_TRAVELX'
                                        value = travelx
                                      )->set_importing_parameter(
                                        name  = 'IT_BOOKING_SUPPLEMENT'
                                        value = new_booking_supplements
                                      )->set_importing_parameter(
                                        name  = 'IT_BOOKING_SUPPLEMENTX'
                                        value = new_booking_supplementsx
                                      ).
    DATA(fm_update_double_output_succ) = fm_update_double->create_output_configuration( ).

    DATA(fm_update_double_output_msgs) = fm_update_double->create_output_configuration( )->set_exporting_parameter( name  = 'ET_MESSAGES'  value = messages ).

    fm_update_double->configure_call( )->when( fm_update_double_input
                                      )->then_set_output( fm_update_double_output_succ
                                      )->for_times( 1
                                      )->then_set_output( fm_update_double_output_msgs
                                      ).


    " Handler Call
    entities_cba = VALUE #( (
                       TravelID  = travel_id
                       BookingID = booking_id
                       %target   = VALUE #( (
                                       %cid                = cid
                                       TravelID            = travel_id
                                       BookingID           = booking_id
                                       BookingSupplementID = booking_supplement_id + 20  "on purpose to test the overwriting
                                       SupplementID        = supplement_id
                                     ) )
                     ) ).

    behavior_handler->cba_booksupplement(
        EXPORTING
          entities_cba = entities_cba
        CHANGING
          mapped       = mapped
          failed       = failed
          reported     = reported
      ).

    cl_abap_unit_assert=>assert_initial( failed ).
    cl_abap_unit_assert=>assert_initial( reported ).

    mapped_line_booking_supplement = VALUE #(
        %cid                = cid
        TravelID            = travel_id
        BookingID           = booking_id
        BookingSupplementID = booking_supplement_id + 1
      ).

    cl_abap_unit_assert=>assert_not_initial( mapped-bookingsupplement ).
    cl_abap_unit_assert=>assert_equals(
        act = mapped-bookingsupplement[ 1 ]
        exp = mapped_line_booking_supplement
      ).
  ENDMETHOD.

  METHOD cba_fail_read.
    DATA:
      entities_cba  TYPE TABLE FOR CREATE zi_travel_u\\Booking\_BookSupplement.


    DATA(fm_read_double) = fm_test_environment->get_double( fm_read ).

    DATA(fm_read_double_output) = fm_read_double->create_output_configuration( )->set_exporting_parameter( name  = 'ET_MESSAGES'  value = messages ).

    fm_read_double->configure_call( )->ignore_all_parameters( )->then_set_output( fm_read_double_output ).

    entities_cba = VALUE #( (
                       TravelID  = travel_id
                       BookingID = booking_id
                       %target   = VALUE #( (
                                       %cid                = cid
                                       TravelID            = travel_id
                                       BookingID           = booking_id
                                       BookingSupplementID = booking_supplement_id + 20  "on purpose to test the overwriting
                                       SupplementID        = supplement_id
                                     ) )
                     ) ).

    behavior_handler->cba_booksupplement(
        EXPORTING
          entities_cba = entities_cba
        CHANGING
          mapped       = mapped
          failed       = failed
          reported     = reported
      ).

    cl_abap_unit_assert=>assert_initial( mapped ).

    cl_abap_unit_assert=>assert_not_initial( failed-booking ).
    cl_abap_unit_assert=>assert_not_initial( reported-booking ).

    failed_line = VALUE #( TravelID = travel_id bookingID = booking_id  %fail-cause = if_abap_behv=>cause-unspecific ).
    cl_abap_unit_assert=>assert_equals( exp = failed_line
                                        act = failed-booking[ 1 ] ).

    cl_abap_unit_assert=>assert_equals( exp = booking_id
                                        act = reported-booking[ 1 ]-bookingID ).

    cl_abap_unit_assert=>assert_equals( exp = message-msgty
                                        act = reported-booking[ 1 ]-%msg->if_t100_dyn_msg~msgty ).

  ENDMETHOD.

  METHOD cba_fail_update.
    DATA:
      entities_cba                   TYPE TABLE FOR CREATE zi_travel_u\\Booking\_BookSupplement,
      failed_line_booking_supplement LIKE LINE OF failed-bookingsupplement,
      old_booking_supplement         TYPE zbook_suppl,
      old_booking_supplements        TYPE zt_booking_supplement.

    old_booking_supplement  = VALUE zbook_suppl(
                                   travel_id             = travel_id
                                   booking_id            = booking_id
                                   booking_supplement_id = booking_supplement_id
                                   supplement_id         = supplement_id
                     ).
    APPEND old_booking_supplement TO old_booking_supplements.


    " Read double
    DATA(fm_read_double) = fm_test_environment->get_double( fm_read ).

    DATA(fm_read_double_input)  = fm_read_double->create_input_configuration(
                                      )->set_importing_parameter(
                                        name  = 'IV_TRAVEL_ID'
                                        value = travel_id
                                      ).
    DATA(fm_read_double_output_succ) = fm_read_double->create_output_configuration(
                                         )->set_exporting_parameter(
                                           name  = 'ET_BOOKING_SUPPLEMENT'
                                           value = old_booking_supplements
                                         ).

    DATA(fm_read_double_output_msgs) = fm_read_double->create_output_configuration( )->set_exporting_parameter( name  = 'ET_MESSAGES'  value = messages ).

    fm_read_double->configure_call( )->when( fm_read_double_input
                                      )->then_set_output( fm_read_double_output_succ
                                      )->for_times( 1
                                      )->then_set_output( fm_read_double_output_msgs
                                      ).

    " Update Double
    DATA(fm_update_double) = fm_test_environment->get_double( fm_update ).

    DATA(fm_update_double_output) = fm_update_double->create_output_configuration( )->set_exporting_parameter( name  = 'ET_MESSAGES'  value = messages ).

    fm_update_double->configure_call( )->ignore_all_parameters( )->then_set_output( fm_update_double_output ).


    "Handler Call
    entities_cba = VALUE #( (
                       TravelID  = travel_id
                       BookingID = booking_id
                       %target   = VALUE #( (
                                       %cid                = cid
                                       TravelID            = travel_id
                                       BookingID           = booking_id
                                       BookingSupplementID = booking_supplement_id + 20  "on purpose to test the overwriting
                                       SupplementID        = supplement_id
                                     ) )
                     ) ).

    behavior_handler->cba_booksupplement(
        EXPORTING
          entities_cba = entities_cba
        CHANGING
          mapped       = mapped
          failed       = failed
          reported     = reported
      ).


    cl_abap_unit_assert=>assert_initial( mapped ).

    cl_abap_unit_assert=>assert_not_initial( failed-bookingsupplement ).
    cl_abap_unit_assert=>assert_not_initial( reported-bookingsupplement ).

    failed_line_booking_supplement = VALUE #(
                                        %cid        = cid
                                        %fail-cause = if_abap_behv=>cause-unspecific
                                      ).
    cl_abap_unit_assert=>assert_equals( exp = failed_line_booking_supplement
                                        act = failed-bookingsupplement[ 1 ] ).

    cl_abap_unit_assert=>assert_equals( exp = cid
                                        act = reported-bookingsupplement[ 1 ]-%cid ).

    cl_abap_unit_assert=>assert_equals( exp = message-msgty
                                        act = reported-bookingsupplement[ 1 ]-%msg->if_t100_dyn_msg~msgty ).

  ENDMETHOD.

ENDCLASS.