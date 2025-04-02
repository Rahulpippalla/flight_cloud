CLASS zcl_flight_amdp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS convert_currency IMPORTING VALUE(iv_amount)               TYPE ztotal_price
                                             VALUE(iv_currency_code_source) TYPE zcurrency_code
                                             VALUE(iv_currency_code_target) TYPE zcurrency_code
                                             VALUE(iv_exchange_rate_date)   TYPE d
                                   EXPORTING VALUE(ev_amount)               TYPE ztotal_price.