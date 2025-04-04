managed implementation in class ZBP_TRAVEL_M unique;
strict(2);

define behavior for ZI_Travel_M alias travel
implementation in class ZBP_TRAVEL_M unique
persistent table ZTRAVEL_M
with additional save
etag master last_changed_at
lock master
early numbering
authorization master(global)

{
  // administrative fields: read only
  field ( readonly ) last_changed_at, last_changed_by, created_at, created_by;

  // mandatory fields that are required to create a travel
  field ( mandatory ) agency_id, customer_id, begin_date, end_date, overall_status, booking_fee, currency_code;

  // Semantic Key field, which is readonly for the consumer, value is assigned in early numbering
  field ( readonly ) travel_id;

  // mapping entity's field types with table field types
  mapping for ZTRAVEL_M corresponding;

  // standard operations for travel entity
  create;
  update;
  delete;

  // instance action and dynamic action control
  action  ( features: instance ) acceptTravel result [1] $self;
  action  ( features: instance ) rejectTravel result [1] $self;

  // internal action that is called by determinations
  internal action ReCalcTotalPrice;

  // instance factory action for copying travel instances
  factory action copyTravel [1];

  // validations
  validation validateCustomer on save { create; field customer_id; }
  validation validateAgency   on save { create; field agency_id; }
  validation validateDates    on save { create; field begin_date, end_date; }
  validation validateStatus   on save { create; field overall_status; }


  determination calculateTotalPrice on modify {create; field booking_fee, currency_code; }



  // create booking by association
  association _Booking { create (features:instance); }


}

define behavior for ZI_Booking_M alias booking
implementation in class ZBP_BOOKING_M unique
persistent table ZBOOKING_M
etag master last_changed_at
lock dependent by _Travel
early numbering
authorization dependent by _Travel

{
  // static field control
  field ( mandatory ) carrier_id, connection_id, flight_date, booking_status;
  field ( readonly ) travel_id, booking_id;

  // mapping entity's field types with table field types
  mapping for ZBOOKING_M corresponding;

  // Fields that are mandatory for create but should be read-only afterwards
  field ( mandatory : create, readonly : update) booking_date, customer_id;

  // standard operations for booking entity
  update;
//  delete;

  // create booking supplement by association
  association _BookSupplement { create (features:instance); }

 // validations
  validation validateStatus on save { create; field booking_status; }

  // determination for calculation of total flight price
  determination calculateTotalPrice on modify { create;  field flight_price, currency_code; }

  association _Travel { }
}


define behavior for ZI_BookSuppl_M alias booksuppl
implementation in class ZBP_BOOKINGSUPPLEMENT_M unique
//persistent table ZBOOKSUPPL_M
with unmanaged save
etag master last_changed_at
lock dependent by _Travel
early numbering
authorization dependent by _Travel

{
  // static field control
  field ( mandatory ) price,supplement_id;
  field ( readonly ) travel_id, booking_id, booking_supplement_id;

  // mapping entity's field types with table field types
  mapping for ZBOOKSUPPL_M corresponding;

  // standard operations for booking supplement entity
  update;


  // determination for calculation of total suppl. price
  determination calculateTotalPrice on modify {create;  field price, currency_code; }

  association _Travel { }
  association _Booking { }
}