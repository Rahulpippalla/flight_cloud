class-pool .
*"* class pool for class ZBP_BOOKING_M

*"* local type definitions
include ZBP_BOOKING_M=================ccdef.

*"* class ZBP_BOOKING_M definition
*"* public declarations
  include ZBP_BOOKING_M=================cu.
*"* protected declarations
  include ZBP_BOOKING_M=================co.
*"* private declarations
  include ZBP_BOOKING_M=================ci.
endclass. "ZBP_BOOKING_M definition

*"* macro definitions
include ZBP_BOOKING_M=================ccmac.
*"* local class implementation
include ZBP_BOOKING_M=================ccimp.

class ZBP_BOOKING_M implementation.
*"* method's implementations
  include methods.
endclass. "ZBP_BOOKING_M implementation
