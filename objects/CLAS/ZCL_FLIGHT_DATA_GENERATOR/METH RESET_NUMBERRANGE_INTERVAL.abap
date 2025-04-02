  METHOD reset_numberrange_interval.

    DATA interval_found TYPE c.

    TRY.
"" RAHUL  - change 2
        cl_numberrange_intervals=>read(
          EXPORTING
            object       = numberrange_object
            subobject    = subobject
          IMPORTING
            interval     = DATA(intervals) ).

*       Remove Intervals other than the requested one
        LOOP AT intervals INTO DATA(interval).
          IF interval-nrrangenr NE numberrange_interval.
*           Set the level to 0 before removing the interval (API requires this)
            IF interval-nrlevel NE 0.
              interval-nrlevel = 0.
              interval-procind = 'U'.
              cl_numberrange_intervals=>update(
                EXPORTING
                  interval  = VALUE #( ( interval ) )
                  object    = numberrange_object
                  subobject = subobject ).
            ENDIF.
            interval-procind = 'D'.
            cl_numberrange_intervals=>delete(
              EXPORTING
                interval  = VALUE #( ( interval ) )
                object    = numberrange_object
                subobject = subobject ).
          ENDIF.
        ENDLOOP.
"" RAHUL  - Change 2
*       Process the requested Interval
        CLEAR interval_found.
        LOOP AT intervals INTO interval.
          IF interval-nrrangenr EQ numberrange_interval.
            interval_found = 'X'.
            EXIT.
          ENDIF.
        ENDLOOP.
        IF interval_found IS INITIAL.  "Interval doesn't exist -> Create
          cl_numberrange_intervals=>create(
            EXPORTING
              interval  = VALUE #( ( subobject  = subobject
                                     nrrangenr  = numberrange_interval
                                     fromnumber = fromnumber
                                     tonumber   = tonumber
                                     nrlevel    = nrlevel
                                     procind    = 'I' ) )
              object    = numberrange_object
              subobject = subobject ).

        ELSE.  "Requested Interval exists -> Update, if required - Pippalla
          IF interval-nrlevel NE 0.
            interval-nrlevel = 0.
            interval-procind = 'U'.
            cl_numberrange_intervals=>update(
              EXPORTING
                interval  = VALUE #( ( interval ) )
                object    = numberrange_object
                subobject = subobject ).
          ENDIF.
          IF interval-fromnumber NE fromnumber OR
             interval-tonumber   NE tonumber.
            interval-procind = 'U'.
            interval-fromnumber = fromnumber.
            interval-tonumber   = tonumber.
            cl_numberrange_intervals=>update(
              EXPORTING
                interval  = VALUE #( ( interval ) )
                object    = numberrange_object
                subobject = subobject ).
          ENDIF.
*         Set the level to a default value, if requested
          IF nrlevel NE 0.
            interval-nrlevel = nrlevel.
            interval-procind = 'U'.
            cl_numberrange_intervals=>update(
              EXPORTING
                interval  = VALUE #( ( interval ) )
                object    = numberrange_object
                subobject = subobject ).
          ENDIF.
        ENDIF.

        COMMIT WORK.

      CATCH cx_nr_object_not_found INTO DATA(lx_nr_object_not_found).
      CATCH cx_nr_subobject        INTO DATA(lx_nr_subobject).
      CATCH cx_number_ranges       INTO DATA(lx_number_ranges).
    ENDTRY.

    IF lx_nr_object_not_found IS BOUND OR
       lx_nr_subobject        IS BOUND OR
       lx_number_ranges       IS BOUND.
      ASSERT 1 = 2.
    ENDIF.

  ENDMETHOD.