#pragma once

#include <optional>
#include "BaseModel.h"

class Visit final : public BaseModel {
public:
    std::optional<int> id;
    int id_appointment;
    int id_sick_leave;

    Visit() = default;

    Visit(int id, int id_appointment, int id_sick_leave) :
        id(id), id_appointment(id_appointment), id_sick_leave(id_sick_leave) {}

    QString tableName() const override;
    void fromSqlRecord(const QSqlRecord& record) override;
    void fromQVariantHash(const QVariantHash& map) override;
    QVariantHash getFields() const override;
};
