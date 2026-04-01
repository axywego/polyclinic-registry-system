#pragma once

#include <optional>
#include "BaseModel.h"

class Specialty final : public BaseModel {
public:
    std::optional<int> id;
    QString name;
    QString description;
    int id_department;

    Specialty() = default;

    Specialty(int id, QString name, QString description, int id_department) : 
        id(id), name(name), description(description), id_department(id_department) {}

    QString tableName() const override;

    void fromSqlRecord(const QSqlRecord& record) override;

    void fromQVariantHash(const QVariantHash& map) override;

    QVariantHash getFields() const override;
};