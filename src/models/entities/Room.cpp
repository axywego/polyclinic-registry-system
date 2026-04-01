// Room.cpp
#include "Room.h"

QString Room::tableName() const {
    return "rooms";
}

void Room::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id_room").toInt();
    number = record.value("number").toInt();
    floor = record.value("floor").toInt();
    id_department = record.value("id_department").toInt();
}

void Room::fromQVariantHash(const QVariantHash& map) {
    id = map["id_room"].toInt();
    number = map["number"].toInt();
    floor = map["floor"].toInt();
    id_department = map["id_department"].toInt();
}

QVariantHash Room::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id_room"] = id.value();
    map["number"] = number;
    map["floor"] = floor;
    map["id_department"] = id_department;
    return map;
}