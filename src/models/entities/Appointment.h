#pragma once

#include <optional>
#include <QDateTime>
#include "BaseModel.h"

class Appointment final : public BaseModel {
public:
    std::optional<int> id;
    QDateTime appointment_time;
    QString status;
    QDateTime cancelled_at;
    int id_patient;
    int id_schedule;

    Appointment() = default;

    Appointment(int id, QDateTime appointment_time, QString status, QDateTime cancelled_at,
                int id_patient, int id_schedule) :
        id(id), appointment_time(appointment_time), status(status), cancelled_at(cancelled_at),
        id_patient(id_patient), id_schedule(id_schedule) {}

    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
