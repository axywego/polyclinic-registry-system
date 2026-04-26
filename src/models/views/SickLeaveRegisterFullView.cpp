#include "SickLeaveRegisterFullView.h"

QString SickLeaveRegisterFullView::viewName() const {
    return "view_sick_leave_register_full";
}

void SickLeaveRegisterFullView::fromSqlRecord(const QSqlRecord& record) {
    // Основная информация
    data["id"] = record.value("id").toInt();
    data["sick_leave_number"] = record.value("sick_leave_number").toString();
    data["issued_date"] = record.value("issued_date").toDateTime();
    data["issued_by"] = record.value("issued_by").toInt();
    data["issued_to_doctor"] = record.value("issued_to_doctor").toInt();

    // Регистратор
    data["registrar_name"] = record.value("registrar_name").toString();

    // Врач
    data["doctor_name"] = record.value("doctor_name").toString();
    data["specialty_name"] = record.value("specialty_name").toString();
}

void SickLeaveRegisterFullView::fromQVariantHash(const QVariantHash& map) {
    data = map;
}

QVariantHash SickLeaveRegisterFullView::getFields() const {
    return data;
}