#pragma once

#include <optional>
#include <QDateTime>
#include <QString>

#include "BaseModel.h"

class VisitDiagnosis final : public BaseModel {
public:
    std::optional<int> id;
    int id_visit;
    int id_diagnosis;
    QString diagnosis_type;

    VisitDiagnosis() = default;
    
    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
