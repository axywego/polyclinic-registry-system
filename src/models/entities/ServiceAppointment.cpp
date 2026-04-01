#include "ServiceAppointment.h"

QString ServiceAppointment::tableName() const {
    return "service_appointments";
}

void ServiceAppointment::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id_service_appointment").toInt();
    id_service = record.value("id_service").toInt();
    id_appointment = record.value("id_appointment").toInt();
}

void ServiceAppointment::fromQVariantHash(const QVariantHash& map) {
    id = map["id_service_appointment"].toInt();
    id_service = map["id_service"].toInt();
    id_appointment = map["id_appointment"].toInt();
}

QVariantHash ServiceAppointment::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id_service_appointment"] = id.value();
    map["id_service"] = id_service;
    map["id_appointment"] = id_appointment;
    return map;
}
