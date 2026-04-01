#include "ScheduleException.h"

QString ScheduleException::tableName() const {
    return "schedule_exceptions";
}

void ScheduleException::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id_schedule_exception").toInt();
    id_doctor = record.value("id_doctor").toInt();
    exception_start_date = record.value("exception_start_date").toDate();
    exception_end_date = record.value("exception_end_date").toDate();
    start_time = record.value("start_time").toTime();
    end_time = record.value("end_time").toTime();
    id_room = record.value("id_room").toInt();
    is_working = record.value("is_working").toBool();
    reason = record.value("reason").toString();
}

void ScheduleException::fromQVariantHash(const QVariantHash& map) {
    id = map["id_schedule_exception"].toInt();
    id_doctor = map["id_doctor"].toInt();
    exception_start_date = map["exception_start_date"].toDate();
    exception_end_date = map["exception_end_date"].toDate();
    start_time = map["start_time"].toTime();
    end_time = map["end_time"].toTime();
    id_room = map["id_room"].toInt();
    is_working = map["is_working"].toBool();
    reason = map["reason"].toString();
}

QVariantHash ScheduleException::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id_schedule_exception"] = id.value();
    map["id_doctor"] = id_doctor;
    map["exception_start_date"] = exception_start_date;
    map["exception_end_date"] = exception_end_date;
    map["start_time"] = start_time;
    map["end_time"] = end_time;
    map["id_room"] = id_room;
    map["is_working"] = is_working;
    map["reason"] = reason;
    return map;
}
