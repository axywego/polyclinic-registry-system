#pragma once

#include <optional>
#include <QDateTime>
#include <QString>

#include "BaseModel.h"

class ServiceAppointment final : public BaseModel {
public:
    std::optional<int> id;
    int id_service;
    int id_appointment;

    ServiceAppointment() = default;
    
    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
