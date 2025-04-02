CLASS zzz_cl_data_gen_agency_ext DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES:
      if_badi_interface,
      zif_data_generation_badi.
    METHODS:
      generate_slogan,
      generate_reviews.