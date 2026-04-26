#include "SickLeaveFullInfoView.h"

QString SickLeaveFullInfoView::viewName() const {
    return "view_sick_leaves_full_info";
}

void SickLeaveFullInfoView::fromSqlRecord(const QSqlRecord& record) {
    // Основная информация
    data["id"] = record.value("id").toInt();
    data["sick_leave_number"] = record.value("sick_leave_number").toString();
    data["opened_at"] = record.value("opened_at").toDateTime();
    data["closed_at"] = record.value("closed_at").toDateTime();
    // data["status"] = record.value("status").toString();
    data["initial_diagnosis"] = record.value("initial_diagnosis").toString();
    data["final_diagnosis"] = record.value("final_diagnosis").toString();

    // ID
    data["id_patient"] = record.value("id_patient").toInt();
    data["id_doctor"] = record.value("id_doctor").toInt();
    data["id_initial_diagnosis"] = record.value("id_initial_diagnosis").toInt();
    data["id_final_diagnosis"] = record.value("id_final_diagnosis").toInt();

    // Пациент
    data["patient_name"] = record.value("patient_name").toString();
    data["patient_birth_date"] = record.value("patient_birth_date").toDate();

    // Врач
    data["doctor_name"] = record.value("doctor_name").toString();
    data["specialty_name"] = record.value("specialty_name").toString();

    // Диагноз начальный
    data["initial_diagnosis_code"] = record.value("initial_diagnosis_code").toString();
    data["initial_diagnosis_name"] = record.value("initial_diagnosis_name").toString();

    // Диагноз финальный (может быть NULL)
    data["final_diagnosis_code"] = record.value("final_diagnosis_code").toString();
    data["final_diagnosis_name"] = record.value("final_diagnosis_name").toString();

    // Регистратор и книга учёта
    data["registrar_id"] = record.value("registrar_id").toInt();
    data["registrar_name"] = record.value("registrar_name").toString();
    data["blank_issued_date"] = record.value("blank_issued_date").toDateTime();
}

void SickLeaveFullInfoView::fromQVariantHash(const QVariantHash& map) {
    data = map;
}

QVariantHash SickLeaveFullInfoView::getFields() const {
    return data;
}