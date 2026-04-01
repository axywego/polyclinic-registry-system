#pragma once

#include <optional>
#include "BaseModel.h"
#include <QTime>
#include <QDate>

class ScheduleException final : public BaseModel {
public:
    std::optional<int> id;
    int id_doctor;
    QDate exception_start_date;
    QDate exception_end_date;
    QTime start_time;
    QTime end_time;
    int id_room;
    bool is_working;
    QString reason;

    ScheduleException() = default;

    ScheduleException(int id, int id_doctor, QDate exception_start_date, QDate exception_end_date,
                      QTime start_time, QTime end_time, int id_room, bool is_working, QString reason) :
        id(id), id_doctor(id_doctor), exception_start_date(exception_start_date),
        exception_end_date(exception_end_date), start_time(start_time), end_time(end_time),
        id_room(id_room), is_working(is_working), reason(reason) {}

    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
