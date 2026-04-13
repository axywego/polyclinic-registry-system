#include "Registrar.h"

QString Registrar::tableName() const {
    return "registrars";
}

void Registrar::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    full_name = record.value("full_name").toString();
    position = record.value("position").toString();
    phone_number = record.value("phone_number").toString();
    login = record.value("login").toString();
    password_hash = record.value("password_hash").toString();
    id_polyclinic = record.value("id_polyclinic").toInt();
    is_active = record.value("is_active").toBool();
}

void Registrar::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    full_name = map["full_name"].toString();
    position = map["position"].toString();
    phone_number = map["phone_number"].toString();
    login = map["login"].toString();
    password_hash = map["password_hash"].toString();
    id_polyclinic = map["id_polyclinic"].toInt();
    is_active = map["is_active"].toBool();
}

QVariantHash Registrar::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["full_name"] = full_name;
    map["position"] = position;
    map["phone_number"] = phone_number;
    map["login"] = login;
    map["password_hash"] = password_hash;
    map["id_polyclinic"] = id_polyclinic;
    map["is_active"] = is_active;
    return map;
}
