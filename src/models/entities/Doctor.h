#pragma once

#include <optional>
#include <QDateTime>
#include <QString>

#include "BaseModel.h"

class Doctor final : public BaseModel {
public:
    std::optional<int> id;
    QString full_name;
    QString phone_number;
    int id_specialty;
    int id_department;
    std::optional<int> id_district;

    Doctor() = default;
    
    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
