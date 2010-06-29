#///////////////////////////////////////////////////////////////////////////////
#
#  Copyright (c) 2010, Michael A. Jackson. BlueQuartz Software
#  All rights reserved.
#  BSD License: http://www.opensource.org/licenses/bsd-license.html
#
#///////////////////////////////////////////////////////////////////////////////
 
# In this file we are doing all of our 'configure' checks. Things like checking
# for headers, functions, libraries, types and size of types.
INCLUDE (${CMAKE_ROOT}/Modules/CheckIncludeFile.cmake)
INCLUDE (${CMAKE_ROOT}/Modules/CheckTypeSize.cmake)
INCLUDE (${CMAKE_ROOT}/Modules/CheckFunctionExists.cmake)
INCLUDE (${CMAKE_ROOT}/Modules/CheckCXXSourceCompiles.cmake)
INCLUDE (${CMAKE_ROOT}/Modules/TestBigEndian.cmake)
TEST_BIG_ENDIAN(MXA_WORDS_BIGENDIAN)

SET (MXA_PROJECT_PREFIX "MXA")
  
IF(WIN32)
  IF(NOT UNIX)
    SET(${MXA_PROJECT_PREFIX}_HAVE_WINDOWS 1)
    SET(${MXA_PROJECT_PREFIX}_HAVE_WINSOCK_H 1)
  ENDIF(NOT UNIX)
ENDIF(WIN32)

#-----------------------------------------------------------------------------
#  Check the size in bytes of all the int and float types
#-----------------------------------------------------------------------------
MACRO ( CORE_CHECK_TYPE_SIZE type var)
    SET (aType ${type})
    SET (aVar  ${var})
    CHECK_TYPE_SIZE(${aType}   ${aVar})
    IF (NOT ${aVar})
        SET (${aVar} 0 CACHE INTERNAL "SizeOf for ${aType}")
    ENDIF()
ENDMACRO()

CORE_CHECK_TYPE_SIZE(char           ${MXA_PROJECT_PREFIX}_SIZEOF_CHAR)
CORE_CHECK_TYPE_SIZE(short          ${MXA_PROJECT_PREFIX}_SIZEOF_SHORT)
CORE_CHECK_TYPE_SIZE(int            ${MXA_PROJECT_PREFIX}_SIZEOF_INT)
CORE_CHECK_TYPE_SIZE(unsigned       ${MXA_PROJECT_PREFIX}_SIZEOF_UNSIGNED)
IF (NOT APPLE)
    CORE_CHECK_TYPE_SIZE(long           ${MXA_PROJECT_PREFIX}_SIZEOF_LONG)
ENDIF()
CORE_CHECK_TYPE_SIZE("long long"    ${MXA_PROJECT_PREFIX}_SIZEOF_LONG_LONG)
CORE_CHECK_TYPE_SIZE(__int64        ${MXA_PROJECT_PREFIX}_SIZEOF___INT64)
IF (NOT ${MXA_PROJECT_PREFIX}_SIZEOF___INT64)
    SET (${MXA_PROJECT_PREFIX}_SIZEOF___INT64 0)
ENDIF()

