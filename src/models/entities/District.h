#pragma once

#include <optional>
#include <QDateTime>
#include <QString>

#include "BaseModel.h"

class District final : public BaseModel {
public:
    std::optional<int> id;
    int number;
    QString name;
    int id_department;
    std::optional<int> id_registrar;

    District() = default;
    
    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
