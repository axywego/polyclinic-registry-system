#!/bin/bash

# Создание моделей для всех таблиц базы данных
# Запуск: ./generate_models.sh

set -e

MODELS_DIR="models"
mkdir -p "$MODELS_DIR"

# Функция для создания .h файла
create_h_file() {
    local class_name=$1
    local fields=$2
    local includes=$3
    
    cat > "$MODELS_DIR/${class_name}.h" << EOF
#pragma once

#include <optional>
#include <QDateTime>
#include <QString>
${includes}
#include "BaseModel.h"

class ${class_name} final : public BaseModel {
public:
${fields}

    ${class_name}() = default;
    
    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
EOF
}

# Функция для создания .cpp файла
create_cpp_file() {
    local class_name=$1
    local table_name=$2
    local field_assignments=$3
    local hash_assignments=$4
    local getfields_assignments=$5
    
    cat > "$MODELS_DIR/${class_name}.cpp" << EOF
#include "${class_name}.h"

QString ${class_name}::tableName() const {
    return "${table_name}";
}

void ${class_name}::fromSqlRecord(const QSqlRecord& record) {
${field_assignments}
}

void ${class_name}::fromQVariantHash(const QVariantHash& map) {
${hash_assignments}
}

QVariantHash ${class_name}::getFields() const {
    QVariantHash map;
${getfields_assignments}
    return map;
}
EOF
}

echo "Генерация моделей в директории: $MODELS_DIR"
echo "============================================="

# ============================================
# 1. Polyclinic
# ============================================
echo "Создание Polyclinic..."

create_h_file "Polyclinic" \
"    std::optional<int> id_polyclinic;
    QString name;
    QString address;
    QString phone_number;" \
""

create_cpp_file "Polyclinic" "polyclinics" \
"    id_polyclinic = record.value(\"id_polyclinic\").toInt();
    name = record.value(\"name\").toString();
    address = record.value(\"address\").toString();
    phone_number = record.value(\"phone_number\").toString();" \
"    id_polyclinic = map[\"id_polyclinic\"].toInt();
    name = map[\"name\"].toString();
    address = map[\"address\"].toString();
    phone_number = map[\"phone_number\"].toString();" \
"    if(id_polyclinic.has_value())
        map[\"id_polyclinic\"] = id_polyclinic.value();
    map[\"name\"] = name;
    map[\"address\"] = address;
    map[\"phone_number\"] = phone_number;"

# ============================================
# 2. Registrar
# ============================================
echo "Создание Registrar..."

create_h_file "Registrar" \
"    std::optional<int> id_registrar;
    QString full_name;
    QString position;
    QString phone_number;
    QString login;
    QString password_hash;
    int id_polyclinic;
    bool is_active;" \
""

create_cpp_file "Registrar" "registrars" \
"    id_registrar = record.value(\"id_registrar\").toInt();
    full_name = record.value(\"full_name\").toString();
    position = record.value(\"position\").toString();
    phone_number = record.value(\"phone_number\").toString();
    login = record.value(\"login\").toString();
    password_hash = record.value(\"password_hash\").toString();
    id_polyclinic = record.value(\"id_polyclinic\").toInt();
    is_active = record.value(\"is_active\").toBool();" \
"    id_registrar = map[\"id_registrar\"].toInt();
    full_name = map[\"full_name\"].toString();
    position = map[\"position\"].toString();
    phone_number = map[\"phone_number\"].toString();
    login = map[\"login\"].toString();
    password_hash = map[\"password_hash\"].toString();
    id_polyclinic = map[\"id_polyclinic\"].toInt();
    is_active = map[\"is_active\"].toBool();" \
"    if(id_registrar.has_value())
        map[\"id_registrar\"] = id_registrar.value();
    map[\"full_name\"] = full_name;
    map[\"position\"] = position;
    map[\"phone_number\"] = phone_number;
    map[\"login\"] = login;
    map[\"password_hash\"] = password_hash;
    map[\"id_polyclinic\"] = id_polyclinic;
    map[\"is_active\"] = is_active;"

# ============================================
# 3. Specialty
# ============================================
echo "Создание Specialty..."

create_h_file "Specialty" \
"    std::optional<int> id_specialty;
    QString name;
    QString description;" \
""

create_cpp_file "Specialty" "specialties" \
"    id_specialty = record.value(\"id_specialty\").toInt();
    name = record.value(\"name\").toString();
    description = record.value(\"description\").toString();" \
"    id_specialty = map[\"id_specialty\"].toInt();
    name = map[\"name\"].toString();
    description = map[\"description\"].toString();" \
"    if(id_specialty.has_value())
        map[\"id_specialty\"] = id_specialty.value();
    map[\"name\"] = name;
    map[\"description\"] = description;"

# ============================================
# 4. Department
# ============================================
echo "Создание Department..."

create_h_file "Department" \
"    std::optional<int> id_department;
    QString name;
    int id_clinic;" \
""

create_cpp_file "Department" "departments" \
"    id_department = record.value(\"id_department\").toInt();
    name = record.value(\"name\").toString();
    id_clinic = record.value(\"id_clinic\").toInt();" \
"    id_department = map[\"id_department\"].toInt();
    name = map[\"name\"].toString();
    id_clinic = map[\"id_clinic\"].toInt();" \
"    if(id_department.has_value())
        map[\"id_department\"] = id_department.value();
    map[\"name\"] = name;
    map[\"id_clinic\"] = id_clinic;"

# ============================================
# 5. District
# ============================================
echo "Создание District..."

create_h_file "District" \
"    std::optional<int> id_district;
    int number;
    QString name;
    int id_department;
    std::optional<int> id_registrar;" \
""

create_cpp_file "District" "districts" \
"    id_district = record.value(\"id_district\").toInt();
    number = record.value(\"number\").toInt();
    name = record.value(\"name\").toString();
    id_department = record.value(\"id_department\").toInt();
    id_registrar = record.value(\"id_registrar\").isNull() ? std::optional<int>() : record.value(\"id_registrar\").toInt();" \
"    id_district = map[\"id_district\"].toInt();
    number = map[\"number\"].toInt();
    name = map[\"name\"].toString();
    id_department = map[\"id_department\"].toInt();
    id_registrar = map[\"id_registrar\"].isNull() ? std::optional<int>() : map[\"id_registrar\"].toInt();" \
"    if(id_district.has_value())
        map[\"id_district\"] = id_district.value();
    map[\"number\"] = number;
    map[\"name\"] = name;
    map[\"id_department\"] = id_department;
    if(id_registrar.has_value())
        map[\"id_registrar\"] = id_registrar.value();"

# ============================================
# 6. Street
# ============================================
echo "Создание Street..."

create_h_file "Street" \
"    std::optional<int> id_street;
    QString name;
    int id_district;
    QString houses_range;" \
""

create_cpp_file "Street" "streets" \
"    id_street = record.value(\"id_street\").toInt();
    name = record.value(\"name\").toString();
    id_district = record.value(\"id_district\").toInt();
    houses_range = record.value(\"houses_range\").toString();" \
"    id_street = map[\"id_street\"].toInt();
    name = map[\"name\"].toString();
    id_district = map[\"id_district\"].toInt();
    houses_range = map[\"houses_range\"].toString();" \
"    if(id_street.has_value())
        map[\"id_street\"] = id_street.value();
    map[\"name\"] = name;
    map[\"id_district\"] = id_district;
    map[\"houses_range\"] = houses_range;"

# ============================================
# 7. Doctor
# ============================================
echo "Создание Doctor..."

create_h_file "Doctor" \
"    std::optional<int> id_doctor;
    QString full_name;
    QString phone_number;
    int id_specialty;
    int id_department;
    std::optional<int> id_district;" \
""

create_cpp_file "Doctor" "doctors" \
"    id_doctor = record.value(\"id_doctor\").toInt();
    full_name = record.value(\"full_name\").toString();
    phone_number = record.value(\"phone_number\").toString();
    id_specialty = record.value(\"id_specialty\").toInt();
    id_department = record.value(\"id_department\").toInt();
    id_district = record.value(\"id_district\").isNull() ? std::optional<int>() : record.value(\"id_district\").toInt();" \
"    id_doctor = map[\"id_doctor\"].toInt();
    full_name = map[\"full_name\"].toString();
    phone_number = map[\"phone_number\"].toString();
    id_specialty = map[\"id_specialty\"].toInt();
    id_department = map[\"id_department\"].toInt();
    id_district = map[\"id_district\"].isNull() ? std::optional<int>() : map[\"id_district\"].toInt();" \
"    if(id_doctor.has_value())
        map[\"id_doctor\"] = id_doctor.value();
    map[\"full_name\"] = full_name;
    map[\"phone_number\"] = phone_number;
    map[\"id_specialty\"] = id_specialty;
    map[\"id_department\"] = id_department;
    if(id_district.has_value())
        map[\"id_district\"] = id_district.value();"

# ============================================
# 8. Room
# ============================================
echo "Создание Room..."

create_h_file "Room" \
"    std::optional<int> id_room;
    QString number;
    int floor;
    int id_department;" \
""

create_cpp_file "Room" "rooms" \
"    id_room = record.value(\"id_room\").toInt();
    number = record.value(\"number\").toString();
    floor = record.value(\"floor\").toInt();
    id_department = record.value(\"id_department\").toInt();" \
"    id_room = map[\"id_room\"].toInt();
    number = map[\"number\"].toString();
    floor = map[\"floor\"].toInt();
    id_department = map[\"id_department\"].toInt();" \
"    if(id_room.has_value())
        map[\"id_room\"] = id_room.value();
    map[\"number\"] = number;
    map[\"floor\"] = floor;
    map[\"id_department\"] = id_department;"

# ============================================
# 9. Patient
# ============================================
echo "Создание Patient..."

create_h_file "Patient" \
"    std::optional<int> id_patient;
    QString full_name;
    QDate birth_date;
    QString address;
    QString phone;
    QString passport_data;
    std::optional<int> id_district;" \
"#include <QDate>
"

create_cpp_file "Patient" "patients" \
"    id_patient = record.value(\"id_patient\").toInt();
    full_name = record.value(\"full_name\").toString();
    birth_date = record.value(\"birth_date\").toDate();
    address = record.value(\"address\").toString();
    phone = record.value(\"phone\").toString();
    passport_data = record.value(\"passport_data\").toString();
    id_district = record.value(\"id_district\").isNull() ? std::optional<int>() : record.value(\"id_district\").toInt();" \
"    id_patient = map[\"id_patient\"].toInt();
    full_name = map[\"full_name\"].toString();
    birth_date = map[\"birth_date\"].toDate();
    address = map[\"address\"].toString();
    phone = map[\"phone\"].toString();
    passport_data = map[\"passport_data\"].toString();
    id_district = map[\"id_district\"].isNull() ? std::optional<int>() : map[\"id_district\"].toInt();" \
"    if(id_patient.has_value())
        map[\"id_patient\"] = id_patient.value();
    map[\"full_name\"] = full_name;
    map[\"birth_date\"] = birth_date;
    map[\"address\"] = address;
    map[\"phone\"] = phone;
    map[\"passport_data\"] = passport_data;
    if(id_district.has_value())
        map[\"id_district\"] = id_district.value();"

# ============================================
# 10. MedicalCard
# ============================================
echo "Создание MedicalCard..."

create_h_file "MedicalCard" \
"    std::optional<int> id_card;
    QString card_number;
    QString blood_group;
    QString allergies;
    QString chronic_diseases;
    QString shelf_number;
    QString row_number;
    QString color_marking;
    int id_patient;
    QDateTime created_at;" \
""

create_cpp_file "MedicalCard" "medical_cards" \
"    id_card = record.value(\"id_card\").toInt();
    card_number = record.value(\"card_number\").toString();
    blood_group = record.value(\"blood_group\").toString();
    allergies = record.value(\"allergies\").toString();
    chronic_diseases = record.value(\"chronic_diseases\").toString();
    shelf_number = record.value(\"shelf_number\").toString();
    row_number = record.value(\"row_number\").toString();
    color_marking = record.value(\"color_marking\").toString();
    id_patient = record.value(\"id_patient\").toInt();
    created_at = record.value(\"created_at\").toDateTime();" \
"    id_card = map[\"id_card\"].toInt();
    card_number = map[\"card_number\"].toString();
    blood_group = map[\"blood_group\"].toString();
    allergies = map[\"allergies\"].toString();
    chronic_diseases = map[\"chronic_diseases\"].toString();
    shelf_number = map[\"shelf_number\"].toString();
    row_number = map[\"row_number\"].toString();
    color_marking = map[\"color_marking\"].toString();
    id_patient = map[\"id_patient\"].toInt();
    created_at = map[\"created_at\"].toDateTime();" \
"    if(id_card.has_value())
        map[\"id_card\"] = id_card.value();
    map[\"card_number\"] = card_number;
    map[\"blood_group\"] = blood_group;
    map[\"allergies\"] = allergies;
    map[\"chronic_diseases\"] = chronic_diseases;
    map[\"shelf_number\"] = shelf_number;
    map[\"row_number\"] = row_number;
    map[\"color_marking\"] = color_marking;
    map[\"id_patient\"] = id_patient;
    map[\"created_at\"] = created_at;"

# ============================================
# 11. Schedule
# ============================================
echo "Создание Schedule..."

create_h_file "Schedule" \
"    std::optional<int> id_schedule;
    int day_of_week;
    QTime start_time;
    QTime end_time;
    int id_room;
    int id_doctor;
    QDate valid_from;
    std::optional<QDate> valid_to;
    int max_patients;" \
"#include <QTime>
"

create_cpp_file "Schedule" "schedules" \
"    id_schedule = record.value(\"id_schedule\").toInt();
    day_of_week = record.value(\"day_of_week\").toInt();
    start_time = record.value(\"start_time\").toTime();
    end_time = record.value(\"end_time\").toTime();
    id_room = record.value(\"id_room\").toInt();
    id_doctor = record.value(\"id_doctor\").toInt();
    valid_from = record.value(\"valid_from\").toDate();
    valid_to = record.value(\"valid_to\").isNull() ? std::optional<QDate>() : record.value(\"valid_to\").toDate();
    max_patients = record.value(\"max_patients\").toInt();" \
"    id_schedule = map[\"id_schedule\"].toInt();
    day_of_week = map[\"day_of_week\"].toInt();
    start_time = map[\"start_time\"].toTime();
    end_time = map[\"end_time\"].toTime();
    id_room = map[\"id_room\"].toInt();
    id_doctor = map[\"id_doctor\"].toInt();
    valid_from = map[\"valid_from\"].toDate();
    valid_to = map[\"valid_to\"].isNull() ? std::optional<QDate>() : map[\"valid_to\"].toDate();
    max_patients = map[\"max_patients\"].toInt();" \
"    if(id_schedule.has_value())
        map[\"id_schedule\"] = id_schedule.value();
    map[\"day_of_week\"] = day_of_week;
    map[\"start_time\"] = start_time;
    map[\"end_time\"] = end_time;
    map[\"id_room\"] = id_room;
    map[\"id_doctor\"] = id_doctor;
    map[\"valid_from\"] = valid_from;
    if(valid_to.has_value())
        map[\"valid_to\"] = valid_to.value();
    map[\"max_patients\"] = max_patients;"

# ============================================
# 12. ScheduleException
# ============================================
echo "Создание ScheduleException..."

create_h_file "ScheduleException" \
"    std::optional<int> id_schedule_exception;
    int id_doctor;
    QDate exception_start_date;
    QDate exception_end_date;
    std::optional<QTime> start_time;
    std::optional<QTime> end_time;
    std::optional<int> id_room;
    bool is_working;
    QString reason;" \
"#include <QTime>
"

create_cpp_file "ScheduleException" "schedule_exceptions" \
"    id_schedule_exception = record.value(\"id_schedule_exception\").toInt();
    id_doctor = record.value(\"id_doctor\").toInt();
    exception_start_date = record.value(\"exception_start_date\").toDate();
    exception_end_date = record.value(\"exception_end_date\").toDate();
    start_time = record.value(\"start_time\").isNull() ? std::optional<QTime>() : record.value(\"start_time\").toTime();
    end_time = record.value(\"end_time\").isNull() ? std::optional<QTime>() : record.value(\"end_time\").toTime();
    id_room = record.value(\"id_room\").isNull() ? std::optional<int>() : record.value(\"id_room\").toInt();
    is_working = record.value(\"is_working\").toBool();
    reason = record.value(\"reason\").toString();" \
"    id_schedule_exception = map[\"id_schedule_exception\"].toInt();
    id_doctor = map[\"id_doctor\"].toInt();
    exception_start_date = map[\"exception_start_date\"].toDate();
    exception_end_date = map[\"exception_end_date\"].toDate();
    start_time = map[\"start_time\"].isNull() ? std::optional<QTime>() : map[\"start_time\"].toTime();
    end_time = map[\"end_time\"].isNull() ? std::optional<QTime>() : map[\"end_time\"].toTime();
    id_room = map[\"id_room\"].isNull() ? std::optional<int>() : map[\"id_room\"].toInt();
    is_working = map[\"is_working\"].toBool();
    reason = map[\"reason\"].toString();" \
"    if(id_schedule_exception.has_value())
        map[\"id_schedule_exception\"] = id_schedule_exception.value();
    map[\"id_doctor\"] = id_doctor;
    map[\"exception_start_date\"] = exception_start_date;
    map[\"exception_end_date\"] = exception_end_date;
    if(start_time.has_value())
        map[\"start_time\"] = start_time.value();
    if(end_time.has_value())
        map[\"end_time\"] = end_time.value();
    if(id_room.has_value())
        map[\"id_room\"] = id_room.value();
    map[\"is_working\"] = is_working;
    map[\"reason\"] = reason;"

# ============================================
# 13. Disease
# ============================================
echo "Создание Disease..."

create_h_file "Disease" \
"    std::optional<int> id;
    QString code;
    QString name;
    QString category;
    QString description;" \
""

create_cpp_file "Disease" "diseases" \
"    id = record.value(\"id\").toInt();
    code = record.value(\"code\").toString();
    name = record.value(\"name\").toString();
    category = record.value(\"category\").toString();
    description = record.value(\"description\").toString();" \
"    id = map[\"id\"].toInt();
    code = map[\"code\"].toString();
    name = map[\"name\"].toString();
    category = map[\"category\"].toString();
    description = map[\"description\"].toString();" \
"    if(id.has_value())
        map[\"id\"] = id.value();
    map[\"code\"] = code;
    map[\"name\"] = name;
    map[\"category\"] = category;
    map[\"description\"] = description;"

# ============================================
# 14. Symptom
# ============================================
echo "Создание Symptom..."

create_h_file "Symptom" \
"    std::optional<int> id;
    QString name;
    QString description;" \
""

create_cpp_file "Symptom" "symptoms" \
"    id = record.value(\"id\").toInt();
    name = record.value(\"name\").toString();
    description = record.value(\"description\").toString();" \
"    id = map[\"id\"].toInt();
    name = map[\"name\"].toString();
    description = map[\"description\"].toString();" \
"    if(id.has_value())
        map[\"id\"] = id.value();
    map[\"name\"] = name;
    map[\"description\"] = description;"

# ============================================
# 15. SickLeaveRegister
# ============================================
echo "Создание SickLeaveRegister..."

create_h_file "SickLeaveRegister" \
"    std::optional<int> id;
    QString sick_leave_number;
    int issued_by;
    int issued_to_doctor;
    QDateTime issued_date;" \
""

create_cpp_file "SickLeaveRegister" "sick_leave_register" \
"    id = record.value(\"id\").toInt();
    sick_leave_number = record.value(\"sick_leave_number\").toString();
    issued_by = record.value(\"issued_by\").toInt();
    issued_to_doctor = record.value(\"issued_to_doctor\").toInt();
    issued_date = record.value(\"issued_date\").toDateTime();" \
"    id = map[\"id\"].toInt();
    sick_leave_number = map[\"sick_leave_number\"].toString();
    issued_by = map[\"issued_by\"].toInt();
    issued_to_doctor = map[\"issued_to_doctor\"].toInt();
    issued_date = map[\"issued_date\"].toDateTime();" \
"    if(id.has_value())
        map[\"id\"] = id.value();
    map[\"sick_leave_number\"] = sick_leave_number;
    map[\"issued_by\"] = issued_by;
    map[\"issued_to_doctor\"] = issued_to_doctor;
    map[\"issued_date\"] = issued_date;"

# ============================================
# 16. SickLeave
# ============================================
echo "Создание SickLeave..."

create_h_file "SickLeave" \
"    std::optional<int> id;
    QString sick_leave_number;
    int id_patient;
    int id_doctor;
    QDateTime opened_at;
    std::optional<QDateTime> closed_at;
    QString status;
    QString initial_diagnosis;
    int id_initial_diagnosis;
    std::optional<QString> final_diagnosis;
    std::optional<int> id_final_diagnosis;" \
""

create_cpp_file "SickLeave" "sick_leaves" \
"    id = record.value(\"id\").toInt();
    sick_leave_number = record.value(\"sick_leave_number\").toString();
    id_patient = record.value(\"id_patient\").toInt();
    id_doctor = record.value(\"id_doctor\").toInt();
    opened_at = record.value(\"opened_at\").toDateTime();
    closed_at = record.value(\"closed_at\").isNull() ? std::optional<QDateTime>() : record.value(\"closed_at\").toDateTime();
    status = record.value(\"status\").toString();
    initial_diagnosis = record.value(\"initial_diagnosis\").toString();
    id_initial_diagnosis = record.value(\"id_initial_diagnosis\").toInt();
    final_diagnosis = record.value(\"final_diagnosis\").isNull() ? std::optional<QString>() : record.value(\"final_diagnosis\").toString();
    id_final_diagnosis = record.value(\"id_final_diagnosis\").isNull() ? std::optional<int>() : record.value(\"id_final_diagnosis\").toInt();" \
"    id = map[\"id\"].toInt();
    sick_leave_number = map[\"sick_leave_number\"].toString();
    id_patient = map[\"id_patient\"].toInt();
    id_doctor = map[\"id_doctor\"].toInt();
    opened_at = map[\"opened_at\"].toDateTime();
    closed_at = map[\"closed_at\"].isNull() ? std::optional<QDateTime>() : map[\"closed_at\"].toDateTime();
    status = map[\"status\"].toString();
    initial_diagnosis = map[\"initial_diagnosis\"].toString();
    id_initial_diagnosis = map[\"id_initial_diagnosis\"].toInt();
    final_diagnosis = map[\"final_diagnosis\"].isNull() ? std::optional<QString>() : map[\"final_diagnosis\"].toString();
    id_final_diagnosis = map[\"id_final_diagnosis\"].isNull() ? std::optional<int>() : map[\"id_final_diagnosis\"].toInt();" \
"    if(id.has_value())
        map[\"id\"] = id.value();
    map[\"sick_leave_number\"] = sick_leave_number;
    map[\"id_patient\"] = id_patient;
    map[\"id_doctor\"] = id_doctor;
    map[\"opened_at\"] = opened_at;
    if(closed_at.has_value())
        map[\"closed_at\"] = closed_at.value();
    map[\"status\"] = status;
    map[\"initial_diagnosis\"] = initial_diagnosis;
    map[\"id_initial_diagnosis\"] = id_initial_diagnosis;
    if(final_diagnosis.has_value())
        map[\"final_diagnosis\"] = final_diagnosis.value();
    if(id_final_diagnosis.has_value())
        map[\"id_final_diagnosis\"] = id_final_diagnosis.value();"

# ============================================
# 17. AppointmentTicket
# ============================================
echo "Создание AppointmentTicket..."

create_h_file "AppointmentTicket" \
"    std::optional<int> id;
    QString ticket_number;
    QString ticket_type;
    std::optional<int> issued_by;
    QDateTime issued_at;" \
""

create_cpp_file "AppointmentTicket" "appointment_tickets" \
"    id = record.value(\"id\").toInt();
    ticket_number = record.value(\"ticket_number\").toString();
    ticket_type = record.value(\"ticket_type\").toString();
    issued_by = record.value(\"issued_by\").isNull() ? std::optional<int>() : record.value(\"issued_by\").toInt();
    issued_at = record.value(\"issued_at\").toDateTime();" \
"    id = map[\"id\"].toInt();
    ticket_number = map[\"ticket_number\"].toString();
    ticket_type = map[\"ticket_type\"].toString();
    issued_by = map[\"issued_by\"].isNull() ? std::optional<int>() : map[\"issued_by\"].toInt();
    issued_at = map[\"issued_at\"].toDateTime();" \
"    if(id.has_value())
        map[\"id\"] = id.value();
    map[\"ticket_number\"] = ticket_number;
    map[\"ticket_type\"] = ticket_type;
    if(issued_by.has_value())
        map[\"issued_by\"] = issued_by.value();
    map[\"issued_at\"] = issued_at;"

# ============================================
# 18. Appointment
# ============================================
echo "Создание Appointment..."

create_h_file "Appointment" \
"    std::optional<int> id;
    QDateTime appointment_time;
    QString status;
    std::optional<QDateTime> cancelled_at;
    int id_patient;
    int id_schedule;
    std::optional<int> id_ticket;
    QString registration_method;
    bool is_home_visit;
    std::optional<QString> home_address;
    std::optional<QString> symptoms_description;
    QDateTime created_at;" \
""

create_cpp_file "Appointment" "appointments" \
"    id = record.value(\"id\").toInt();
    appointment_time = record.value(\"appointment_time\").toDateTime();
    status = record.value(\"status\").toString();
    cancelled_at = record.value(\"cancelled_at\").isNull() ? std::optional<QDateTime>() : record.value(\"cancelled_at\").toDateTime();
    id_patient = record.value(\"id_patient\").toInt();
    id_schedule = record.value(\"id_schedule\").toInt();
    id_ticket = record.value(\"id_ticket\").isNull() ? std::optional<int>() : record.value(\"id_ticket\").toInt();
    registration_method = record.value(\"registration_method\").toString();
    is_home_visit = record.value(\"is_home_visit\").toBool();
    home_address = record.value(\"home_address\").isNull() ? std::optional<QString>() : record.value(\"home_address\").toString();
    symptoms_description = record.value(\"symptoms_description\").isNull() ? std::optional<QString>() : record.value(\"symptoms_description\").toString();
    created_at = record.value(\"created_at\").toDateTime();" \
"    id = map[\"id\"].toInt();
    appointment_time = map[\"appointment_time\"].toDateTime();
    status = map[\"status\"].toString();
    cancelled_at = map[\"cancelled_at\"].isNull() ? std::optional<QDateTime>() : map[\"cancelled_at\"].toDateTime();
    id_patient = map[\"id_patient\"].toInt();
    id_schedule = map[\"id_schedule\"].toInt();
    id_ticket = map[\"id_ticket\"].isNull() ? std::optional<int>() : map[\"id_ticket\"].toInt();
    registration_method = map[\"registration_method\"].toString();
    is_home_visit = map[\"is_home_visit\"].toBool();
    home_address = map[\"home_address\"].isNull() ? std::optional<QString>() : map[\"home_address\"].toString();
    symptoms_description = map[\"symptoms_description\"].isNull() ? std::optional<QString>() : map[\"symptoms_description\"].toString();
    created_at = map[\"created_at\"].toDateTime();" \
"    if(id.has_value())
        map[\"id\"] = id.value();
    map[\"appointment_time\"] = appointment_time;
    map[\"status\"] = status;
    if(cancelled_at.has_value())
        map[\"cancelled_at\"] = cancelled_at.value();
    map[\"id_patient\"] = id_patient;
    map[\"id_schedule\"] = id_schedule;
    if(id_ticket.has_value())
        map[\"id_ticket\"] = id_ticket.value();
    map[\"registration_method\"] = registration_method;
    map[\"is_home_visit\"] = is_home_visit;
    if(home_address.has_value())
        map[\"home_address\"] = home_address.value();
    if(symptoms_description.has_value())
        map[\"symptoms_description\"] = symptoms_description.value();
    map[\"created_at\"] = created_at;"

# ============================================
# 19. Visit
# ============================================
echo "Создание Visit..."

create_h_file "Visit" \
"    std::optional<int> id;
    std::optional<int> id_appointment;
    std::optional<int> id_sick_leave;
    QDateTime visit_date;" \
""

create_cpp_file "Visit" "visits" \
"    id = record.value(\"id\").toInt();
    id_appointment = record.value(\"id_appointment\").isNull() ? std::optional<int>() : record.value(\"id_appointment\").toInt();
    id_sick_leave = record.value(\"id_sick_leave\").isNull() ? std::optional<int>() : record.value(\"id_sick_leave\").toInt();
    visit_date = record.value(\"visit_date\").toDateTime();" \
"    id = map[\"id\"].toInt();
    id_appointment = map[\"id_appointment\"].isNull() ? std::optional<int>() : map[\"id_appointment\"].toInt();
    id_sick_leave = map[\"id_sick_leave\"].isNull() ? std::optional<int>() : map[\"id_sick_leave\"].toInt();
    visit_date = map[\"visit_date\"].toDateTime();" \
"    if(id.has_value())
        map[\"id\"] = id.value();
    if(id_appointment.has_value())
        map[\"id_appointment\"] = id_appointment.value();
    if(id_sick_leave.has_value())
        map[\"id_sick_leave\"] = id_sick_leave.value();
    map[\"visit_date\"] = visit_date;"

# ============================================
# 20. VisitDiagnosis
# ============================================
echo "Создание VisitDiagnosis..."

create_h_file "VisitDiagnosis" \
"    std::optional<int> id;
    int id_visit;
    int id_diagnosis;
    QString diagnosis_type;" \
""

create_cpp_file "VisitDiagnosis" "visit_diagnoses" \
"    id = record.value(\"id\").toInt();
    id_visit = record.value(\"id_visit\").toInt();
    id_diagnosis = record.value(\"id_diagnosis\").toInt();
    diagnosis_type = record.value(\"diagnosis_type\").toString();" \
"    id = map[\"id\"].toInt();
    id_visit = map[\"id_visit\"].toInt();
    id_diagnosis = map[\"id_diagnosis\"].toInt();
    diagnosis_type = map[\"diagnosis_type\"].toString();" \
"    if(id.has_value())
        map[\"id\"] = id.value();
    map[\"id_visit\"] = id_visit;
    map[\"id_diagnosis\"] = id_diagnosis;
    map[\"diagnosis_type\"] = diagnosis_type;"

# ============================================
# 21. VisitSymptom
# ============================================
echo "Создание VisitSymptom..."

create_h_file "VisitSymptom" \
"    std::optional<int> id;
    int id_symptom;
    int id_visit;" \
""

create_cpp_file "VisitSymptom" "visit_symptoms" \
"    id = record.value(\"id\").toInt();
    id_symptom = record.value(\"id_symptom\").toInt();
    id_visit = record.value(\"id_visit\").toInt();" \
"    id = map[\"id\"].toInt();
    id_symptom = map[\"id_symptom\"].toInt();
    id_visit = map[\"id_visit\"].toInt();" \
"    if(id.has_value())
        map[\"id\"] = id.value();
    map[\"id_symptom\"] = id_symptom;
    map[\"id_visit\"] = id_visit;"

# ============================================
# 22. Service
# ============================================
echo "Создание Service..."

create_h_file "Service" \
"    std::optional<int> id_service;
    QString name;
    QString description;
    int price;" \
""

create_cpp_file "Service" "services" \
"    id_service = record.value(\"id_service\").toInt();
    name = record.value(\"name\").toString();
    description = record.value(\"description\").toString();
    price = record.value(\"price\").toInt();" \
"    id_service = map[\"id_service\"].toInt();
    name = map[\"name\"].toString();
    description = map[\"description\"].toString();
    price = map[\"price\"].toInt();" \
"    if(id_service.has_value())
        map[\"id_service\"] = id_service.value();
    map[\"name\"] = name;
    map[\"description\"] = description;
    map[\"price\"] = price;"

# ============================================
# 23. ServiceAppointment
# ============================================
echo "Создание ServiceAppointment..."

create_h_file "ServiceAppointment" \
"    std::optional<int> id_service_appointment;
    int id_service;
    int id_appointment;" \
""

create_cpp_file "ServiceAppointment" "service_appointments" \
"    id_service_appointment = record.value(\"id_service_appointment\").toInt();
    id_service = record.value(\"id_service\").toInt();
    id_appointment = record.value(\"id_appointment\").toInt();" \
"    id_service_appointment = map[\"id_service_appointment\"].toInt();
    id_service = map[\"id_service\"].toInt();
    id_appointment = map[\"id_appointment\"].toInt();" \
"    if(id_service_appointment.has_value())
        map[\"id_service_appointment\"] = id_service_appointment.value();
    map[\"id_service\"] = id_service;
    map[\"id_appointment\"] = id_appointment;"

# ============================================
# 24. MedicalDocument
# ============================================
echo "Создание MedicalDocument..."

create_h_file "MedicalDocument" \
"    std::optional<int> id;
    QString document_type;
    QString document_number;
    int id_patient;
    int id_doctor;
    std::optional<int> id_registrar;
    QDateTime created_at;
    QString content;" \
""

create_cpp_file "MedicalDocument" "medical_documents" \
"    id = record.value(\"id\").toInt();
    document_type = record.value(\"document_type\").toString();
    document_number = record.value(\"document_number\").toString();
    id_patient = record.value(\"id_patient\").toInt();
    id_doctor = record.value(\"id_doctor\").toInt();
    id_registrar = record.value(\"id_registrar\").isNull() ? std::optional<int>() : record.value(\"id_registrar\").toInt();
    created_at = record.value(\"created_at\").toDateTime();
    content = record.value(\"content\").toString();" \
"    id = map[\"id\"].toInt();
    document_type = map[\"document_type\"].toString();
    document_number = map[\"document_number\"].toString();
    id_patient = map[\"id_patient\"].toInt();
    id_doctor = map[\"id_doctor\"].toInt();
    id_registrar = map[\"id_registrar\"].isNull() ? std::optional<int>() : map[\"id_registrar\"].toInt();
    created_at = map[\"created_at\"].toDateTime();
    content = map[\"content\"].toString();" \
"    if(id.has_value())
        map[\"id\"] = id.value();
    map[\"document_type\"] = document_type;
    map[\"document_number\"] = document_number;
    map[\"id_patient\"] = id_patient;
    map[\"id_doctor\"] = id_doctor;
    if(id_registrar.has_value())
        map[\"id_registrar\"] = id_registrar.value();
    map[\"created_at\"] = created_at;
    map[\"content\"] = content;"

echo "============================================="
echo "Генерация завершена!"
echo "Создано файлов:"
ls -la "$MODELS_DIR"/*.h "$MODELS_DIR"/*.cpp 2>/dev/null | wc -l
echo ""
echo "Файлы находятся в директории: $MODELS_DIR"