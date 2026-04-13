#pragma once

#include <optional>
#include <QDateTime>
#include <QString>

#include "BaseModel.h"

class Appointment final : public BaseModel {
public:
    std::optional<int> id;
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
    QDateTime created_at;

    Appointment() = default;
    
    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
