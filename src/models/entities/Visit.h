#pragma once

#include <optional>
#include <QDateTime>
#include <QString>

#include "BaseModel.h"

class Visit final : public BaseModel {
public:
    std::optional<int> id;
    std::optional<int> id_appointment;
    std::optional<int> id_sick_leave;
    QDateTime visit_date;

    Visit() = default;
    
    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
