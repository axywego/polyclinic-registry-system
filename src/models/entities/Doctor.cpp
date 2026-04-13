#include "Doctor.h"

QString Doctor::tableName() const {
    return "doctors";
}

void Doctor::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    full_name = record.value("full_name").toString();
    phone_number = record.value("phone_number").toString();
    id_specialty = record.value("id_specialty").toInt();
    id_department = record.value("id_department").toInt();
    id_district = record.value("id_district").isNull() ? std::optional<int>() : record.value("id_district").toInt();
}

void Doctor::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    full_name = map["full_name"].toString();
    phone_number = map["phone_number"].toString();
    id_specialty = map["id_specialty"].toInt();
    id_department = map["id_department"].toInt();
    id_district = map["id_district"].isNull() ? std::optional<int>() : map["id_district"].toInt();
}

QVariantHash Doctor::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["full_name"] = full_name;
    map["phone_number"] = phone_number;
    map["id_specialty"] = id_specialty;
    map["id_department"] = id_department;
    if(id_district.has_value())
        map["id_district"] = id_district.value();
    return map;
}
