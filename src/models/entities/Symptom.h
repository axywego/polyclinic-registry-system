#pragma once

#include <optional>
#include <QDateTime>
#include <QString>

#include "BaseModel.h"

class Symptom final : public BaseModel {
public:
    std::optional<int> id;
    QString name;
    QString description;

    Symptom() = default;
    
    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
