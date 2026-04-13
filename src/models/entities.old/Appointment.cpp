#include "Appointment.h"

QString Appointment::tableName() const {
    return "appointments";
}

void Appointment::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    appointment_time = record.value("appointment_time").toDateTime();
    status = record.value("status").toString();
    cancelled_at = record.value("cancelled_at").toDateTime();
    id_patient = record.value("id_patient").toInt();
    id_schedule = record.value("id_schedule").toInt();
}

void Appointment::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    appointment_time = map["appointment_time"].toDateTime();
    status = map["status"].toString();
    cancelled_at = map["cancelled_at"].toDateTime();
    id_patient = map["id_patient"].toInt();
    id_schedule = map["id_schedule"].toInt();
}

QVariantHash Appointment::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["appointment_time"] = appointment_time;
    map["status"] = status;
    map["cancelled_at"] = cancelled_at;
    map["id_patient"] = id_patient;
    map["id_schedule"] = id_schedule;
    return map;
}
