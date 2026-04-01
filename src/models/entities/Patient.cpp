#include "Patient.h"

QString Patient::tableName() const {
    return "patients";
}

void Patient::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id_patient").toInt();
    full_name = record.value("full_name").toString();
    birth_date = record.value("birth_date").toDate();
    address = record.value("address").toString();
    phone = record.value("phone").toString();
    passport_data = record.value("passport_data").toString();
}

void Patient::fromQVariantHash(const QVariantHash& map) {
    id = map["id_patient"].toInt();
    full_name = map["full_name"].toString();
    birth_date = map["birth_date"].toDate();
    address = map["address"].toString();
    phone = map["phone"].toString();
    passport_data = map["passport_data"].toString();
}

QVariantHash Patient::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id_patient"] = id.value();
    map["full_name"] = full_name;
    map["birth_date"] = birth_date;
    map["address"] = address;
    map["phone"] = phone;
    map["passport_data"] = passport_data;
    return map;
}
