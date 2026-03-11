#include "Polyclinic.h"

QString Polyclinic::tableName() const {
    return "polyclinics";
}

void Polyclinic::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    name = record.value("name").toString();
    address = record.value("address").toString();
    phoneNumber = record.value("phoneNumber").toString();
}

QHash<QString, QVariant> Polyclinic::getFields() const {
    QHash<QString, QVariant> map;
    if(id.has_value())
        map["id"] = id.value();
    map["name"] = name;
    map["address"] = address;
    map["phoneNumber"] = phoneNumber;
    return map;
}