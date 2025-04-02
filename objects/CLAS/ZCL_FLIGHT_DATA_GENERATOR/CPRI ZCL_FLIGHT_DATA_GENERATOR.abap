  PRIVATE SECTION.
    CLASS-METHODS:
      "! Calculation of Price <br/>
      "!  <br/>
      "! Propagation to zcl_flight_legacy=>calculate_flight_price.<br/>
      "! @parameter iv_seats_occupied_percent | occupied seats
      "! @parameter iv_flight_distance | flight distance in kilometer
      "! @parameter rv_price | calculated flight price
      "! changes from s4d - 1
      calculate_flight_price
        IMPORTING
          iv_seats_occupied_percent TYPE zplane_seats_occupied
          iv_flight_distance        TYPE zflight_distance
        RETURNING
          VALUE(rv_price)           TYPE zflight_price.
