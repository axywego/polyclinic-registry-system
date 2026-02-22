cmake_minimum_required(VERSION 3.16)

project(polyclinics_registry_system)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Sql)

add_executable(${PROJECT_NAME} src/main.cpp)

target_link_libraries(${PROJECT_NAME} PRIVATE 
    Qt6::Core 
    Qt6::Sql
)

if(WIN32 AND NOT CMAKE_CROSSCOMPILING)
    get_target_property(_qmake_executable Qt6::qmake IMPORTED_LOCATION)
    get_filename_component(_qt_bin_dir "${_qmake_executable}" DIRECTORY)
    find_program(WINDEPLOYQT_EXECUTABLE windeployqt HINTS "${_qt_bin_dir}")

    if(WINDEPLOYQT_EXECUTABLE)
        add_custom_command(TARGET ${PROJECT_NAME}
            POST_BUILD
            COMMAND ${WINDEPLOYQT_EXECUTABLE}
                --debug
                $<TARGET_FILE:${PROJECT_NAME}>
            COMMENT "Deploying Qt Libraries..."
        )
        add_custom_command(TARGET ${PROJECT_NAME}
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E make_directory 
                $<TARGET_FILE_DIR:${PROJECT_NAME}>/sqldrivers
            COMMAND ${CMAKE_COMMAND} -E copy
                "${_qt_bin_dir}/../plugins/sqldrivers/qsqlpsql.dll"
                $<TARGET_FILE_DIR:${PROJECT_NAME}>/sqldrivers/
            COMMENT "Copying PostgreSQL driver..."
        )
    else()
        message(WARNING "windeployqt not found!")
    endif()
endif()