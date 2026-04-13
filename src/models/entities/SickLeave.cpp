#include "SickLeave.h"

QString SickLeave::tableName() const {
    return "sick_leaves";
}

void SickLeave::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    sick_leave_number = record.value("sick_leave_number").toString();
    id_patient = record.value("id_patient").toInt();
    id_doctor = record.value("id_doctor").toInt();
    opened_at = record.value("opened_at").toDateTime();
    closed_at = record.value("closed_at").isNull() ? std::optional<QDateTime>() : record.value("closed_at").toDateTime();
    status = record.value("status").toString();
    initial_diagnosis = record.value("initial_diagnosis").toString();
    id_initial_diagnosis = record.value("id_initial_diagnosis").toInt();
    final_diagnosis = record.value("final_diagnosis").isNull() ? std::optional<QString>() : record.value("final_diagnosis").toString();
    id_final_diagnosis = record.value("id_final_diagnosis").isNull() ? std::optional<int>() : record.value("id_final_diagnosis").toInt();
}

void SickLeave::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    sick_leave_number = map["sick_leave_number"].toString();
    id_patient = map["id_patient"].toInt();
    id_doctor = map["id_doctor"].toInt();
    opened_at = map["opened_at"].toDateTime();
    closed_at = map["closed_at"].isNull() ? std::optional<QDateTime>() : map["closed_at"].toDateTime();
    status = map["status"].toString();
    initial_diagnosis = map["initial_diagnosis"].toString();
    id_initial_diagnosis = map["id_initial_diagnosis"].toInt();
    final_diagnosis = map["final_diagnosis"].isNull() ? std::optional<QString>() : map["final_diagnosis"].toString();
    id_final_diagnosis = map["id_final_diagnosis"].isNull() ? std::optional<int>() : map["id_final_diagnosis"].toInt();
}

QVariantHash SickLeave::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["sick_leave_number"] = sick_leave_number;
    map["id_patient"] = id_patient;
    map["id_doctor"] = id_doctor;
    map["opened_at"] = opened_at;
    if(closed_at.has_value())
        map["closed_at"] = closed_at.value();
    map["status"] = status;
    map["initial_diagnosis"] = initial_diagnosis;
    map["id_initial_diagnosis"] = id_initial_diagnosis;
    if(final_diagnosis.has_value())
        map["final_diagnosis"] = final_diagnosis.value();
    if(id_final_diagnosis.has_value())
        map["id_final_diagnosis"] = id_final_diagnosis.value();
    return map;
}
