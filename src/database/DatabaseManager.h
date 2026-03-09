#pragma once

#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlError>
#include <QtSql/QSqlQuery>

class DatabaseManager {
private:
    QSqlDatabase db;

    DatabaseManager();
    ~DatabaseManager();
    DatabaseManager(const DatabaseManager&) = delete;
public:
    static DatabaseManager& instance();

    QSqlDatabase& getDatabase();

    bool connect(const QString& host, const int port, const QString& name, const QString& user, const QString& password);
    bool disconnect();
    bool isConnected() const;
};