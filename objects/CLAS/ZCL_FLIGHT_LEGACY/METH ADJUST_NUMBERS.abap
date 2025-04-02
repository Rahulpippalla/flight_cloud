  METHOD adjust_numbers.
    et_travel_mapping       = lcl_travel_buffer=>get_instance( )->adjust_numbers( ).
    et_booking_mapping      = lcl_booking_buffer=>get_instance( )->adjust_numbers( et_travel_mapping ).
    et_bookingsuppl_mapping = lcl_booking_supplement_buffer=>get_instance( )->adjust_numbers( et_booking_mapping ).
  ENDMETHOD.