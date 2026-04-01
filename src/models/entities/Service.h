#pragma once

#include <optional>
#include "BaseModel.h"

class Service final : public BaseModel {
public:
    std::optional<int> id;
    QString name;
    QString description;
    int price;

    Service() = default;

    Service(int id, QString name, QString description, int price) :
        id(id), name(name), description(description), price(price) {}

    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
