#include "PolyclinicRepository.h"

#include "../database/DatabaseManager.h"

bool PolyclinicRepository::create(Polyclinic& p) {
    auto& db = DatabaseManager::instance().getDatabase();

    QSqlQuery q(db);

    q.prepare(R"(
            INSERT INTO polyclinics
            (name, address, phoneNumber)
            VALUES
            (:name, :address, :phoneNumber)
            RETURNING id
        )");

    q.bindValue(":name", p.name);
    q.bindValue(":address", p.address);
    q.bindValue(":phoneNumber", p.phoneNumber);

    if(!q.exec()) {
        qCritical() << "PolyclinicRepository : cannot create : " << q.lastError().text();
    }

    if(q.next()){
        p.id = q.value(0).toInt(); 
    }

    return true;
}

bool PolyclinicRepository::update(const Polyclinic& p) {
    
}

std::optional<Polyclinic> PolyclinicRepository::findById(const int id) const {
    auto& db = DatabaseManager::instance().getDatabase();
    QSqlQuery q(db);

    q.prepare("SELECT * FROM polyclinics WHERE id = :id");
    q.bindValue(":id", id);

    if (!q.exec() || !q.next()) {
        return std::nullopt;
    }

    Polyclinic p;
    p.id = q.value("id").toInt();
    p.name = q.value("name").toString();
    p.address = q.value("address").toString();
    p.phoneNumber = q.value("phoneNumber").toString();

    return p;
}

QVector<Polyclinic> PolyclinicRepository::getAll() const {
    QVector<Polyclinic> polyclinics;
    auto& db = DatabaseManager::instance().getDatabase();

    QSqlQuery q(db);

    if(!q.exec("SELECT * FROM polyclinics")) {
        qCritical() << "PolyclinicRepository : cannot get all : " << q.lastError().text();
        return polyclinics;
    }

    while(q.next()){
        Polyclinic p;
        p.id = q.value("id").toInt();
        p.name = q.value("name").toString();
        p.address = q.value("address").toString();
        p.phoneNumber = q.value("phoneNumber").toString();

        polyclinics.append(p);
    }

    return polyclinics;
}

bool PolyclinicRepository::remove(const int id) {
    auto& db = DatabaseManager::instance().getDatabase();
    QSqlQuery q(db);

    q.prepare("DELETE FROM polyclinics WHERE id = :id");
    q.bindValue(":id", id);

    if (!q.exec()) {
        qCritical() << "PolyclinicsRepository : remove - Error:" << q.lastError().text();
        return false;
    }

    return q.numRowsAffected() > 0;
}