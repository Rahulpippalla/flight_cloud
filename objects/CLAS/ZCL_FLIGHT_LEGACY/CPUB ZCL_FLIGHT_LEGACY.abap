CLASS zcl_flight_legacy DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE
  GLOBAL FRIENDS zcl_flight_data_generator.

  PUBLIC SECTION.
    INTERFACES zif_flight_legacy.

    TYPES: BEGIN OF ENUM ty_change_mode STRUCTURE change_mode," Key checks are done separately
             create,
             update," Only fields that have been changed need to be checked
           END OF ENUM ty_change_mode STRUCTURE change_mode.

    CLASS-METHODS: get_instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_flight_legacy.

    "   With respect to the same method call of create/update/delete_travel() we have All or Nothing.
    "   I.e. when one of the levels contains an error, the complete call is refused.
    "   However, the buffer is not cleared in case of an error.
    "   I.e. when the caller wants to start over, he needs to call Initialize() explicitly.
    "   Extra Code - Conflict Creation

    METHODS set_status_to_booked IMPORTING iv_travel_id TYPE ztravel_id
                                 EXPORTING et_messages  TYPE zif_flight_legacy=>tt_if_t100_message.

    METHODS create_travel IMPORTING is_travel             TYPE zstravel_in
                                    it_booking            TYPE zt_booking_in OPTIONAL
                                    it_booking_supplement TYPE zt_booking_supplement_in OPTIONAL
                                    iv_numbering_mode     TYPE zif_flight_legacy=>t_numbering_mode DEFAULT zif_flight_legacy=>numbering_mode-early
                          EXPORTING es_travel             TYPE ztravel
                                    et_booking            TYPE zt_booking
                                    et_booking_supplement TYPE zt_booking_supplement
                                    et_messages           TYPE zif_flight_legacy=>tt_if_t100_message.
    METHODS update_travel IMPORTING is_travel              TYPE zstravel_in
                                    is_travelx             TYPE zstravel_inx
                                    it_booking             TYPE zt_booking_in OPTIONAL
                                    it_bookingx            TYPE ztbooking_inx OPTIONAL
                                    it_booking_supplement  TYPE zt_booking_supplement_in OPTIONAL
                                    it_booking_supplementx TYPE zt_booking_supplement_inx OPTIONAL
                          EXPORTING es_travel              TYPE ztravel
                                    et_booking             TYPE zt_booking
                                    et_booking_supplement  TYPE zt_booking_supplement
                                    et_messages            TYPE zif_flight_legacy=>tt_if_t100_message.
    METHODS delete_travel IMPORTING iv_travel_id TYPE ztravel_id
                          EXPORTING et_messages  TYPE zif_flight_legacy=>tt_if_t100_message.
    METHODS get_travel IMPORTING iv_travel_id           TYPE ztravel_id
                                 iv_include_buffer      TYPE abap_boolean
                                 iv_include_temp_buffer TYPE abap_boolean OPTIONAL
                       EXPORTING es_travel              TYPE ztravel
                                 et_booking             TYPE zt_booking
                                 et_booking_supplement  TYPE zt_booking_supplement
                                 et_messages            TYPE zif_flight_legacy=>tt_if_t100_message.
    METHODS adjust_numbers EXPORTING et_travel_mapping       TYPE zif_flight_legacy=>tt_ln_travel_mapping
                                     et_booking_mapping      TYPE zif_flight_legacy=>tt_ln_booking_mapping
                                     et_bookingsuppl_mapping TYPE zif_flight_legacy=>tt_ln_bookingsuppl_mapping.
    METHODS save.
    METHODS initialize.
    METHODS convert_messages IMPORTING it_messages TYPE zif_flight_legacy=>tt_if_t100_message
                             EXPORTING et_messages TYPE zt_message.