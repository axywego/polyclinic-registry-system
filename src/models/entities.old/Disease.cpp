#include "Disease.h"

QString Disease::tableName() const {
    return "diseases";
}

void Disease::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    code = record.value("code").toString();
    name = record.value("name").toString();
    category = record.value("category").toString();
    description = record.value("description").toString();
}

void Disease::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    code = map["code"].toString();
    name = map["name"].toString();
    category = map["category"].toString();
    description = map["description"].toString();
}

QVariantHash Disease::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["code"] = code;
    map["name"] = name;
    map["category"] = category;
    map["description"] = description;
    return map;
}
