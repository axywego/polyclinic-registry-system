cmake_minimum_required(VERSION 3.16)
project(polyclinic_registry_system)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_SKIP_INSTALL_RPATH TRUE)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Sql)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Sql)

add_library(polyclinic_lib
    src/core/EnvLoader.h
    src/core/EnvLoader.cpp
    
    src/database/DatabaseManager.h
    src/database/DatabaseManager.cpp
    
    src/models/Polyclinic.h
    src/models/Polyclinic.cpp
    
    src/repositories/PolyclinicRepository.h
    src/repositories/PolyclinicRepository.cpp
    
    src/services/PolyclinicService.h
    src/services/PolyclinicService.cpp
)

target_include_directories(polyclinic_lib
    PUBLIC
        ${CMAKE_SOURCE_DIR}/src
)

target_link_libraries(polyclinic_lib
    PRIVATE 
        Qt${QT_VERSION_MAJOR}::Core 
        Qt${QT_VERSION_MAJOR}::Sql
)

add_executable(${PROJECT_NAME}
    src/main.cpp
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE 
        polyclinic_lib
        Qt${QT_VERSION_MAJOR}::Core
)

if(NOT WIN32)
    include(GNUInstallDirs)
    install(TARGETS ${PROJECT_NAME}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    )
endif()

### Tests ###
enable_testing()

include(FetchContent)
FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git  
    GIT_TAG v1.14.0
)
FetchContent_MakeAvailable(googletest)

option(BUILD_TESTS "Build tests" ON)
if(BUILD_TESTS)
    add_subdirectory(tests)
endif()