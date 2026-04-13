#pragma once

#include <optional>
#include <QDateTime>
#include <QString>
#include <QTime>

#include "BaseModel.h"

class ScheduleException final : public BaseModel {
public:
    std::optional<int> id;
    int id_doctor;
    QDate exception_start_date;
    QDate exception_end_date;
    std::optional<QTime> start_time;
    std::optional<QTime> end_time;
    std::optional<int> id_room;
    bool is_working;
    QString reason;

    ScheduleException() = default;
    
    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
