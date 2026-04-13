#pragma once

#include <optional>
#include <QDateTime>
#include <QString>

#include "BaseModel.h"

class Polyclinic final : public BaseModel {
public:
    std::optional<int> id;
    QString name;
    QString address;
    QString phone_number;

    Polyclinic() = default;
    
    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
