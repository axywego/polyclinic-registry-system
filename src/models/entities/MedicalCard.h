#pragma once

#include <optional>
#include <QDateTime>
#include <QString>

#include "BaseModel.h"

class MedicalCard final : public BaseModel {
public:
    std::optional<int> id;
    QString card_number;
    QString blood_group;
    QString allergies;
    QString chronic_diseases;
    QString shelf_number;
    QString row_number;
    QString color_marking;
    int id_patient;
    QDateTime created_at;

    MedicalCard() = default;
    
    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
