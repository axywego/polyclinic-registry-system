#include "Doctor.h"

QString Doctor::tableName() const {
    return "doctors";
}

void Doctor::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id_doctor").toInt();
    fullName = record.value("full_name").toString();
    phoneNumber = record.value("phone_number").toString();
    id_specialty = record.value("id_speciality").toInt();
}

void Doctor::fromQVariantHash(const QVariantHash& map) {
    id = map["id_doctor"].toInt();
    fullName = map["full_name"].toString();
    phoneNumber = map["phone_number"].toString();
    id_specialty = map["id_speciality"].toInt();
}

QVariantHash Doctor::getFields() const {
    QHash<QString, QVariant> map;
    if(id.has_value())
        map["id_doctor"] = id.value();
    map["full_name"] = fullName;
    map["phone_number"] = phoneNumber;
    map["id_specialty"] = id_specialty;
    return map;
}