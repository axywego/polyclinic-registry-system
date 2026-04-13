#include "UtilsAdapter.h"

#include <QCryptographicHash>

UtilsAdapter::UtilsAdapter(QObject* parent): QObject(parent) { }

QString UtilsAdapter::sha256(const QString& str){
    return QCryptographicHash::hash(str.toUtf8(), QCryptographicHash::Sha256).toHex();
}