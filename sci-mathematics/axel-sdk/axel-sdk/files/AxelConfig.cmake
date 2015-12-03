
set (AXEL_INCLUDE_DIR /opt/axel-sdk/include)

set (AXEL_LIBRARY_DIR /opt/axel-sdk/lib)

set (AXEL_PLUGIN_DIR /opt/axel-sdk/plugins)
if (APPLE)
set (AXEL_PLUGIN_DIR /opt/axel-sdk/bin/axel.app/Contents/PlugIns)
endif (APPLE)
if (WIN32)
set (AXEL_PLUGIN_DIR /opt/axel-sdk/bin/)
endif (WIN32)

set (AXEL_LIBRARIES axlCore axlGui)

if(JSON_RPC)
set (AXEL_LIBRARIES ${AXEL_LIBRARIES} axlRpc)
endif(JSON_RPC)

set (AXEL_INCLUDE_DIR ${AXEL_INCLUDE_DIR};/opt/axel-sdk/;/opt/axel-sdk/include/dtk/;/opt/axel-sdk/dtkCore)
set (AXEL_LIBRARIES ${AXEL_LIBRARIES} )
set (AXEL_LIBRARY_DIR ${AXEL_LIBRARY_DIR} /opt/axel-sdk/lib;/opt/axel-sdk/lib64)
set (AXEL_FOUND TRUE)
