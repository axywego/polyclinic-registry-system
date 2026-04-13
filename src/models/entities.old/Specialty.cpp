#include "Specialty.h"

QString Specialty::tableName() const {
    return "specialties";
}

void Specialty::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id_specialty").toInt();
    name = record.value("name").toString();
    description = record.value("description").toString();
    id_department = record.value("id_department").toInt();
}

void Specialty::fromQVariantHash(const QVariantHash& map) {
    id = map["id_specialty"].toInt();
    name = map["name"].toString();
    description = map["description"].toString();
    id_department = map["id_department"].toInt();
}

QVariantHash Specialty::getFields() const {
    QHash<QString, QVariant> map;
    if(id.has_value())
        map["id_specialty"] = id.value();
    map["name"] = name;
    map["description"] = description;
    map["id_department"] = id_department;
    return map;
}