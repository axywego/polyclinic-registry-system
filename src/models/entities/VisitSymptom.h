#pragma once

#include <optional>
#include "BaseModel.h"

class VisitSymptom final : public BaseModel {
public:
    std::optional<int> id;
    int id_symptom;
    int id_visit;

    VisitSymptom() = default;

    VisitSymptom(int id, int id_symptom, int id_visit) :
        id(id), id_symptom(id_symptom), id_visit(id_visit) {}

    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
