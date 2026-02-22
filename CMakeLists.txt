cmake_minimum_required(VERSION 3.16)

project(polyclinic_registry_system)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_SKIP_INSTALL_RPATH TRUE)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Sql)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Sql)

if(WIN32)
    message(STATUS "Building for Windows (MinGW)")
else()
    message(STATUS "Building for Linux/Native")
endif()

add_executable(${PROJECT_NAME} src/main.cpp
    src/core/EnvLoader.h
    src/core/EnvLoader.cpp
)

target_link_libraries(${PROJECT_NAME} PRIVATE 
    Qt${QT_VERSION_MAJOR}::Core 
    Qt${QT_VERSION_MAJOR}::Sql
)

if(NOT WIN32)
    include(GNUInstallDirs)
    install(TARGETS ${PROJECT_NAME}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    )
endif()


# should be changed in the future
if(WIN32 AND NOT CMAKE_CROSSCOMPILING)
    
endif()