CORE_CHECK_TYPE_SIZE(float          ${MXA_PROJECT_PREFIX}_SIZEOF_FLOAT)
CORE_CHECK_TYPE_SIZE(double         ${MXA_PROJECT_PREFIX}_SIZEOF_DOUBLE)
CORE_CHECK_TYPE_SIZE("long double"  ${MXA_PROJECT_PREFIX}_SIZEOF_LONG_DOUBLE)
CORE_CHECK_TYPE_SIZE(int8_t         ${MXA_PROJECT_PREFIX}_SIZEOF_INT8_T)
CORE_CHECK_TYPE_SIZE(uint8_t        ${MXA_PROJECT_PREFIX}_SIZEOF_UINT8_T)
CORE_CHECK_TYPE_SIZE(int_least8_t   ${MXA_PROJECT_PREFIX}_SIZEOF_INT_LEAST8_T)
CORE_CHECK_TYPE_SIZE(uint_least8_t  ${MXA_PROJECT_PREFIX}_SIZEOF_UINT_LEAST8_T)
CORE_CHECK_TYPE_SIZE(int_fast8_t    ${MXA_PROJECT_PREFIX}_SIZEOF_INT_FAST8_T)
CORE_CHECK_TYPE_SIZE(uint_fast8_t   ${MXA_PROJECT_PREFIX}_SIZEOF_UINT_FAST8_T)
CORE_CHECK_TYPE_SIZE(int16_t        ${MXA_PROJECT_PREFIX}_SIZEOF_INT16_T)
CORE_CHECK_TYPE_SIZE(uint16_t       ${MXA_PROJECT_PREFIX}_SIZEOF_UINT16_T)
CORE_CHECK_TYPE_SIZE(int_least16_t  ${MXA_PROJECT_PREFIX}_SIZEOF_INT_LEAST16_T)
CORE_CHECK_TYPE_SIZE(uint_least16_t ${MXA_PROJECT_PREFIX}_SIZEOF_UINT_LEAST16_T)
CORE_CHECK_TYPE_SIZE(int_fast16_t   ${MXA_PROJECT_PREFIX}_SIZEOF_INT_FAST16_T)
CORE_CHECK_TYPE_SIZE(uint_fast16_t  ${MXA_PROJECT_PREFIX}_SIZEOF_UINT_FAST16_T)
CORE_CHECK_TYPE_SIZE(int32_t        ${MXA_PROJECT_PREFIX}_SIZEOF_INT32_T)
CORE_CHECK_TYPE_SIZE(uint32_t       ${MXA_PROJECT_PREFIX}_SIZEOF_UINT32_T)
CORE_CHECK_TYPE_SIZE(int_least32_t  ${MXA_PROJECT_PREFIX}_SIZEOF_INT_LEAST32_T)
CORE_CHECK_TYPE_SIZE(uint_least32_t ${MXA_PROJECT_PREFIX}_SIZEOF_UINT_LEAST32_T)
CORE_CHECK_TYPE_SIZE(int_fast32_t   ${MXA_PROJECT_PREFIX}_SIZEOF_INT_FAST32_T)
CORE_CHECK_TYPE_SIZE(uint_fast32_t  ${MXA_PROJECT_PREFIX}_SIZEOF_UINT_FAST32_T)
CORE_CHECK_TYPE_SIZE(int64_t        ${MXA_PROJECT_PREFIX}_SIZEOF_INT64_T)
CORE_CHECK_TYPE_SIZE(uint64_t       ${MXA_PROJECT_PREFIX}_SIZEOF_UINT64_T)
CORE_CHECK_TYPE_SIZE(int_least64_t  ${MXA_PROJECT_PREFIX}_SIZEOF_INT_LEAST64_T)
CORE_CHECK_TYPE_SIZE(uint_least64_t ${MXA_PROJECT_PREFIX}_SIZEOF_UINT_LEAST64_T)
CORE_CHECK_TYPE_SIZE(int_fast64_t   ${MXA_PROJECT_PREFIX}_SIZEOF_INT_FAST64_T)
CORE_CHECK_TYPE_SIZE(uint_fast64_t  ${MXA_PROJECT_PREFIX}_SIZEOF_UINT_FAST64_T)
IF (NOT APPLE)
    CORE_CHECK_TYPE_SIZE(size_t         ${MXA_PROJECT_PREFIX}_SIZEOF_SIZE_T)
    CORE_CHECK_TYPE_SIZE(ssize_t        ${MXA_PROJECT_PREFIX}_SIZEOF_SSIZE_T)
    IF (NOT ${MXA_PROJECT_PREFIX}_SIZEOF_SSIZE_T)
        SET (${MXA_PROJECT_PREFIX}_SIZEOF_SSIZE_T 0)
    ENDIF()
ENDIF()
CORE_CHECK_TYPE_SIZE(off_t          ${MXA_PROJECT_PREFIX}_SIZEOF_OFF_T)
CORE_CHECK_TYPE_SIZE(off64_t        ${MXA_PROJECT_PREFIX}_SIZEOF_OFF64_T)
IF (NOT ${MXA_PROJECT_PREFIX}_SIZEOF_OFF64_T)
    SET (${MXA_PROJECT_PREFIX}_SIZEOF_OFF64_T 0)
ENDIF()


