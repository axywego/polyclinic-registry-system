#pragma once

#include <optional>
#include <QDateTime>
#include <QString>

#include "BaseModel.h"

class VisitSymptom final : public BaseModel {
public:
    std::optional<int> id;
    int id_symptom;
    int id_visit;

    VisitSymptom() = default;
    
    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
