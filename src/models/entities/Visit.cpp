#include "Visit.h"

QString Visit::tableName() const {
    return "visits";
}

void Visit::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    id_appointment = record.value("id_appointment").isNull() ? std::optional<int>() : record.value("id_appointment").toInt();
    id_sick_leave = record.value("id_sick_leave").isNull() ? std::optional<int>() : record.value("id_sick_leave").toInt();
    visit_date = record.value("visit_date").toDateTime();
}

void Visit::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    id_appointment = map["id_appointment"].isNull() ? std::optional<int>() : map["id_appointment"].toInt();
    id_sick_leave = map["id_sick_leave"].isNull() ? std::optional<int>() : map["id_sick_leave"].toInt();
    visit_date = map["visit_date"].toDateTime();
}

QVariantHash Visit::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    if(id_appointment.has_value())
        map["id_appointment"] = id_appointment.value();
    if(id_sick_leave.has_value())
        map["id_sick_leave"] = id_sick_leave.value();
    map["visit_date"] = visit_date;
    return map;
}
