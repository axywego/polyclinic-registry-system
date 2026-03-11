#pragma once

#include <QHash>
#include <QString>
#include <QVariant>
#include <QtSql/QSqlRecord>

class BaseModel {
public:
    virtual ~BaseModel() = default;

    virtual QString tableName() const = 0;

    virtual void fromSqlRecord(const QSqlRecord& record) = 0;

    virtual QHash<QString, QVariant> getFields() const = 0;
};