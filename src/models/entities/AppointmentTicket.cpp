#include "AppointmentTicket.h"

QString AppointmentTicket::tableName() const {
    return "appointment_tickets";
}

void AppointmentTicket::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    ticket_number = record.value("ticket_number").toString();
    ticket_type = record.value("ticket_type").toString();
    issued_by = record.value("issued_by").isNull() ? std::optional<int>() : record.value("issued_by").toInt();
    issued_at = record.value("issued_at").toDateTime();
}

void AppointmentTicket::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    ticket_number = map["ticket_number"].toString();
    ticket_type = map["ticket_type"].toString();
    issued_by = map["issued_by"].isNull() ? std::optional<int>() : map["issued_by"].toInt();
    issued_at = map["issued_at"].toDateTime();
}

QVariantHash AppointmentTicket::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["ticket_number"] = ticket_number;
    map["ticket_type"] = ticket_type;
    if(issued_by.has_value())
        map["issued_by"] = issued_by.value();
    map["issued_at"] = issued_at;
    return map;
}
