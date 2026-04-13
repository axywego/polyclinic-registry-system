#include "DoctorFullInfoView.h"

QString DoctorFullInfoView::viewName() const {
    return "view_doctors_full_info";
}

void DoctorFullInfoView::fromSqlRecord(const QSqlRecord& record) {
    data["id_doctor"] = record.value("id_doctor").toInt();
    data["doctor_name"] = record.value("doctor_name").toString();
    data["specialty_name"] = record.value("specialty_name").toString();
    data["department_name"] = record.value("department_name").toString();
    data["polyclinic_name"] = record.value("polyclinic_name").toString();
    data["id_polyclinic"] = record.value("id_polyclinic").toInt();
}

void DoctorFullInfoView::fromQVariantHash(const QVariantHash& map) {
    data = map;
}

QVariantHash DoctorFullInfoView::getFields() const {
    return data;
}