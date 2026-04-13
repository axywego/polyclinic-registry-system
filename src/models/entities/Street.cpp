#include "Street.h"

QString Street::tableName() const {
    return "streets";
}

void Street::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    name = record.value("name").toString();
    id_district = record.value("id_district").toInt();
    houses_range = record.value("houses_range").toString();
}

void Street::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    name = map["name"].toString();
    id_district = map["id_district"].toInt();
    houses_range = map["houses_range"].toString();
}

QVariantHash Street::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["name"] = name;
    map["id_district"] = id_district;
    map["houses_range"] = houses_range;
    return map;
}
