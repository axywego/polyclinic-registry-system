#include "DatabaseManager.h"

#include "../core/EnvLoader.h"

DatabaseManager& DatabaseManager::instance() {
    static DatabaseManager instance;
    return instance;
}

DatabaseManager::DatabaseManager() {
    db = QSqlDatabase::addDatabase("QPSQL");
}

DatabaseManager::~DatabaseManager() {
    disconnect();
}

QSqlDatabase& DatabaseManager::getDatabase() {
    return db;
}

bool DatabaseManager::connect(const QString& host, const int port, const QString& name, const QString& user, const QString& password) {
    if(isConnected()){
        return true;
    }

    db.setHostName(host);
    db.setPort(port);
    db.setDatabaseName(name);
    db.setUserName(user);
    db.setPassword(password);

    if (!db.open()) {
        qDebug() << "DatabaseManager: Connection failed!";
        qDebug() << "Error:" << db.lastError().text();
        qDebug() << "Driver error:" << db.lastError().driverText();
        qDebug() << "Database error:" << db.lastError().databaseText();
        return false;
    }

    return true;
}

bool DatabaseManager::isConnected() const {
    return db.isOpen();
}

bool DatabaseManager::disconnect() {
    if(isConnected()){
        db.close();
        return true;
    }
    return false;
}
