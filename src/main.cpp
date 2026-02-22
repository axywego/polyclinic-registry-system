#include <QCoreApplication>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlError>
#include <QtSql/QSqlQuery>
#include <QDebug>
#include <QLibrary>
#include "core/EnvLoader.h"


int main(int argc, char* argv[]) {
    QCoreApplication a(argc, argv);

    

    // QLibrary lib("sqldrivers/qsqlpsql.dll");
    // if (!lib.load()) {
    //     qDebug() << "!!! cannot load plugin !!!";
    //     qDebug() << "error system:" << lib.errorString();
    //     return -1;
    // } else {
    //     qDebug() << "success.";
    //     lib.unload();
    // }

    if(!loadEnv(".env")){
        qDebug() << "pizdec";
    }


    QString dbName = getEnv("POSTGRES_DB");
    QString dbUser = getEnv("POSTGRES_USER");
    QString dbPassword = getEnv("POSTGRES_PASSWORD");
    int dbPort = getEnv("PG_PORT").toInt();

    qDebug() << dbName;
    qDebug() << dbUser;
    qDebug() << dbPassword;
    qDebug() << dbPort;

    QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL");
    db.setHostName("localhost");
    db.setPort(dbPort);
    db.setDatabaseName(dbName);
    db.setUserName(dbUser);
    db.setPassword(dbPassword);

    if(!db.open()) {
        qDebug() << "error connection: " << db.lastError().text();
        return -1;
    }

    qDebug() << "vse work";
    return a.exec();
}