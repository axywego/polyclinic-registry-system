#pragma once

#include <QHash>
#include <QString>
#include <QVariant>
#include <QtSql/QSqlRecord>

#include <concepts>

class ViewModel {
public:
    QVariantHash data;

    virtual ~ViewModel() = default;

    // The name of the view to which the ViewModel belongs
    virtual QString viewName() const = 0;

    // Translating the SQL record into a structure we understand
    virtual void fromSqlRecord(const QSqlRecord& record) = 0;

    // Initializing from QVariantHash(QHash<QString, QVariant>)
    virtual void fromQVariantHash(const QVariantHash& map) = 0;

    // Retrieving fields using a hash table
    virtual QVariantHash getFields() const = 0;
};

template<typename T>
concept ViewType = std::derived_from<T, ViewModel>;