#pragma once

#include <optional>
#include "BaseModel.h"

class Polyclinic final : public BaseModel {
public:
    std::optional<int> id;
    QString name;
    QString address;
    QString phoneNumber;

    Polyclinic() = default;

    Polyclinic(int id, QString name, QString address, QString phoneNumber) : 
        id(id), name(name), address(address), phoneNumber(phoneNumber) {}

    QString tableName() const override;

    void fromSqlRecord(const QSqlRecord& record) override;

    QHash<QString, QVariant> getFields() const override;
};