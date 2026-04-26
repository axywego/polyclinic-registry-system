#include "DoctorFullInfoView.h"

QString DoctorFullInfoView::viewName() const {
    return "view_doctors_full_info";
}

void DoctorFullInfoView::fromSqlRecord(const QSqlRecord& record) {
    data["doctor_id"] = record.value("doctor_id").toInt();
    data["doctor_name"] = record.value("doctor_name").toString();
    data["doctor_phone"] = record.value("doctor_phone").toString();
    data["specialty_id"] = record.value("specialty_id").toInt();
    data["specialty_name"] = record.value("specialty_name").toString();
    data["department_id"] = record.value("department_id").toInt();
    data["department_name"] = record.value("department_name").toString();
    data["polyclinic_id"] = record.value("polyclinic_id").toInt();
    data["polyclinic_name"] = record.value("polyclinic_name").toString();
    data["polyclinic_address"] = record.value("polyclinic_address").toString();
    data["district_id"] = record.value("district_id").isNull() ? 0 : record.value("district_id").toInt();
    data["district_number"] = record.value("district_number").isNull() ? 0 : record.value("district_number").toInt();
    data["registrar_id"] = record.value("registrar_id").isNull() ? 0 : record.value("registrar_id").toInt();
    data["registrar_name"] = record.value("registrar_name").isNull() ? "" : record.value("registrar_name").toString();
    data["room_number"] = record.value("room_number").isNull() ? "—" : record.value("room_number").toString();
}

void DoctorFullInfoView::fromQVariantHash(const QVariantHash& map) {
    data = map;
}

QVariantHash DoctorFullInfoView::getFields() const {
    return data;
}