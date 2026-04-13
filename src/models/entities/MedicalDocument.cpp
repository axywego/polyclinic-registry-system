#include "MedicalDocument.h"

QString MedicalDocument::tableName() const {
    return "medical_documents";
}

void MedicalDocument::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    document_type = record.value("document_type").toString();
    document_number = record.value("document_number").toString();
    id_patient = record.value("id_patient").toInt();
    id_doctor = record.value("id_doctor").toInt();
    id_registrar = record.value("id_registrar").isNull() ? std::optional<int>() : record.value("id_registrar").toInt();
    created_at = record.value("created_at").toDateTime();
    content = record.value("content").toString();
}

void MedicalDocument::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    document_type = map["document_type"].toString();
    document_number = map["document_number"].toString();
    id_patient = map["id_patient"].toInt();
    id_doctor = map["id_doctor"].toInt();
    id_registrar = map["id_registrar"].isNull() ? std::optional<int>() : map["id_registrar"].toInt();
    created_at = map["created_at"].toDateTime();
    content = map["content"].toString();
}

QVariantHash MedicalDocument::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["document_type"] = document_type;
    map["document_number"] = document_number;
    map["id_patient"] = id_patient;
    map["id_doctor"] = id_doctor;
    if(id_registrar.has_value())
        map["id_registrar"] = id_registrar.value();
    map["created_at"] = created_at;
    map["content"] = content;
    return map;
}
