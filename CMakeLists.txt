cmake_minimum_required(VERSION 3.16)
project(polyclinic_registry_system)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_SKIP_INSTALL_RPATH TRUE)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Sql Gui Quick Qml)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Sql Gui Quick Qml)

qt6_standard_project_setup()


## generating models adapters

set(MODELS
    Polyclinic
)

set(GENERATED_ADAPTER_DIR "${CMAKE_CURRENT_BINARY_DIR}/generated/adapters")
set(ADAPTER_SOURCES "")

foreach(MODEL ${MODELS})
    set(MODEL_NAME ${MODEL})
    set(CLASS_NAME "${MODEL}ServiceAdapter")
    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/src/templates/adapter.h.in
        ${GENERATED_ADAPTER_DIR}/${CLASS_NAME}.h
        @ONLY
    )
    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/src/templates/adapter.cpp.in
        ${GENERATED_ADAPTER_DIR}/${CLASS_NAME}.cpp
        @ONLY
    )
    list(APPEND ADAPTER_SOURCES
        ${GENERATED_ADAPTER_DIR}/${CLASS_NAME}.h
        ${GENERATED_ADAPTER_DIR}/${CLASS_NAME}.cpp
    )
endforeach()

add_library(polyclinic_lib
    src/core/EnvLoader.h
    src/core/EnvLoader.cpp
    
    src/database/DatabaseManager.h
    src/database/DatabaseManager.cpp
    
    src/models/BaseModel.h
    src/models/BaseModel.cpp
    src/models/Polyclinic.h
    src/models/Polyclinic.cpp
    
    src/repositories/criteria/Criteria.h
    src/repositories/criteria/Criteria.cpp
    src/repositories/criteria/CriteriaHelpers.h
    src/repositories/criteria/CriteriaHelpers.cpp

    src/repositories/GenericRepository.h
    src/repositories/GenericRepository.cpp

    src/services/GenericService.h
    src/services/GenericService.cpp
    # src/services/adapters/PolyclinicServiceAdapter.h
    # src/services/adapters/PolyclinicServiceAdapter.cpp

    # src/macros/QmlAdapter.h
    ${ADAPTER_SOURCES}
)

# set_source_files_properties(
#     src/services/adapters/PolyclinicServiceAdapter.h
#     PROPERTIES
#     AUTOMOC ON
# )

target_include_directories(polyclinic_lib
    PUBLIC
        ${CMAKE_SOURCE_DIR}/src
        ${GENERATED_ADAPTER_DIR}
)

target_link_libraries(polyclinic_lib
    PRIVATE 
        Qt${QT_VERSION_MAJOR}::Core 
        Qt${QT_VERSION_MAJOR}::Sql
)

qt_add_executable(${PROJECT_NAME}
    src/main.cpp
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE 
        polyclinic_lib
        Qt${QT_VERSION_MAJOR}::Core
        Qt${QT_VERSION_MAJOR}::Gui
        Qt${QT_VERSION_MAJOR}::Quick
        Qt${QT_VERSION_MAJOR}::Qml
)

qt_add_qml_module(${PROJECT_NAME}
    URI Polyclinic.UI
    VERSION 1.0
    RESOURCE_PREFIX "/"
    QML_FILES
        src/qml/Main.qml
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