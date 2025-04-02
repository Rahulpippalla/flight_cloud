  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor(  previous = previous ) .

    me->mv_attr1                 = attr1.
    me->mv_attr2                 = attr2.
    me->mv_attr3                 = attr3.
    me->mv_attr4                 = attr4.
    me->mv_travel_id             = travel_id.
    me->mv_booking_id            = booking_id.
    me->mv_booking_supplement_id = booking_supplement_id.
    me->mv_agency_id             = agency_id.
    me->mv_customer_id           = customer_id.
    me->mv_carrier_id            = carrier_id.
    me->mv_connection_id         = connection_id.
    me->mv_supplement_id         = supplement_id.
    me->mv_begin_date            = begin_date.
    me->mv_end_date              = end_date.
    me->mv_booking_date          = booking_date.
    me->mv_flight_date           = flight_date.
    me->mv_status                = status.
    me->mv_currency_code         = currency_code.
    me->mv_uname                 = uname.


    if_abap_behv_message~m_severity = severity.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.