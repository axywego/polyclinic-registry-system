#include "MedicalCard.h"

QString MedicalCard::tableName() const {
    return "medical_cards";
}

void MedicalCard::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    card_number = record.value("card_number").toString();
    blood_group = record.value("blood_group").toString();
    allergies = record.value("allergies").toString();
    chronic_diseases = record.value("chronic_diseases").toString();
    shelf_number = record.value("shelf_number").toString();
    row_number = record.value("row_number").toString();
    color_marking = record.value("color_marking").toString();
    id_patient = record.value("id_patient").toInt();
    created_at = record.value("created_at").toDateTime();
}

void MedicalCard::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    card_number = map["card_number"].toString();
    blood_group = map["blood_group"].toString();
    allergies = map["allergies"].toString();
    chronic_diseases = map["chronic_diseases"].toString();
    shelf_number = map["shelf_number"].toString();
    row_number = map["row_number"].toString();
    color_marking = map["color_marking"].toString();
    id_patient = map["id_patient"].toInt();
    created_at = map["created_at"].toDateTime();
}

QVariantHash MedicalCard::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["card_number"] = card_number;
    map["blood_group"] = blood_group;
    map["allergies"] = allergies;
    map["chronic_diseases"] = chronic_diseases;
    map["shelf_number"] = shelf_number;
    map["row_number"] = row_number;
    map["color_marking"] = color_marking;
    map["id_patient"] = id_patient;
    map["created_at"] = created_at;
    return map;
}
