#include "Department.h"

QString Department::tableName() const {
    return "departments";
}

void Department::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    name = record.value("name").toString();
    id_clinic = record.value("id_clinic").toInt();
}

void Department::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    name = map["name"].toString();
    id_clinic = map["id_clinic"].toInt();
}

QVariantHash Department::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["name"] = name;
    map["id_clinic"] = id_clinic;
    return map;
}
