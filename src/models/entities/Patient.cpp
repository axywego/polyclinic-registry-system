#include "Patient.h"

QString Patient::tableName() const {
    return "patients";
}

void Patient::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    full_name = record.value("full_name").toString();
    birth_date = record.value("birth_date").toDate();
    address = record.value("address").toString();
    phone = record.value("phone").toString();
    passport_data = record.value("passport_data").toString();
    id_district = record.value("id_district").isNull() ? std::optional<int>() : record.value("id_district").toInt();
}

void Patient::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    full_name = map["full_name"].toString();
    birth_date = map["birth_date"].toDate();
    address = map["address"].toString();
    phone = map["phone"].toString();
    passport_data = map["passport_data"].toString();
    id_district = map["id_district"].isNull() ? std::optional<int>() : map["id_district"].toInt();
}

QVariantHash Patient::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["full_name"] = full_name;
    map["birth_date"] = birth_date;
    map["address"] = address;
    map["phone"] = phone;
    map["passport_data"] = passport_data;
    if(id_district.has_value())
        map["id_district"] = id_district.value();
    return map;
}
