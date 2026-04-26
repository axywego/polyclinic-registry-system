#pragma once

#include "ViewModel.h"
#include <QDate>
#include <QDateTime>

class SickLeaveFullInfoView final : public ViewModel {
public:
    QString viewName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};