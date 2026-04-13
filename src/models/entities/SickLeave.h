#pragma once

#include <optional>
#include <QDateTime>
#include <QString>

#include "BaseModel.h"

class SickLeave final : public BaseModel {
public:
    std::optional<int> id;
    QString sick_leave_number;
    int id_patient;
    int id_doctor;
    QDateTime opened_at;
    std::optional<QDateTime> closed_at;
    QString status;
    QString initial_diagnosis;
    int id_initial_diagnosis;
    std::optional<QString> final_diagnosis;
    std::optional<int> id_final_diagnosis;

    SickLeave() = default;
    
    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
