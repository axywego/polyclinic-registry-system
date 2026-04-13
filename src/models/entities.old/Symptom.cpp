#include "Symptom.h"

QString Symptom::tableName() const {
    return "symptoms";
}

void Symptom::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    name = record.value("name").toString();
    description = record.value("description").toString();
}

void Symptom::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    name = map["name"].toString();
    description = map["description"].toString();
}

QVariantHash Symptom::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["name"] = name;
    map["description"] = description;
    return map;
}
