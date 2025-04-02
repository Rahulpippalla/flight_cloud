  METHOD get_cause_from_message.
    fail_cause = if_abap_behv=>cause-unspecific.

    IF msgid = 'ZCM_FLIGHT_LEGAC'.
      CASE msgno.
        WHEN '009'  "Travel Key initial
          OR '016'  "Travel does not exist
          OR '017'  "Booking does not exist
          OR '021'. "BookingSupplement does not exist
          IF is_dependend = abap_true.
            fail_cause = if_abap_behv=>cause-dependency.
          ELSE.
            fail_cause = if_abap_behv=>cause-not_found.
          ENDIF.
        WHEN '032'. "Travel is locked by
          fail_cause = if_abap_behv=>cause-locked.
        WHEN '046'. "You are not authorized
          fail_cause = if_abap_behv=>cause-unauthorized.
      ENDCASE.
    ENDIF.
  ENDMETHOD.