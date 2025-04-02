  METHOD lock_travel ##NEEDED.
*   IF iv_lock = abap_true.
*     CALL FUNCTION 'ENQUEUE_ZETRAVEL'
*       EXCEPTIONS
*         foreign_lock   = 1
*         system_failure = 2
*         OTHERS         = 3.
*     IF sy-subrc <> 0.
*       RAISE EXCEPTION TYPE zcx_flight_legacy
*         EXPORTING
*           textid = zcx_flight_legacy=>travel_lock.
*     ENDIF.
*   ELSE.
*     CALL FUNCTION 'DEQUEUE_ZETRAVEL'.
*   ENDIF.
  ENDMETHOD.