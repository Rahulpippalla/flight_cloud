unmanaged implementation in class ZBP_TRAVEL_U unique;
strict;

// behavior defintion for the TRAVEL root entity
define behavior for ZI_Travel_U alias Travel
implementation in class ZBP_TRAVEL_U unique
etag master LastChangedAt
lock master
authorization master ( global )
late numbering
{
  field ( readonly ) TravelID;
  field ( mandatory ) AgencyID, CustomerID, BeginDate, EndDate;

  create;
  update;
  delete;

  action ( features : instance ) set_status_booked result [1] $self;

  association _Booking { create ( features : instance ); }


  mapping for ztravel control zstravel_intx
  {
    AgencyID = agency_id;
    BeginDate = begin_date;
    BookingFee = booking_fee;
    CurrencyCode = currency_code;
    CustomerID = customer_id;
    EndDate = end_date;
    LastChangedAt = lastchangedat;
    Memo = description;
    Status = status;
    TotalPrice = total_price;
    TravelID = travel_id;
  }
}

// behavior definition for the BOOKING child entity
define behavior for ZI_Booking_U alias Booking
implementation in class ZBP_BOOKING_U unique
etag dependent by _Travel
lock dependent by _Travel
authorization dependent by _Travel
late numbering
{
  field ( readonly ) TravelID, BookingID;
  field ( mandatory ) BookingDate, CustomerID, AirlineID, ConnectionID, FlightDate;


  update;
  delete;

  association _BookSupplement { create; }
  association _Travel;

  mapping for zbooking control zsbooking_intx
  {
    AirlineID = carrier_id;
    BookingDate = booking_date;
    BookingID = booking_id;
    ConnectionID = connection_id;
    CurrencyCode = currency_code;
    CustomerID = customer_id;
    FlightDate = flight_date;
    FlightPrice = flight_price;
    TravelID = travel_id;
  }

}

// behavior defintion for the BOOKING SUPPLEMENT sub node
define behavior for ZI_BookingSupplement_U alias BookingSupplement
implementation in class ZBP_BOOKINGSUPPLEMENT_U unique
etag dependent by _Travel
lock dependent by _Travel
authorization dependent by _Travel
late numbering
{

  field ( readonly ) TravelID, BookingID, BookingSupplementID;
  field ( mandatory : create, readonly : update ) SupplementID;
  field ( mandatory ) Price;



  update;
  delete;

  association _Travel abbreviation Travel;
  association _Booking;

  mapping for zbook_suppl control zsbooking_supplement_intx
  {
    BookingID = booking_id;
    BookingSupplementID = booking_supplement_id;
    CurrencyCode = currency_code;
    Price = price;
    SupplementID = supplement_id;
    TravelID = travel_id;
  }
}