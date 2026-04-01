#pragma once

#include <optional>
#include "BaseModel.h"

class Doctor final : public BaseModel {
public:
    std::optional<int> id;
    QString fullName;
    QString phoneNumber;

    // fk
    int id_specialty;

    Doctor() = default;

    Doctor(int id, QString fullName, QString phoneNumber, int id_specialty) : 
        id(id), fullName(fullName), phoneNumber(phoneNumber), id_specialty(id_specialty) {}

    QString tableName() const override;

    void fromSqlRecord(const QSqlRecord& record) override;

    void fromQVariantHash(const QVariantHash& map) override;

    QVariantHash getFields() const override;
};