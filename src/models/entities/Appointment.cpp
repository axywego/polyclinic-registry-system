#include "Appointment.h"

QString Appointment::tableName() const {
    return "appointments";
}

void Appointment::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    appointment_time = record.value("appointment_time").toDateTime();
    status = record.value("status").toString();
    cancelled_at = record.value("cancelled_at").isNull() ? std::optional<QDateTime>() : record.value("cancelled_at").toDateTime();
    id_patient = record.value("id_patient").toInt();
    id_schedule = record.value("id_schedule").toInt();
    id_ticket = record.value("id_ticket").isNull() ? std::optional<int>() : record.value("id_ticket").toInt();
    registration_method = record.value("registration_method").toString();
    is_home_visit = record.value("is_home_visit").toBool();
    home_address = record.value("home_address").isNull() ? std::optional<QString>() : record.value("home_address").toString();
    symptoms_description = record.value("symptoms_description").isNull() ? std::optional<QString>() : record.value("symptoms_description").toString();
    created_at = record.value("created_at").toDateTime();
}

void Appointment::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    appointment_time = map["appointment_time"].toDateTime();
    status = map["status"].toString();
    cancelled_at = map["cancelled_at"].isNull() ? std::optional<QDateTime>() : map["cancelled_at"].toDateTime();
    id_patient = map["id_patient"].toInt();
    id_schedule = map["id_schedule"].toInt();
    id_ticket = map["id_ticket"].isNull() ? std::optional<int>() : map["id_ticket"].toInt();
    registration_method = map["registration_method"].toString();
    is_home_visit = map["is_home_visit"].toBool();
    home_address = map["home_address"].isNull() ? std::optional<QString>() : map["home_address"].toString();
    symptoms_description = map["symptoms_description"].isNull() ? std::optional<QString>() : map["symptoms_description"].toString();
    created_at = map["created_at"].toDateTime();
}

QVariantHash Appointment::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["appointment_time"] = appointment_time;
    map["status"] = status;
    if(cancelled_at.has_value())
        map["cancelled_at"] = cancelled_at.value();
    map["id_patient"] = id_patient;
    map["id_schedule"] = id_schedule;
    if(id_ticket.has_value())
        map["id_ticket"] = id_ticket.value();
    map["registration_method"] = registration_method;
    map["is_home_visit"] = is_home_visit;
    if(home_address.has_value())
        map["home_address"] = home_address.value();
    if(symptoms_description.has_value())
        map["symptoms_description"] = symptoms_description.value();
    map["created_at"] = created_at;
    return map;
}
