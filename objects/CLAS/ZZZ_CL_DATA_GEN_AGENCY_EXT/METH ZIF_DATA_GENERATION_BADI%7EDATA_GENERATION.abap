  METHOD zif_data_generation_badi~data_generation.
    me->out = out.
    out->write( ' --> Agency Extension' ) ##NO_TEXT.
    out->write( ' --> --> Agency Slogan' ) ##NO_TEXT.
    generate_slogan( ).
    out->write( ' --> --> Agency Reviews' ) ##NO_TEXT.
    generate_reviews( ).
  ENDMETHOD.