#include <gtest/gtest.h>
#include "../../src/services/GenericService.h"
#include "../../src/database/DatabaseManager.h"
#include "../../src/core/EnvLoader.h"

class GenericServiceTests : public ::testing::Test {
protected:
    GenericService<Polyclinic> service;
    
    void SetUp() override {
        loadEnv(".env");

        const QString dbName = getEnv("POSTGRES_DB", "");
        const QString dbUser = getEnv("POSTGRES_USER", "");
        const QString dbPassword = getEnv("POSTGRES_PASSWORD", "");
        const int dbPort = getEnv("PG_PORT", "").toInt();

        DatabaseManager::instance().connect("localhost", dbPort, dbName, dbUser, dbPassword);
    }
    
    void TearDown() override {
        DatabaseManager::instance().disconnect();
    }
};

TEST_F(GenericServiceTests, AddPolyclinic_ReturnsTrue) {
    Polyclinic p;
    p.name = "дурка";
    p.address = "там где дурка";
    p.phoneNumber = "телефон дурки";

    EXPECT_TRUE(service.add(p));
}

TEST_F(GenericServiceTests, SearchByQueries_GetInfoAboutPolyclinic_Success) {
    const auto res = service.searchByQueries(Equals("name", "дурка"));

    EXPECT_TRUE(res.has_value());

    const auto p = res.value()[0]; 

    const auto finded = service.getInfo(p.id.value());
    EXPECT_TRUE(finded.has_value());
    EXPECT_TRUE(finded->contains("name"));
    EXPECT_TRUE(finded->contains("address"));
    EXPECT_TRUE(finded->contains("phoneNumber"));

    EXPECT_TRUE(service.remove(finded.value()["id"].toInt()));
}