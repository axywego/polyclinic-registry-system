#include "Department.h"

QString Department::tableName() const {
    return "departments";
}

void Department::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id_department").toInt();
    name = record.value("name").toString();
    id_polyclinic = record.value("id_polyclinic").toInt();
}

void Department::fromQVariantHash(const QVariantHash& map) {
    id = map["id_department"].toInt();
    name = map["name"].toString();
    id_polyclinic = map["id_polyclinic"].toInt();
}

QVariantHash Department::getFields() const {
    QHash<QString, QVariant> map;
    if(id.has_value())
        map["id_department"] = id.value();
    map["name"] = name;
    map["id_polyclinic"] = id_polyclinic;
    return map;
}