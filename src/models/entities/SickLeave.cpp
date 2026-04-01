#include "SickLeave.h"

QString SickLeave::tableName() const {
    return "sick_leaves";
}

void SickLeave::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    id_patient = record.value("id_patient").toInt();
    opened_at = record.value("opened_at").toDateTime();
    closed_at = record.value("closed_at").toDateTime();
    status = record.value("status").toString();
    initial_diagnosis = record.value("initial_diagnosis").toString();
    id_initial_diagnosis = record.value("id_initial_diagnosis").toInt();
    final_diagnosis = record.value("final_diagnosis").toString();
    id_final_diagnosis = record.value("id_final_diagnosis").toInt();
}

void SickLeave::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    id_patient = map["id_patient"].toInt();
    opened_at = map["opened_at"].toDateTime();
    closed_at = map["closed_at"].toDateTime();
    status = map["status"].toString();
    initial_diagnosis = map["initial_diagnosis"].toString();
    id_initial_diagnosis = map["id_initial_diagnosis"].toInt();
    final_diagnosis = map["final_diagnosis"].toString();
    id_final_diagnosis = map["id_final_diagnosis"].toInt();
}

QVariantHash SickLeave::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["id_patient"] = id_patient;
    map["opened_at"] = opened_at;
    map["closed_at"] = closed_at;
    map["status"] = status;
    map["initial_diagnosis"] = initial_diagnosis;
    map["id_initial_diagnosis"] = id_initial_diagnosis;
    map["final_diagnosis"] = final_diagnosis;
    map["id_final_diagnosis"] = id_final_diagnosis;
    return map;
}
