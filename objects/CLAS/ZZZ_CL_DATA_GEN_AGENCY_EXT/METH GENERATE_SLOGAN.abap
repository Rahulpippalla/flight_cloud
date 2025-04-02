  METHOD generate_slogan.
    lcl_slogan=>get_instance( out )->generate_slogan(
      text = VALUE #( ##NO_TEXT
          root = abap_true
          followed_by = VALUE #( ( 2 ) ( 3 ) )
          posible_end = abap_false
          ( id = 1  text = 'We are' )
          ( id = 7  text = |{ lcl_slogan=>agencys_name } is| )
          followed_by = VALUE #( ( 2 ) ( 3 ) ( 4 ) ( 5 ) )
          ( id = 6  text = 'Fly with' )
          followed_by = VALUE #( ( 3 ) ( 4 ) ( 5 ) )
          ( id = 11  text = 'Better with' )

          root = abap_false
          posible_end = abap_true
          followed_by = VALUE #(  )
          ( id = 2  text = 'the best!' )
          ( id = 3  text = 'the leader in business!' )
          followed_by = VALUE #( ( 1 ) )
          ( id = 5  text = 'us!' )
          ( id = 4  text = |{ lcl_slogan=>agencys_name }!| )



          root = abap_true
          followed_by = VALUE #( ( 10 ) )
          posible_end = abap_false
          ( id = 8  text = 'Cool' )
          ( id = 9  text = 'Fast' )

          root = abap_false
          posible_end = abap_false
          followed_by = VALUE #( ( 12 ) ( 13 ) )
          ( id = 10  text = 'and' )

          root = abap_false
          posible_end = abap_true
          followed_by = VALUE #( ( 1 ) ( 7 ) ( 6 ) )
          ( id = 12  text = 'smooth!' )
          ( id = 13  text = 'save!' )
        )
      ).
  ENDMETHOD.