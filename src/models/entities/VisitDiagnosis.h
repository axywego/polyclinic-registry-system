#pragma once

#include <optional>
#include "BaseModel.h"

class VisitDiagnosis final : public BaseModel {
public:
    std::optional<int> id;
    int id_visit;
    int id_diagnosis;
    QString diagnosis_type;

    VisitDiagnosis() = default;

    VisitDiagnosis(int id, int id_visit, int id_diagnosis, QString diagnosis_type) :
        id(id), id_visit(id_visit), id_diagnosis(id_diagnosis), diagnosis_type(diagnosis_type) {}

    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
