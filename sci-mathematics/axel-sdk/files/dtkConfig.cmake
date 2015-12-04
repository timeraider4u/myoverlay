## Version: $Id$
##
######################################################################
##
### Commentary:
##
######################################################################
##
### Change Log:
##
######################################################################
##
### Code:

set(DTK_BUILD_32 0)
set(DTK_BUILD_64 1)

## ###################################################################
## Defines:
## - dtk_INCLUDE_DIRS
## ###################################################################

set(dtk_INCLUDE_DIRS
  "/opt/axel-sdk/include"
  "/opt/axel-sdk/include/dtk"
  "/opt/axel-sdk/include/dtkComposer"
  "/opt/axel-sdk/include/dtkCore"
  "/opt/axel-sdk/include/dtkCoreSupport"
  "/opt/axel-sdk/include/dtkDistributed"
  "/opt/axel-sdk/include/dtkLog"
  "/opt/axel-sdk/include/dtkMath"
  "/opt/axel-sdk/include/dtkMeta"
  "/opt/axel-sdk/include/dtkTest")

set(DTK_INSTALL_PREFIX "/opt/axel-sdk")

set(dtk_INSTALL_DOCS "/opt/axel-sdk/doc")

include("/opt/axel-sdk/lib64/cmake/dtk/dtkDepends.cmake")

find_package(Qt5 REQUIRED COMPONENTS
  Core
  Concurrent
  Network
  Quick
  Widgets
  Test
  Xml)

## ###################################################################
## Options
## ###################################################################

set(DTK_BUILD_DISTRIBUTED ON)
set(DTK_BUILD_COMPOSER OFF)
set(DTK_BUILD_SCRIPT OFF)
set(DTK_BUILD_WRAPPERS OFF)
set(DTK_BUILD_SUPPORT_CORE ON)
set(DTK_BUILD_SUPPORT_CONTAINER ON)
set(DTK_BUILD_SUPPORT_COMPOSER ON)
set(DTK_BUILD_SUPPORT_DISTRIBUTED ON)
set(DTK_BUILD_SUPPORT_GUI ON)
set(DTK_BUILD_SUPPORT_MATH ON)
set(DTK_BUILD_SUPPORT_PLOT OFF)
set(DTK_BUILD_SUPPORT_VR OFF)
set(DTK_ENABLE_COVERAGE OFF)
set(DTK_COVERAGE_USE_COBERTURA ON)
set(DTK_ENABLE_MEMCHECK OFF)

set(DTK_HAVE_MPI NO)
set(DTK_HAVE_VRPN NO)
set(DTK_HAVE_NITE )
set(DTK_HAVE_ZLIB YES)

######################################################################
### dtkConfig.cmake.in ends here
