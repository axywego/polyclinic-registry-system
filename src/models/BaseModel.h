#pragma once

#include <QHash>
#include <QString>
#include <QVariant>
#include <QtSql/QSqlRecord>

#include <concepts>

/*
    BaseModel is an abstract class for model from Database
*/
class BaseModel {
public:
    virtual ~BaseModel() = default;

    // The name of the table to which the model belongs
    virtual QString tableName() const = 0;

    // Translating the SQL record into a structure we understand
    virtual void fromSqlRecord(const QSqlRecord& record) = 0;

    // Retrieving fields using a hash table
    virtual QHash<QString, QVariant> getFields() const = 0;
};

// Declare a concept that will be used later for other classes interacting with the model
template<typename T>
concept ModelType = std::derived_from<T, BaseModel>;