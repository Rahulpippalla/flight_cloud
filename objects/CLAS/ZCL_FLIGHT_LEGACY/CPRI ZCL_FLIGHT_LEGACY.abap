private section.

  class-data GO_INSTANCE type ref to ZCL_FLIGHT_LEGACY .

      "! Calculation of Price <br/>
      "!  <br/>
      "! Price will be calculated using distance multiplied and occupied seats.<br/>
      "! Depending on how many seats in percentage are occupied the formula <br/>
      "! 3/400·x² + 25<br/>
      "! will be applied.<br/>
      "!   0% seats occupied leads to 25% of distance as price.<br/>
      "!  75% seats occupied leads to 50% of distance as price.<br/>
      "! 100% seats occupied leads to 100% of distance as price.<br/>
      "! @parameter iv_seats_occupied_percent | occupied seats
      "! @parameter iv_flight_distance | flight distance in kilometer
      "! @parameter rv_price | calculated flight price
  class-methods CALCULATE_FLIGHT_PRICE
    importing
      !IV_SEATS_OCCUPIED_PERCENT type ZPLANE_SEATS_OCCUPIED
      !IV_FLIGHT_DISTANCE type ZFLIGHT_DISTANCE
    returning
      value(RV_PRICE) type ZFLIGHT_PRICE  ##RELAX.
  methods LOCK_TRAVEL
    importing
      !IV_LOCK type ABAP_BOOL
    raising
      ZCX_FLIGHT_LEGACY  ##RELAX ##NEEDED.
  methods _RESOLVE_ATTRIBUTE
    importing
      !IV_ATTRNAME type SCX_ATTRNAME
      !IX type ref to ZCX_FLIGHT_LEGACY
    returning
      value(RV_SYMSGV) type SYMSGV .
    "! Final determinations / derivations after all levels have been prepared, e.g. bottom-up derivations
  methods _DETERMINE
    exporting
      !ET_MESSAGES type ZIF_FLIGHT_LEGACY=>TT_IF_T100_MESSAGE
    changing
      !CS_TRAVEL type ZTRAVEL
      !CT_BOOKING type ZT_BOOKING
      !CT_BOOKING_SUPPLEMENT type ZT_BOOKING_SUPPLEMENT .
  methods _DETERMINE_TRAVEL_TOTAL_PRICE
    changing
      !CS_TRAVEL type ZTRAVEL
      !CT_BOOKING type ZT_BOOKING
      !CT_BOOKING_SUPPLEMENT type ZT_BOOKING_SUPPLEMENT
      !CT_MESSAGES type ZIF_FLIGHT_LEGACY=>TT_IF_T100_MESSAGE  ##NEEDED.
  methods _CONVERT_CURRENCY
    importing
      !IV_CURRENCY_CODE_SOURCE type ZCURRENCY_CODE
      !IV_CURRENCY_CODE_TARGET type ZCURRENCY_CODE
      !IV_AMOUNT type ZTOTAL_PRICE
    returning
      value(RV_AMOUNT) type ZTOTAL_PRICE .