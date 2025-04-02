class-pool .
*"* class pool for class ZCL_DATA_GENERATOR_MANAGED

*"* local type definitions
include ZCL_DATA_GENERATOR_MANAGED====ccdef.

*"* class ZCL_DATA_GENERATOR_MANAGED definition
*"* public declarations
  include ZCL_DATA_GENERATOR_MANAGED====cu.
*"* protected declarations
  include ZCL_DATA_GENERATOR_MANAGED====co.
*"* private declarations
  include ZCL_DATA_GENERATOR_MANAGED====ci.
endclass. "ZCL_DATA_GENERATOR_MANAGED definition

*"* macro definitions
include ZCL_DATA_GENERATOR_MANAGED====ccmac.
*"* local class implementation
include ZCL_DATA_GENERATOR_MANAGED====ccimp.

class ZCL_DATA_GENERATOR_MANAGED implementation.
*"* method's implementations
  include methods.
endclass. "ZCL_DATA_GENERATOR_MANAGED implementation
