#
# Copyright by The HDF Group.
# All rights reserved.
#
# This file is part of HDF5.  The full HDF5 copyright notice, including
# terms governing use, modification, and redistribution, is contained in
# the COPYING file, which can be found at the root of the source code
# distribution tree, or in https://www.hdfgroup.org/licenses.
# If you do not have access to either file, you may request a copy from
# help@hdfgroup.org.
#
#-------------------------------------------------------------------------------
macro (EXTERNAL_JPEG_LIBRARY compress_type libtype)
  if (${libtype} MATCHES "SHARED")
    set (BUILD_EXT_SHARED_LIBS "ON")
  else ()
    set (BUILD_EXT_SHARED_LIBS "OFF")
  endif ()
  if (${compress_type} MATCHES "GIT")
    EXTERNALPROJECT_ADD (JPEG
        GIT_REPOSITORY ${JPEG_URL}
        GIT_TAG ${JPEG_BRANCH}
        INSTALL_COMMAND ""
        CMAKE_ARGS
            -DBUILD_SHARED_LIBS:BOOL=${BUILD_EXT_SHARED_LIBS}
            -DJPEG_PACKAGE_EXT:STRING=${JPEG_PACKAGE_EXT}
            -DJPEG_EXTERNALLY_CONFIGURED:BOOL=OFF
            -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
            -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
            -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
            -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
            -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
            -DCMAKE_PDB_OUTPUT_DIRECTORY:PATH=${CMAKE_PDB_OUTPUT_DIRECTORY}
            -DCMAKE_ANSI_CFLAGS:STRING=${CMAKE_ANSI_CFLAGS}
            -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
            -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
            -DCMAKE_TOOLCHAIN_FILE:STRING=${CMAKE_TOOLCHAIN_FILE}
    )
  elseif (${compress_type} MATCHES "TGZ")
    EXTERNALPROJECT_ADD (JPEG
        URL ${JPEG_URL}
        URL_MD5 ""
        INSTALL_COMMAND ""
        CMAKE_ARGS
            -DBUILD_SHARED_LIBS:BOOL=${BUILD_EXT_SHARED_LIBS}
            -DJPEG_PACKAGE_EXT:STRING=${JPEG_PACKAGE_EXT}
            -DJPEG_EXTERNALLY_CONFIGURED:BOOL=OFF
            -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
            -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
            -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
            -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
            -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
            -DCMAKE_PDB_OUTPUT_DIRECTORY:PATH=${CMAKE_PDB_OUTPUT_DIRECTORY}
            -DCMAKE_ANSI_CFLAGS:STRING=${CMAKE_ANSI_CFLAGS}
            -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
            -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
            -DCMAKE_TOOLCHAIN_FILE:STRING=${CMAKE_TOOLCHAIN_FILE}
    )
  endif ()
  externalproject_get_property (JPEG BINARY_DIR SOURCE_DIR)

  # Create imported target JPEG
  add_library (jpeg ${libtype} IMPORTED)
  HDF_IMPORT_SET_LIB_OPTIONS (jpeg "jpeg" ${libtype} "")
  add_dependencies (jpeg JPEG)

#  include (${BINARY_DIR}/JPEG-targets.cmake)
  set (JPEG_LIBRARY "jpeg")

  set (JPEG_INCLUDE_DIR_GEN "${BINARY_DIR}")
  set (JPEG_INCLUDE_DIR "${SOURCE_DIR}/src")
  set (JPEG_FOUND 1)
  set (JPEG_LIBRARIES ${JPEG_LIBRARY})
  set (JPEG_INCLUDE_DIRS ${JPEG_INCLUDE_DIR_GEN} ${JPEG_INCLUDE_DIR})
endmacro ()

#-------------------------------------------------------------------------------
macro (PACKAGE_JPEG_LIBRARY compress_type)
  add_custom_target (JPEG-GenHeader-Copy ALL
      COMMAND ${CMAKE_COMMAND} -E copy_if_different ${JPEG_INCLUDE_DIR}/bzlib.h ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/
      COMMENT "Copying ${JPEG_INCLUDE_DIR}/bzlib.h to ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/"
  )
  set (EXTERNAL_HEADER_LIST ${EXTERNAL_HEADER_LIST} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/bzlib.h)
  if (${compress_type} MATCHES "GIT" OR ${compress_type} MATCHES "TGZ")
    add_dependencies (JPEG-GenHeader-Copy jpeg)
  endif ()
endmacro ()
