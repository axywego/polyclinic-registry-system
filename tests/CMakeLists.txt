add_executable(polyclinic_tests
    main.cpp
    models/PolyclinicTest.cpp
    repositories/PolyclinicRepositoryTest.cpp
    services/PolyclinicServiceTest.cpp
)

target_link_libraries(polyclinic_tests
    PRIVATE
        polyclinic_lib
        GTest::gtest_main
        GTest::gmock_main
        Qt${QT_VERSION_MAJOR}::Core
        Qt${QT_VERSION_MAJOR}::Sql
)

include(GoogleTest)
gtest_discover_tests(polyclinic_tests)