#include "VisitDiagnosis.h"

QString VisitDiagnosis::tableName() const {
    return "visit_diagnoses";
}

void VisitDiagnosis::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    id_visit = record.value("id_visit").toInt();
    id_diagnosis = record.value("id_diagnosis").toInt();
    diagnosis_type = record.value("diagnosis_type").toString();
}

void VisitDiagnosis::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    id_visit = map["id_visit"].toInt();
    id_diagnosis = map["id_diagnosis"].toInt();
    diagnosis_type = map["diagnosis_type"].toString();
}

QVariantHash VisitDiagnosis::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["id_visit"] = id_visit;
    map["id_diagnosis"] = id_diagnosis;
    map["diagnosis_type"] = diagnosis_type;
    return map;
}
