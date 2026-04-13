#include "VisitSymptom.h"

QString VisitSymptom::tableName() const {
    return "visit_symptoms";
}

void VisitSymptom::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    id_symptom = record.value("id_symptom").toInt();
    id_visit = record.value("id_visit").toInt();
}

void VisitSymptom::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    id_symptom = map["id_symptom"].toInt();
    id_visit = map["id_visit"].toInt();
}

QVariantHash VisitSymptom::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["id_symptom"] = id_symptom;
    map["id_visit"] = id_visit;
    return map;
}
