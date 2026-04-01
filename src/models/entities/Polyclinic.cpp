#include "Polyclinic.h"

QString Polyclinic::tableName() const {
    return "polyclinics";
}

void Polyclinic::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id_polyclinic").toInt();
    name = record.value("name").toString();
    address = record.value("address").toString();
    phoneNumber = record.value("phone_number").toString();
}

void Polyclinic::fromQVariantHash(const QVariantHash& map) {
    id = map["id_polyclinic"].toInt();
    name = map["name"].toString();
    address = map["address"].toString();
    phoneNumber = map["phone_number"].toString();
}

QVariantHash Polyclinic::getFields() const {
    QHash<QString, QVariant> map;
    if(id.has_value())
        map["id_polyclinic"] = id.value();
    map["name"] = name;
    map["address"] = address;
    map["phone_number"] = phoneNumber;
    return map;
}