#pragma once

#include <optional>
#include <QDateTime>
#include <QString>
#include <QTime>

#include "BaseModel.h"

class Schedule final : public BaseModel {
public:
    std::optional<int> id;
    int day_of_week;
    QTime start_time;
    QTime end_time;
    int id_room;
    int id_doctor;
    QDate valid_from;
    std::optional<QDate> valid_to;
    int max_patients;

    Schedule() = default;
    
    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
