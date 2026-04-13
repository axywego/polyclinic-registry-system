#include "Service.h"

QString Service::tableName() const {
    return "services";
}

void Service::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id_service").toInt();
    name = record.value("name").toString();
    description = record.value("description").toString();
    price = record.value("price").toInt();
}

void Service::fromQVariantHash(const QVariantHash& map) {
    id = map["id_service"].toInt();
    name = map["name"].toString();
    description = map["description"].toString();
    price = map["price"].toInt();
}

QVariantHash Service::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id_service"] = id.value();
    map["name"] = name;
    map["description"] = description;
    map["price"] = price;
    return map;
}
