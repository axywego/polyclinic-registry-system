#include "SickLeaveRegister.h"

QString SickLeaveRegister::tableName() const {
    return "sick_leave_register";
}

void SickLeaveRegister::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    sick_leave_number = record.value("sick_leave_number").toString();
    issued_by = record.value("issued_by").toInt();
    issued_to_doctor = record.value("issued_to_doctor").toInt();
    issued_date = record.value("issued_date").toDateTime();
}

void SickLeaveRegister::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    sick_leave_number = map["sick_leave_number"].toString();
    issued_by = map["issued_by"].toInt();
    issued_to_doctor = map["issued_to_doctor"].toInt();
    issued_date = map["issued_date"].toDateTime();
}

QVariantHash SickLeaveRegister::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["sick_leave_number"] = sick_leave_number;
    map["issued_by"] = issued_by;
    map["issued_to_doctor"] = issued_to_doctor;
    map["issued_date"] = issued_date;
    return map;
}
