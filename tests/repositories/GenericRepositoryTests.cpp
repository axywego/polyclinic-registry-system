#include <gtest/gtest.h>
#include "../../src/repositories/GenericRepository.h"
#include "../../src/database/DatabaseManager.h"

#include "../../src/core/EnvLoader.h"

class GenericRepositoryTests : public ::testing::Test {
protected:
    GenericRepository<Polyclinic> repo;
    
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

TEST_F(GenericRepositoryTests, Polyclinic_FindById_NonExisting_ReturnsNullopt) {
    auto found = repo.findById(99999);
    EXPECT_FALSE(found.has_value());
}

TEST_F(GenericRepositoryTests, Polyclinic_Create_FindById_Delete_Success) {
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


TEST_F(GenericRepositoryTests, SearchByQueries_GetInfoAboutPolyclinic_Success) {
    const auto res = repo.searchByQueries(Equals("name", "дурка"));

    EXPECT_TRUE(res.has_value());

    const auto p = res.value()[0]; 

    const auto finded = service.getInfo(p.id.value());
    EXPECT_TRUE(finded.has_value());
    EXPECT_TRUE(finded->contains("name"));
    EXPECT_TRUE(finded->contains("address"));
    EXPECT_TRUE(finded->contains("phoneNumber"));

    EXPECT_TRUE(service.remove(finded.value()["id"].toInt()));
}