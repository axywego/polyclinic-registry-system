#pragma once

#include <optional>
#include "BaseModel.h"

class Disease final : public BaseModel {
public:
    std::optional<int> id;
    QString code;
    QString name;
    QString category;
    QString description;

    Disease() = default;

    Disease(int id, QString code, QString name, QString category, QString description) :
        id(id), code(code), name(name), category(category), description(description) {}

    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
