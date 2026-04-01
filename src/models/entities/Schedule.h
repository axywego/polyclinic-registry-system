#pragma once

#include <optional>
#include "BaseModel.h"
#include <QTime>
#include <QDate>

class Schedule final : public BaseModel {
public:
    std::optional<int> id;
    int day_of_week;
    QTime start_time;
    QTime end_time;
    int id_room;
    int id_doctor;
    QDate valid_from;
    QDate valid_to;

    Schedule() = default;

    Schedule(int id, int day_of_week, QTime start_time, QTime end_time, 
             int id_room, int id_doctor, QDate valid_from, QDate valid_to) :
        id(id), day_of_week(day_of_week), start_time(start_time), end_time(end_time),
        id_room(id_room), id_doctor(id_doctor), valid_from(valid_from), valid_to(valid_to) {}

    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
