#include "AppointmentFullInfoView.h"

QString AppointmentFullInfoView::viewName() const {
    return "view_appointments_full_info";
}

void AppointmentFullInfoView::fromSqlRecord(const QSqlRecord& record) {
    // Основная информация о записи
    data["appointment_id"] = record.value("appointment_id").toInt();
    data["appointment_time"] = record.value("appointment_time").toDateTime();
    data["status"] = record.value("status").toString();
    data["cancelled_at"] = record.value("cancelled_at").toDateTime();

    // Поликлиника
    data["id_polyclinic"] = record.value("id_polyclinic").toInt();
    data["polyclinic_name"] = record.value("polyclinic_name").toString();
    data["polyclinic_address"] = record.value("polyclinic_address").toString();
    data["polyclinic_phone"] = record.value("polyclinic_phone").toString();

    // Врач
    data["id_doctor"] = record.value("id_doctor").toInt();
    data["doctor_name"] = record.value("doctor_name").toString();
    data["doctor_phone"] = record.value("doctor_phone").toString();

    // Специальность
    data["id_specialty"] = record.value("id_specialty").toInt();
    data["specialty_name"] = record.value("specialty_name").toString();

    // Отделение
    data["id_department"] = record.value("id_department").toInt();
    data["department_name"] = record.value("department_name").toString();

    // Кабинет
    data["id_room"] = record.value("id_room").toInt();
    data["room_number"] = record.value("room_number").toInt();
    data["room_floor"] = record.value("room_floor").toInt();

    // Пациент
    data["id_patient"] = record.value("id_patient").toInt();
    data["patient_name"] = record.value("patient_name").toString();
    data["patient_birth_date"] = record.value("patient_birth_date").toDate();
    data["patient_phone"] = record.value("patient_phone").toString();
    data["patient_address"] = record.value("patient_address").toString();

    // Мед карта
    data["id_card"] = record.value("id_card").toInt();
    data["blood_group"] = record.value("blood_group").toString();
    data["allergies"] = record.value("allergies").toString();
    data["chronic_diseases"] = record.value("chronic_diseases").toString();
}

void AppointmentFullInfoView::fromQVariantHash(const QVariantHash& map) {
    data = map;
}

QVariantHash AppointmentFullInfoView::getFields() const {
    return data;
}