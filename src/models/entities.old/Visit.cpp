#include "Visit.h"

QString Visit::tableName() const {
    return "visits";
}

void Visit::fromSqlRecord(const QSqlRecord& record) {
    id = record.value("id").toInt();
    id_appointment = record.value("id_appointment").toInt();
    id_sick_leave = record.value("id_sick_leave").toInt();
}

void Visit::fromQVariantHash(const QVariantHash& map) {
    id = map["id"].toInt();
    id_appointment = map["id_appointment"].toInt();
    id_sick_leave = map["id_sick_leave"].toInt();
}

QVariantHash Visit::getFields() const {
    QVariantHash map;
    if(id.has_value())
        map["id"] = id.value();
    map["id_appointment"] = id_appointment;
    map["id_sick_leave"] = id_sick_leave;
    return map;
}
