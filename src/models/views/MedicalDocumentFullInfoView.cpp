#include "MedicalDocumentFullInfoView.h"

QString MedicalDocumentFullInfoView::viewName() const {
    return "view_medical_documents_full";
}

void MedicalDocumentFullInfoView::fromSqlRecord(const QSqlRecord& record) {
    // Основная информация о документе
    data["id"] = record.value("id").toInt();
    data["document_type"] = record.value("document_type").toString();
    data["document_number"] = record.value("document_number").toString();
    data["content"] = record.value("content").toString();
    data["created_at"] = record.value("created_at").toDateTime();

    // ID
    data["id_patient"] = record.value("id_patient").toInt();
    data["id_doctor"] = record.value("id_doctor").toInt();
    data["id_registrar"] = record.value("id_registrar").toInt();

    // Пациент
    data["patient_name"] = record.value("patient_name").toString();
    data["patient_birth_date"] = record.value("patient_birth_date").toDate();
    data["patient_phone"] = record.value("patient_phone").toString();

    // Врач
    data["doctor_name"] = record.value("doctor_name").toString();
    data["specialty_name"] = record.value("specialty_name").toString();

    // Регистратор
    data["registrar_name"] = record.value("registrar_name").toString();
}

void MedicalDocumentFullInfoView::fromQVariantHash(const QVariantHash& map) {
    data = map;
}

QVariantHash MedicalDocumentFullInfoView::getFields() const {
    return data;
}