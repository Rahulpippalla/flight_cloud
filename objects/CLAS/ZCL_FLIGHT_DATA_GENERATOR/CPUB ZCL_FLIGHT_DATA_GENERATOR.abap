CLASS zcl_flight_data_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.

    CLASS-METHODS:
      reset_numberrange_interval
        IMPORTING
          numberrange_object   TYPE cl_numberrange_runtime=>nr_object
          numberrange_interval TYPE cl_numberrange_runtime=>nr_interval
          subobject            TYPE cl_numberrange_intervals=>nr_subobject OPTIONAL
          fromnumber           TYPE cl_numberrange_intervals=>nr_nriv_line-fromnumber
          tonumber             TYPE cl_numberrange_intervals=>nr_nriv_line-tonumber
          nrlevel              TYPE cl_numberrange_intervals=>nr_nriv_line-nrlevel DEFAULT 0.
