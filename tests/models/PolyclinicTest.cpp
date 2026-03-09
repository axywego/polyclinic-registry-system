#include <gtest/gtest.h>
#include "../../src/models/Polyclinic.h"

class PolyclinicTest : public ::testing::Test {
protected:
    Polyclinic p;
    
    void SetUp() override {
        p.name = "Полоцкая городская поликлиника №1";
        p.address = "какой-то там адрес";
        p.phoneNumber = "какой-то там телефон";
    }
};

TEST_F(PolyclinicTest, PolyclinicCreatedSuccessfully) {
    EXPECT_EQ(p.name, "Полоцкая городская поликлиника №1");
    EXPECT_EQ(p.address, "какой-то там адрес");
    EXPECT_FALSE(p.id.has_value());
}