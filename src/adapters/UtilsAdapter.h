#pragma once

#include <QObject>
#include <QString>
#include <QVariant>
#include <QVariantMap>
#include <QHash>
#include <optional>

class UtilsAdapter : public QObject {
    Q_OBJECT
private:

public:
    explicit UtilsAdapter(QObject* parent = nullptr);
    Q_INVOKABLE QString sha256(const QString& str);
};