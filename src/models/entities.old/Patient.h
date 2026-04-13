#pragma once

#include <optional>
#include "BaseModel.h"
#include <QDate>

class Patient final : public BaseModel {
public:
    std::optional<int> id;
    QString full_name;
    QDate birth_date;
    QString address;
    QString phone;
    QString passport_data;

    Patient() = default;

    Patient(int id, QString full_name, QDate birth_date, QString address, QString phone, QString passport_data) :
        id(id), full_name(full_name), birth_date(birth_date), address(address), phone(phone), passport_data(passport_data) {}

    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
