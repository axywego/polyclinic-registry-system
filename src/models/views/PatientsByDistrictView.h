#pragma once

#include "ViewModel.h"

class PatientsByDistrictView final : public ViewModel {
public:
    QString viewName() const override;

    void fromSqlRecord(const QSqlRecord& record) override;

    void fromQVariantHash(const QVariantHash& map) override;

    QVariantHash getFields() const override;
};