#pragma once

#include <optional>
#include "BaseModel.h"

class MedicalCard final : public BaseModel {
public:
    std::optional<int> id;
    QString blood_group;
    QString allergies;
    QString chronic_diseases;
    int id_patient;

    MedicalCard() = default;

    MedicalCard(int id, QString blood_group, QString allergies, QString chronic_diseases, int id_patient) :
        id(id), blood_group(blood_group), allergies(allergies), chronic_diseases(chronic_diseases), id_patient(id_patient) {}

    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
