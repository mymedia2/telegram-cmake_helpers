# This file is part of Desktop App Toolkit,
# a set of libraries for developing nice desktop applications.
#
# For license and copyright information please follow this link:
# https://github.com/desktop-app/legal/blob/master/LEGAL

option(DESKTOP_APP_DISABLE_CRASH_REPORTS "Disable crash report generation." OFF)
option(DESKTOP_APP_LOTTIE_USE_CACHE "Use caching in lottie animations." ON)

option(DESKTOP_APP_USE_GLIBC_WRAPS "Use wraps for new GLIBC features." OFF)
if (LINUX AND NOT DESKTOP_APP_SPECIAL_TARGET STREQUAL "")
    set(DESKTOP_APP_USE_GLIBC_WRAPS ON)
endif()

option(DESKTOP_APP_USE_PACKAGED "Find libraries using CMake instead of exact paths." ON)
if (NOT DESKTOP_APP_SPECIAL_TARGET STREQUAL "")
    set(DESKTOP_APP_USE_PACKAGED OFF)
endif()

option(DESKTOP_APP_DISABLE_SPELLCHECK "Disable spellcheck library." OFF)
if (DESKTOP_APP_SPECIAL_TARGET STREQUAL "osx")
    set(DESKTOP_APP_DISABLE_SPELLCHECK ON)
endif()

option(DESKTOP_APP_USE_PACKAGED_RLOTTIE "Find rlottie using CMake instead of bundled one." ${DESKTOP_APP_USE_PACKAGED})

if (DESKTOP_APP_SPECIAL_TARGET STREQUAL ""
    OR DESKTOP_APP_SPECIAL_TARGET STREQUAL "uwp"
    OR DESKTOP_APP_SPECIAL_TARGET STREQUAL "mas")
    set(disable_autoupdate 1)
endif()

set(build_osx 0)
set(build_macstore 0)
set(build_winstore 0)
set(build_linux32 0)

if (WIN32)
    if (DESKTOP_APP_SPECIAL_TARGET STREQUAL "uwp")
        set(build_winstore 1)
    endif()
elseif (APPLE)
    if (DESKTOP_APP_SPECIAL_TARGET STREQUAL "osx")
        set(build_osx 1)
    elseif (DESKTOP_APP_SPECIAL_TARGET STREQUAL "mas")
        set(build_macstore 1)
    endif()
else()
    execute_process(COMMAND uname -m OUTPUT_VARIABLE machine_uname)
    if (CMAKE_SIZEOF_VOID_P EQUAL 4)
        set(build_linux32 1)
    endif()
    if (DESKTOP_APP_SPECIAL_TARGET STREQUAL "linux")
        if (build_linux32)
            report_bad_special_target()
        endif()
    elseif (DESKTOP_APP_SPECIAL_TARGET STREQUAL "linux32")
        if (NOT build_linux32)
            report_bad_special_target()
        endif()
    endif()
    if (NOT DESKTOP_APP_USE_PACKAGED)
        set(CMAKE_AR /usr/bin/gcc-ar)
        set(CMAKE_RANLIB /usr/bin/gcc-ranlib)
        set(CMAKE_NM /usr/bin/gcc-nm)
    endif()
endif()

if (NOT APPLE OR build_osx)
    get_filename_component(libs_loc "../Libraries" REALPATH)
else()
    get_filename_component(libs_loc "../Libraries/macos" REALPATH)
endif()
get_filename_component(third_party_loc "Telegram/ThirdParty" REALPATH)
get_filename_component(submodules_loc "Telegram" REALPATH)
