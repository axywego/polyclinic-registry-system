// Room.h
#pragma once

#include <optional>
#include "BaseModel.h"

class Room final : public BaseModel {
public:
    std::optional<int> id;
    int number;
    int floor;
    int id_department;

    Room() = default;

    Room(int id, int number, int floor, int id_department) :
        id(id), number(number), floor(floor), id_department(id_department) {}

    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};