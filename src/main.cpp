#include <QCoreApplication>
#include <QDebug>
#include <QLibrary>

#include "core/EnvLoader.h"
#include "database/DatabaseManager.h"


int main(int argc, char* argv[]) {
    QCoreApplication a(argc, argv);

    if(!loadEnv(".env")){
        qDebug() << "Cannot to load env.";
    }

    const QString dbName = getEnv("POSTGRES_DB");
    const QString dbUser = getEnv("POSTGRES_USER");
    const QString dbPassword = getEnv("POSTGRES_PASSWORD");
    const int dbPort = getEnv("PG_PORT").toInt();

    if(!DatabaseManager::instance().connect("localhost", dbPort, dbName, dbUser, dbPassword)) {
        qDebug() << "Connection to database is successful.";
    }

    qDebug() << (DatabaseManager::instance().isConnected() ? "заебись все работает" : "ммм хуета");

    DatabaseManager::instance().disconnect();

    return a.exec();
}