IF(${MXA_PROJECT_PREFIX}_SIZEOF___INT64)
  IF("${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_AND___INT64" MATCHES "^${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_AND___INT64$")
    MESSAGE(STATUS "Checking whether long and __int64 are the same type")
    TRY_COMPILE(${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_AND___INT64
      ${PROJECT_BINARY_DIR}/CMakeTmp
      ${PROJECT_CMAKE_DIR}/CoreTests/TestCompareTypes.cxx
      COMPILE_DEFINITIONS
      -D${MXA_PROJECT_PREFIX}_TEST_COMPARE_TYPE_1=long
      -D${MXA_PROJECT_PREFIX}_TEST_COMPARE_TYPE_2=__int64
      OUTPUT_VARIABLE OUTPUT)
    IF(${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_AND___INT64)
      MESSAGE(STATUS "Checking whether long and __int64 are the same type -- yes")
      SET(${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_AND___INT64 1 CACHE INTERNAL "Whether long and __int64 are the same type")
      WRITE_FILE(${CMAKE_BINARY_DIR}/CMakeFiles/CMakeOutput.log
        "Determining whether long and __int64 are the same type "
        "passed with the following output:\n"
        "${OUTPUT}\n" APPEND)
    ELSE(${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_AND___INT64)
      MESSAGE(STATUS "Checking whether long and __int64 are the same type -- no")
      SET(${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_AND___INT64 0 CACHE INTERNAL "Whether long and __int64 are the same type")
      WRITE_FILE(${CMAKE_BINARY_DIR}/CMakeFiles/CMakeError.log
        "Determining whether long and __int64 are the same type "
        "failed with the following output:\n"
        "${OUTPUT}\n" APPEND)
    ENDIF(${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_AND___INT64)
  ENDIF("${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_AND___INT64" MATCHES "^${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_AND___INT64$")
  IF(${MXA_PROJECT_PREFIX}_SIZEOF_LONG_LONG)
    IF("${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_LONG_AND___INT64" MATCHES "^${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_LONG_AND___INT64$")
      MESSAGE(STATUS "Checking whether long long and __int64 are the same type")
      TRY_COMPILE(${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_LONG_AND___INT64
        ${PROJECT_BINARY_DIR}/CMakeTmp
        ${PROJECT_CMAKE_DIR}/CoreTests/TestCompareTypes.cxx
        COMPILE_DEFINITIONS
        -D${MXA_PROJECT_PREFIX}_TEST_COMPARE_TYPE_1=TYPE_LONG_LONG
        -D${MXA_PROJECT_PREFIX}_TEST_COMPARE_TYPE_2=__int64
        OUTPUT_VARIABLE OUTPUT)
      IF(${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_LONG_AND___INT64)
        MESSAGE(STATUS "Checking whether long long and __int64 are the same type -- yes")
        SET(${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_LONG_AND___INT64 1 CACHE INTERNAL "Whether long long and __int64 are the same type")
        WRITE_FILE(${CMAKE_BINARY_DIR}/CMakeFiles/CMakeOutput.log
          "Determining whether long long and __int64 are the same type "
          "passed with the following output:\n"
          "${OUTPUT}\n" APPEND)
      ELSE(${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_LONG_AND___INT64)
        MESSAGE(STATUS "Checking whether long long and __int64 are the same type -- no")
        SET(${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_LONG_AND___INT64 0 CACHE INTERNAL "Whether long long and __int64 are the same type")
        WRITE_FILE(${CMAKE_BINARY_DIR}/CMakeFiles/CMakeError.log
          "Determining whether long long and __int64 are the same type "
          "failed with the following output:\n"
          "${OUTPUT}\n" APPEND)
      ENDIF(${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_LONG_AND___INT64)
    ENDIF("${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_LONG_AND___INT64" MATCHES "^${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_LONG_AND___INT64$")
  ENDIF(${MXA_PROJECT_PREFIX}_SIZEOF_LONG_LONG)
  IF(NOT ${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_AND___INT64)
    IF(NOT ${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_LONG_AND___INT64)
#  VS 6 cannot convert unsigned __int64 to double unless the
# "Visual C++ Processor Pack" is installed.
      IF("${MXA_PROJECT_PREFIX}_TYPE_CONVERT_UI64_TO_DOUBLE" MATCHES "^${MXA_PROJECT_PREFIX}_TYPE_CONVERT_UI64_TO_DOUBLE$")
        MESSAGE(STATUS "Checking whether unsigned __int64 can convert to double")
        TRY_COMPILE(${MXA_PROJECT_PREFIX}_TYPE_CONVERT_UI64_TO_DOUBLE
          ${PROJECT_BINARY_DIR}/CMakeTmp
          ${PROJECT_CMAKE_DIR}/CoreTests/TestConvertTypes.cxx
          COMPILE_DEFINITIONS
          -D${MXA_PROJECT_PREFIX}_TEST_CONVERT_TYPE_FROM=TYPE_UNSIGNED___INT64
          -D${MXA_PROJECT_PREFIX}_TEST_CONVERT_TYPE_TO=double
          OUTPUT_VARIABLE OUTPUT)
        IF(${MXA_PROJECT_PREFIX}_TYPE_CONVERT_UI64_TO_DOUBLE)
          MESSAGE(STATUS "Checking whether unsigned __int64 can convert to double -- yes")
          SET(${MXA_PROJECT_PREFIX}_TYPE_CONVERT_UI64_TO_DOUBLE 1 CACHE INTERNAL "Whether unsigned __int64 can convert to double")
          WRITE_FILE(${CMAKE_BINARY_DIR}/CMakeFiles/CMakeOutput.log
            "Determining whether unsigned __int64 can convert to double "
            "passed with the following output:\n"
            "${OUTPUT}\n" APPEND)
        ELSE(${MXA_PROJECT_PREFIX}_TYPE_CONVERT_UI64_TO_DOUBLE)
          MESSAGE(STATUS "Checking whether unsigned __int64 can convert to double -- no")
          SET(${MXA_PROJECT_PREFIX}_TYPE_CONVERT_UI64_TO_DOUBLE 0 CACHE INTERNAL "Whether unsigned __int64 can convert to double")
          WRITE_FILE(${CMAKE_BINARY_DIR}/CMakeFiles/CMakeError.log
            "Determining whether unsigned __int64 can convert to double "
            "failed with the following output:\n"
            "${OUTPUT}\n" APPEND)
        ENDIF(${MXA_PROJECT_PREFIX}_TYPE_CONVERT_UI64_TO_DOUBLE)
      ENDIF("${MXA_PROJECT_PREFIX}_TYPE_CONVERT_UI64_TO_DOUBLE" MATCHES "^${MXA_PROJECT_PREFIX}_TYPE_CONVERT_UI64_TO_DOUBLE$")
    ENDIF(NOT ${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_LONG_AND___INT64)
  ENDIF(NOT ${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_AND___INT64)
ENDIF(${MXA_PROJECT_PREFIX}_SIZEOF___INT64)

# Enable the "long long" type if it is available.  It is standard in
# C99 and C++03 but not in earlier standards.
SET(${MXA_PROJECT_PREFIX}_TYPE_USE_LONG_LONG)
IF(${MXA_PROJECT_PREFIX}_SIZEOF_LONG_LONG)
  SET(${MXA_PROJECT_PREFIX}_TYPE_USE_LONG_LONG 1)
ENDIF(${MXA_PROJECT_PREFIX}_SIZEOF_LONG_LONG)

# Enable the "__int64" type if it is available and unique.  It is not
# standard.
SET(${MXA_PROJECT_PREFIX}_TYPE_USE___INT64)
IF(${MXA_PROJECT_PREFIX}_SIZEOF___INT64)
  IF(NOT ${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_AND___INT64)
    IF(NOT ${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_LONG_AND___INT64)
      SET(${MXA_PROJECT_PREFIX}_TYPE_USE___INT64 1)
    ENDIF(NOT ${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_LONG_AND___INT64)
  ENDIF(NOT ${MXA_PROJECT_PREFIX}_TYPE_SAME_LONG_AND___INT64)
ENDIF(${MXA_PROJECT_PREFIX}_SIZEOF___INT64)

IF("${MXA_PROJECT_PREFIX}_COMPILER_HAS_BOOL" MATCHES "^${MXA_PROJECT_PREFIX}_COMPILER_HAS_BOOL$")
  MESSAGE(STATUS "Checking support for C++ type bool")
  TRY_COMPILE(${MXA_PROJECT_PREFIX}_COMPILER_HAS_BOOL
              ${PROJECT_BINARY_DIR}/CMakeTmp/Bool
              ${PROJECT_CMAKE_DIR}/CoreTests/TestBoolType.cxx
              OUTPUT_VARIABLE OUTPUT)
  IF(${MXA_PROJECT_PREFIX}_COMPILER_HAS_BOOL)
    MESSAGE(STATUS "Checking support for C++ type bool -- yes")
    SET(${MXA_PROJECT_PREFIX}_COMPILER_HAS_BOOL 1 CACHE INTERNAL "Support for C++ type bool")
    WRITE_FILE(${CMAKE_BINARY_DIR}/CMakeFiles/CMakeOutput.log
      "Determining if the C++ compiler supports type bool "
      "passed with the following output:\n"
      "${OUTPUT}\n" APPEND)
  ELSE(${MXA_PROJECT_PREFIX}_COMPILER_HAS_BOOL)
    MESSAGE(STATUS "Checking support for C++ type bool -- no")
    SET(${MXA_PROJECT_PREFIX}_COMPILER_HAS_BOOL 0 CACHE INTERNAL "Support for C++ type bool")
    WRITE_FILE(${CMAKE_BINARY_DIR}/CMakeFiles/CMakeError.log
      "Determining if the C++ compiler supports type bool "
      "failed with the following output:\n"
      "${OUTPUT}\n" APPEND)
  ENDIF(${MXA_PROJECT_PREFIX}_COMPILER_HAS_BOOL)
ENDIF("${MXA_PROJECT_PREFIX}_COMPILER_HAS_BOOL" MATCHES "^${MXA_PROJECT_PREFIX}_COMPILER_HAS_BOOL$")

IF("${MXA_PROJECT_PREFIX}_TYPE_CHAR_IS_SIGNED" MATCHES "^${MXA_PROJECT_PREFIX}_TYPE_CHAR_IS_SIGNED$")
  MESSAGE(STATUS "Checking signedness of char")
  TRY_RUN(${MXA_PROJECT_PREFIX}_TYPE_CHAR_IS_SIGNED ${MXA_PROJECT_PREFIX}_TYPE_CHAR_IS_SIGNED_COMPILED
          ${PROJECT_BINARY_DIR}/CMakeTmp/Char
          ${PROJECT_CMAKE_DIR}/CoreTests/TestCharSignedness.cxx)
  IF(${MXA_PROJECT_PREFIX}_TYPE_CHAR_IS_SIGNED_COMPILED)
    IF(${MXA_PROJECT_PREFIX}_TYPE_CHAR_IS_SIGNED)
      MESSAGE(STATUS "Checking signedness of char -- signed")
      SET(${MXA_PROJECT_PREFIX}_TYPE_CHAR_IS_SIGNED 1 CACHE INTERNAL "Whether char is signed.")
    ELSE(${MXA_PROJECT_PREFIX}_TYPE_CHAR_IS_SIGNED)
      MESSAGE(STATUS "Checking signedness of char -- unsigned")
      SET(${MXA_PROJECT_PREFIX}_TYPE_CHAR_IS_SIGNED 0 CACHE INTERNAL "Whether char is signed.")
    ENDIF(${MXA_PROJECT_PREFIX}_TYPE_CHAR_IS_SIGNED)
  ELSE(${MXA_PROJECT_PREFIX}_TYPE_CHAR_IS_SIGNED_COMPILED)
    MESSAGE(STATUS "Checking signedness of char -- failed")
  ENDIF(${MXA_PROJECT_PREFIX}_TYPE_CHAR_IS_SIGNED_COMPILED)
ENDIF("${MXA_PROJECT_PREFIX}_TYPE_CHAR_IS_SIGNED" MATCHES "^${MXA_PROJECT_PREFIX}_TYPE_CHAR_IS_SIGNED$")


# --------------------------------------------------------------------
#  Now check for needed Header files
# --------------------------------------------------------------------
macro (CORE_CHECK_INCLUDE_FILE header var prefix)
    CHECK_INCLUDE_FILE("${header}"        ${prefix}_${var} )
endmacro()


CORE_CHECK_INCLUDE_FILE("stddef.h"        HAVE_STDDEF_H   ${MXA_PROJECT_PREFIX})
CORE_CHECK_INCLUDE_FILE("stdint.h"        HAVE_STDINT_H   ${MXA_PROJECT_PREFIX})
CORE_CHECK_INCLUDE_FILE("stdlib.h"        HAVE_STDLIB_H   ${MXA_PROJECT_PREFIX})
CORE_CHECK_INCLUDE_FILE("setjmp.h"        HAVE_SETJMP_H   ${MXA_PROJECT_PREFIX})
CORE_CHECK_INCLUDE_FILE("string.h"        HAVE_STRING_H   ${MXA_PROJECT_PREFIX})
CORE_CHECK_INCLUDE_FILE("stdio.h"         HAVE_STDIO_H   ${MXA_PROJECT_PREFIX})
CORE_CHECK_INCLUDE_FILE("math.h"          HAVE_MATH_H   ${MXA_PROJECT_PREFIX})
CORE_CHECK_INCLUDE_FILE("time.h"          HAVE_TIME_H   ${MXA_PROJECT_PREFIX})
CORE_CHECK_INCLUDE_FILE("sys/time.h"      HAVE_SYS_TIME_H   ${MXA_PROJECT_PREFIX})
CORE_CHECK_INCLUDE_FILE("sys/types.h"     HAVE_SYS_TYPES_H   ${MXA_PROJECT_PREFIX})
CORE_CHECK_INCLUDE_FILE("sys/socket.h"    HAVE_SYS_SOCKET_H   ${MXA_PROJECT_PREFIX})
CORE_CHECK_INCLUDE_FILE("sys/stat.h"      HAVE_SYS_STAT_H   ${MXA_PROJECT_PREFIX})
CORE_CHECK_INCLUDE_FILE("netinet/in.h"    HAVE_NETINET_IN_H   ${MXA_PROJECT_PREFIX})
CORE_CHECK_INCLUDE_FILE("arpa/inet.h"     HAVE_ARPA_INET_H   ${MXA_PROJECT_PREFIX})
CORE_CHECK_INCLUDE_FILE("unistd.h"        HAVE_UNISTD_H   ${MXA_PROJECT_PREFIX})
CORE_CHECK_INCLUDE_FILE("fcntl.h"         HAVE_FCNTL_H   ${MXA_PROJECT_PREFIX})
CORE_CHECK_INCLUDE_FILE("errno.h"         HAVE_ERRNO_H   ${MXA_PROJECT_PREFIX})


set (SSE_COMPILE_FLAGS "")
SET (VERSION_COMPILE_FLAGS "")

if (MSVC)
 set(${MXA_PROJECT_PREFIX}_HAVE_TIME_GETTIMEOFDAY "TRUE")
endif()
 
IF (NOT MSVC)

    TRY_COMPILE(${MXA_PROJECT_PREFIX}_HAVE_TIME_GETTIMEOFDAY
          ${CMAKE_BINARY_DIR}
          ${PROJECT_CMAKE_DIR}/CoreTests/GetTimeOfDayTest.cpp
          COMPILE_DEFINITIONS -DTRY_TIME_H
          OUTPUT_VARIABLE OUTPUT)
    IF (${MXA_PROJECT_PREFIX}_HAVE_TIME_GETTIMEOFDAY STREQUAL "TRUE")
        SET (${MXA_PROJECT_PREFIX}_HAVE_TIME_GETTIMEOFDAY "1")
    ENDIF (${MXA_PROJECT_PREFIX}_HAVE_TIME_GETTIMEOFDAY STREQUAL "TRUE")

    TRY_COMPILE(${MXA_PROJECT_PREFIX}_HAVE_SYS_TIME_GETTIMEOFDAY
          ${CMAKE_BINARY_DIR}
          ${PROJECT_CMAKE_DIR}/CoreTests/GetTimeOfDayTest.cpp
          COMPILE_DEFINITIONS -DTRY_SYS_TIME_H
          OUTPUT_VARIABLE OUTPUT)
    IF (${MXA_PROJECT_PREFIX}_HAVE_SYS_TIME_GETTIMEOFDAY STREQUAL "TRUE")
        SET (${MXA_PROJECT_PREFIX}_HAVE_SYS_TIME_GETTIMEOFDAY "1")
    ENDIF (${MXA_PROJECT_PREFIX}_HAVE_SYS_TIME_GETTIMEOFDAY STREQUAL "TRUE")

    if (NOT ${MXA_PROJECT_PREFIX}_HAVE_SYS_TIME_GETTIMEOFDAY AND NOT ${MXA_PROJECT_PREFIX}_HAVE_TIME_GETTIMEOFDAY)
        message(STATUS "---------------------------------------------------------------")
        message(STATUS "Function 'gettimeofday()' was not found. MXADataModel will use its")
        message(STATUS "  own implementation.. This can happen on older versions of")
        message(STATUS "  MinGW on Windows. Consider upgrading your MinGW installation")
        message(STATUS "  to a newer version such as MinGW 3.12")
        message(STATUS "---------------------------------------------------------------")
    endif()
ENDIF (NOT MSVC)

if (FALSE)
#-----------------------------------------------------------------------------
# Check how to print a Long Long integer
#-----------------------------------------------------------------------------
SET(EMMPM_EMMPM_PRINTF_LL_WIDTH "EMMPM_PRINTF_LL_WIDTH")
IF (EMMPM_PRINTF_LL_WIDTH MATCHES "^EMMPM_PRINTF_LL_WIDTH$")
  SET(PRINT_LL_FOUND 0)
  MESSAGE(STATUS "Checking for appropriate format for 64 bit long:")
  FOREACH(EMMPM_PRINTF_LL l64 l L q I64 ll)
    SET(CURRENT_TEST_DEFINITIONS "-DPRINTF_LL_WIDTH=${EMMPM_PRINTF_LL}")
    IF (EMMPM_SIZEOF_LONG_LONG)
      SET(CURRENT_TEST_DEFINITIONS "${CURRENT_TEST_DEFINITIONS} -DHAVE_LONG_LONG")
    ENDIF (EMMPM_SIZEOF_LONG_LONG)
    TRY_RUN(EMMPM_PRINTF_LL_TEST_RUN   EMMPM_PRINTF_LL_TEST_COMPILE
      ${PROJECT_BINARY_DIR}/CMake
      ${PROJECT_CMAKE_DIR}/CoreTests/TestMiscFeatures.c
      CMAKE_FLAGS -DCOMPILE_DEFINITIONS:STRING=${CURRENT_TEST_DEFINITIONS}
      OUTPUT_VARIABLE OUTPUT)
    IF (EMMPM_PRINTF_LL_TEST_COMPILE)
      IF (EMMPM_PRINTF_LL_TEST_RUN MATCHES 0)
        SET(EMMPM_PRINTF_LL_WIDTH "\"${EMMPM_PRINTF_LL}\"" CACHE INTERNAL "Width for printf for type `long long' or `__int64', us. `ll")
        SET(PRINT_LL_FOUND 1)
      ELSE (EMMPM_PRINTF_LL_TEST_RUN MATCHES 0)
        MESSAGE("Width with ${EMMPM_PRINTF_LL} failed with result: ${EMMPM_PRINTF_LL_TEST_RUN}")
      ENDIF (EMMPM_PRINTF_LL_TEST_RUN MATCHES 0)
    ELSE (EMMPM_PRINTF_LL_TEST_COMPILE)
      FILE( APPEND ${CMAKE_BINARY_DIR}/CMakeFiles/CMakeError.log
        "Test EMMPM_PRINTF_LL_WIDTH for ${EMMPM_PRINTF_LL} failed with the following output:\n ${OUTPUT}\n")
    ENDIF (EMMPM_PRINTF_LL_TEST_COMPILE)
  ENDFOREACH(EMMPM_PRINTF_LL)
  IF (PRINT_LL_FOUND)
    MESSAGE(STATUS "Checking for apropriate format for 64 bit long: found ${EMMPM_PRINTF_LL_WIDTH}")
  ELSE (PRINT_LL_FOUND)
    MESSAGE(STATUS "Checking for apropriate format for 64 bit long: not found")
    SET(EMMPM_PRINTF_LL_WIDTH "\"unknown\"" CACHE INTERNAL
      "Width for printf for type `long long' or `__int64', us. `ll")
  ENDIF (PRINT_LL_FOUND)
ENDIF (EMMPM_PRINTF_LL_WIDTH MATCHES "^EMMPM_PRINTF_LL_WIDTH$")
endif()

