#pragma once

#include <optional>
#include "BaseModel.h"

class ServiceAppointment final : public BaseModel {
public:
    std::optional<int> id;
    int id_service;
    int id_appointment;

    ServiceAppointment() = default;

    ServiceAppointment(int id, int id_service, int id_appointment) :
        id(id), id_service(id_service), id_appointment(id_appointment) {}

    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
