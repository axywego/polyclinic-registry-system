#pragma once

#include <optional>
#include <QDateTime>
#include <QString>

#include "BaseModel.h"

class Registrar final : public BaseModel {
public:
    std::optional<int> id;
    QString full_name;
    QString position;
    QString phone_number;
    QString login;
    QString password_hash;
    QString role;
    int id_polyclinic;
    bool is_active;

    Registrar() = default;
    
    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
