#include "District.h"

QString District::tableName() const {
    return "districts";
}

void District::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    number = record.value("number").toInt();
    name = record.value("name").toString();
    id_department = record.value("id_department").toInt();
    id_registrar = record.value("id_registrar").isNull() ? std::optional<int>() : record.value("id_registrar").toInt();
}

void District::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    number = map["number"].toInt();
    name = map["name"].toString();
    id_department = map["id_department"].toInt();
    id_registrar = map["id_registrar"].isNull() ? std::optional<int>() : map["id_registrar"].toInt();
}

QVariantHash District::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["number"] = number;
    map["name"] = name;
    map["id_department"] = id_department;
    if(id_registrar.has_value())
        map["id_registrar"] = id_registrar.value();
    return map;
}
