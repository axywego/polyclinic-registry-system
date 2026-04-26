#include "PatientsByDistrictView.h"

QString PatientsByDistrictView::viewName() const {
    return "view_patients_by_district";
}

void PatientsByDistrictView::fromSqlRecord(const QSqlRecord& record) {
    data["district_id"] = record.value("district_id").toInt();
    data["district_number"] = record.value("district_number").toString();
    data["patient_id"] = record.value("patient_id").toInt();
    data["full_name"] = record.value("full_name").toString();
    data["address"] = record.value("address").toString();
    data["phone"] = record.value("phone").toString();
    data["card_number"] = record.value("card_number").toString();
    data["shelf_number"] = record.value("shelf_number").toString();
    data["row_number"] = record.value("row_number").toString();
    data["color_marking"] = record.value("color_marking").toString();
}

void PatientsByDistrictView::fromQVariantHash(const QVariantHash& map) {
    data = map;
}

QVariantHash PatientsByDistrictView::getFields() const {
    return data;
}