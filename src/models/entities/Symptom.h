#pragma once

#include <optional>
#include "BaseModel.h"

class Symptom final : public BaseModel {
public:
    std::optional<int> id;
    QString name;
    QString description;

    Symptom() = default;

    Symptom(int id, QString name, QString description) :
        id(id), name(name), description(description) {}

    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
