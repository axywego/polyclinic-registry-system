#pragma once

#include <optional>
#include "BaseModel.h"

class Department final : public BaseModel {
public:
    std::optional<int> id;
    QString name;

    // fk
    int id_polyclinic;

    Department() = default;

    Department(int id, QString name, int id_polyclinic) : 
        id(id), name(name), id_polyclinic(id_polyclinic) {}

    QString tableName() const override;

    void fromSqlRecord(const QSqlRecord& record) override;

    void fromQVariantHash(const QVariantHash& map) override;

    QVariantHash getFields() const override;
};