#include "MedicalCard.h"

QString MedicalCard::tableName() const {
    return "medical_cards";
}

void MedicalCard::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id_card").toInt();
    blood_group = record.value("blood_group").toString();
    allergies = record.value("allergies").toString();
    chronic_diseases = record.value("chronic_diseases").toString();
    id_patient = record.value("id_patient").toInt();
}

void MedicalCard::fromQVariantHash(const QVariantHash& map) {
    id = map["id_card"].toInt();
    blood_group = map["blood_group"].toString();
    allergies = map["allergies"].toString();
    chronic_diseases = map["chronic_diseases"].toString();
    id_patient = map["id_patient"].toInt();
}

QVariantHash MedicalCard::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id_card"] = id.value();
    map["blood_group"] = blood_group;
    map["allergies"] = allergies;
    map["chronic_diseases"] = chronic_diseases;
    map["id_patient"] = id_patient;
    return map;
}
