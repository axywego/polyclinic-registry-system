#pragma once

#include <optional>
#include <QDateTime>
#include <QString>

#include "BaseModel.h"

class MedicalDocument final : public BaseModel {
public:
    std::optional<int> id;
    QString document_type;
    QString document_number;
    int id_patient;
    int id_doctor;
    std::optional<int> id_registrar;
    QDateTime created_at;
    QString content;

    MedicalDocument() = default;
    
    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
