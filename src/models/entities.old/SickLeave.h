#pragma once

#include <optional>
#include "BaseModel.h"
#include <QDateTime>

class SickLeave final : public BaseModel {
public:
    std::optional<int> id;
    int id_patient;
    QDateTime opened_at;
    QDateTime closed_at;
    QString status;
    QString initial_diagnosis;
    int id_initial_diagnosis;
    QString final_diagnosis;
    int id_final_diagnosis;

    SickLeave() = default;

    SickLeave(int id, int id_patient, QDateTime opened_at, QDateTime closed_at,
              QString status, QString initial_diagnosis, int id_initial_diagnosis,
              QString final_diagnosis, int id_final_diagnosis) :
        id(id), id_patient(id_patient), opened_at(opened_at), closed_at(closed_at),
        status(status), initial_diagnosis(initial_diagnosis), id_initial_diagnosis(id_initial_diagnosis),
        final_diagnosis(final_diagnosis), id_final_diagnosis(id_final_diagnosis) {}

    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
