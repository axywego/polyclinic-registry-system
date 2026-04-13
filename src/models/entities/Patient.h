#pragma once

#include <optional>
#include <QDateTime>
#include <QString>
#include <QDate>

#include "BaseModel.h"

class Patient final : public BaseModel {
public:
    std::optional<int> id;
    QString full_name;
    QDate birth_date;
    QString address;
    QString phone;
    QString passport_data;
    std::optional<int> id_district;

    Patient() = default;
    
    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
