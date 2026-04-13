#pragma once

#include <optional>
#include <QDateTime>
#include <QString>

#include "BaseModel.h"

class AppointmentTicket final : public BaseModel {
public:
    std::optional<int> id;
    QString ticket_number;
    QString ticket_type;
    std::optional<int> issued_by;
    QDateTime issued_at;

    AppointmentTicket() = default;
    
    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
