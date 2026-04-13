#include "Polyclinic.h"

QString Polyclinic::tableName() const {
    return "polyclinics";
}

void Polyclinic::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    name = record.value("name").toString();
    address = record.value("address").toString();
    phone_number = record.value("phone_number").toString();
}

void Polyclinic::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    name = map["name"].toString();
    address = map["address"].toString();
    phone_number = map["phone_number"].toString();
}

QVariantHash Polyclinic::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["name"] = name;
    map["address"] = address;
    map["phone_number"] = phone_number;
    return map;
}
