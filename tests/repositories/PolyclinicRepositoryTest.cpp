#include <gtest/gtest.h>
#include "../../src/repositories/PolyclinicRepository.h"
#include "../../src/database/DatabaseManager.h"

#include "../../src/core/EnvLoader.h"

class PolyclinicRepositoryTest : public ::testing::Test {
protected:
    PolyclinicRepository repo;
    
    void SetUp() override {
        loadEnv(".env");

        const QString dbName = getEnv("POSTGRES_DB");
        const QString dbUser = getEnv("POSTGRES_USER");
        const QString dbPassword = getEnv("POSTGRES_PASSWORD");
        const int dbPort = getEnv("PG_PORT").toInt();

        DatabaseManager::instance().connect("localhost", dbPort, dbName, dbUser, dbPassword);
    }
    
    void TearDown() override {
        DatabaseManager::instance().disconnect();
    }
};

TEST_F(PolyclinicRepositoryTest, FindById_NonExistingPolyclinic_ReturnsNullopt) {
    auto found = repo.findById(99999);
    EXPECT_FALSE(found.has_value());
}

TEST_F(PolyclinicRepositoryTest, Create_Delete_FindById_Polyclinic_Success) {
    Polyclinic p;
    p.name = "Name";
    p.address = "Address";
    p.phoneNumber = "PhoneNumber";
    repo.create(p);

    auto found = repo.findById(p.id.value());
    EXPECT_TRUE(found.has_value());
    
    bool result = repo.remove(p.id.value());
    EXPECT_TRUE(result);
}