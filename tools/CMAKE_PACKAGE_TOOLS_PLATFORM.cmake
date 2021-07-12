
##
# Gather information like distribution name, release version of the system
# and machine for which the system is built for.
#
# <function>(
#		<name_out>    // variable name where the system name will be stored
#		<version_out> // variable name where the system version will be stored
#		<machine_out> // variable name where the system machine will be stored
# )
#
FUNCTION(CMAKE_PACKAGE_TOOLS_PLATFORM name_out version_out machine_out)
	IF(NOT CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
		MESSAGE(FATAL_ERROR "Sorry, only linux is supported")
	ENDIF()
	FIND_PROGRAM(uname uname REQUIRED)
	FIND_PROGRAM(lsb_release lsb_release REQUIRED)

	EXECUTE_PROCESS(COMMAND "${lsb_release}" -si
		OUTPUT_STRIP_TRAILING_WHITESPACE
		OUTPUT_VARIABLE _system_name)
	IF(NOT _system_name)
		MESSAGE(FATAL_ERROR "Cannot obtain system name!")
	ENDIF()
	STRING(TOLOWER "${_system_name}" system_name)

	EXECUTE_PROCESS(COMMAND "${lsb_release}" -sr
		OUTPUT_STRIP_TRAILING_WHITESPACE
		OUTPUT_VARIABLE _system_version)
	IF(NOT _system_version)
		MESSAGE(FATAL_ERROR "Cannot obtain system version!")
	ENDIF()
	STRING(REGEX REPLACE "[.]" "" system_version "${_system_version}")

	EXECUTE_PROCESS(COMMAND "${uname}" -m
		OUTPUT_STRIP_TRAILING_WHITESPACE
		OUTPUT_VARIABLE _system_machine)
	IF(NOT _system_machine)
		MESSAGE(FATAL_ERROR "Cannot obtain system machine!")
	ENDIF()
	STRING(REGEX REPLACE "[_]" "-" system_machine "${_system_machine}")

	SET("${name_out}" "${system_name}" PARENT_SCOPE)
	SET("${version_out}" "${system_version}" PARENT_SCOPE)
	SET("${machine_out}" "${system_machine}" PARENT_SCOPE)
ENDFUNCTION()



##
# Generates a platform string
#
# <function>(
#		<platform_string_out> // variable name where the platform string will be stored
# )
#
FUNCTION(CMAKE_PACKAGE_TOOLS_PLATFORM_STRING platform_string_out)
	CMAKE_PACKAGE_TOOLS_PLATFORM(name version machine)
	SET("${platform_string_out}" "${machine}-${name}-${version}" PARENT_SCOPE)
ENDFUNCTION()

