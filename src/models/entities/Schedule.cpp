#include "Schedule.h"

QString Schedule::tableName() const {
    return "schedules";
}

void Schedule::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    day_of_week = record.value("day_of_week").toInt();
    start_time = record.value("start_time").toTime();
    end_time = record.value("end_time").toTime();
    id_room = record.value("id_room").toInt();
    id_doctor = record.value("id_doctor").toInt();
    valid_from = record.value("valid_from").toDate();
    valid_to = record.value("valid_to").isNull() ? std::optional<QDate>() : record.value("valid_to").toDate();
    max_patients = record.value("max_patients").toInt();
}

void Schedule::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    day_of_week = map["day_of_week"].toInt();
    start_time = map["start_time"].toTime();
    end_time = map["end_time"].toTime();
    id_room = map["id_room"].toInt();
    id_doctor = map["id_doctor"].toInt();
    valid_from = map["valid_from"].toDate();
    valid_to = map["valid_to"].isNull() ? std::optional<QDate>() : map["valid_to"].toDate();
    max_patients = map["max_patients"].toInt();
}

QVariantHash Schedule::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["day_of_week"] = day_of_week;
    map["start_time"] = start_time;
    map["end_time"] = end_time;
    map["id_room"] = id_room;
    map["id_doctor"] = id_doctor;
    map["valid_from"] = valid_from;
    if(valid_to.has_value())
        map["valid_to"] = valid_to.value();
    map["max_patients"] = max_patients;
    return map;
}
